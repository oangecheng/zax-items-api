
local skindef = require("zx_skin/zx_skins")


local Skinable = Class(function (self, inst)
    self.inst = inst
    self.skinid = 0
end)



function Skinable:ChangeSkin(doer)
    local allskins = skindef.GetSkins(doer.userid)
    local skinlist = allskins[self.inst.prefab]
    local skin = GetRandomItem(skinlist)
    if skin and skin.skinfunc then
        skin.skinfunc(self.inst)
    end
end


return Skinable