local PREFAB = "zxflowerbush"

local assets = ZxGetPrefabAnimAsset(PREFAB)


local function onHammered(inst)
    local fx = SpawnPrefab("petals")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end


local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState() 
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("flower")
    inst:AddTag("structure")

    MakeObstaclePhysics(inst, .2)
    ZxInitItemForClient(inst, PREFAB, "idle")

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    ZxInitItemForServer(inst, PREFAB)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onHammered)

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab(PREFAB, fn, assets, nil),
MakePlacer(PREFAB.."_placer", "zxoxalis", "zxoxalis", "idle")