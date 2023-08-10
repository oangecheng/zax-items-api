GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

-- 仓库保鲜
TUNING.ZX_GRANARY_FRESHRATE = GetModConfigData("zx_granary_freshrate")
TUNING.ZX_GRANARY_DIFFICULT = GetModConfigData("zx_granary_difficult")
-- 语言
TUNING.ZX_ITEMS_LANGUAGE = GetModConfigData("zx_items_language")
-- 一些其他物品
TUNING.ZX_MEATRACK = GetModConfigData("zx_meatrack")
TUNING.ZX_BEEBOX = GetModConfigData("zx_beebox")



PrefabFiles = {
	"zx_granary",
	"zx_placers",
    "zx_flower",
    "zx_light",
    "zx_well",
    "zx_box",
}


Assets = {
    Asset("ANIM", "anim/ui_zx_5x10.zip"),	
    Asset("ANIM", "anim/ui_zx_5x5.zip"),	
    Asset("ATLAS", "images/inventoryimages/zx_meatrack_hermit.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_meatrack_hermit.tex"),
    Asset("ATLAS", "images/inventoryimages/zx_beebox_hermit.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_beebox_hermit.tex"),

    Asset("ATLAS", "images/medal_skins.xml"),
    Asset("IMAGE", "images/medal_skins.tex"),
    Asset("ATLAS", "images/zx_flower_1.xml"),
    Asset("IMAGE", "images/zx_flower_1.tex"),

    Asset("ATLAS", "images/zx_skins/zx_flower/juhua.xml"),
    Asset("IMAGE", "images/zx_skins/zx_flower/juhua.tex"),

}


local ch = TUNING.ZX_ITEMS_LANGUAGE == "ch"
modimport(ch and "utils/strings_ch.lua" or "utils/strings_eng.lua")
modimport("scripts/mods/zx_containers.lua")
modimport("utils/recipes.lua")
modimport("utils/minimap.lua")

-- 原版物品其他mod可能也有
-- 加个配置项是否可建造
if TUNING.ZX_MEATRACK then
    modimport("scripts/mods/zx_meatrack.lua")
end
if TUNING.ZX_BEEBOX then
    modimport("scripts/mods/zx_beebox.lua")
end

modimport("scripts/medal_ui.lua")--UI、容器等
require("utils/skin_test")


AddPlayerPostInit(function(inst)
    inst.skin_money = 100
    inst.skin_str = BuySkin()

    if TheWorld.ismastersim then
        inst:ListenForEvent("oneat", function(inst, data)
            inst:ShowPopUp(POPUPS.MEDALSKIN, true, inst)
        end)
    end
end)


-- act.doer:ShowPopUp(POPUPS.MEDALSKIN, true ,act.invobject)



