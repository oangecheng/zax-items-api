

---- 升级材料定义
local upgrade_farm = {
    "zxstone"
}
local upgrade_bowl = {
    "zxstone"
}

local upgrade = {
    farm = upgrade_farm,
    bowl = upgrade_bowl,
    all  = JoinArrays(upgrade_farm, upgrade_bowl)
}



local animals = require "defs/animaldefs"
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
    meat = 10,
    smallmeat = 5,
    monstermeat = 4,
    pumpkin = 2
}

local foods = {
    custom = foods_custom,
    all    = MergeMaps(foods_custom, foods_other)
}


return {
    upgrade = upgrade,
    souls   = souls,
    foods   = foods,
}

