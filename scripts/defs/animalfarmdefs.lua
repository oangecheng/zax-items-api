local HATCH_BASE_TIME = ZXTUNING.DEBUG and 60 or TUNING.TOTAL_DAY_TIME * 0.5
local MATERIALS = (require "defs/zxitemdefs").upgrade.farm


local function obtainFarmUpgrade()
    return {
        maxlv = ZXTUNING.FARM_MAX_LV,
        testfn = function (inst, item, lv)
            local index = math.min(lv + 1, #MATERIALS)
            local needitem = MATERIALS[index]
            return needitem == item.prefab
        end
    }
end


local perdfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = {"zxperd_soul"},
    hatchtime = HATCH_BASE_TIME,
    animalcnt = 10,

    foodnum = 1,
    foods = { 
        "zxfarmfood_normal"
    },

}


local pigfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = {"zxpigman_soul"},
    hatchtime = HATCH_BASE_TIME * 1.5,
    animalcnt = 8,

    foodnum = 2,
    foods = { 
        "zxfarmfood_normal"
    },
}



local beefalofarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = {"zxbeefalo_soul"},
    hatchtime = HATCH_BASE_TIME * 2,
    animalcnt = 6,

    foodnum = 2,
    foods = { 
        "zxfarmfood_normal"
    },
}


return {
    zxperdfarm    = perdfarm,
    -- zxpigmanfarm  = pigfarm,
    -- zxbeefalofarm = beefalofarm,
}
