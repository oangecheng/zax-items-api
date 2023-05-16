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



