local assets = {
    Asset("ANIM", "anim/zx_well.zip"),
	Asset("ATLAS", "images/minimap/zx_well.xml"),
	Asset("ATLAS", "images/zx_well.xml"),
	Asset("IMAGE", "images/zx_well.tex"),
}

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
    inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
end


-- 建造
local function onbuilt(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_craft")
end


local function fn()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, .25)
	inst:SetPhysicsRadiusOverride(.25)

    inst.MiniMapEntity:SetIcon("zx_well.tex")

    inst.AnimState:SetBank("zx_well")
    inst.AnimState:SetBuild("zx_well")
    inst.AnimState:PlayAnimation("idle",true)

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

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onHammered)
    -- inst.components.workable:SetOnWorkCallback(onHit)

    inst:ListenForEvent("onbuilt", onBuilt)
    return inst
end

return Prefab("zx_well", fn, assets, prefabs),
    MakePlacer("zx_well_placer", "zx_well", "zx_well", "idle")