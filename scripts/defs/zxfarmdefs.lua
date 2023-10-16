
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

    -- initskin = ZxGetPrefabDefaultSkin("zxperdfarm"),
    -- initanim = "idle",

    hatchitem = "zxperd_soul",
    hatchtime = 10,
    animal    = "zxperd",
    animalcnt = 10,

    --- 每间隔300s生产一次
    producetime = 50,
    products = { 
        ["bird_egg"] = 1 
    },

    foodnum = 1,
    foods = { 
        "zxfarmfood_normal"
    },
}


local pigfarm = {
    hatchitem = "zxpigman_soul",
    hatchtime = 10,
    animal    = "zxpigman",
    animalcnt = 10,

    --- 每间隔300s生产一次
    producetime = 50,
    products = { 
        ["bird_egg"] = 1 
    },

    foodnum = 1,
    foods = { 
        "zxfarmfood_normal"
    },
}



local cowfarm = {

}



return {
    farms = {
        zxperdfarm = perdfarm,
        zxpigmanfarm  = pigfarm,
        zxbeefalofarm  = cowfarm,
    },

    souls = souls,
    foods = foods
}