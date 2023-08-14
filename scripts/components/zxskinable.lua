
local skindef = require("zx_skin/zx_skins")


local Skinable = Class(function (self, inst)
    self.inst = inst
    self.index = 2
end)



function Skinable:ChangeSkin(doer)
    local allskins = skindef.GetSkins(doer.userid)
    local skinlist = allskins[self.inst.prefab].data
    local cnt = #skinlist
    local index = math.fmod(self.index , cnt )
    self.index = self.index + 1

    local skin = skinlist[index + 1]
    if skin and skin.skinfunc then
        skin.skinfunc(self.inst)
    end
end


return Skinable