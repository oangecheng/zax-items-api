

---comment 计算当前动物产品总数量
---@param self table farm组件
---@return integer 数量
local function productionsCnt(self)
    local sum = 0
    if self.productions then
        for _, v in pairs(self.productions) do
            sum = sum + v
        end
    end
    return sum
end


local Farm = Class(function (self, inst)
    self.inst = inst
    self.childcount = 0
    self.childmax = 10
    --- @type table|nil 
    --- 存储产品 key = prefab, v = num
    self.productions = nil
end)


---comment 设置动物上限
---@param max number 上限
function Farm:SetChildMaxCnt(max)
    self.childmax = max or 10
end


---comment 获取动物上限值
---@return number 上限
function Farm:GetChildMaxCnt()
    return self.childmax or 10
end


---comment 判断农场小动物是否满了
---@return boolean
function Farm:IsFull()
    return self.childcount >= self.childmax
end


---comment 是否还能存放物品
---@return boolean true可继续存放
function Farm:CanStore()
    return productionsCnt(self) < 100
end


---comment 存放动物产物
---@param prefab string 物品
---@param num number 数量
function Farm:Store(prefab, num)
    local productions = self.productions or {}
    local newnum = (productions[prefab] or 0) + num
    productions[prefab] = newnum
    self.productions = productions
    if not self:CanStore() then
        self.inst:PushEvent("ZXPauseProduce", {})
    end
end


---comment 收获动物产物
---@param doer table 玩家
---@return boolean 是否收获成功
function Farm:Harvest(doer)
    if not (self.productions and doer.components.inventory) then
        return false
    end
    for k, v in pairs(self.productions) do
        local items = ZXSpawnPrefabs(k, v)
        if items ~= nil then
            for _, iv in ipairs(items) do
                doer.components.inventory:GiveItem(iv)
            end
        end
    end
    self.productions = nil
    return true
end


function Farm:OnSave()
    return {
        childcount = self.childcount,
        productions = self.productions,
    }
end


function Farm:OnLoad(data)
    self.childcount = data.childcount or 0
    self.productions = data.productions or nil
end



return Farm