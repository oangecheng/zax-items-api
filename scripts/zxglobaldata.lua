

ZXFARMS = {}

ZXFARM_TIMERS = {
    HATCH = "hatching",
    PRODUCE = "producing",
}


local function getBindId(inst)
    return inst.components.zxbindable and inst.components.zxbindable:GetBindId() or nil
end


function ZXFarmGetBindItems(inst)
    local bindId = getBindId(inst)
    if bindId then
        return ZXFARMS[bindId] or {}
    end
    return {}
end


function ZXFarmBindItems(bindId, item)
    local list = ZXFARMS[bindId] or {}
    list[item.prefab] = item
    ZXFARMS[bindId] = list
end



function ZXFarmHasHatcher(inst)
    local bindId = getBindId(inst)
    if bindId then
        local items = ZXFARMS[bindId] or {}
        return items["zxfarmhatch"] ~= nil
    end
    return false
end


--- 给农场内的其他绑定物广播事件
function ZxFarmPushEvent(pusher, event, data)
    local bindId = getBindId(pusher)
    if bindId then
        local items = ZXFARMS[bindId]
        if items then
            for _, value in pairs(items) do
                if value and value ~= pusher then
                    value:PushEvent(event, data)
                end
            end
        end
    end
end



function ZxFarmHasHost(inst)
    local bindId = getBindId(inst)
    if bindId then
        local items = ZXFARMS[bindId]
        if items then
            for key, value in pairs(items) do
                if value:HasTag("ZXFARM_HOST") then
                    return true
                end
            end
        end
    end
    return false
end


function ZXFarmHasFeeder(inst)
    local bindId = getBindId(inst)
    if bindId then
        local items = ZXFARMS[bindId] or {}
        return items["zxfarmbowl"] ~= nil
    end
    return false
end


function ZXFarmEatFood(eater, num)
    local bindId = getBindId(eater)
    if bindId then
        local items = ZXFARMS[bindId] or {}
        local bowl = items["zxfarmbowl"]
        if bowl then
            return bowl.components.zxfeeder:EatFood(num)
        end
    end
    return false
end
