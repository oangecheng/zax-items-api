

ZXFARMS = {}


function ZXFarmBindItems(bindId, item)
    local list = ZXFARMS[bindId] or {}
    list[item.prefab] = item
    ZXFARMS[bindId] = list
end


function ZXFarmEatFood(bindId, num)
    local bowl = ZXFARMS[bindId]["zxfarmbowl"]
    if bowl and bowl.components.zxfarmfeeder then
        return bowl.components.zxfarmfeeder:EatFood(num)
    end
    return false
end