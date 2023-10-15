--- 用于绑定一组建筑
--- 未找到官方更好的实现方式，如果找到了后续替换实现
local Bindable = Class(function (self, inst)
    self.inst = inst
    self.bindId = nil
    self.shareData = nil
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
--- @param shareData any 共享的数据
function Bindable:Bind(id, shareData)
    ZXLog("Bind", self.inst.prefab)
    if not self.bindId and id then
        self.bindId = id
        self.shareData = shareData
        ZXFarmBindItems(self.bindId, self.inst)
        if self.onBindFunc then
            self.onBindFunc(self.inst, self.bindId, self.shareData)
        end
    end
end


--- 解除绑定
function Bindable:Unbind()
    ZXLog("Unbind", self.onUnBindFunc, self.bindId)
    if self.onUnBindFunc and self.bindId and self.shareData then
        self.onUnBindFunc(self.inst, self.bindId, self.shareData)
    end
    self.bindId = nil
    self.shareData = nil
end


--- 获取绑定的id
--- @return string 绑定的id
function Bindable:GetBindId()
    return self.bindId
end


function Bindable:OnSave()
    return {
        bindId = self.bindId,
        shareData = self.shareData
    }
end


function Bindable:OnLoad(data)
    self.bindId = data.bindId
    self.shareData = data.shareData
    ZXFarmBindItems(self.bindId, self.inst)
    if self.onBindFunc and self.bindId and self.shareData then
        self.onBindFunc(self.inst, self.bindId, self.shareData)
    end
end


return Bindable