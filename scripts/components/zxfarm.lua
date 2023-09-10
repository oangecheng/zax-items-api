

local Farm = Class(function (self, inst)
    self.inst = inst
    self.seeds = {}
    self.foods = {}

end)



function Farm:StartSpawnChild()
    self.inst.task = self.inst:DoPeriodicTask(10, function ()
        local ent = SpawnPrefab("zxfarmpig")
        local x,y,z = self.inst.Transform:GetWorldPosition()
        ent.Transform:SetPosition(x, y, z)
    end)
end




return Farm