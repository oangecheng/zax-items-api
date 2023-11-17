GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

require("zxtuning")
require("zxfunctions")


-- 仓库保鲜
TUNING.ZX_GRANARY_FRESHRATE = GetModConfigData("zx_granary_freshrate")
TUNING.ZX_GRANARY_DIFFICULT = GetModConfigData("zx_granary_difficult")
-- 一些其他物品
TUNING.ZX_MEATRACK = GetModConfigData("zx_meatrack")
TUNING.ZX_BEEBOX = GetModConfigData("zx_beebox")


ZXTUNING.IS_CH = GetModConfigData("zx_items_language") == "ch"
ZXTUNING.LIGHT_RADIUS_MULTI = GetModConfigData("zxlightradius") or 1
ZXTUNING.BOX_FRESH_RATE = TUNING.ZX_GRANARY_FRESHRATE or 0.2


ZXTUNING.FARM_ENABLE     = GetModConfigData("zxfarmenable")
ZXTUNING.FARM_AREA       = GetModConfigData("zxfarmarea")
ZXTUNING.FARM_MAX_LV     = GetModConfigData("zxfarmmaxlv")
ZXTUNING.FRAM_DROP_RATIO = GetModConfigData("zxfarmdroprate")


ZXTUNING.ZXPERD_SIZE    = GetModConfigData("zxperd_size") or 0.4
ZXTUNING.ZXPIGMAN_SIZE  = GetModConfigData("zxpigman_size") or 0.4
ZXTUNING.ZXBEEFALO_SIZE = GetModConfigData("zxbeefalo_size") or 0.4
ZXTUNING.ZXGOAT_SIZE    = GetModConfigData("zxgoat_size") or 0.4
ZXTUNING.ZXKOALEFANT_SIZE = GetModConfigData("zxkoalefant_size") or 0.4



modimport(ZXTUNING.IS_CH and "utils/strings_ch.lua" or "utils/strings_eng.lua")
require("zx_skin/zxskinutils")



Assets = {
    Asset("ANIM", "anim/ui_zx_5x10.zip"),
    Asset("ANIM", "anim/zx5x5_normal.zip"),
    Asset("ANIM", "anim/zx5x5_honey.zip"),

    Asset("ANIM", "anim/ui_chest_3x3.zip"),
    Asset("ATLAS", "images/inventoryimages/zx_meatrack_hermit.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_meatrack_hermit.tex"),
    Asset("ATLAS", "images/inventoryimages/zx_beebox_hermit.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_beebox_hermit.tex"),
    Asset("ATLAS", "images/zx_slotbg_honey.xml"),
    Asset("IMAGE", "images/zx_slotbg_honey.tex"),

    Asset("ANIM", "anim/zxstone.zip"),
    Asset("ATLAS", "images/inventoryimages/zxstone.xml"),
    Asset("IMAGE", "images/inventoryimages/zxstone.tex")
}


----加载所有的预览图
for k, v in pairs(ZxGetAllSkins()) do
    local path = "images/zxskins/"..k.."/"
    for i, s in ipairs(v.data) do
        table.insert(Assets, Asset("ATLAS", path..s.file..".xml"))
        table.insert(Assets, Asset("IMAGE", path..s.file..".tex"))
    end
end



PrefabFiles = {
	"zx_placers",
    "zx_flower",
    "zx_light",
    "zx_well",
        
    "zxflowerbush",
    "zxboxs",
    "zxlights",
    "zxskintools",
    "zxstone",
}






modimport("scripts/mods/zx_containers.lua")
modimport("utils/recipes.lua")
modimport("scripts/mods/zxhook.lua")
modimport("scripts/zxui.lua")
modimport("scripts/zxrpc.lua")
modimport("scripts/mods/minimap.lua")
modimport("scripts/zxactionhook.lua")


--- 选择是否加载农场功能
local farmprefabs = {
    "zxfarms",
    "zxfarmanimals",
    "zxfarmitems"
}
if ZXTUNING.FARM_ENABLE then
    require("zxfarmmanager")
    modimport("scripts/mods/zxfarminit")
    for _, v in ipairs(farmprefabs) do
        table.insert(PrefabFiles, v)
    end
end



AddPlayerPostInit(function(inst)
   ZxGetUserSkinFromServer(inst)
end)




-- 原版物品其他mod可能也有
-- 加个配置项是否可建造
if TUNING.ZX_MEATRACK then
    modimport("scripts/mods/zx_meatrack.lua")
end
if TUNING.ZX_BEEBOX then
    modimport("scripts/mods/zx_beebox.lua")
end




