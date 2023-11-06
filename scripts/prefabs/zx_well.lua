
local assets = ZxGetPrefabAnimAsset("zx_well")

local prefabs = {
    "collapse_small",
}

-- 锤完了掉东西
local function onHammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("zx_items")
    inst:Remove()
end


-- 挨锤
local function onHit(inst, worker)
    inst.AnimState:PlayAnimation("onhit")
	inst.AnimState:PushAnimation("idle")
end


-- 建造
local function onBuilt(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_craft")
end


local function fn()

    local name = "zx_well"
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
	
	MakeObstaclePhysics(inst, 0.8)
	inst:SetPhysicsRadiusOverride(1)

    ZxInitItemForClient(inst, name, "idle", false)

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    inst:AddTag("watersource")
    inst:AddTag("structure")

    if not TheWorld.ismastersim then
		return inst
    end

    inst:AddComponent("watersource")
    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    
    ZxInitItemForServer(inst, name)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onHammered)
    inst.components.workable:SetOnWorkCallback(onHit)

    inst:ListenForEvent("onbuilt", onBuilt)
    -- 如果没有做雪覆盖的动画，这个函数是没有意义的
    MakeSnowCovered(inst)

    return inst
end

return Prefab("zx_well", fn, assets, prefabs),
    MakePlacer("zx_well_placer", "zx_well", "zx_well", "idle")