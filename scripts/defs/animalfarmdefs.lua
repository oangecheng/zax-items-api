-- 基准时间，以一只鸡一天消耗一个饲料，生产一个鸡腿为基准值
-- 每个动物的生产的物品是独立的
local HATCH_BASE_TIME = ZXTUNING.DEBUG and 5 or TUNING.TOTAL_DAY_TIME * 0.5

local function obtainFarmUpgrade()
    return {
        maxlv = ZXTUNING.FARM_MAX_LV,
        testfn = function(doer, item, lv)
            if item.prefab == "zxstone" then
                local needs = { livinglog = lv + 1, cutstone = lv + 1 }
                return ZXItemConsume(doer, needs)
            end
        end
    }
end




local perdfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxperd_soul" },
    hatchtime = HATCH_BASE_TIME,
    animalcnt = 10,
    foods = {
        "zxfarmfood_normal",
        "berries",
        "berries_juicy",
        "corn",
    },
}


local pigfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxpigman_soul" },
    hatchtime = HATCH_BASE_TIME * 1.5,
    animalcnt = 8,
    foods = {
        "zxfarmfood_normal",
        "spoiled_food"
    },
}


local beefalofarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxbeefalo_soul" },
    hatchtime = HATCH_BASE_TIME * 2,
    animalcnt = 6,
    foods = {
        "zxfarmfood_normal",
        "cutgrass",
        "twigs"
    },
}




local goatfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxgoat_soul" },
    hatchtime = HATCH_BASE_TIME * 3,
    animalcnt = 6,
    foods = {
        "zxfarmfood_normal",
        "cactus_meat",
        "cactus_flower"
    },
}


local koalefantfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxkoalefant_w_soul", "zxkoalefant_s_soul" },
    hatchtime = HATCH_BASE_TIME * 3,
    animalcnt = 4,
    foods = {
        "zxfarmfood_normal",
        "cave_banana",
        "watermelon"
    },
}



local catfarm = {
    upgrade = obtainFarmUpgrade(),
    hatchitems = { "zxcat_soul" },
    hatchtime = HATCH_BASE_TIME,
    animalcnt = 8,
    foods = {
        "zxfarmfood_normal",
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
        "zxfarmfood_normal",
        "pumpkin",
        "tomato"
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
        "zxfarmfood_normal",
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
        "zxfarmfood_normal",
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
