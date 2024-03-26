


local function productionsCnt(self)
    local sum = 0
    if self.productions then
        for k, v in pairs(self.productions) do
            sum = sum + v
        end
    end
    return sum
end


local Farm = Class(function (self, inst)
    self.inst = inst
    self.childcount = 0
    self.productions = nil
    self.childmax = 10
end)


function Farm:CanStore()
    return productionsCnt(self) < 100
end


function Farm:Store(prefab, num)
    local productions = self.productions or {}
    if self:CanStore() then
        local newnum = (productions[prefab] or 0) + num
        productions[prefab] = newnum
        self.productions = productions
        if not self:CanStore() then
            self.inst:PushEvent("ZXPauseProduce", {})
        end
    end
end


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