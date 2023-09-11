
local Animal = Class(function (self, inst)
    self.inst = inst
    self.pt = nil
end)


---设置农场位置，设置完不可更改
---@param x number 坐标x
---@param y number 坐标y
---@param z number 坐标z
function Animal:SetFarmPosition(x,y,z)
    if self.pt == nil then
        self.pt = {x = x, y = y, z = z}
    end
end


---获取农场位置
---@return any
function Animal:GetFarmPostion()
    return self.pt
end


function Animal:OnSave()
    return {
        pt = self.pt
    }
end


function Animal:OnLoad(data)
    self.pt = data.pt or nil
end


return Animal