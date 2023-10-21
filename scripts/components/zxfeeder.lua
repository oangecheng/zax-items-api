

local Feeder = Class(function (self, inst)
    self.inst = inst
    self.maxfoodnum = 120
    self.foods = {}
    self.foodnum = 0
end)



function Feeder:SetOnGiveFoodFunc(func)
    self.onGiveFoodFunc = func
end

function Feeder:SetOnEatFoodFunc(func)
    self.onEatFoodFunc = func
end


function Feeder:SetFoodMaxNum(max)
    self.maxfoodnum = max
end


function Feeder:GetFoodMaxNum()
    return self.maxfoodnum
end

function Feeder:GetFoodNum()
    return self.foodnum
end


function Feeder:SetFoods(foods)
    if foods then
        self.foods = foods
    end
end


function Feeder:IsFull()
    return self.foodnum >= self.maxfoodnum
end


function Feeder:CanGiveFood(food, doer)
    return food and (not self:IsFull()) and self.foods[food.prefab] ~= nil
end


function Feeder:GiveFood(food, doer)
    if self.foods and self.foodnum < self.maxfoodnum then
        ---@diagnostic disable-next-line: undefined-field
        local num = self.foods[food.prefab]
        if num then

            if food.components.stackable then
                local consume = true
                while self.foodnum < self.maxfoodnum and consume do
                    self.foodnum = math.min(self.foodnum + num, self.maxfoodnum)
                    if food and food.components.stackable:StackSize() <= 1 then
                        consume = false
                    end
                    food.components.stackable:Get():Remove()
                end
            else
                self.foodnum = math.min(self.foodnum + num, self.maxfoodnum)
                food:Remove()
            end
            if self.onGiveFoodFunc then
                self.onGiveFoodFunc(self.inst, self.foodnum)
            end
        end
    end
    ZXLog("GiveFood", self.foodnum)
end



function Feeder:EatFood(num)
    ZXLog("EatFood", self.foodnum, num)
    if self.foodnum >= num then
        self.foodnum = self.foodnum - num
        if self.onEatFoodFunc then
            self.onEatFoodFunc(self.inst, self.foodnum)
        end
        return true
    else
        return false
    end
end



function Feeder:OnLoad(data)
    self.foodnum = data.foodnum or 0
end


function Feeder:OnSave()
    return {
        foodnum = self.foodnum
    }
end


return Feeder