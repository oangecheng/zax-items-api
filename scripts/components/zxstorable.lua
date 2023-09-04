
local function notifySizeChanged(self)
    if self.onSizeChangedFunc then
        self.onSizeChangedFunc(self.inst, self.size)
    end
end



local Storable = Class(function (self, inst)
    self.inst = inst;
    self.size = 0;
    self.target = nil
end)


function Storable:SetTarget(target)
    self.target = target
end


function Storable:OnSizeChangedFunc(func)
    self.onSizeChangedFunc = func
end


function Storable:CanStore(item, doer)
    return item and self.target and self.target == item.prefab
end


function Storable:CanTake(doer)
    return self.target and self.size > 0
end


function Storable:Store(item, doer)
    if self:CanStore(item) then
        local num = 1
        local stackable = item.components.stackable
        if stackable ~= nil then
            num = stackable:StackSize()
        end
        self.size = self.size + num
        notifySizeChanged(self)
    end
end


function Storable:Take(doer)
    if self:CanTake(doer) then
        local item = SpawnPrefab(self.target)
        local delta = 1
        if item ~= nil then
            local stackable = item.components.stackable
            if stackable then
                delta = math.min(self.size, stackable.maxsize)
                stackable:SetStackSize(delta)
            end
        end
        self.size = math.max(0, self.size - delta)
        notifySizeChanged(self)
        return item
    end
    return nil
end


function Storable:OnSave()
    return {
        size = self.size
    }
end


function Storable:OnLoad(data)
    self.size = data.size or 0
    notifySizeChanged(self)
end


return Storable