

local function userskins(doer, self)
    return ZxGetUserPrefabSkins(doer.userid, self.inst.prefab)
end


--- 查找目标skin
--- @param skinid number 0则查找默认皮肤
local function findSkin(self, skinid)
    return ZxFindSkin(self.inst.prefab, skinid)
end


local function reskin(self, skin)
    if skin and skin.skinfunc then
        self.skinid = skin.id
        skin.skinfunc(self.inst)
    end
end


local Skinable = Class(function (self, inst)
    self.inst = inst
    self.skinid = 0
end)


function Skinable:SetInitSkinId(id )
    self.skinid = id
    local skin = findSkin(self, self.skinid)
    reskin(self, skin)
end


--- 判断该玩家是否可以更换皮肤
--- 当玩家拥有的数量大于1时，即可认为可以更换皮肤
--- @param doer table
--- @return boolean true 可以更换
function Skinable:CanChangeSkin(doer)
    local skins = userskins(doer, self)
    return #skins > 1

end



function Skinable:ChangeSkin(doer)
    -- 先获取玩家拥有的该物品皮肤
    local skins = userskins(doer, self)
    if next(skins) ~= nil then
        local size = #skins
        local index = 0
        if self.skinid ~= 0 then
            for i, v in ipairs(skins) do
                if v.id == self.skinid then
                    index = i
                    break
                end
            end
        end

        index = index + 1 > size and 1 or index + 1
        reskin(self, skins[index])
    end
end

function Skinable:OnSave()
    return {
        skinid = self.skinid
    }
end


function Skinable:OnLoad(data)
    self.skinid = data.skinid or 0
    local skin = findSkin(self, self.skinid)
    reskin(self, skin)
end


return Skinable