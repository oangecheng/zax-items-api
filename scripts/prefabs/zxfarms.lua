
local TIMER_HATCH = "hatch"

local assets = {
    Asset("ANIM", "anim/zx_flower.zip"),	
    Asset("ATLAS", "images/inventoryimages/zx_flower_1.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_flower_1.tex"),
}


local function onHarmmered(inst)
    local fx = SpawnPrefab("petals")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
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


    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState() 
        inst.entity:AddMiniMapEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst:AddTag("structure")
        inst:AddTag("zxfarm")

        MakeObstaclePhysics(inst, .2)      
        inst.AnimState:SetBank("zx_flower") 
        inst.AnimState:SetBuild("zx_flower")
        inst.AnimState:PlayAnimation("zx_flower_1")
    
        inst.entity:SetPristine()
        
        if not TheWorld.ismastersim then
            return inst
        end
    
        inst:AddComponent("inspectable")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        inst.components.workable:SetOnFinishCallback(onHarmmered)
    
        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)

        inst:AddComponent("timer")
        inst:ListenForEvent("timerdone", onTimeDone)

        inst:AddComponent("zxfarm")
        inst.components.zxfarm:SetHatchItem(farm.hatchitem)
        inst.components.zxfarm:SetChild(farm.animal)
        inst.components.zxfarm:SetOnHatch(onHatch)
        inst.components.zxfarm:SetOnChildSpawn(onChildSpawn)
        
        return inst
    end
    
    return Prefab(name, fn, assets, nil)
end


local FARMS = require "defs/zxfarmdefs"
local farmlist = {}
for k, v in pairs(FARMS) do
    table.insert(farmlist, MakeFarm(k, v))
    table.insert(farmlist, MakePlacer(k.."_placer", "zx_flower", "zx_flower", "zx_flower_1"))
    -- table.insert(farmlist, MakePlacer(k.."_placer", v.initskin.file, v.initskin.file, v.initanim))
end
return unpack(farmlist)