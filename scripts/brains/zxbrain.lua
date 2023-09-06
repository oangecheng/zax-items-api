require "behaviours/wander"
local BrainCommon = require("brains/braincommon")
local MAX_WANDER_DIST = 80
local SHRINE_LOITER_TIME = 4
local SHRINE_LOITER_TIME_VAR = 3
local MIN_SHRINE_WANDER_DIST = 4
local MAX_SHRINE_WANDER_DIST = 6


local BUSH_TAGS = { "bush" }
local function FindNearestBush(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 40, BUSH_TAGS)
    local emptybush = nil
    for i, v in ipairs(ents) do
        if v ~= inst and v.entity:IsVisible() and v.components.pickable ~= nil then
            -- NOTE: if a bush that can be in the ocean gets made, we should test for that here (unless perds learn to swim!)
            if v.components.pickable:CanBePicked() then
                return v
            elseif emptybush == nil then
                emptybush = v
            end
        end
    end
    return emptybush
        or (inst.components.homeseeker ~= nil and inst.components.homeseeker.home)
        or nil
end


local function HomePos(inst)
    local bush = FindNearestBush(inst)

    local x, y, z = inst.Transform:GetWorldPosition()
    local x1, y1, z1 = bush.Transform:GetWorldPosition()
    local dx, dz = x - x1, z - z1
    local nlen = MIN_SHRINE_WANDER_DIST / math.sqrt(dx * dx + dz * dz)
    return Vector3(x1 + dx * nlen, 0, z1 + dz * nlen)
end


local PerdBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

--------------------------------------------------------------------------

function PerdBrain:OnStart()

    
    local day = WhileNode( function() return TheWorld.state.isday end, "IsDay",
        PriorityNode{
            Wander(self.inst, HomePos, MAX_WANDER_DIST)
        }, .5)

    local root = PriorityNode(
    {
        BrainCommon.PanicTrigger(self.inst),
        day,
    }, .25)
    self.bt = BT(self.inst, root)
end

return PerdBrain
