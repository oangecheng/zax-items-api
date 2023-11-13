--- 用于绑定一组建筑
--- 未找到官方更好的实现方式，如果找到了后续替换实现
local Bindable = Class(function (self, inst)
    self.inst = inst
    self.bindId = nil
end)


--- 物品因为绑定关系被添加时的通知
--- @param func function
function Bindable:SetOnBindFunc(func)
    self.onBindFunc = func
end


--- 物品因为绑定关系被添加时的通知
--- @param func function
function Bindable:SetOnUnBindFunc(func)
    self.onUnBindFunc = func
end


--- 是否可以被绑定
--- @return boolean  
function Bindable:CanBind()
    return not self.bindId
end


--- 设置绑定的id，多个绑定物品的id应该是一致的
--- @param id string 绑定的id，需要唯一性
function Bindable:Bind(id)
    if not self.bindId and id then
        self.bindId = id
        ZXFarmBindItems(self.bindId, self.inst)
    end
end


--- 解除绑定
function Bindable:Unbind()
    self.bindId = nil
end


function Bindable:Dispatch(isbind, data)
    if self.bindId and data then
        if isbind then
            if self.onBindFunc then
                self.onBindFunc(self.inst, self.bindId, data)
            end
        else
            if self.onUnBindFunc then
                self.onUnBindFunc(self.inst, self.bindId, data)
            end
        end
    end
end


--- 获取绑定的id
--- @return string 绑定的id
function Bindable:GetBindId()
    return self.bindId
end


function Bindable:OnSave()
    return {
        bindId = self.bindId,
    }
end


function Bindable:OnLoad(data)
    self.bindId = data.bindId
    ZXFarmBindItems(self.bindId, self.inst)
end


return Bindable