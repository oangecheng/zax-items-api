

local function onupgrade(self, lv)
    if self.onupgradefn then
        self.onupgradefn(self.inst, lv)
    end
end


local Upgradable = Class(function (self, inst)
    self.inst = inst
    self.lv = 0
end, nil, {
    lv = onupgrade
})


function Upgradable:SetTestFn(fn)
    self.testfn = fn
end


function Upgradable:SetOnUpgradeFn(fn)
    self.onupgradefn = fn
end



function Upgradable:Upgrade()
    
end



function Upgradable:OnSave()
    return {
        lv = self.lv
    }
end


function Upgradable:OnLoad(data)
    self.lv = data.lv or 0
end


return Upgradable