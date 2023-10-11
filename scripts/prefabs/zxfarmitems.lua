local assets = {
    Asset("ANIM", "anim/zxfarmperd1.zip"),
    Asset("ANIM", "anim/zxmushroomhouse1.zip"),
    Asset("ANIM", "anim/zxfarmhatch.zip"),
    Asset("ANIM", "anim/zxfarmbowl.zip")
}

local prefabs = {
    "collapse_small",
}

local FARMS = require "defs/zxfarmdefs"



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
        inst.AnimState:PlayAnimation("idle")
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

    local function updateBowlState(inst)
        local feeder = inst.components.zxfarmfeeder
        if feeder:GetFoodNum() > feeder:GetMaxFoodNum() * 0.2 then
            TheNet:Announce("充足的食物")
            inst.AnimState:PlayAnimation("full")
        else
            TheNet:Announce("食物太少了")
            inst.AnimState:PlayAnimation("empty")
        end
    end
    

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
        inst:AddTag("ZXFARMFEEDER")
    
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("zxbindable")
        observeItemBuild(inst)

        inst:AddComponent("zxfarmfeeder")
        inst.components.zxfarmfeeder:SetFoods(FARMS["zxperdfarm"].foods)
        -- 给食物尝试驱动下生产
        inst.components.zxfarmfeeder:SetOnGiveFoodFunc(function (_, foodnum)
            updateBowlState(inst)
        end)
        -- 食物消耗之后变更下动画
        inst.components.zxfarmfeeder:SetOnEatFoodFunc(function (_, foodnum)
            updateBowlState(inst)
        end)

        

        return inst
    end
    return Prefab(name, fn, assets, prefabs)  
end


return MakeLand(), 
MakeHatchMachine("zxfarmhatch"), MakePlacer("zxfarmhatch_placer", "zxfarmhatch", "zxfarmhatch", "working"),
MakeFarmBowl("zxfarmbowl"), MakePlacer("zxfarmbowl_placer", "zxfarmbowl", "zxfarmbowl", "empty")