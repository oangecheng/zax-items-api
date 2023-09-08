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


local function spellCB(tool, target, pos, doer)
    if doer and target and target.components.zxskinable then
        target.components.zxskinable:ChangeSkin(doer)
        spawnFx(target)
    end
end


local function can_cast_fn(doer, target, pos)
    if doer and target and target.components.zxskinable then
        return target.components.zxskinable:CanChangeSkin(doer)
    end
    return false
end



local function net(inst)
    inst.useskinclient = function(inst, skinid)
        if TheWorld.ismastersim and skinid then
            inst.components.zxskinable:SetSkin(skinid)
        else
            SendModRPCToServer(MOD_RPC.zx_itemsapi.UseSkin, inst, skinid)
        end
    end
end



local function onequip(inst, owner)
    inst.zxowener = owner
    local symbol = ZxGetSwapSymbol(inst)
    owner.AnimState:OverrideSymbol("swap_object", symbol, "swap")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    inst.zxowener = nil
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
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
    inst.components.spellcaster:SetCanCastFn(can_cast_fn)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    inst.openShop = function ()
        inst.zxshopopen:set(true)
    end

    inst._cached_reskinname = {}

    return inst
end

return Prefab("zxskintool", tool_fn, assets, prefabs)