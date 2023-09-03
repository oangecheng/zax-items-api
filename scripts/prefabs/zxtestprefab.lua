-- local assets = {
--     Asset("ANIM", "anim/zxhoneyjar1.zip"),
-- }

-- local prefabs = {
--     "collapse_small",
-- }


-- local function fn()

--     local inst = CreateEntity()
    
--     inst.entity:AddTransform()
--     inst.entity:AddAnimState()
--     inst.entity:AddMiniMapEntity()
--     inst.entity:AddNetwork()
	
-- 	MakeObstaclePhysics(inst, 1)
-- 	inst:SetPhysicsRadiusOverride(1)

--     inst.AnimState:SetBank("zxhoneyjar1")
--     inst.AnimState:SetBuild("zxhoneyjar1")
--     inst.AnimState:PlayAnimation("open")

--     inst:DoTaskInTime(5, function ()
--         inst.AnimState:OverrideSymbol("honey0", "zxhoneyjar1", "honey2")
--     end)

--     MakeSnowCoveredPristine(inst)

--     inst.entity:SetPristine()

--     inst:AddTag("watersource")
--     inst:AddTag("structure")

--     if not TheWorld.ismastersim then
-- 		return inst
--     end


--     return inst
-- end

-- return Prefab("zxhoneyjar1", fn, assets, prefabs),
--     MakePlacer("zxhoneyjar1_placer", "zxhoneyjar1", "zxhoneyjar1", "open")