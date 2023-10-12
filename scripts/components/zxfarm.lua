
local Farm = Class(function (self, inst)
    self.inst = inst
    self.childcount = 0

    self.child = nil
    self.childmax = 10
    self.time = 0
    self.foodnum = 1
    self.products = {}

    self.inst:ListenForEvent("timerdone", function (_, data)
        if data.name == ZXFARM_TIMERS.PRODUCE then
            self:StartProduce()
            if self.onItemGetFunc then
                self.onItemGetFunc({})
            end
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


function Farm:SetProduct(items)
    self.products = items or {}
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
    local inst = self.inst
    if inst.components.timer:TimerExists(ZXFARM_TIMERS.PRODUCE) then
        return
    end
    local animcnt = self.childcount
    local foodneed = (self.foodnum or 1) * animcnt
    if self.time > 0 and animcnt > 0 and ZXFarmEatFood(inst, foodneed) then
        local time = self.time * (1.1 - 0.1 * animcnt)
        inst.components.timer:StartTimer(ZXFARM_TIMERS.PRODUCE, time)
    end
end


function Farm:OnSave()
    return {
        childcount = self.childcount,
    }
end


function Farm:OnLoad(data)
    self.childcount = data.childcount or {}
end



return Farm