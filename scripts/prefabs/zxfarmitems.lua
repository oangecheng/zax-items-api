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
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetScale(0.8, 0.8, 0.8)
    
        inst.entity:SetPristine()
    
        inst:AddTag("structure")
        inst:AddTag("NOBLOCK")
        inst:AddTag("zxfarmitem")
        inst:AddTag("ZXHATCHER")
    
        if not TheWorld.ismastersim then
            return inst
        end
        -- 添加timer，用于孵化计时
        inst:AddComponent("timer")
        inst:AddComponent("inspectable")

        inst:AddComponent("zxhatcher")
        inst.components.zxhatcher:SetOnStartFunc(function ()
            inst.AnimState:PlayAnimation("working", true)
        end)
        inst.components.zxhatcher:SetOnStopFunc(function ()
            ZxFarmPushEvent(inst, ZXEVENTS.FARM_HATCH_FINISHED, { item = inst })
            inst.AnimState:PlayAnimation("idle")
        end)


        -- 农场组件绑定相关，绑定之后，设置孵化的物品和孵化时间
        observeItemBuild(inst)
        inst:AddComponent("zxbindable")
        inst.components.zxbindable:SetOnBindFunc(function (_, _, data)
            ZXLog("onBind 1")
            if not data then return end
            ZXLog("onBind 2"..data.hatchitem)
            inst.components.zxhatcher:SetHatchSeed(data.hatchitem)
            inst.components.zxhatcher:SetHatchTime(data.hatchtime)
        end)
        inst.components.zxbindable:SetOnUnBindFunc(function ()
            inst.components.zxhatcher:SetHatchSeed(nil)
            inst.components.zxhatcher:SetHatchTime(nil)
        end)


        return inst
    end
    return Prefab(name, fn, assets, prefabs)  
end




local function MakeFarmBowl(name)

    local function updateBowlState(inst)
        local feeder = inst.components.zxfeeder
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
        inst:AddTag("ZXFEEDER")
    
        if not TheWorld.ismastersim then
            return inst
        end
        
        inst:AddComponent("zxfeeder")
        -- 给食物尝试驱动下生产
        inst.components.zxfeeder:SetOnGiveFoodFunc(function (_, foodnum)
            updateBowlState(inst)
            ZxFarmPushEvent(inst, ZXEVENTS.FARM_ADD_FOOD, { item = inst})
        end)
        -- 食物消耗之后变更下动画
        inst.components.zxfeeder:SetOnEatFoodFunc(function (_, foodnum)
            updateBowlState(inst)
        end)

        -- 农场组件绑定，成功绑定，设置可以投放的食物参数
        observeItemBuild(inst)
        inst:AddComponent("zxbindable")
        inst.components.zxbindable:SetOnBindFunc(function (_, _, data)
            if not data then return end
            inst.components.zxfeeder:SetFoods(data.foods)
        end)
        inst.components.zxbindable:SetOnUnBindFunc(function()
            inst.components.zxfeeder:SetFoods(nil)
        end)
        

        return inst
    end
    return Prefab(name, fn, assets, prefabs)  
end


return MakeLand(), 
MakeHatchMachine("zxfarmhatch"), MakePlacer("zxfarmhatch_placer", "zxfarmhatch", "zxfarmhatch", "working"),
MakeFarmBowl("zxfarmbowl"), MakePlacer("zxfarmbowl_placer", "zxfarmbowl", "zxfarmbowl", "empty")