local TIMER = "Accelerating"


local function onAccelerate(self)
    if self.onAccelerateFn then
        local multi = self.accelerating and self.multiplier or 1
        self.onAccelerateFn(self.inst, multi)
    end
end


---用于减少某个功能的耗时
---需要宿主具有timer组件
local Accelerate = Class(function (self, inst)
    self.inst = inst
    self.multiplier = 1
    self.maxduration = TUNING.TOTAL_DAY_TIME
    self.accelerating = false

    self.inst:ListenForEvent("timerdone", function (_, data)
        if data.name == TIMER then
            self.accelerating = false
        end
    end)
end,
nil,
{
    accelerating = onAccelerate
})


---设置监听
---@param fn function cb函数
function Accelerate:SetOnAccelerateFn(fn)
    self.onAccelerateFn = fn
end


---设置最大的加速时长
---@param max number 时长
function Accelerate:SetMaxDuration(max)
    self.maxduration = max
end


---设置加速倍率
---@param multiplier number 倍率，<1才会有效
function Accelerate:SetMultiplier(multiplier)
    self.multiplier = multiplier
end


---开始加速，多次调用时间累加
---@param duration number 加速时长
function Accelerate:Start(duration)
    local time = self.inst.components.timer:GetTimeLeft(TIMER) 
    time = math.min(duration + (time or 0), self.maxduration)
    self.inst.components.timer:StopTimer(TIMER)
    self.inst.components.timer:StartTimer(TIMER, time)
    self.accelerating = true
end


function Accelerate:OnSave()
    return {
        accelerating = self.accelerating
    }
end


function Accelerate:OnLoad(data)
    self.accelerating = data.accelerating
end


return Accelerate