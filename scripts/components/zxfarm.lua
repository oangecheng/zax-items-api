
local PRODUCTION_MAX_CNT = 100


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
    local animcnt = self.animalcnt
    local temp = nil
    if self.producefunc and animcnt > 0 then
        temp = {}
        for i = 1, animcnt do
            local product, num = self.producefunc(self.inst)
            if product and num > 0 then
                local originnum = temp[product] or 0
                temp[product] = originnum + num
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

    self.child = nil
    self.childmax = 10
    self.time = 0
    self.foodnum = 1

    self.inst:ListenForEvent("timerdone", function (_, data)
        if data.name == ZXFARM_TIMERS.PRODUCE then
            produce(self)
            self:StartProduce()
        end
    end)
end)



function Farm:SetChild(prefab)
    self.child = prefab
end


function Farm:GetChildCnt()
    return self.childcount
end


function Farm:SetChildMaxCnt(max)
    self.max = max or 10
end


function Farm:SetProduceTime(time)
    self.time = time
end


function Farm:SetFoodNum(num)
    self.foodnum = num or 1
end


function Farm:SetProduceFunc(func)
    self.producefunc = func
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
    if self.productions and doer.components.inventory then
        for k, v in pairs(self.productions) do
            local items = ZXSpawnPrefabs(k, v)
            if items ~= nil then
                for _, iv in ipairs(items) do
                    doer.components.inventory:GiveItem(iv)
                end
                self.productions = nil
                return true
            end
        end
    end
    return false
end


function Farm:AddFarmAnimal()
    if self.child and self:GetChildCnt() < self.childmax then
        local ent = SpawnPrefab(self.child)
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
            if timer:TimerExists(ZXFARM_TIMERS.PRODUCE) then
                if ZXFarmEatFood(self.inst, 1) then
                    local timeleft = timer:GetTimeLeft(ZXFARM_TIMERS.PRODUCE) * 0.9
                    timer:SetTimeLeft(ZXFARM_TIMERS.PRODUCE, timeleft)
                end  
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
    if inst.components.timer:TimerExists(ZXFARM_TIMERS.PRODUCE) then
        return
    end
    local animcnt = self.childcount
    local foodneed = (self.foodnum or 1) * animcnt
    if self.time > 0 and animcnt > 0 and ZXFarmEatFood(inst, foodneed) then
        inst.components.timer:StartTimer(ZXFARM_TIMERS.PRODUCE, self.time)
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