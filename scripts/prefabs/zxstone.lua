
local assets = {
    Asset("ANIM", "anim/zxstone.zip"),
    Asset("ATLAS", "images/inventoryimages/zxstone.xml"),
    Asset("IMAGE", "images/inventoryimages/zxstone.tex")
}


local prefabs = {
    "collapse_small",
}


local function ondropped(inst)
    inst.AnimState:PlayAnimation("idle", false)
end


local function fn()

    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("zxstone")
    inst.AnimState:SetBuild("zxstone")
    inst.AnimState:PlayAnimation("idle", false)

    inst.entity:SetPristine()
    inst:AddTag("ZXSTONE")   

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetSinks(true)
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem.imagename = "zxstone"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/zxstone.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    return inst
end
return Prefab("zxstone", fn, assets, prefabs)