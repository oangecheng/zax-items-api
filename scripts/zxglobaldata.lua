

ZXFARMS = {}


local function getBindId(inst)
    return inst.components.zxbindable and inst.components.zxbindable:GetBindId() or nil
end


function ZXFarmItems(inst)
    local bindId = getBindId(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
    local ret = {}
    if x and y and z and bindId then
        local ents = TheSim:FindEntities(x, y, z, 6, { "zxfarmitem" }, nil)
        for _, value in ipairs(ents) do
            if value and value.components.zxbindable:GetBindId() == bindId then
                ret[value.prefab] = value
            end
        end
    end
    return ret
end


function ZXFarmBindItems(bindId, item)
    local list = ZXFARMS[bindId] or {}
    list[item.prefab] = item
    ZXFARMS[bindId] = list
end



function ZXFarmFindHatcher(inst)
    local bindId = getBindId(inst)
    if bindId then
        local items = ZXFARMS[bindId] or {}
        return items["zxfarmhatch"]
    end
end


function ZXFarmFindBowl(inst)
    local bindId = getBindId(inst)
    if bindId then
        local items = ZXFARMS[bindId] or {}
        return items["zxfarmbowl"]
    end
end


function ZXFarmEatFood(eater, num)
    local bindId = getBindId(eater)
    if bindId then
        local items = ZXFARMS[bindId] or {}
        local bowl = items["zxfarmbowl"]
        if bowl then
            return bowl.components.zxfarmfeeder:EatFood(num)
        end
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



function ZxFarmGetHost(inst)
    local bindId = getBindId(inst)
    if bindId then
        local items = ZXFARMS[bindId]
        if items then
            for key, value in pairs(items) do
                if value:HasTag("ZXFARM_HOST") then
                    return value
                end
            end
        end
    end
    return nil
end