
local TIMER = "hatching"


local Hatcher = Class(function (self, inst)
    self.inst = inst
    self.seed = nil
    self.time = 480 -- 默认一天时间

    self.inst:ListenForEvent("timerdone", function (_, data)
        if data.name == TIMER then
            local temp = self.seed or self.seedlist[1]
            self.seed = nil
            if self.onStopFunc then
                self.onStopFunc(self.inst, temp)
            end        
        end
    end)
end)

--- 设置孵化器参数
--- @param list string 物品名称
function Hatcher:SetHatchSeeds(list)
    self.seedlist = list
end


function Hatcher:GetSeed()
    return self.seed or (self.seedlist and self.seedlist[1])
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
    return self.inst.components.timer:TimerExists(TIMER)
end


function Hatcher:CanHatch(item, doer)
    return item and self.seedlist and table.contains(self.seedlist, item.prefab)
end


function Hatcher:Hatch(item, doer)
    if not self:IsWorking() and self:CanHatch(item, doer) then
        self.inst.components.timer:StartTimer(TIMER, self.time)
        self.seed = item.prefab
        if self.onStartFunc then
            self.onStartFunc(self.inst, self.seed)
        end
        if item.components.stackable then
            item.components.stackable:Get():Remove()
        else
            item:Remove()
        end
    end
end


function Hatcher:OnSave()
    return {
        seed = self.seed
    }
end


function Hatcher:OnLoad(data)
    self.seed = data.seed or nil
end

    
return Hatcher