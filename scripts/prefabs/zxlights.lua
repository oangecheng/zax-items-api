require("prefabs/mushtree_spores")

local PREABLE = "zxlight"

local assets = ZxGetPrefabAnimAsset(PREABLE)
table.insert(assets, Asset("ANIM", "anim/ui_lamp_1x4.zip"))
local defalutSKin = ZxGetPrefabDefaultSkin(PREABLE)
---打开关闭的声音
local sound = "dontstarve/common/together/mushroom_lamp/lantern_1_on"

-- 放置孢子
local light_str = {
    {radius = 5.5, falloff = .85, intensity = 0.75},
    {radius = 6.5, falloff = .85, intensity = 0.75},
    {radius = 8.0, falloff = .85, intensity = 0.75},
    {radius = 10,  falloff = .85, intensity = 0.75},
}

-- 啥也不放的配置
local empty_light_str = {
    radius  = 5, falloff = 0.85, intensity = 0.75
}
-- 放特殊物品
local fulllight_light_str = {
    radius = 10, falloff = 0.85, intensity = 0.75
}

local colour_tint = { 0.4, 0.3, 0.25, 0.2, 0.1  }
local mult_tint   = { 0.7, 0.6, 0.55, 0.5, 0.45 }

-- 物品色值定义
local COLOURED_LIGHTS = {
    red = {
        [MUSHTREE_SPORE_RED] = true,
        ["winter_ornament_light1"] = true,
        ["winter_ornament_light5"] = true,
    },

    green = {
        [MUSHTREE_SPORE_GREEN] = true,
        ["winter_ornament_light2"] = true,
        ["winter_ornament_light6"] = true,
    },

    blue = {
        [MUSHTREE_SPORE_BLUE] = true,
        ["winter_ornament_light3"] = true,
        ["winter_ornament_light7"] = true,
    },
}


local function isBatteryType(item)
    return item:HasTag("lightbattery")
        or item:HasTag("spore")
        or item:HasTag("lightcontainer")
end


local function isLightOn(inst)
    return inst.Light:IsEnabled()
end


local function IsRedSpore(item)
    if COLOURED_LIGHTS.red[item.prefab] then
        return true
    elseif item.components.container ~= nil then
        return item.components.container:FindItem(IsRedSpore) ~= nil
    else
        return false
    end
end

local function IsGreenSpore(item)
    if COLOURED_LIGHTS.green[item.prefab] then
        return true
    elseif item.components.container ~= nil then
        return item.components.container:FindItem(IsGreenSpore) ~= nil
    else
        return false
    end
end

local function IsBlueSpore(item)
    if COLOURED_LIGHTS.blue[item.prefab] then
        return true
    elseif item.components.container ~= nil then
        return item.components.container:FindItem(IsBlueSpore) ~= nil
    else
        return false
    end
end


local function isFullLighter(item)
    return item:HasTag("fulllighter")
end


local function updateLightState(inst)
    if inst:HasTag("burnt") then
        return
    end
    local config = nil
    local batterycnt = #inst.components.container:FindItems(isBatteryType)
    if batterycnt > 0 then
        local full = #inst.components.container:FindItems(isFullLighter) > 0
        config = full and fulllight_light_str or light_str[batterycnt]
        local r = #inst.components.container:FindItems(IsRedSpore)
        local g = #inst.components.container:FindItems(IsGreenSpore)
        local b = #inst.components.container:FindItems(IsBlueSpore)
        inst.Light:SetColour(colour_tint[g+b + 1] + r/11, colour_tint[r+b + 1] + g/11, colour_tint[r+g + 1] + b/11)
    else
        config = empty_light_str
        inst.Light:SetColour(.65, .65, .5)
    end
    inst.Light:SetRadius(config.radius * ZXTUNING.LIGHT_RADIUS_MULTI)
    inst.Light:SetFalloff(config.falloff)
    inst.Light:SetIntensity(config.intensity)
end


local prefabs = {
    "collapse_small",
}


local function onhit(inst, worker)
	inst.AnimState:PushAnimation("close", true)
end

local function open(inst)
    updateLightState(inst)
	inst.Light:Enable(true)
	inst.AnimState:PlayAnimation("open", true)
    inst.SoundEmitter:PlaySound(sound)
end


local function close(inst)
    inst.Light:Enable(false)
    inst.AnimState:PlayAnimation("close")
    inst.SoundEmitter:PlaySound(sound)
end


local function tryopen(inst, isnight)
    if isnight then
        if not isLightOn(inst) then
            open(inst)
        end
    elseif isLightOn(inst) then
        inst:DoTaskInTime(3.0, close)
    end
end


local function onbuild(inst)
    tryopen(inst, TheWorld.state.isnight)
end


local function onhammered(inst)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:DropLoot()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end


local function on_burnt(inst)
    inst:Remove()
end


local function MakeLight(name, initSkinId)

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        inst.entity:AddLight()

        inst.Light:Enable(false)

        inst:AddTag("zxlight")
        inst:AddTag("structure")
        MakeObstaclePhysics(inst, .2)


        inst.AnimState:SetBank(defalutSKin.bank)
        inst.AnimState:SetBuild(defalutSKin.build)
        inst.AnimState:PlayAnimation("close")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("lootdropper")
        inst:AddComponent("zxskinable")


        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)

        inst:AddComponent("container")
        inst.components.container:WidgetSetup(name)
        inst:ListenForEvent("itemget", updateLightState)
        inst:ListenForEvent("itemlose", updateLightState)
        --永亮灯内部永久保鲜
        inst:AddComponent("preserver")
        inst.components.preserver:SetPerishRateMultiplier(0)

        inst:ListenForEvent("onbuilt", onbuild)
        inst:WatchWorldState("isnight", tryopen)
        updateLightState(inst)
        tryopen(inst, TheWorld.state.isnight)


        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)
        AddHauntableDropItemOrWork(inst)

        inst.components.burnable:SetOnBurntFn(on_burnt)


        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end


return MakeLight(PREABLE),
MakePlacer(PREABLE.."_placer", defalutSKin.bank, defalutSKin.bank, "close")