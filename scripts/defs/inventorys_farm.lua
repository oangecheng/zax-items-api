local DIR = "images/inventoryimages/"

local ITEMS = {}


--- 灵魂
local ANIMAL_SOULS = (require "defs/zxitemdefs").souls
for k, _ in pairs(ANIMAL_SOULS) do
    ITEMS[k] = {
        assets = {
            Asset("ANIM", "anim/zxanimalsoul.zip"),
            Asset("ATLAS", DIR .. k .. ".xml"),
            Asset("IMAGE", DIR .. k .. ".tex")
        },

        bank   = "zxanimalsoul",
        build  = "zxanimalsoul",
        scale  = 1.5,
        loop   = false,
        tags   = { "ZXFARM_SOUL" },
        image  = k,
        atlas  = k,

        --- 替换素材
        initfn = function(inst, prefab)
            if k ~= "zxperd_soul" then
                inst.AnimState:OverrideSymbol("swap_soul", "zxanimalsoul", k)
            end
        end
    }
end


--- 饲料
local FOODS = (require "defs/zxitemdefs").foods.custom
for k, v in pairs(FOODS) do
    ITEMS[k] = {

        assets = {
            Asset("ANIM", "anim/zxfarmfood.zip"),
            Asset("ATLAS", DIR .. k .. ".xml"),
            Asset("IMAGE", DIR .. k .. ".tex")
        },

        bank   = "zxfarmfood",
        build  = "zxfarmfood",
        lopp   = false,
        tags   = { "ZXFARM_FOOD" },
        image  = k,
        atlas  = k,

        initfn = function(inst, prefab)
            inst.AnimState:OverrideSymbol("zxfarmfood_normal", "zxfarmfood", k)
        end
    }
end




return ITEMS
