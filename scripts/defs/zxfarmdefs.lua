
-- 基准时间，以一只鸡一天消耗一个饲料，生产一个鸡腿为基准值
-- 每个动物的生产的物品是独立的
local PRODUCE_BASE_TIME = ZXTUNING.DEBUG and 60 or TUNING.TOTAL_DAY_TIME * 2.5
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

    hatchitems = {"zxperd_soul"},
    hatchtime = HATCH_BASE_TIME,
    animalcnt = 10,

    foodnum = 1,
    foods = { 
        "zxfarmfood_normal"
    },

    upgrade = obtainFarmUpgrade(),
    producetime = PRODUCE_BASE_TIME,

}


local pigfarm = {
    hatchitems = {"zxpigman_soul"},
    hatchtime = HATCH_BASE_TIME * 1.5,
    animalcnt = 8,

    foodnum = 2,
    foods = { 
        "zxfarmfood_normal"
    },

    upgrade = obtainFarmUpgrade(),

    producetime = PRODUCE_BASE_TIME * 1.5,
    producefunc = function (inst)
        -- 月圆的时候，必然生产2个猪皮
        if TheWorld.state.isfullmoon then return {"pigskin", 2} end
        if math.random() <= 0.5 then
            return {"pigskin", 1}
        else
            return { "meat", 1 }
        end
    end
}



local beefalofarm = {
    hatchitems = {"zxbeefalo_soul"},
    hatchtime = HATCH_BASE_TIME * 2,
    animalcnt = 6,

    foodnum = 2,
    foods = { 
        "zxfarmfood_normal"
    },

    upgrade = obtainFarmUpgrade(),

    producetime = PRODUCE_BASE_TIME * 2,
}




local goatfarm = {
    hatchitems = {"zxgoat_soul"},
    hatchtime = HATCH_BASE_TIME * 3,
    animalcnt = 6,

    foodnum = 3,
    foods = { 
        "zxfarmfood_normal"
    },

    upgrade = obtainFarmUpgrade(),
    producetime = PRODUCE_BASE_TIME * 3,
}


local koalefantfarm = {
    hatchitems = {"zxkoalefant_w_soul", "zxkoalefant_s_soul"},
    hatchtime = HATCH_BASE_TIME * 3,
    animalcnt = 4,
    foodnum = 5,
    foods = { 
        "zxfarmfood_normal"
    },

    upgrade = obtainFarmUpgrade(),
    producetime = PRODUCE_BASE_TIME * 3,
}



local catfarm = {
    hatchitems = {"zxcat_soul"},
    hatchtime = HATCH_BASE_TIME,
    animalcnt = 8,
    foodnum = 2,
    foods = { 
        "fishmeat",
        "fishmeat_small",
        "eel",
    },
    upgrade = obtainFarmUpgrade(),
    producetime = PRODUCE_BASE_TIME * 1.5,
}


--- 高脚鸟农场
local tallbirdfarm = {
    hatchitems = { "zxtallbird_soul" },
    hatchtime = HATCH_BASE_TIME * 2,
    animalcnt = 6,
    foodnum = 4,
    foods = {
        "pumpkin"
    },
    upgrade = obtainFarmUpgrade(),
    producetime = PRODUCE_BASE_TIME * 3
}



local spiderfarm = {
    hatchitems = { "zxspider_soul", "zxspider_warrior_soul" },
    hatchtime = HATCH_BASE_TIME,
    animalcnt = 8,
    foodnum = 2,
    foods = {
        "meat",
        "monstermeat",
        "smallmeat"
    },
    upgrade = obtainFarmUpgrade(),
    producetime = PRODUCE_BASE_TIME 
}



local houndfarm = {
    hatchitems = { "zxhound_soul", "zxhound_ice_soul", "zxhound_fire_soul" },
    hatchtime = HATCH_BASE_TIME * 1.5,
    animalcnt = 8,
    foodnum = 3,
    foods = {
        "meat",
        "monstermeat",
        "smallmeat"
    },
    upgrade = obtainFarmUpgrade(),
    producetime = PRODUCE_BASE_TIME  * 1.5
}



return {
    farms = {
        zxperdfarm = perdfarm,
        zxpigmanfarm  = pigfarm,
        zxbeefalofarm  = beefalofarm,
        zxgoatfarm = goatfarm,
        zxcatfarm = catfarm,
        zxkoalefantfarm = koalefantfarm,
    },
}