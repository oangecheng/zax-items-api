local assets = {
    Asset("ANIM", "anim/zxfarmhatch.zip"),
    Asset("ANIM", "anim/zxfarmbowl.zip"),
    Asset("ANIM", "anim/zxanimalsoul.zip")
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
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
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
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
        return inst
    end
    return Prefab(name, fn, soulassets, prefabs)
end




local function net(inst)
    inst.zxchangename = net_string(inst.GUID, "zxchangename", "zx_itemsapi_itemdirty")
    inst.zxextrainfo  = net_string(inst.GUID, "zxextrainfo" , "zx_itemsapi_itemdirty") 
    inst:ListenForEvent("zx_itemsapi_itemdirty", function(inst)
        local newname = inst.zxchangename:value()
		if newname then
			inst.displaynamefn = function(aaa)
				return newname
			end
		end

        local extrainfo = inst.zxextrainfo:value()
        inst.zxextrainfostr = extrainfo or nil
	end)
end


local function changeName(inst, suffix)
    local name = STRINGS.NAMES[string.upper(inst.prefab)]
    if name and suffix then
        local newname = name.."["..suffix.."]"
        if inst.zxchangename then
            inst.zxchangename:set(newname)
        end
    end
end


--- 更新显示的额外信息
--- @param info string 信息
local function updateDisplayInfo(inst, info)
    if inst.zxextrainfo and info then
        inst.zxextrainfo:set(info)
    end
end




local function MakeHatchMachine(name)

    local scale = 0.8

    local res = ZxGetPrefabAnimAsset(name)

    local function fn()

        local inst = CreateEntity()
        
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
    
    
        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("idle")
        
        ZxInitItemForClient(inst, name, "idle")

        inst.AnimState:SetScale(scale, scale, scale)
    
        inst.entity:SetPristine()
    
        inst:AddTag("structure")
        inst:AddTag("NOBLOCK")
        inst:AddTag("ZXHATCHER")
    
        net(inst)

        if not TheWorld.ismastersim then
            return inst
        end
        -- 添加timer，用于孵化计时
        inst:AddComponent("timer")
        inst:AddComponent("inspectable")
        inst.components.inspectable.descriptionfn = function (_, viewer)
            if inst.components.zxhatcher:IsWorking() then
                return STRINGS.ZXFARMHATCH_WORKING
            else
                return STRINGS.ZXFARMHATCH_IDLE
            end
        end

        ZxInitItemForServer(inst, name, scale)
        ZXFarmItemInitFunc(inst)

        inst:AddComponent("zxhatcher")
        inst.components.zxhatcher:SetOnStartFunc(function (_, seed)
            inst.AnimState:PlayAnimation("working", true)
            local anim = (seed == "zxperd_soul") and "swap_soul" or seed
            inst.AnimState:OverrideSymbol("swap_soul", "zxanimalsoul", anim)
        end)
        inst.components.zxhatcher:SetOnStopFunc(function (_, seed)
            ZxFarmPushEvent(inst, ZXEVENTS.FARM_HATCH_FINISHED, { item = inst, soul = seed })
            inst.AnimState:PlayAnimation("idle")
        end)


        -- 农场组件绑定相关，绑定之后，设置孵化的物品和孵化时间
        ZXFarmObserveItemBuild(inst)
        inst:AddComponent("zxbindable")
        inst.components.zxbindable:SetOnBindFunc(function (_, _, data)
            if not data then return end
            inst.components.zxhatcher:SetHatchSeeds(data.hatchitems)
            inst.components.zxhatcher:SetHatchTime(data.hatchtime)
            changeName(inst, STRINGS.ZX_HASBIND)
        end)

        inst.components.zxbindable:SetOnUnBindFunc(function (_, _, data)
            inst.components.zxhatcher:SetHatchSeeds(nil)
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
        end)

        inst.OnLoad = function (inst, data)
            local hatcher = inst.components.zxhatcher
            if hatcher:IsWorking() then
                local seed = hatcher:GetSeed()
                inst.AnimState:PlayAnimation("working", true)
                local anim = (seed == nil or seed == "zxperd_soul") and "swap_soul" or seed
                inst.AnimState:OverrideSymbol("swap_soul", "zxanimalsoul", anim)
            end
        end


        return inst
    end
    return Prefab(name, fn, res, prefabs)  
end





local function MakeFarmBowl(name)

    local LEFT_RATIO = 0.3

    local res = ZxGetPrefabAnimAsset(name)

    local foodsdef = FARMS.foods

    local function updateBowlState(inst)
        local feeder = inst.components.zxfeeder
        local foodleft = feeder:GetFoodNum()
        local foodmax  = feeder:GetFoodMaxNum()
        if foodleft >= foodmax * 0.5 then
            inst.AnimState:PlayAnimation("full")
        elseif foodleft >= foodmax * LEFT_RATIO then
            inst.AnimState:PlayAnimation("half")
        else
            inst.AnimState:PlayAnimation("empty")
        end
        local str = tostring(foodleft).."/"..tostring(foodmax)
        local info = "\n"..string.format(STRINGS.ZXFARMBOWL_FOODLEFT, str)
        updateDisplayInfo(inst, info)
    end
    

    local function fn()

        local scale = 0.8
        local inst = CreateEntity()
        
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
    
    
        ZxInitItemForClient(inst, name, "empty")
        inst.AnimState:SetScale(scale, scale, scale)
    
        inst.entity:SetPristine()
    
        inst:AddTag("structure")
        inst:AddTag("NOBLOCK")
        inst:AddTag("ZXFEEDER")
        inst:AddTag("ZXUPGRADE")
    
        net(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        
        inst:AddComponent("zxfeeder")
        inst:AddComponent("inspectable")
        inst.components.inspectable.descriptionfn = function (_, viewer)
            local foodleft = inst.components.zxfeeder:GetFoodNum()
            local foodmax  = inst.components.zxfeeder:GetFoodMaxNum()
            if foodleft <= 0 then return STRINGS.ZXFARMBOWL_EMPTY
            elseif foodleft < foodmax * LEFT_RATIO then return STRINGS.ZXFARMBOWL_NOTENOUGH
            else return STRINGS.ZXFARMBOWL_ENOUGH end
        end

        ZxInitItemForServer(inst, name, scale)
        ZXFarmItemInitFunc(inst)

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
        ZXFarmObserveItemBuild(inst)
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
            changeName(inst, STRINGS.ZX_HASBIND)
        end)

        inst.components.zxbindable:SetOnUnBindFunc(function()
            inst.components.zxfeeder:SetFoods(nil)
        end)

        inst:AddComponent("zxupgradable")
        inst.components.zxupgradable:SetMax(ZXTUNING.FARM_MAX_LV)
        inst.components.zxupgradable:SetMaterialTestFn(function (_, item, lv)
            return item.prefab == "thulecite"
        end)
        inst.components.zxupgradable:SetOnUpgradeFn(function (_, lv)
            inst.components.zxfeeder:SetFoodMaxNum(ZXTUNING.FOOD_MAX_NUM * (1 + lv * 0.5))
            updateBowlState(inst)
        end)

        
        updateBowlState(inst)
        inst.OnLoad = function (_, data)
            updateBowlState(inst)
        end

        return inst
    end
    return Prefab(name, fn, res, prefabs)  
end


local items = {}
for i, v in pairs(FARMS.souls) do
    table.insert(items, MakeAnimalSoul(v))
end

local customfoods = { "zxfarmfood_normal" }
for _, v in ipairs(customfoods) do
    table.insert(items, MakeFarmFood(v))
end


return
MakeHatchMachine("zxfarmhatch"), MakePlacer("zxfarmhatch_placer", "zxfarmhatch", "zxfarmhatch", "working"),
MakeFarmBowl("zxfarmbowl"), MakePlacer("zxfarmbowl_placer", "zxfarmbowl", "zxfarmbowl", "empty"),
unpack(items)