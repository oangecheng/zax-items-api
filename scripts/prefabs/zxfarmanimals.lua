---@diagnostic disable: deprecated


local MIN_DELTA = 1
local MAX_DELTA = 3.5
local ANIM_SIZE = 0.4


---获取位移范围
---@return number 最大
---@return number 最小
local function getMaxAndMinDelta()
    return MAX_DELTA * ZXTUNING.FARM_AREA, MIN_DELTA * ZXTUNING.FARM_AREA
end


---计算动物下个位置
local function findNextPosition(inst)
    local pt = inst.components.zxanimal:GetFarmPosition()
    if pt then
        local max, min = getMaxAndMinDelta()
        local dx = math.random(min, max)
        dx = math.random() < 0.5 and dx or -dx
        local dz = math.random(min, max)
        dz = math.random() < 0.5 and dz or -dz
        return Vector3(pt.x + dx, pt.y, pt.z + dz)
    end
    return nil
end


local brain = require "brains/zxanimalbrain"




local function updateName(inst)
    local name = STRINGS.NAMES[string.upper(inst.prefab)]
    local type = inst.components.zxanimal:GetType()
    local pref = STRINGS.ZXANIML_TYPES_STRS[type] or "%s"
    if inst._zxname then
        local newname = string.format(pref, name)
        if inst.components.zxupgradable then
            newname = newname.."[lv"..inst.components.zxupgradable:GetLv().."]"
        end
        inst._zxname:set(newname)
    end
end


local function MakeAnimal(animal, data)
    local assets = data.assets
    local anim = data.anim

    local function fn()
        local inst = CreateEntity()
    
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()
        inst.entity:SetPristine()

        inst:AddTag("character")
        inst:AddTag(ZXTAGS.ANIMAL)
        inst:AddTag(ZXTAGS.UP_TARGET)
    
        MakeCharacterPhysics(inst, 1, 0)
        RemovePhysicsColliders(inst)
        inst.Physics:Stop()
        inst.DynamicShadow:SetSize(0.5, .75)
        if data.initfunc then
            data.initfunc(inst, TheWorld.ismastersim)
        end

        inst.AnimState:SetBank(anim.bank)
        inst.AnimState:SetBuild(anim.build)
        local size = anim.size and anim.size or ANIM_SIZE
        inst.AnimState:SetScale(size, size, size)
        inst.AnimState:PlayAnimation("idle_loop", true)
        if anim.extrafunc then
            anim.extrafunc(inst)
        end

        ZXNetInfo(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        -- 初始化农场
        ZXFarmItemInitFunc(inst)

        inst:AddComponent("timer")
        inst:AddComponent("locomotor")
        inst.components.locomotor.runspeed = data.speed
        inst.components.locomotor.walkspeed = data.speed
        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(data.loots)
        inst:AddComponent("inspectable")

        --- 大小变化
        inst:AddComponent("zxresizeable")
        inst.components.zxresizeable:SetScale(anim.size)

        --- 动物生产配置
        inst:AddComponent("zxanimal")
        inst.components.zxanimal:SetTypes(data.types)
        inst.components.zxanimal:SetData(data.foodnum, data.producetime)
        inst.components.zxanimal:SetOnTypeFn(updateName)
        inst.components.zxanimal:SetOnProducedFn(function ()
            local host = ZxGetFarmHost(inst)
            local productions = data.producefn(inst, host)
            if productions and host then
                local farm = host.components.zxfarm
                for k, v in pairs(productions) do 
                    farm:Store(k, v)
                end
            end
        end)

        --- 升级
        inst:AddComponent("zxupgradable")
        inst.components.zxupgradable:SetMax(10)
        inst.components.zxupgradable:SetTestFn(function (doer, item, lv)
            if inst.prefab and inst.prefab.."_soul" == item.prefab then
                return ZXItemConsume(doer, { zxstone = lv + 1 })
            end 
        end)
        inst.components.zxupgradable:SetOnUpgradeFn(function (_, lv)
            local time = data.producetime * (1 - lv * 0.05)
            inst.components.zxanimal:SetProduceTime(time)
            updateName(inst)
        end)

        --- 绑定组件
        inst:AddComponent("zxbindable")
        inst.components.zxbindable:SetOnBindFunc(function ()
            inst.components.zxanimal:StartProduce()
        end)
        inst.components.zxbindable:SetOnUnBindFunc(function ()
            inst.components.lootdropper:DropLoot()
        end)


        -- 5~10s移动一次
        -- 暂时用这个策略，后面根据反馈优化
        local time = math.random(5, 10)
        inst:DoPeriodicTask(time, function ()
            local p = findNextPosition(inst)
            if p then
                inst.components.locomotor:GoToPoint(p, nil, false)
            end
        end)
        -- inst:SetBrain(brain)
        inst:SetStateGraph(data.sg or "ZxAnimalSG")
        return inst
    end
    
    return Prefab(animal, fn, assets, nil)
end



local ANIMALS = require("defs/animaldefs")
local list = {}
for k, v in pairs(ANIMALS) do
    table.insert(list, MakeAnimal(k, v))
end
return unpack(list)