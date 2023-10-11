
local TIMER_HATCH = "hatch"
local TIMER_PRODUCE = "produce"
local BIND_RADIUS = 4

local FARMS = require "defs/zxfarmdefs"


local assets = {
    Asset("ANIM", "anim/zxfarmperd1.zip")
}


local function findFarmItems(inst)
    return ZxFindFarmItems(inst)
end


local function onHammered(inst, doer)
    if inst.components.lootdropper then
        inst.components.lootdropper:DropLoot()
    end

    local ents = findFarmItems(inst)
    if ents then
        local bindId = inst.components.zxbindable:GetBindId()
        for k, value in pairs(ents) do
            value.components.zxbindable:Remove(bindId)
        end
    end

    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()


end


--- 查找孵化器
local function findHatchMachine(inst)
    local ents = findFarmItems(inst)
    return ents and ents["zxfarmhatch"] or nil
end


--- 查找饲料盆
local function findFoodBowl(inst)
    local ents = findFarmItems(inst)
    return ents and ents["zxfarmbowl"] or nil
end



--- 当农场的其他物品被建造时
--- 如果在范围内，就将其与农场主体绑定
local function onFarmItemBuild(inst, item)
    local fx, _, fz = inst.Transform:GetWorldPosition()
    local ix, _, iz = item.Transform:GetWorldPosition()
    local bindId = inst.components.zxbindable:GetBindId()
    -- 数据合法
    if bindId and fx and ix then
        -- 范围内
        if math.abs(fx-ix) <= BIND_RADIUS and math.abs(fz-iz) <= BIND_RADIUS then
            if item.components.zxbindable and item.components.zxbindable:CanBind() then
                item.components.zxbindable:Bind(bindId)
            end
        end
    end
end




--- 尝试开始生产产品
--- 需要有动物，需要有足够的食物
--- todo 后续优化每个小动物独立绑定生产机制
local function tryStartProduce(inst)
    local farmdata = FARMS[inst.prefab]
    local animcnt = inst.components.zxfarm:GetChildCnt()
    local foodneed = (farmdata.foodneed or 1) * animcnt
    if animcnt > 0 and ZXFarmEatFood(inst.components.zxbindable:GetBindId(), foodneed) then
        local time = farmdata.producetime * (1.1 - 0.1 * animcnt)
        inst.components.timer:StartTimer(TIMER_PRODUCE, time)
    end
end



local function onChildSpawn(inst, child)
    TheNet:Announce("小动物出生了~")

    local timer = inst.components.timer
    local farmdata = FARMS[inst.prefab]
    local foodneed = farmdata.foodneed or 1

    if ZXFarmEatFood(inst.components.zxbindable:GetBindId(), foodneed) then
        if timer:TimerExists(TIMER_PRODUCE) then
            local timeleft = timer:GetTimeLeft(TIMER_PRODUCE) * 0.9
            timer:SetTimeLeft(TIMER_PRODUCE, timeleft)
        else
            -- 第一个动物需要启动生产机制
            tryStartProduce(inst)
        end
    end
end







local function MakeFarm(name, farm)

    local function onHatch(inst, doer, seed)
        inst.components.timer:StartTimer(TIMER_HATCH, farm.hatchtime)
        inst.components.zxfarm:SetIsHatching(true)
        local machine = findHatchMachine(inst)
        if machine then
            machine.AnimState:PlayAnimation("working", true)
        end
    end
     
     
    local function onTimeDone(inst, data)
        if data.name == TIMER_HATCH then
            inst.components.zxfarm:SpawnChild()
            inst.components.zxfarm:SetIsHatching(false)
            
            local machine = findHatchMachine(inst)
            if machine then
                machine.AnimState:PlayAnimation("idle")
            end

        elseif data.name == TIMER_PRODUCE then
            TheNet:Announce("生产了一个物品~")
            tryStartProduce(inst)
        end
    end


    local function onBuild(inst)
        local x,y,z = inst.Transform:GetWorldPosition()
        local bindId = inst.prefab.."x"..tostring(x).."y"..tostring(y).."z"..tostring(z)
        inst.components.zxbindable:Bind(bindId)

        local land = SpawnPrefab("zxfarmland")
        land.components.zxbindable:Bind(bindId)
        land.Transform:SetPosition(x, y, z)
    end


    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState() 
        inst.entity:AddMiniMapEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst:AddTag("structure")
        inst:AddTag("zxfarm")

        MakeObstaclePhysics(inst, 1)
        RemovePhysicsColliders(inst)
        inst.AnimState:SetBank("zxfarmperd1") 
        inst.AnimState:SetBuild("zxfarmperd1")
        inst.AnimState:PlayAnimation("idle")
    
        inst.entity:SetPristine()
        
        if not TheWorld.ismastersim then
            return inst
        end
    
        inst:AddComponent("inspectable")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        inst.components.workable:SetOnFinishCallback(onHammered)
    
        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)

        inst:AddComponent("timer")
        inst:ListenForEvent("timerdone", onTimeDone)

        inst:AddComponent("zxfarm")
        inst.components.zxfarm:SetHatchItem(farm.hatchitem)
        inst.components.zxfarm:SetChild(farm.animal)
        inst.components.zxfarm:SetOnHatch(onHatch)
        inst.components.zxfarm:SetOnChildSpawn(onChildSpawn)
        inst:AddComponent("zxbindable")

        
        TheWorld:ListenForEvent(ZXEVENTS.FARM_ITEM_BUILD, function (_, data)
            onFarmItemBuild(inst, data.item)
        end)
        inst:ListenForEvent("onbuilt", onBuild)
        
        return inst
    end
    
    return Prefab(name, fn, assets, nil)
end


local farmlist = {}
for k, v in pairs(FARMS) do
    table.insert(farmlist, MakeFarm(k, v))
    table.insert(farmlist, MakePlacer(k.."_placer", "zxfarmperd1", "zxfarmperd1", "idle"))
    -- table.insert(farmlist, MakePlacer(k.."_placer", v.initskin.file, v.initskin.file, v.initanim))
end
return unpack(farmlist)