local TIMER_PRODUCE = "produce"

local Animal = Class(function (self, inst)
    self.inst = inst
    self.pt = nil
    self.type = 0
    self.foodnum = 1
    self.producetime = 480

    --- 生产结束，尝试下一次生产
    self.inst:ListenForEvent("timerdone", function(_, data)
        if data.name == TIMER_PRODUCE then
            if self.producedfn then
                self.producedfn()
            end
            self:StartProduce()
        end
    end)

    --- 农场满了暂停生产，收获后重新启动
    self.inst:ListenForEvent(ZXEVENTS.FARM_PRD, function (_, data)
        local timer = self.inst.components.timer
        if data and timer then
            if data.e == 1  then
                timer:PauseTimer(TIMER_PRODUCE)
            elseif data.e == 2 then
                timer:ResumeTimer(TIMER_PRODUCE)
            end
        end
    end)

    --- 添加了食物尝试生产
    self.inst:ListenForEvent(ZXEVENTS.FARM_ADD_FOOD, function (_, data)
        self:StartProduce()
    end)
end)


function Animal:SetOnProducedFn(fn)
    self.producedfn = fn
end


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
function Animal:GetFarmPosition()
    return self.pt
end


---comment 改变动物类型
---@param type number
function Animal:SetType(type)
    self.type = type
end


---comment 获取动物类型
---@return number 类型
function Animal:GetType()
    return self.type
end


function Animal:SetData(foodnum, producetime)
    self.foodnum = foodnum
    self.producetime = producetime
end


function Animal:GetData()
    return self.foodnum, self.producetime
end


function Animal:StartProduce()
    if not ZxFarmCanStore(self.inst) then
       return false
    end
    local timer = self.inst.components.timer
    if timer:ResumeTimer(TIMER_PRODUCE) then
       return true
    end
    if ZXFarmEatFood(self.inst, self.foodnum) then
        timer:StartTimer(TIMER_PRODUCE, self.producetime)
        return true
    end
    return false
end



function Animal:OnSave()
    return {
        pt = self.pt,
        type = self.type
    }
end


function Animal:OnLoad(data)
    self.pt = data.pt or nil
    self.type = data.type or 0
end


return Animal