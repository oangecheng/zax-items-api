
local DISTANCE = 4
local FARMS = (require "defs/zxfarmdefs").farms
local assets = {
    Asset("ANIM", "anim/zxfarmland.zip"),
}


local function getDistance()
    return DISTANCE * ZXTUNING.FARM_AREA
end


local prefabs = {
    "collapse_small",
}


for k, v in pairs(FARMS) do
    local res = ZxGetPrefabAnimAsset(k)
    for _, iv in ipairs(res) do
        table.insert(assets, iv)
    end
end


local function isValidBuilder(host, item)
    if item:HasTag("ZXFEEDER") then
        return not ZXFarmHasFeeder(host)
    elseif item:HasTag("ZXHATCHER") then
        return not ZXFarmHasHatcher(host)
    end
    return false
end


local function isValidDistance(host, item)
    local fx, _, fz = host.Transform:GetWorldPosition()
    local ix, _, iz = item.Transform:GetWorldPosition()

    local distance = getDistance()
    if fx and ix then
        return math.abs(fx-ix) <= distance and math.abs(fz-iz) <= distance
    else
        if fx == nil then
            host:Remove()
        end 
        if ix == nil then
            item:Remove()
        end
    end
    return false
end



--- 当农场的其他物品被建造时
--- 如果在范围内，就将其与农场主体绑定
local function onFarmItemBuild(host, item)
    -- 先判定农场有没有绑定过物品
    if not isValidBuilder(host, item) then
        return
    end

    local bindId = host.components.zxbindable:GetBindId()
    if bindId and host.farmdata then
        if isValidDistance(host, item) then
            local bindable = item.components.zxbindable
            if bindable and bindable:CanBind() then
                bindable:Bind(bindId, host.farmdata)
            end
        end
    end
end



local function MakeFarm(name, data)
     
    --- 建造主体的时候会生成地皮
    local function onBuild(inst)
        local x,y,z = inst.Transform:GetWorldPosition()
        local bindId = inst.prefab.."x"..tostring(x).."y"..tostring(y).."z"..tostring(z)
        -- 数据就在主体结构这里，不需要绑定数据
        inst.components.zxbindable:Bind(bindId, data)
        -- 移除地皮
        -- local land = SpawnPrefab("zxfarmland")
        -- land.components.zxbindable:Bind(bindId, data)
        -- land.Transform:SetPosition(x, y, z)
    end


    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState() 
        inst.entity:AddMiniMapEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst:AddTag("structure")
        inst:AddTag("ZXFARM_HOST")

        MakeObstaclePhysics(inst, 1)
        RemovePhysicsColliders(inst)

        ZxInitItemForClient(inst, name, "idle", true)
        inst.entity:SetPristine()
        
        if not TheWorld.ismastersim then
            return inst
        end

        ZxInitItemForServer(inst, name)

        inst.farmdata = data
    
        inst:AddComponent("timer")
        inst:AddComponent("inspectable")
        inst.components.inspectable.descriptionfn = function (_, _)
            local childleft = inst.components.zxfarm:GetLeftChildNum()
            if childleft > 0 then
                return string.format(STRINGS.ZXFARM_SPACELEFT, tostring(childleft))
            else
                return STRINGS.ZXFARM_SPACENO
            end
        end

        ZXFarmAddHarmmerdAction(inst, 5)

        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)

        inst:AddComponent("zxfarm")
        inst.components.zxfarm:SetChild(data.animal)
        inst.components.zxfarm:SetChildMaxCnt(data.animalcnt)
        inst.components.zxfarm:SetProduceFunc(data.producefunc)
        inst.components.zxfarm:SetProduceTime(data.producetime * ZXTUNING.FARM_TIME_MULTI)
        inst.components.zxfarm:SetFoodNum(data.foodnum)

        inst:AddComponent("zxbindable")
        inst.components.zxbindable:SetOnUnBindFunc(function(_, _, _)
            inst:Remove()
        end)
   
        --- 监听农场事件推送
        inst:ListenForEvent(ZXEVENTS.FARM_ADD_FOOD, function ()
            inst.components.zxfarm:StartProduce()
        end)
        inst:ListenForEvent(ZXEVENTS.FARM_HATCH_FINISHED, function ()
            inst.components.zxfarm:AddFarmAnimal()
        end)
        inst:ListenForEvent("onbuilt", onBuild)
        inst:ListenForEvent(ZXEVENTS.FARM_ITEM_BUILD, function (_, event)
            onFarmItemBuild(inst, event.item)
        end)
        
        return inst
    end
    
    return Prefab(name, fn, assets, nil)
end




local function MakeLand()
    local function fn()

        local inst = CreateEntity()
        
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
    
        local scale = 2 * ZXTUNING.FARM_AREA
        inst.AnimState:SetScale(scale, scale, scale)
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


local farmlist = {}
-- table.insert( farmlist, MakeLand())
for k, v in pairs(FARMS) do
    table.insert(farmlist, MakeFarm(k, v))
    table.insert(farmlist, MakePlacer(k.."_placer", k, k, "idle"))
end
return unpack(farmlist)