-- 法杖模式
local MODE_SKIN    = 1
local MODE_MIRROR  = 2
local MODE_ENLARGE = 3
local MODE_SHRINK  = 4
local SIZE = MODE_SHRINK


local assets = {
    Asset("ANIM", "anim/zxskintool1.zip"),
    Asset("ANIM", "anim/swap_zxskintool1.zip"),
    Asset("ATLAS", "images/zxskins/zxskintool/zxskintool1.xml"),
    Asset("IMAGE", "images/zxskins/zxskintool/zxskintool1.tex"),

    Asset("ANIM", "anim/zxskintool2.zip"),
    Asset("ANIM", "anim/swap_zxskintool2.zip"),
    Asset("ATLAS", "images/zxskins/zxskintool/zxskintool2.xml"),
    Asset("IMAGE", "images/zxskins/zxskintool/zxskintool2.tex")
}

local prefabs = {
    "tornado",
}


--生成特效
local function spawnFx(inst)
    local offset = {y=0.5,scale=1.2}
	local fx = SpawnPrefab("explode_reskin")
	local x,y,z=inst.Transform:GetWorldPosition()
	local offset_y = offset and offset.y or 0
	local scale = offset and offset.scale or 1
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


local function trySay(player, msg)
    if player.components.talker then
        player.components.talker:Say(msg)
    end
end


local function doAnimAction(tool, target, player)
    local resizeable = target.components.zxresizeable
    if resizeable then
        if tool.mode == MODE_MIRROR then
            resizeable:Mirror(player)
            spawnFx(target)
            trySay(player, "转过来瞧瞧")
        elseif tool.mode == MODE_ENLARGE then
            resizeable:Enlarge(player)
            spawnFx(target)
            trySay(player, "大大大")
        elseif tool.mode == MODE_SHRINK then
            resizeable:Shrink(player)
            spawnFx(target)
            trySay(player, "小小小")
        end
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
        local extrainfo = inst.zxextrainfo:value()
        inst.zxextrainfostr = extrainfo or nil
	end)

    inst.useskinclient = function(inst, skinid)
        if TheWorld.ismastersim and skinid then
            inst.components.zxskinable:SetSkin(skinid)
        else
            SendModRPCToServer(MOD_RPC.zx_itemsapi.UseSkin, inst, skinid)
        end
    end
end

local function changeName(inst, mode)
    local name = STRINGS.NAMES[string.upper(inst.prefab)]
    if name and mode then
        local newname = name.."["..mode.."]"
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
    inst:RemoveTag("zxswitchmode")
end



local function onunequip(inst, owner)
    inst.zxowener = nil
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    inst:RemoveTag("zxshop")
    inst:AddTag("zxswitchmode")
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
    inst.switchMode = function ()
        local m = inst.mode or MODE_SKIN
        local next = (m + 1) % SIZE
        inst.mode = next
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