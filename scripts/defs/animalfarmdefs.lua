-- 基准时间，以一只鸡一天消耗一个饲料，生产一个鸡腿为基准值
-- 每个动物的生产的物品是独立的
local HATCH_BASE_TIME = ZXTUNING.DEBUG and 5 or TUNING.TOTAL_DAY_TIME * 0.5
local MATERIALS = (require "defs/zxitemdefs").upgrade.farm


local function obtainFarmUpgrade()
    return {
        maxlv = ZXTUNING.FARM_MAX_LV,
        testfn = function(inst, item, lv)
            local index = math.min(lv + 1, #MATERIALS)
            local needitem = MATERIALS[index]
            return needitem == item.prefab
        end
    }
end




local perdfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxperd_soul" },
    hatchtime = HATCH_BASE_TIME,
    animalcnt = 10,
    foods = {
        "zxfarmfood_normal"
    },
}


local pigfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxpigman_soul" },
    hatchtime = HATCH_BASE_TIME * 1.5,
    animalcnt = 8,
    foods = {
        "zxfarmfood_normal"
    },
}


local beefalofarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxbeefalo_soul" },
    hatchtime = HATCH_BASE_TIME * 2,
    animalcnt = 6,
    foods = {
        "zxfarmfood_normal"
    },
}




local goatfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxgoat_soul" },
    hatchtime = HATCH_BASE_TIME * 3,
    animalcnt = 6,
    foods = {
        "zxfarmfood_normal"
    },
}


local koalefantfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxkoalefant_w_soul", "zxkoalefant_s_soul" },
    hatchtime = HATCH_BASE_TIME * 3,
    animalcnt = 4,
    foods = {
        "zxfarmfood_normal"
    },
}



local catfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxcat_soul" },
    hatchtime = HATCH_BASE_TIME,
    animalcnt = 8,
    foods = {
        "fishmeat",
        "fishmeat_small",
        "eel",
    },
}


--- 高脚鸟农场
local tallbirdfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxtallbird_soul" },
    hatchtime = HATCH_BASE_TIME * 2,
    animalcnt = 6,
    foods = {
        "pumpkin"
    },
}


local spiderfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { 
        "zxspider_soul",
        "zxspider_warrior_soul",
        "zxspider_dropper_soul",
        "zxspider_healer_soul"
    },
    hatchtime = HATCH_BASE_TIME,
    animalcnt = 8,
    foods = {
        "meat",
        "monstermeat",
        "smallmeat"
    },
}



local houndfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxhound_soul", "zxhound_ice_soul", "zxhound_fire_soul" },
    hatchtime = HATCH_BASE_TIME * 1.5,
    animalcnt = 8,
    foods = {
        "meat",
        "monstermeat",
        "smallmeat"
    },
}



return {
    zxperdfarm      = perdfarm,
    zxpigmanfarm    = pigfarm,
    zxbeefalofarm   = beefalofarm,
    zxgoatfarm      = goatfarm,
    zxcatfarm       = catfarm,
    zxkoalefantfarm = koalefantfarm,
    zxhoundfarm     = houndfarm,
    zxspiderfarm    = spiderfarm,
    zxtallbirdfarm  = tallbirdfarm,
}
