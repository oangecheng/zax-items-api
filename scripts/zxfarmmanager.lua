

local zxfarmdata = {}
local tagfeeder = "ZXFEEDER"
local taghost = "ZXFARM_HOST"
local taghatcher = "ZXHATCHER"
local FARMS = (require "defs/animalfarmdefs")

--- 查找绑定id
--- @param inst table 
--- @return nil id
local function getBindId(inst)
    local bindable = inst.components.zxbindable
    return bindable and bindable:GetBindId() or nil
end


---获取所有的物品
---@param bindId string|nil 绑定id
---@return table
local function getFarmItems(bindId)
    local data = bindId and zxfarmdata[bindId]
    return data and data.items or {}
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
        local items = getFarmItems(bindId)
        for _, v in pairs(items) do
            if v:HasTag(tag) then
                return v
            end
        end
    end
    return nil
end


local function dispatchBind(inst, data)
    if (not inst.calledbind) and inst.components.zxbindable then
        inst.components.zxbindable:Dispatch(true, data)
        inst.calledbind = true
    end
end



--- 绑定物品，需要提供id
--- @param bindId string 绑定id，具备唯一性
--- @param item table 物品
function ZXFarmBindItems(bindId, item)
    local key = itemkey(item)
    if bindId and item and key then

        local data = zxfarmdata[bindId] or {}
        local list = data.items or {}
        list[key] = item
        data.items = list

        if item:HasTag(taghost) then
            --- 主体绑定的时候通知所有子物品
            data.host = item.prefab
            for _, v in pairs(list) do
                if v then
                    dispatchBind(v, FARMS[data.host])
                end
            end
        else
            -- 子物品绑定的时候，自己刷新下状态
            if data.host then
                dispatchBind(item, FARMS[data.host])
            end
        end

        zxfarmdata[bindId] = data

    end
end



--- 给农场内的其他绑定物广播事件
function ZxFarmPushEvent(pusher, event, data, all)
    local bindId = getBindId(pusher)
    if bindId then
        local items = getFarmItems(bindId)
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
        for _, data in pairs(zxfarmdata) do
            if data ~= nil and data.items ~= nil then
                for k, v in pairs(data.items) do
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


function ZxFarmCanStore(inst)
    local farm = findItemByTag(inst, taghost)
    if farm and farm.components.zxfarm then
        return farm.components.zxfarm:CanStore()
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


function ZxGetFarmHost(inst)
    return findItemByTag(inst, taghost)
end



function ZxGetFarmFeeder(inst)
    return findItemByTag(inst, tagfeeder)
end



--- 移除绑定的物品
--- 如果是农场，那么移除的时候，所有已绑定的物品都会被移除
--- @param item any 待移除的物品
--- @param bindId string 绑定id
local function removeBindItem(item, bindId)
    if bindId and item then

        local data = zxfarmdata[bindId]
        local list = data and data.items or {}

        if item:HasTag(taghost) then
            for k, value in pairs(list) do
                if value ~= item then
                    value:Remove()
                end
            end
            zxfarmdata[bindId] = nil
        else
            local bindable = item.components.zxbindable
            if bindable then
                if data.host then
                    bindable:Dispatch(false, FARMS[data.host])
                end
                bindable:Unbind()
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
    inst:Remove()
end



function ZXFarmItemInitFunc(inst, workcount)
    
    if inst:HasTag("structure") then
        inst:AddComponent("lootdropper")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(workcount or 3)
        inst.components.workable:SetOnFinishCallback(onHammered)
        inst.components.workable:SetOnWorkCallback(function ()
            if inst.onhitfn then
                inst.onhitfn(inst)
            end
        end)
    end
    

    inst:ListenForEvent("onremove", function ()
        local bindId = getBindId(inst)
        ZXLog("onremove", bindId, inst.prefab)
        if bindId then
            removeBindItem(inst, bindId)
        end
    end)
end



---获取所有的动物
---@param inst any
---@return table
function ZXFarmAnimals(inst)
    local id = getBindId(inst)
    local items = getFarmItems(id)
    local animals = {}
    for k, v in pairs(items) do
        if v:HasTag("ZXFARM_ANIMAL") then
            table.insert(animals, v)
        end
    end
    return animals
end
