require "behaviours/wander"
require "behaviours/leash"
require "behaviours/standstill"
require "behaviours/doaction"
local BrainCommon = require("brains/braincommon")


local MAX_WANDER_DIST = 3.5


local function  homePos(inst)
    local pt = inst.components.zxanimal:GetFarmPosition()
    return Vector3(pt.x, pt.y, pt.z)
end


local PerdBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


function PerdBrain:OnStart()
    local root = PriorityNode(
    {
        Wander(self.inst, homePos, MAX_WANDER_DIST),
    }, .25)
    self.bt = BT(self.inst, root)
end

return PerdBrain