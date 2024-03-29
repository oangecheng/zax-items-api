
local PRODUCTION_MAX_CNT = 100
local TIMER = "produce"

local function productionsCnt(self)
    local sum = 0
    if self.productions then
        for k, v in pairs(self.productions) do
            sum = sum + v
        end
    end
    return sum
end


local function produce(self)
    local temp = nil
    local animals = ZXFarmAnimals(self.inst)
    if next(animals) ~= nil then
        temp = {}
        for _, v in ipairs(animals) do
            local product = v.producefn and v.producefn(v, self.inst)
            if product and product[1] and product[2] then
                local originnum = temp[product[1]] or 0
                temp[product[1]] = originnum + product[2]
            end
        end
    end

    if temp then
        if self.productions == nil then
            self.productions = {}
        end
        for k, v in pairs(temp) do
            if self.productions[k] ~= nil then
                self.productions[k] = self.productions[k] + v
            else
                self.productions[k] = v
            end
        end
    end
end


local Farm = Class(function (self, inst)
    self.inst = inst
    self.childcount = 0
    self.productions = nil

    self.childmax = 10
    self.time = 0
    self.foodnum = 1

    self.inst:ListenForEvent("timerdone", function (_, data)
        if data.name == TIMER then
            produce(self)
            self:StartProduce()
        end
    end)
end)


function Farm:GetChildCnt()
    return self.childcount
end


function Farm:SetChildMaxCnt(max)
    self.childmax = max or 10
end


function Farm:GetChildMaxCnt(max)
    return self.childmax or 10
end


function Farm:SetProduceTime(time)
    if self.time ~= 0 and time ~= 0  and self.time ~= time then
        local timer = self.inst.components.timer        
        if timer and timer:TimerExists(TIMER) then
            local left = timer:GetTimeLeft(TIMER) * (time / self.time)
            timer:SetTimeLeft(TIMER, left)
        end
    end
    self.time = time
end


function Farm:SetFoodNum(num)
    self.foodnum = num or 1
end


function Farm:SetOnChildSpawn(func)
    self.onChildSpawn = func
end


function Farm:SetOnItemGetFunc(func)
    self.onItemGetFunc = func
end


function Farm:IsFull()
    return self.childcount >= self.childmax
end


function Farm:GetLeftChildNum()
    return self.childmax - self.childcount
end



function Farm:Harvest(doer)
    if self.productions ~= nil and doer.components.inventory then
        for k, v in pairs(self.productions) do
            local items = ZXSpawnPrefabs(k, v)
            if items ~= nil then
                for _, iv in ipairs(items) do
                    doer.components.inventory:GiveItem(iv)
                end
            end
        end
        self.productions = nil
        self:StartProduce()
        return true
    end
    return false
end


---添加一个小动物
---@param child string
function Farm:AddFarmAnimal(child)
    if child and self:GetChildCnt() < self.childmax then
        local ent = SpawnPrefab(child)
        if ent then
            local x,y,z = self.inst.Transform:GetWorldPosition()            
            self.childcount = self.childcount + 1
            ent.Transform:SetPosition(x, y, z)

            local bindId = self.inst.components.zxbindable:GetBindId()
            ent.components.zxbindable:Bind(bindId)

            if ent.components.zxanimal then
                ent.components.zxanimal:SetFarmPosition(x, y, z)
            end


            local timer = self.inst.components.timer        
            if timer:TimerExists(TIMER) then
                ZXFarmEatFood(self.inst, 1)
            else
                -- 第一个动物需要启动生产机制
                self:StartProduce()
            end

            if self.onChildSpawn then
                self.onChildSpawn(self.inst, ent)
            end
        end
    end
end


function Farm:StartProduce()
    -- 物品超过100后停止生产
    if productionsCnt(self) >= PRODUCTION_MAX_CNT then
        return
    end

    local inst = self.inst
    if inst.components.timer:TimerExists(TIMER) then
        return
    end
    local animcnt = self.childcount
    local foodneed = (self.foodnum or 1) * animcnt
    if self.time > 0 and animcnt > 0 and ZXFarmEatFood(inst, foodneed) then
        inst.components.timer:StartTimer(TIMER, self.time)
    end
end


function Farm:OnSave()
    return {
        childcount = self.childcount,
        productions = self.productions,
    }
end


function Farm:OnLoad(data)
    self.childcount = data.childcount or 0
    self.productions = data.productions or nil
end



return Farm