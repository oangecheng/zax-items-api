

---- 升级材料定义
local upgrade_farm = {
    "purplegem",
    "greengem",
    "opalpreciousgem"
}
local upgrade_bowl = {
    "thulecite"
}

local upgrade = {
    farm = upgrade_farm,
    bowl = upgrade_bowl,
    all  = JoinArrays(upgrade_farm, upgrade_bowl)
}


-- 基准半小时
local basetime = TUNING.TOTAL_DAY_TIME * 3.75
local accelerate = {
	zxstone = basetime,
}



local animals = require "defs/zxanimaldefs"
-- 灵魂key灵魂，value动物
local souls = {}
for k, v in pairs(animals) do
    local soul = k.."_soul"
    souls[soul] = k
end



--- 食物
local foods_custom = {
    zxfarmfood_normal = 5,
}
local foods_other = {
    fishmeat = 15,
    fishmeat_small = 5,
    eel = 10,
}

local foods = {
    custom = foods_custom,
    all    = MergeMaps(foods_custom, foods_other)
}



return {
    upgrade = upgrade,
    accelerate = accelerate,
    souls   = souls,
    foods   = foods,
}

