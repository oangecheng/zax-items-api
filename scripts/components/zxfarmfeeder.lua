

local FarmFeeder = Class(function (self, inst)
    self.inst = inst
    self.maxfoodnum = 100
    self.foods = {}
    self.foodnum = 0
end)



function FarmFeeder:SetOnGiveFoodFunc(func)
    self.onGiveFoodFunc = func
end

function FarmFeeder:SetOnEatFoodFunc(func)
    self.onEatFoodFunc = func
end


function FarmFeeder:SetMaxFoodNum(max)
    self.maxfoodnum = max
end


function FarmFeeder:GetMaxFoodNum()
    return self.maxfoodnum
end

function FarmFeeder:GetFoodNum()
    return self.foodnum
end


function FarmFeeder:SetFoods(foods)
    self.foods = foods
end


function FarmFeeder:CanGiveFood(food, doer)
    return food and self.foodnum < self.maxfoodnum and self.foods[food.prefab] ~= nil
end


function FarmFeeder:GiveFood(food, doer)
    if self.foods and self.foodnum < self.maxfoodnum then
        ---@diagnostic disable-next-line: undefined-field
        local num = self.foods[food.prefab]
        if num then

            if food.components.stackable then
                local consume = true
                while self.foodnum < self.maxfoodnum and consume do
                    self.foodnum = math.min(self.foodnum + num, self.maxfoodnum)
                    print("GiveFood 3"..tostring(self.foodnum))
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
end



function FarmFeeder:EatFood(num)
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



function FarmFeeder:OnLoad(data)
    self.foodnum = data.foodnum or 0
end


function FarmFeeder:OnSave()
    return {
        foodnum = self.foodnum
    }
end


return FarmFeeder