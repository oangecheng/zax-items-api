local assets = {
    Asset("ANIM", "anim/zxfarmland.zip"),
    Asset("ANIM", "anim/zxmushroomhouse1.zip"),
    Asset("ANIM", "anim/zxfarmhatch.zip"),
    Asset("ANIM", "anim/zxfarmbowl.zip"),
}


local FARMS = (require "defs/zxfarmdefs")


local prefabs = {
    "collapse_small",
}




local function MakeFarmFood(name)

    local function ondropped(inst)
        inst.AnimState:PlayAnimation("idle", false)
    end

    local foodassets = {
        Asset("ANIM", "anim/zxfarmfood.zip"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex")
    }
    

    local function fn()

        local inst = CreateEntity()
        
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

    
        inst.AnimState:SetBank("zxfarmfood")
        inst.AnimState:SetBuild("zxfarmfood")
        inst.AnimState:PlayAnimation("idle", false)
        inst.AnimState:OverrideSymbol("zxfarmfood_normal", "zxfarmfood", name)

        inst.entity:SetPristine()
        inst:AddTag("ZXFARM_FOOD")   

        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem:SetOnDroppedFn(ondropped)
        inst.components.inventoryitem.imagename = name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = 40
        return inst
    end
    return Prefab(name, fn, foodassets, prefabs)
end





local function MakeAnimalSoul(name)

    local function ondropped(inst)
        inst.AnimState:PlayAnimation("idle", false)
    end

    local soulassets = {
        Asset("ANIM", "anim/zxanimalsoul.zip"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex")
    }
    

    local function fn()

        local inst = CreateEntity()
        
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

    
        inst.AnimState:SetBank("zxanimalsoul")
        inst.AnimState:SetBuild("zxanimalsoul")
        inst.AnimState:SetScale(1.5,1.5,1.5)
        inst.AnimState:PlayAnimation("idle", false)
        if name ~= "zxperd_soul" then
            inst.AnimState:OverrideSymbol("swap_soul", "zxanimalsoul", name)
        end

        inst.entity:SetPristine()
        inst:AddTag("ZXFARM_SOUL")   

        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem:SetOnDroppedFn(ondropped)
        inst.components.inventoryitem.imagename = name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = 20
        return inst
    end
    return Prefab(name, fn, soulassets, prefabs)
end





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
    
        inst.AnimState:SetScale(2,2,2)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
    
        inst.AnimState:SetBank("zxfarmland")
        inst.AnimState:SetBuild("zxfarmland")
        inst.AnimState:PlayAnimation("land1")
    
        inst.entity:SetPristine()
    
        inst:AddTag("structure")
        inst:AddTag("NOBLOCK")
        inst:AddTag("NOCLICK")
        inst:AddTag("zxfarmitem")
    
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("zxbindable")
        inst.components.zxbindable:SetOnUnBindFunc(function ()
            inst:Remove()
        end)
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
        ZXAddHarmmerdAction(inst)

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
            if not data then return end
            inst.components.zxhatcher:SetHatchSeed(data.hatchitem)
            inst.components.zxhatcher:SetHatchTime(data.hatchtime)
        end)
        inst.components.zxbindable:SetOnUnBindFunc(function (_, _, data)
            inst.components.zxhatcher:SetHatchSeed(nil)
            inst.components.zxhatcher:SetHatchTime(nil)
          
            if inst.components.zxhatcher:IsWorking() then
                local x,y,z = inst.Transform:GetWorldPosition()
                if x and y and z then
                    local ent = SpawnPrefab(data.hatchitem)
                    if ent then
                        ent.Transform:SetPosition(x, y, z)
                    end
                end
            end
            inst:Remove()
        end)


        return inst
    end
    return Prefab(name, fn, assets, prefabs)  
end





local function MakeFarmBowl(name)

    local foodsdef = FARMS.foods

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
        ZXAddHarmmerdAction(inst)

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
            local list = {}
            for _, v in ipairs(data.foods) do
                local temp = foodsdef[v]
                if temp then
                    list[v] = temp
                end
            end
            inst.components.zxfeeder:SetFoods(list)
        end)
        inst.components.zxbindable:SetOnUnBindFunc(function()
            inst.components.zxfeeder:SetFoods(nil)
            inst:Remove()
        end)
        

        return inst
    end
    return Prefab(name, fn, assets, prefabs)  
end


local items = {}
for i, v in pairs(FARMS.souls) do
    table.insert(items, MakeAnimalSoul(v))
end
for k, _ in pairs(FARMS.foods) do
    table.insert(items, MakeFarmFood(k))
end


return MakeLand(), 
MakeHatchMachine("zxfarmhatch"), MakePlacer("zxfarmhatch_placer", "zxfarmhatch", "zxfarmhatch", "working"),
MakeFarmBowl("zxfarmbowl"), MakePlacer("zxfarmbowl_placer", "zxfarmbowl", "zxfarmbowl", "empty"),
unpack(items)