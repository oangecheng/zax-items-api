--- 用于绑定一组建筑
--- 未找到官方更好的实现方式，如果找到了后续替换实现
local Bindable = Class(function (self, inst)
    self.inst = inst
end)


--- 物品因为绑定关系被添加时的通知
--- @param func function
function Bindable:SetOnAddFunc(func)
    self.onAddFunc = func
end


--- 物品因为绑定关系被移除时的通知
--- @param func function
function Bindable:SetOnRemoveFunc(func)
    self.onRemoveFunc = func
end


--- 是否可以被绑定
--- @return boolean  
function Bindable:CanBind()
    return not self.bindId
end


--- 设置绑定的id，多个绑定物品的id应该是一致的
--- @param id string 绑定的id，需要唯一性
function Bindable:Bind(id)
    if not self.bindId then
        self.bindId = id
    end
end


--- 解除绑定
function Bindable:Unbind()
    self.bindId = nil
end


--- 获取绑定的id
--- @return string 绑定的id
function Bindable:GetBindId()
    return self.bindId
end


--- 通过绑定id去移除物品，id校验通过执行
--- @param bindId  string id
function Bindable:Remove(bindId)
    if bindId and self.bindId and bindId == self.bindId then
        if self.onRemoveFunc then
            self.onRemoveFunc(self.inst)
        end
        self.inst:Remove()
    end
end


function Bindable:OnSave()
    return {
        bindId = self.bindId
    }
end


function Bindable:OnLoad(data)
    self.bindId = data.bindId
end


return Bindable