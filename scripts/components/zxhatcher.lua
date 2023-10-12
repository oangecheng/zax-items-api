

local Hatcher = Class(function (self, inst)
    self.inst = inst
    self.seed = nil
    self.time = 480 -- 默认一天时间

    self.inst:ListenForEvent("timedone", function (_, data)
        if data.name == ZXFARM_TIMERS.HATCH then
            if self.onStopFunc then
                self.onStopFunc(self.inst)
            end        
        end
    end)
end)

--- 设置孵化器参数
--- @param seed string 物品名称
function Hatcher:SetHatchSeed(seed)
    self.seed = seed
end


--- 设置孵化器参数
--- @param time number 物品名称
function Hatcher:SetHatchTime(time)
    self.time = time
end


function Hatcher:SetOnStartFunc(func)
    self.onStartFunc = func
end


function Hatcher:SetOnStopFunc(func)
    self.onStopFunc = func
end


function Hatcher:IsWorking()
    return self.inst.components.timer:TimerExists(ZXFARM_TIMERS.HATCH)
end


function Hatcher:CanHatch(item, doer)
    return item and self.seed and item.prefab == self.seed
end


function Hatcher:Hatch(item, doer)
    if not self:IsWorking() and self:CanHatch(item, doer) then
        self.inst.components.timer:StartTimer(ZXFARM_TIMERS.HATCH, self.time)
        if self.onStartFunc then
            self.onStartFunc(self.inst)
        end
        item:Remove()
    end
end

    
return Hatcher