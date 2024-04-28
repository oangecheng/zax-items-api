
local function give(user, prefab)
    if user.components.inventory then
        local item = SpawnPrefab(prefab)
        if item then
            user.components.inventory:GiveItem(item)
            return true
        end
    end
end


local Giver = Class(function (self, inst)
    self.inst = inst
    self.datas = {}
    self.recos = {}
end)


function Giver:SetData(prefab, max)
    local data = self.datas[prefab] or {}
    data.max = max or 1
    self.datas[prefab] = data
end


function Giver:Give(prefab)
    local data = self.datas[prefab]
    local cnt = self.recos[prefab] or 0
    if cnt < (data and data.max or 1) and give(self.inst, prefab) then
        self.recos[prefab] = cnt + 1
    end
end


function Giver:OnLoad(data)
    self.recos = data.recos or {}
end


function Giver:OnSave()
    return {
        recos = self.recos
    }
end




return Giver