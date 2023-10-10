
local Farm = Class(function (self, inst)
    self.inst = inst
    self.item = nil
    self.childmax = 10
    self.child = nil
    self.childs = {}
    self.ishatching = false
end)


function Farm:SetIsHatching(is)
    self.ishatching = is
end


---设置农场生产动物所需要的原材料
---@param prefab string 原料名称
function Farm:SetHatchItem(prefab)
    if self.item == nil then
        self.item = prefab
    end
end


function Farm:SetOnHatch(func)
    self.onHatch = func
end


---是否能够给予种子
---@param item table 物品实体
---@return boolean
function Farm:CanHatch(item)
    return self.item and item and self.item == item.prefab 
        and self:GetChildCnt() < self.childmax
        and (not self.ishatching)
end



function Farm:Hatch(item, doer)
    if self:CanHatch(item) then
        if self.onHatch then
            self.onHatch(self.inst, doer, item)
            item:Remove()
        end
    end
end


function Farm:GetChildCnt()
    return #self.childs
end


function Farm:SetOnChildSpawn(func)
    self.onChildSpawn = func
end


function Farm:SetChild(prefab)
    self.child = prefab
end


function Farm:SpawnChild()
    if self.child and self:GetChildCnt() < self.childmax then
        local ent = SpawnPrefab(self.child)
        if ent then
            local x,y,z = self.inst.Transform:GetWorldPosition()
            table.insert(self.childs, ent.GUID)
            ent.Transform:SetPosition(x, y, z)

            local bundleId = self.inst.components.zxbundable:GetBundleId()
            ent.components.zxbundable:SetBundleId(bundleId)
            if ent.components.zxanimal then
                ent.components.zxanimal:SetFarmPosition(x, y, z)
            end
            if self.onChildSpawn then
                self.onChildSpawn(self.inst, ent)
            end
        end
    end
end


function Farm:OnSave()
    return {
        childs = self.childs,
        ishatching = self.ishatching
    }
end


function Farm:OnLoad(data)
    self.childs = data.childs or {}
    self.ishatching = data.ishatching or false
end



return Farm