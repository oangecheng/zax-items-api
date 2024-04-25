
local function onUpgrade(self)
    if self.onupgradefn then
        self.onupgradefn(self.inst, self.lv)
    end
end


local Upgradable = Class(function (self, inst)
    self.inst = inst
    self.max = math.maxinteger
    self.lv = 0
end,
nil,
{
    lv = onUpgrade
})

---获取等级
---@return integer 等级
function Upgradable:GetLv()
    return self.lv
end


---是否可升级
---@return boolean
function Upgradable:IsMax()
    return self.lv >= self.max
end

---升级
---@param doer table 玩家
---@param item table 材料
function Upgradable:UpgradeTest(doer, item)
    return self.testfn and self.testfn(doer, item, self.lv)
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
---@param fn function (#doer, #item, #self.lv) 测试函数
function Upgradable:SetTestFn(fn)
    self.testfn = fn
end


---升级回调
---@param fn function 函数
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

return Upgradable