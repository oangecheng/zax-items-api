local assets = {
    Asset("ANIM", "anim/zxfarmperd1.zip"),
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

    inst.AnimState:SetScale(1.5,1.5,1.5)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

	inst.AnimState:SetBank("zxfarmperd1")
    inst.AnimState:SetBuild("zxfarmperd1")
    inst.AnimState:PlayAnimation("land")

    inst.entity:SetPristine()

    inst:AddTag("structure")
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    if not TheWorld.ismastersim then
		return inst
    end


    return inst
end

return Prefab("zxfarmperd1_land", fn, assets, prefabs)