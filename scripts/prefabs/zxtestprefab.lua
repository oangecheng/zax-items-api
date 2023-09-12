local assets = {
    Asset("ANIM", "anim/zxgranaryveggie1.zip"),
}

local prefabs = {
    "collapse_small",
}


local function fn()

    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)
    inst.AnimState:SetBank("zxgranaryveggie1")
    inst.AnimState:SetBuild("zxgranaryveggie1")
    inst.AnimState:PlayAnimation("idle", true)


    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    inst:AddTag("watersource")
    inst:AddTag("structure")

    if not TheWorld.ismastersim then
		return inst
    end
    inst:AddComponent("inspectable")


    return inst
end

return Prefab("zxgranaryveggie1", fn, assets, prefabs),
    MakePlacer("zxgranaryveggie1_placer", "zxgranaryveggie1", "zxgranaryveggie1", "idle")