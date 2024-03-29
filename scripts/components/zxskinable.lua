

local function userskins(doer, self)
    return ZxGetUserPrefabSkins(doer.userid, self.inst.prefab)
end


--- 查找目标skin
--- @param skinid string 0则查找默认皮肤
local function findSkin(self, skinid)
    return ZxFindSkin(self.inst.prefab, skinid)
end


local function reskin(self, skin)
    if skin and skin.skinfunc then
        self.skinid = skin.id
        skin.skinfunc(self.inst)
        if self.onSkinChangeFunc then
            self.onSkinChangeFunc(self.inst, self.skinid)
        end
    end
end


local Skinable = Class(function (self, inst)
    self.inst = inst
    -- 这里必须延迟一下，不然prefab是空的，因为时序问题还没赋值
    self.inst:DoTaskInTime(0, function ()
        if self.skinid == nil then
            local skin =  ZxGetPrefabDefaultSkin(self.inst.prefab)
            self.skinid = skin.id
            reskin(self, skin)
        end
    end)
end)


function Skinable:GetSkinId()
   return self.skinid 
end


--- 判断该玩家是否可以更换皮肤
--- 当玩家拥有的数量大于1时，即可认为可以更换皮肤
--- @param doer table
--- @return boolean true 可以更换
function Skinable:CanChangeSkin(doer)
    local skins = userskins(doer, self)
    return #skins >= 1

end


function Skinable:SetSkinChangedFunc(func)
    self.onSkinChangeFunc = func
end


function Skinable:ChangeSkin(doer)
    -- 先获取玩家拥有的该物品皮肤
    local skins = userskins(doer, self)
    if next(skins) ~= nil then
        local size = #skins
        local index = nil
        if self.skinid ~= nil then
            for i, v in ipairs(skins) do
                if v.id == self.skinid then
                    index = i
                    break
                end
            end
        end
        if index == nil then
            index = 1
        else
            index = index + 1 > size and 1 or index + 1
        end
        reskin(self, skins[index])
    end
end


function Skinable:SetSkin(skinid)
    local skin = findSkin(self, skinid)
    print("set skin "..tostring(skin))
    reskin(self, skin)
end


function Skinable:OnSave()
    return {
        skinid = self.skinid
    }
end


function Skinable:OnLoad(data)
    self.skinid = data.skinid and tostring(data.skinid) or nil
    local skin = findSkin(self, self.skinid)
    reskin(self, skin)
end


return Skinable