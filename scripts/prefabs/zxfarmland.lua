local assets = {
    Asset("ANIM", "anim/zxfarmperd1.zip"),
    Asset("ANIM", "anim/zxmushroomhouse1.zip"),

}

local prefabs = {
    "collapse_small",
}


local function MakeLand(name)
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
        inst:AddTag("zxfarmitem")
    
        if not TheWorld.ismastersim then
            return inst
        end
    
    
        return inst
    end
    
    return Prefab(name, fn, assets, prefabs)
    
end


local function MakeItem(name)
    local function fn()

        local inst = CreateEntity()
        
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
    
        inst.AnimState:SetScale(0.5,0.5,0.5)
    
        inst.AnimState:SetBank("zxfarmperd1")
        inst.AnimState:SetBuild("zxfarmperd1")
        inst.AnimState:PlayAnimation("hatch")
    
        inst.entity:SetPristine()
    
        inst:AddTag("structure")
        inst:AddTag("NOBLOCK")
        inst:AddTag("zxfarmitem")
    
        if not TheWorld.ismastersim then
            return inst
        end
    
    
        return inst
    end
    
    return Prefab(name, fn, assets, prefabs)
    
end


return MakeLand("zxfarmperd1_land"),
MakeItem("zxhatchmachine")
