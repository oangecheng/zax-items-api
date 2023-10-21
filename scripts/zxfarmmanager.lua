

local zxfarmdata = {}
local tagfeeder = "ZXFEEDER"
local taghost = "ZXFARM_HOST"
local taghatcher = "ZXHATCHER"

--- 查找绑定id
--- @param inst table 
--- @return nil id
local function getBindId(inst)
    local bindable = inst.components.zxbindable
    return bindable and bindable:GetBindId() or nil
end


--- 生成每个物品存储的key，这里使用GUID
--- @return nil key
local function itemkey(inst)
    return inst ~= nil and inst.GUID or nil
end



--- 根据tag查找对应的物品
--- @param inst table 发起者，主要用来获取bindId
--- @param tag string 查找的标签
--- @return nil 目标预制无
local function findItemByTag(inst, tag)
    local bindId = getBindId(inst)
    if bindId then
        local items = zxfarmdata[bindId] or {}
        for _, v in pairs(items) do
            if v:HasTag(tag) then
                return v
            end
        end
    end
    return nil
end



--- 绑定物品，需要提供id
--- @param bindId string 绑定id，具备唯一性
--- @param item table 物品
function ZXFarmBindItems(bindId, item)
    local key = itemkey(item)
    if bindId and item and key then
        local list = zxfarmdata[bindId] or {}
        list[key] = item
        zxfarmdata[bindId] = list
    end
end



--- 给农场内的其他绑定物广播事件
function ZxFarmPushEvent(pusher, event, data)
    local bindId = getBindId(pusher)
    if bindId then
        local items = zxfarmdata[bindId]
        if items then
            for _, value in pairs(items) do
                if value and value ~= pusher then
                    value:PushEvent(event, data)
                end
            end
        end
    end
end



--- 农场建筑建造后，向所有的农场主体推送事件
--- 建造的物品
function ZXFarmObserveItemBuild(item)
    item:ListenForEvent("onbuilt", function (inst)
        for _, list in pairs(zxfarmdata) do
            if list ~= nil then
                for k, v in pairs(list) do
                    if v ~= nil and v:HasTag(taghost) then
                        v:PushEvent(ZXEVENTS.FARM_ITEM_BUILD, { item = item })
                    end
                end
            end
        end
    end)
end



function ZXFarmEatFood(eater, num)
    local bowl = findItemByTag(eater, tagfeeder)
    if bowl ~= nil then
        return bowl.components.zxfeeder:EatFood(num)
    end
    return false
end



function ZxFarmIsFull(inst)
    local farm = findItemByTag(inst, taghost)
    if farm and farm.components.zxfarm then
        return farm.components.zxfarm:IsFull()
    end
    return false
end




function ZXFarmHasHatcher(inst)
    return findItemByTag(inst, taghatcher) ~= nil
end


function ZxFarmHasHost(inst)
    return findItemByTag(inst, taghost) ~= nil
end


function ZXFarmHasFeeder(inst)
    return findItemByTag(inst, tagfeeder) ~= nil
end



--- 移除绑定的物品
--- 如果是农场，那么移除的时候，所有已绑定的物品都会被移除
--- @param item any 待移除的物品
--- @param bindId string 绑定id
local function removeBindItem(item, bindId)
    if bindId and item then
        local list = zxfarmdata[bindId]

        if item:HasTag(taghost) then
            for k, value in pairs(list) do
                if value.components.zxbindable then
                    value.components.zxbindable:Unbind()
                end
                list[k] = nil
            end
            zxfarmdata[bindId] = nil

        else
            local key = itemkey(item)
            if list and key ~= nil then
                list[key] = nil
                if item.components.zxbindable then
                    item.components.zxbindable:Unbind()
                end
            end
        end
    end
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
        removeBindItem(inst, bindId)
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