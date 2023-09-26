

local perdfarm = {

    -- initskin = ZxGetPrefabDefaultSkin("zxperdfarm"),
    -- initanim = "idle",

    hatchitem = "berd_egg",
    hatchtime = TUNING.TOTAL_DAY_TIME,
    animal    = "zxperd",

    --- 每间隔300s生产一次
    producetime = TUNING.DAY_TIME_DEFAULT,
    products = { 
        ["bird_egg"] = 1 
    },
    foods = { 
        ["berries"] = 1
    }
}


local pigfarm = {

}



local cowfarm = {

}



return {
    zxperdfarm = perdfarm,
    zxpigfarm  = pigfarm,
    zxcowfarm  = cowfarm,
}