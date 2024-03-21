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
        inst:AddTag("character")
        inst:AddTag("ZXFARM_ANIMAL")
    
        MakeCharacterPhysics(inst, 1, 0)
        RemovePhysicsColliders(inst)
        inst.Physics:Stop()
        inst.DynamicShadow:SetSize(0.5, .75)
        data.initfunc(inst, TheWorld.ismastersim)

        inst.AnimState:SetBank(anim.bank)
        inst.AnimState:SetBuild(anim.build)
        local size = anim.size and anim.size or ANIM_SIZE
        inst.AnimState:SetScale(size, size, size)
        inst.AnimState:PlayAnimation("idle_loop", true)
        if anim.extrafunc then
            anim.extrafunc(inst)
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        -- 初始化农场
        ZXFarmItemInitFunc(inst)

        inst.sound = data.sound

        inst:AddComponent("locomotor")
        inst.components.locomotor.runspeed = data.walkspeed
        inst.components.locomotor.walkspeed = data.walkspeed
        inst:AddComponent("zxanimal")
        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(data.loots)

        inst:AddComponent("zxbindable")
        inst.components.zxbindable:SetOnUnBindFunc(function ()
            inst.components.lootdropper:DropLoot()
        end)
        inst:SetStateGraph(data.sg or "ZxAnimalSG")
        inst:AddComponent("inspectable")

        inst.producefn = data.producefn

        -- 5~10s移动一次
        -- 暂时用这个策略，后面根据反馈优化
        local time = math.random(5, 10)
        inst:DoPeriodicTask(time, function ()
            local p = findNextPosition(inst)
            if p then
                inst.components.locomotor:GoToPoint(p, nil, false)
            end
        end)
    
        return inst
    end
    
    return Prefab(animal, fn, assets, nil)
end



local ANIMALS = require("defs/zxanimaldefs")
local list = {}
for k, v in pairs(ANIMALS) do
    table.insert(list, MakeAnimal(k, v))
end
return unpack(list)