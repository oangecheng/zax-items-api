
local TIMER_HATCH = "hatch"

local assets = {
    Asset("ANIM", "anim/zxfarmperd1.zip")
}


local function onHammered(inst, doer)
    if inst.components.lootdropper then
        inst.components.lootdropper:DropLoot()
    end
    local x,y,z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()

    if x and y and z then
        local ents = TheSim:FindEntities(x, y, z, 4, { "zxfarmitem" }, nil)
        if ents then
            for index, value in ipairs(ents) do
                if value then
                    value:Remove()
                end
            end
        end
    end
end


local function onChildSpawn(inst, child)
    TheNet:Announce("小动物出生了~")
end


local function MakeFarm(name, farm)

    local function onHatch(inst, doer, seed)
        inst.components.timer:StartTimer(TIMER_HATCH, farm.hatchtime)
        inst.components.zxfarm:SetIsHatching(true)
    end
     
     
    local function onTimeDone(inst, data)
        if data.name == TIMER_HATCH then
            inst.components.zxfarm:SpawnChild()
            inst.components.zxfarm:SetIsHatching(false)
        end
    end


    local function onBuild(inst)
        local x,y,z = inst.Transform:GetWorldPosition()
        local land = SpawnPrefab("zxfarmperd1_land")
        land.Transform:SetPosition(x, y, z)
        local hatch = SpawnPrefab("zxhatchmachine")
        hatch.Transform:SetPosition(x - 2, y, z + 2)
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
        inst:ListenForEvent("onbuilt", onBuild)
        
        return inst
    end
    
    return Prefab(name, fn, assets, nil)
end


local FARMS = require "defs/zxfarmdefs"
local farmlist = {}
for k, v in pairs(FARMS) do
    table.insert(farmlist, MakeFarm(k, v))
    table.insert(farmlist, MakePlacer(k.."_placer", "zxfarmperd1", "zxfarmperd1", "idle"))
    -- table.insert(farmlist, MakePlacer(k.."_placer", v.initskin.file, v.initskin.file, v.initanim))
end
return unpack(farmlist)