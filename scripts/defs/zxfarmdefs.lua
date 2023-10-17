
-- 基准时间，以一只鸡一天消耗一个饲料，生产一个鸡腿为基准值
-- 每个动物的生产的物品是独立的
local PRODUCE_BASE_TIME = TUNING.TOTAL_DAY_TIME
local HATCH_BASE_TIME = TUNING.TOTAL_DAY_TIME * 0.5

local souls = {
    "zxperd_soul",
    "zxpigman_soul",
    "zxbeefalo_soul",
    "zxgoat_soul",
}



local foods = {
    ["zxfarmfood_normal"] = 5,
}



local perdfarm = {

    hatchitem = "zxperd_soul",
    hatchtime = HATCH_BASE_TIME,
    animal    = "zxperd",
    animalcnt = 10,

    foodnum = 1,
    foods = { 
        "zxfarmfood_normal"
    },

    producetime = PRODUCE_BASE_TIME,
    producefunc = function (inst)
        return math.random() <= 0.5 and "drumstick", 1 or  "bird_egg", 1
    end
}


local pigfarm = {
    hatchitem = "zxpigman_soul",
    hatchtime = HATCH_BASE_TIME * 1.5,
    animal    = "zxpigman",
    animalcnt = 10,

    foodnum = 2,
    foods = { 
        "zxfarmfood_normal"
    },

    producetime = PRODUCE_BASE_TIME * 1.5,
    producefunc = function (inst)
        -- 月圆的时候，必然生产2个猪皮
        if TheWorld.state.isfullmoon then return "pigskin", 2 end
        return math.random() <= 0.3 and "pigskin", 1  or  "meat", 1
    end
}



local beefalofarm = {
    hatchitem = "zxbeefalo_soul",
    hatchtime = HATCH_BASE_TIME * 2,
    animal    = "zxbeefalo",
    animalcnt = 10,

    foodnum = 2,
    foods = { 
        "zxfarmfood_normal"
    },

    producetime = PRODUCE_BASE_TIME * 2,
    producefunc = function (inst)
        -- 春天有百分之10的概率生产一个牛角
        if TheWorld.state.isspring then
            if math.random() <= 0.1 then
                return "horn", 1
            end
        end
        return math.random() <= 0.8 and "beefalowool", 2 or "meat",1
    end
}




local goatfarm = {
    hatchitem = "zxgoat_soul",
    hatchtime = HATCH_BASE_TIME * 2,
    animal    = "zxgoat",
    animalcnt = 10,

    foodnum = 3,
    foods = { 
        "zxfarmfood_normal"
    },

    producetime = PRODUCE_BASE_TIME * 3,
    producefunc = function (inst)
        -- 春天下雨的时候有百分之10的概率生产一个奶
        if TheWorld.state.israining and TheWorld.state.isspring then
            if math.random() <= 0.1 then
                return "goatmilk",1
            end
        end
        return math.random() <= 0.3 and "lightninggoathorn",1 or "meat",2
    end
}




return {
    farms = {
        zxperdfarm = perdfarm,
        zxpigmanfarm  = pigfarm,
        -- zxbeefalofarm  = beefalofarm,
    },

    souls = souls,
    foods = foods
}