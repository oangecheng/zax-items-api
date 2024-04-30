local DIR = "images/inventoryimages/"

local ITEMS = {}


--- 灵魂
local ANIMAL_SOULS = (require "defs/zxitemdefs").souls
for k, _ in pairs(ANIMAL_SOULS) do
    ITEMS[k] = {
        assets = {
            Asset("ANIM", "anim/zxanimalsoul.zip"),
            Asset("ATLAS", DIR .. "zxsoul.xml"),
            Asset("IMAGE", DIR .. "zxsoul.tex")
        },

        bank   = "zxanimalsoul",
        build  = "zxanimalsoul",
        scale  = 1.5,
        loop   = false,
        tags   = { "ZXFARM_SOUL" },
        image  = k,
        atlas  = "zxsoul",

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


--- 变异药水
ITEMS["zxpotion_trans"] = {
    assets = {
        Asset("ANIM", "anim/zxpotion.zip"),
        Asset("ATLAS", DIR .."zxpotion.xml"),
        Asset("IMAGE", DIR .."zxpotion.tex")
    },
    bank  = "zxpotion",
    build = "zxpotion",
    loop  = false,
    tags  = { ZXTAGS.TRANS },
    image = "zxpotion_trans",
    atlas = "zxpotion",

    initfn = function (inst, _, _)
        inst.AnimState:OverrideSymbol("swap_potion", "zxpotion", "zxpotion_trans")
    end
}




return ITEMS
