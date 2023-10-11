local assets = {
    Asset("ANIM", "anim/zxfarmperd1.zip"),
    Asset("ANIM", "anim/zxmushroomhouse1.zip"),
    Asset("ANIM", "anim/zxfarmhatch.zip"),
    Asset("ANIM", "anim/zxfarmbowl.zip")
}

local prefabs = {
    "collapse_small",
}


--- 农场物品被建造之后，push事件
local function observeItemBuild(inst)
    inst:ListenForEvent("onbuilt", function (item)
        TheWorld:PushEvent(ZXEVENTS.FARM_ITEM_BUILD, { item = item})
    end)
end



local function MakeLand()
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

        inst:AddComponent("zxbindable")
        return inst
    end
    return Prefab("zxfarmland", fn, assets, prefabs)
end


local function MakeHatchMachine(name)
    local function fn()

        local inst = CreateEntity()
        
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
    
    
        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("working", true)
        inst.AnimState:SetScale(0.8, 0.8, 0.8)
    
        inst.entity:SetPristine()
    
        inst:AddTag("structure")
        inst:AddTag("NOBLOCK")
        inst:AddTag("zxfarmitem")
    
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("zxbindable")
        observeItemBuild(inst)
        return inst
    end
    return Prefab(name, fn, assets, prefabs)  
end




local function MakeFarmBowl(name)
    local function fn()

        local inst = CreateEntity()
        
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
    
    
        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("empty")
        inst.AnimState:SetScale(0.8, 0.8, 0.8)
    
        inst.entity:SetPristine()
    
        inst:AddTag("structure")
        inst:AddTag("NOBLOCK")
        inst:AddTag("zxfarmitem")
    
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("zxbindable")
        observeItemBuild(inst)
        return inst
    end
    return Prefab(name, fn, assets, prefabs)  
end


return MakeLand(), 
MakeHatchMachine("zxfarmhatch"), MakePlacer("zxfarmhatch_placer", "zxfarmhatch", "zxfarmhatch", "working"),
MakeFarmBowl("zxfarmbowl"), MakePlacer("zxfarmbowl_placer", "zxfarmbowl", "zxfarmbowl", "empty")