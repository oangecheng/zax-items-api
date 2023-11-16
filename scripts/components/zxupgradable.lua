
local function onUpgrade(self)
    if self.onupgradefn then
        self.onupgradefn(self.inst, self.lv)
    end
end


local Upgradable = Class(function (self, inst)
    self.inst = inst
    self.lv = 0
    self.max = 1
end,
nil,
{
    lv = onUpgrade
})


---是否可升级
---@return boolean
function Upgradable:IsMax()
    return self.lv >= self.max
end

---升级
---@param item table 材料
function Upgradable:IsValidMaterial(item)
    return self.testfn and self.testfn(self.inst, item, self.lv)
end


---升级
function Upgradable:Upgrade()
    self.lv = math.min(self.max, self.lv + 1)
end

---设置最大等级
---@param max integer 最大值 >=1
function Upgradable:SetMax(max)
    self.max = math.max(1, max)
end


---设置可用于升级的材料列表
---@param fn function 测试函数
function Upgradable:SetMaterialTestFn(fn)
    self.testfn = fn
end


---设置可用于升级的材料列表
---@param fn function 测试函数
function Upgradable:SetOnUpgradeFn(fn)
    self.onupgradefn = fn
end


function Upgradable:OnSave()
    return {
        lv = self.lv
    }
end


function Upgradable:OnLoad(data)
    self.lv = data.lv or 0
end