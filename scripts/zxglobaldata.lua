

ZXFARMS = {}

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
    if bindId then
        local list = ZXFARMS[bindId] or {}
        list[item.prefab] = item
        ZXFARMS[bindId] = list
    end
end


function ZXFarmUnbindItems(bindId, item)
    local list = ZXFARMS[bindId]

    if bindId and item then
        if item:HasTag("ZXFARM_HOST") then
            for k, value in pairs(list) do
                if value.components.zxbindable then
                    value.components.zxbindable:Unbind()
                end
                list[k] = nil
            end
            ZXFARMS[bindId] = nil
        else
            if list then
                list[item.prefab] = nil
                if item.components.zxbindable then
                    item.components.zxbindable:Unbind()
                end
            end
        end
    end
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
                if value and value:HasTag("ZXFARM_HOST") then
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


function ZxFarmIsFull(inst)
    local bindId = getBindId(inst)
    if bindId then
        local items = ZXFARMS[bindId]
        if items then
            for key, value in pairs(items) do
                if value.components.zxfarm then
                    return value.components.zxfarm:IsFull()
                end
            end
        end
    end
    return false
end




local function onHammered(inst)
    if inst.components.lootdropper then
        inst.components.lootdropper:DropLoot()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")

    local bindId = getBindId(inst)
    if bindId then
        ZXFarmUnbindItems(bindId, inst)
    else
        inst:Remove()
    end
end


local function onHit(inst)
    
end

function ZXFarmAddHarmmerdAction(inst, workcount)
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(workcount or 3)
    inst.components.workable:SetOnFinishCallback(onHammered)
    inst.components.workable:SetOnWorkCallback(onHit)
end