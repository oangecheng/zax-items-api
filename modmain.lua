GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

-- 仓库保鲜
TUNING.ZX_GRANARY_FRESHRATE = GetModConfigData("zx_granary_freshrate")
TUNING.ZX_GRANARY_DIFFICULT = GetModConfigData("zx_granary_difficult")
-- 语言
TUNING.ZX_ITEMS_LANGUAGE = GetModConfigData("zx_items_language")



PrefabFiles = {
	"zx_granary_meat",
	"zx_granary_veggie"
}


Assets = {
    Asset("ANIM", "anim/ui_zx_5x10.zip"),
}


local ch = TUNING.ZX_ITEMS_LANGUAGE == "ch"
modimport(ch and "utils/strings_ch" or "utils/strings_eng")
modimport("scripts/mods/zx_containers.lua")
modimport("utils/recipes")
modimport("utils/minimap")



