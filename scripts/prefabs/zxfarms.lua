
local DISTANCE = 4
local FARMS = (require "defs/zxfarmdefs").farms
local assets = {}
local MULTIPLIER = { 0.8, 0.7, 0.6, 0.5 }

local animals = {
    zxperd_soul = "zxperd",
    zxpigman_soul = "zxpigman",
    zxbeefalo_soul = "zxbeefalo",
    zxgoat_soul = "zxgoat",
    zxkoalefant_w_soul = "zxkoalefant_w",
    zxkoalefant_s_soul = "zxkoalefant_s",
    zxcat_soul = "zxcat",
}



local function accelerateMax(lv)
    return ZXTUNING.ACCELERATE_TIME * (lv + 1)
end


local function accelerateMulti(lv)
    local index = math.max(lv + 1, #MULTIPLIER)
    return MULTIPLIER[index]
end


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
    if bindId then
        if isValidDistance(host, item) then
            local bindable = item.components.zxbindable
            if bindable and bindable:CanBind() then
                bindable:Bind(bindId)
            end
        end
    end
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


local function updateFarmDesc(inst)
    local max = inst.components.zxfarm:GetChildMaxCnt()
    local cnt = inst.components.zxfarm:GetChildCnt()
    local str = (ZXTUNING.IS_CH and "空间" or "Space")..tostring(cnt).."/"..tostring(max)
    if inst.zxextrainfo then
        inst.zxextrainfo:set("\n"..str)
    end
    local name = STRINGS.NAMES[string.upper(inst.prefab)]
    local lv = inst.components.zxupgradable:GetLv()
    if name then
        local newname = name.."[lv"..lv.."]"
        if inst.zxchangename then
            inst.zxchangename:set(newname)
        end
    end
end



local function MakeFarm(name, data)

    --- 升级，每级提升 50% 上限
    --- 同时提升可加速的时间上限
    local function onUpgradeFn(inst, lv)
        local farm = inst.components.zxfarm
        local delta = math.max(1, math.floor(data.animalcnt * 0.5))
        farm:SetChildMaxCnt(data.animalcnt + delta)
        updateFarmDesc(inst)

        local acc = inst.components.zxaccelerate
        acc:SetMaxDuration(accelerateMax(lv))
        acc:SetMultiplier(accelerateMulti(lv))

    end


    local function onAccelerate(inst, multiplier)
        local farm = inst.components.zxfarm
        local time = math.floor(data.producetime * multiplier)
        farm:SetProduceTime(time)
    end

     
    --- 建造主体的时候会生成地皮
    local function onBuild(inst)
        local x,y,z = inst.Transform:GetWorldPosition()
        local bindId = inst.prefab.."x"..tostring(x).."y"..tostring(y).."z"..tostring(z)
        inst.components.zxbindable:Bind(bindId)
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
        inst:AddTag("ZXUPGRADE")
        inst:AddTag("ZXACCELERATE")

        MakeObstaclePhysics(inst, 1)
        RemovePhysicsColliders(inst)

        ZxInitItemForClient(inst, name, "idle", true)
        inst.entity:SetPristine()
        
        net(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        ZxInitItemForServer(inst, name)

        inst.farmdata = data
    
        inst:AddComponent("timer")
        inst:AddComponent("inspectable")

        ZXFarmItemInitFunc(inst, 5)
        inst.onhitfn = function ()
            inst.AnimState:PlayAnimation("onhit")
            inst.AnimState:PushAnimation("idle")
        end

        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)

        inst:AddComponent("zxfarm")
        inst.components.zxfarm:SetChildMaxCnt(data.animalcnt)
        inst.components.zxfarm:SetProduceFunc(data.producefunc)
        inst.components.zxfarm:SetProduceTime(data.producetime)
        inst.components.zxfarm:SetFoodNum(data.foodnum)
        inst:AddComponent("zxbindable")

        ---加速组件
        inst:AddComponent("zxaccelerate")
        inst.components.zxaccelerate:SetMaxDuration(ZXTUNING.ACCELERATE_TIME)
        inst.components.zxaccelerate:SetMultiplier(MULTIPLIER[1])
        inst.components.zxaccelerate:SetOnAccelerateFn(onAccelerate)

        ---升级组件
        inst:AddComponent("zxupgradable")
        inst.components.zxupgradable:SetMax(data.upgrade.maxlv)
        inst.components.zxupgradable:SetMaterialTestFn(data.upgrade.testfn)
        inst.components.zxupgradable:SetOnUpgradeFn(onUpgradeFn)
   
        --- 监听农场事件推送
        inst:ListenForEvent(ZXEVENTS.FARM_ADD_FOOD, function ()
            inst.components.zxfarm:StartProduce()
        end)
        inst:ListenForEvent(ZXEVENTS.FARM_HATCH_FINISHED, function (_, d)
            local animal = d.soul and animals[d.soul]
            inst.components.zxfarm:AddFarmAnimal(animal)
        end)
        inst:ListenForEvent("onbuilt", onBuild)
        inst:ListenForEvent(ZXEVENTS.FARM_ITEM_BUILD, function (_, event)
            onFarmItemBuild(inst, event.item)
        end)

        
        return inst
    end
    
    return Prefab(name, fn, assets, prefabs)
end


local farmlist = {}
for k, v in pairs(FARMS) do
    table.insert(farmlist, MakeFarm(k, v))
    table.insert(farmlist, MakePlacer(k.."_placer", k, k, "idle"))
end
return unpack(farmlist)