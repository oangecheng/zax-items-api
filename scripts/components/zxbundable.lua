
local Bundable = Class(function (self, inst)
    self.inst = inst
end)


function Bundable:SetOnAddFunc(func)
    self.onAddFunc = func
end


function Bundable:SetOnRemoveFunc(func)
    self.onRemoveFunc = func
end

function Bundable:SetBundleId(id)
    if not self.bundleId then
        self.bundleId = id
    end
end


function Bundable:GetBundleId()
    return self.bundleId
end


function Bundable:Remove(bundleId)
    if bundleId ~= nil and bundleId == self.bundleId then
        if self.onRemoveFunc then
            self.onRemoveFunc(self.inst)
        end
        self.inst:Remove()
    end
end


function Bundable:OnSave()
    return {
        bundleId = self.bundleId
    }
end


function Bundable:OnLoad(data)
    self.bundleId = data.bundleId
end


return Bundable