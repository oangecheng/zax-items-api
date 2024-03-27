
require "behaviours/wander"
require "behaviours/leash"
require "behaviours/doaction"
local BrainCommon = require("brains/braincommon")

local MAX_WANDER_DIST = ZXTUNING.FARM_AREA * 3.5 * 0.5


local function getHostLoc(inst)
    local host = ZxGetFarmHost(inst)
    return host and host:GetPosition() or nil
end


local function getFeederLoc(inst)
    local feeder = ZxGetFarmFeeder(inst)
    return feeder and feeder:GetPosition() or nil
end


local AnimalBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


function AnimalBrain:OnStart()
    local root = PriorityNode({
        Wander(self.inst, getHostLoc, MAX_WANDER_DIST)
    }, .25)
    self.bt = BT(self.inst, root)
end


return AnimalBrain