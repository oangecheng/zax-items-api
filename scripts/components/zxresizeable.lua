local MAX = 2
local MIN = 0.5
local STP = 0.1



---计算比值
---@param self any
---@return number
local function calcScale(self)
    return (self.scale or 1) * (self.orgscale or 1)
end


---发生镜像变更时调用
---@param self any
local function updateAnimState(self)
    local scale = calcScale(self)
    local x = self.mirror and -1 or 1
    self.inst.AnimState:SetScale(scale * x, scale, scale)
    if self.onChangedFunc then
        self.onChangedFunc(self.inst, self.scale, self.mirror)
    end
end


local ResizeAble = Class(function(self, inst)
    self.inst = inst
    self.scale = 1
    self.mirror = false
end,
nil,
{
    scale  = updateAnimState,
    mirror = updateAnimState
})


---设置监听
---@param func function
function ResizeAble:SetOnChangedFunc(func)
    self.onChangedFunc = func
end


---设置大小
---@param scale number
function ResizeAble:SetScale(scale)
    if scale ~= nil then
        self.orgscale = scale
        updateAnimState(self)
    end
end


function ResizeAble:GetScale()
    return calcScale(self)
end


---是否可以放大
---@return boolean
function ResizeAble:CanEnlarge()
    return self.scale < MAX
end


---进行放大
---@param doer any 玩家
function ResizeAble:Enlarge(doer)
    if self:CanEnlarge() then
        self.scale = self.scale + STP
    end
end


---是否可以缩小
---@return boolean
function ResizeAble:CanShrink()
    return self.scale > MIN
end


---进行缩小
---@param doer any 玩家
function ResizeAble:Shrink(doer)
    if self:CanShrink() then
        self.scale = self.scale - STP
    end
end


---镜像操作，只进行x轴方向的镜像
---@param doer any 玩家
function ResizeAble:Mirror(doer)
    self.mirror = not self.mirror
end


function ResizeAble:OnSave()
    return {
        scale  = self.scale,
        mirror = self.mirror
    }
end


function ResizeAble:OnLoad(data)
    self.scale = data.scale or 1
    self.mirror = data.mirror
end


return ResizeAble
