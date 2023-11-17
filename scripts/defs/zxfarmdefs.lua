
-- 基准时间，以一只鸡一天消耗一个饲料，生产一个鸡腿为基准值
-- 每个动物的生产的物品是独立的
local PRODUCE_BASE_TIME = ZXTUNING.DEBUG and 60 or TUNING.TOTAL_DAY_TIME * 2.5
local HATCH_BASE_TIME = ZXTUNING.DEBUG and 60 or TUNING.TOTAL_DAY_TIME * 0.5


local souls = {
    "zxperd_soul",
    "zxpigman_soul",
    "zxbeefalo_soul",
    "zxgoat_soul",
    "zxkoalefant_w_soul",
    "zxkoalefant_s_soul",
    "zxcat_soul",
}



local materials = {
    "purplegem",
    "greengem",
    "opalpreciousgem"
}


local function obtainFarmUpgrade()
    return {
        maxlv = ZXTUNING.FARM_MAX_LV,
        testfn = function (inst, item, lv)
            local index = math.min(lv + 1, #materials)
            local needitem = materials[index]
            return needitem == item.prefab
        end
    }
end


local foods = {
    ["zxfarmfood_normal"] = 5,
}



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
    producefunc = function (inst)
        if math.random() <= 0.5 then
            return { "drumstick", 1 }
        else 
            return { "bird_egg", 1 }
        end
    end,

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
    producefunc = function (inst)
        -- 春天有百分之10的概率生产一个牛角
        if TheWorld.state.isspring then
            if math.random() <= 0.1 then
                return {"horn", 1}
            end
        end

        if math.random() <= 0.7 then
            return {"beefalowool", 4}
        else
            return { "meat", 1 }
        end
    end
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
    producefunc = function (inst)
        -- 春天下雨的时候有百分之10的概率生产一个奶
        if TheWorld.state.israining and TheWorld.state.isspring then
            if math.random() <= 0.3 then
                return {"goatmilk", 1}
            end
        end
        if math.random() <= 0.5 then
            return { "lightninggoathorn", 1}
        else
            return { "meat", 1}
        end
    end
}


local koalefantfarm = {
    hatchitems = {"zxkoalefant_w_soul", "zxkoalefant_s_soul"},
    hatchtime = HATCH_BASE_TIME * 3,
    animalcnt = 4,
    foodnum = 3,
    foods = { 
        "zxfarmfood_normal"
    },

    upgrade = obtainFarmUpgrade(),

    producetime = PRODUCE_BASE_TIME * 3,
    producefunc = function (inst)
        if math.random() <= 0.5 then
            return { "trunk_winter", 1}
        else
            return { "trunk_summer", 1}
        end
    end
}



local catfarm = {
    hatchitems = {"zxcat_soul"},
    hatchtime = HATCH_BASE_TIME,
    animalcnt = 8,

    foodnum = 1,
    foods = { 
        "zxfarmfood_normal"
    },

    upgrade = obtainFarmUpgrade(),

    producetime = PRODUCE_BASE_TIME * 1.5,
    producefunc = function (inst)
        return { "meat", 1}
    end
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

    souls = souls,
    foods = foods,
}