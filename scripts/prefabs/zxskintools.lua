-- 法杖模式
local MODE_SKIN    = 0
local MODE_MIRROR  = 1
local MODE_ENLARGE = 2
local MODE_SHRINK  = 3
local SIZE = MODE_SHRINK + 1

local isch = ZXTUNING.IS_CH

local modes = {
    [MODE_SKIN] = { 
        name = isch and "换肤模式" or "Skin Mode",
        msg  = isch and "换一种感觉" or "Rotate",
    },
    [MODE_MIRROR] = { 
        name = isch and "镜像模式" or "Mirror Mode",
        msg  = isch and "转过来瞧瞧" or "Rotate",
    },
    [MODE_ENLARGE] = { 
        name = isch and "放大模式" or "Enlarge Mode",
        msg  = isch and "大!大!大!" or "Bigger!",
    },
    [MODE_SHRINK] = { 
        name = isch and "缩小模式" or "Shrink mode",
        msg  = isch and "小!小!小!" or "Smaller!",
    },
}


local assets = {
    Asset("ANIM", "anim/zxskintool1.zip"),
    Asset("ANIM", "anim/swap_zxskintool1.zip"),
    Asset("ATLAS", "images/zxskins/zxskintool/zxskintool1.xml"),
    Asset("IMAGE", "images/zxskins/zxskintool/zxskintool1.tex"),

    Asset("ANIM", "anim/zxskintool2.zip"),
    Asset("ANIM", "anim/swap_zxskintool2.zip"),
    Asset("ATLAS", "images/zxskins/zxskintool/zxskintool2.xml"),
    Asset("IMAGE", "images/zxskins/zxskintool/zxskintool2.tex"),

    Asset("ANIM", "anim/zxskintool3.zip"),
    Asset("ANIM", "anim/swap_zxskintool3.zip"),
    Asset("ATLAS", "images/zxskins/zxskintool/zxskintool3.xml"),
    Asset("IMAGE", "images/zxskins/zxskintool/zxskintool3.tex")
}

local prefabs = {
    "tornado",
}


--生成特效
local function spawnFx(inst)
    local resizeable = inst.components.zxresizeable
    local multi = resizeable and resizeable:GetScale() or 1

    local offset = {y=0.5,scale=1.2}
	local fx = SpawnPrefab("explode_reskin")
	local x,y,z=inst.Transform:GetWorldPosition()
	local offset_y = offset and offset.y or 0
	local scale = (offset and offset.scale or 1) * multi
	if fx then
		fx.Transform:SetScale(scale, scale, scale)
		fx.Transform:SetPosition(x,y+offset_y,z)
	end
end


local function changeSkin(target, doer)
    if doer and target and target.components.zxskinable then
        target.components.zxskinable:ChangeSkin(doer)
        spawnFx(target)
    end
end 


local function trySay(player, mode)
    local msg = modes[mode].msg
    if player.components.talker then
        player.components.talker:Say(msg)
    end
end


local function doAnimAction(tool, target, player)
    local resizeable = target and target.components.zxresizeable
    local mode = tool.mode
    if resizeable then
        if mode == MODE_MIRROR then
            resizeable:Mirror(player)
        elseif mode == MODE_ENLARGE then
            resizeable:Enlarge(player)
        elseif mode == MODE_SHRINK then
            resizeable:Shrink(player)
        end
        spawnFx(target)
        trySay(player, tool.mode)
    end
end



local function spellCB(tool, target, pos, doer)
    local player = doer or tool.zxowener
    if tool.mode == MODE_SKIN then
        changeSkin(target, player)
    else
        doAnimAction(tool, target, player)
    end
end


local function can_cast_fn(inst, doer, target, pos)
    local player = doer or inst.zxowener
    if not (player and target) then
       return false
    end
    if inst.mode == MODE_SKIN then
        local skinable = target.components.zxskinable
        return skinable and skinable:CanChangeSkin(player)
    else
        return target.components.zxresizeable ~= nil
    end
end



local function net(inst)
    inst.zxchangename = net_string(inst.GUID, "zxchangename", "zx_itemsapi_itemdirty")
    inst:ListenForEvent("zx_itemsapi_itemdirty", function(inst)
        local newname = inst.zxchangename:value()
		if newname then
			inst.displaynamefn = function(aaa)
				return newname
			end
		end
	end)

    inst.useskinclient = function(inst, skinid)
        if TheWorld.ismastersim and skinid then
            inst.components.zxskinable:SetSkin(skinid)
        else
            SendModRPCToServer(MOD_RPC.zx_itemsapi.UseSkin, inst, skinid)
        end
    end

    inst.switchMode = function(inst, mode)
        if TheWorld.ismastersim and mode then
            inst.SetMode(mode)
        else
            SendModRPCToServer(MOD_RPC.zx_itemsapi.SwitchMode, inst, mode)
        end
    end
end

local function changeName(inst, mode)
    local name = STRINGS.NAMES[string.upper(inst.prefab)]
    if name and mode then
        local newname = name.."["..tostring(modes[mode].name).."]"
        if inst.zxchangename then
            inst.zxchangename:set(newname)
        end
    end
end




local function onequip(inst, owner)
    inst.zxowener = owner
    local symbol = ZxGetSwapSymbol(inst)
    owner.AnimState:OverrideSymbol("swap_object", symbol, "swap")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    inst:AddTag("zxshop")
end



local function onunequip(inst, owner)
    inst.zxowener = nil
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    inst:RemoveTag("zxshop")
end

local function tool_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("zxskintool1")
    inst.AnimState:SetBuild("zxskintool1")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("nopunch")
    inst:AddTag("zxskintool")
    inst:AddTag("veryquickcast")

    MakeInventoryFloatable(inst)
    inst.entity:SetPristine()

    net(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/zxskins/zxskintool/zxskintool1.xml"
    inst.components.inventoryitem.imagename = "zxskintool1"


    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("zxskinable")

    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseondead = true
    inst.components.spellcaster.veryquickcast = true
    inst.components.spellcaster.canusefrominventory  = false
    inst.components.spellcaster:SetSpellFn(spellCB)
    inst.components.spellcaster:SetCanCastFn(function (doer, target, pos)
        return can_cast_fn(inst, doer, target, pos)
    end)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    inst.openShop = function ()
        inst.zxshopopen:set(true)
    end

    inst.mode = MODE_SKIN
    inst.SetMode = function (mode)
        inst.mode = mode
        changeName(inst, inst.mode)
    end

    inst.OnLoad = function (_, data)
        inst.mode = data.mode or MODE_SKIN
        changeName(inst, inst.mode)
    end
    inst.OnSave = function (_, data)
        data.mode = inst.mode
    end

    inst._cached_reskinname = {}

    return inst
end

return Prefab("zxskintool", tool_fn, assets, prefabs)