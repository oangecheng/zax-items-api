local assets = {
    Asset("ANIM", "anim/zx_flower.zip"),	
    Asset("ATLAS", "images/inventoryimages/zx_flower_1.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_flower_1.tex"),
}


local function on_hammered(inst)
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
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(on_hammered)

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)

    return inst
end


return Prefab("zx_flower_1", fn, assets, prefabs),
MakePlacer("zx_flower_1_placer", "zx_flower", "zx_flower", "zx_flower_1")