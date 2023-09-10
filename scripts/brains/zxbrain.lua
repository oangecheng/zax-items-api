require "behaviours/wander"
local BrainCommon = require("brains/braincommon")
local MAX_WANDER_DIST = 30
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
    return bush ~= nil and bush:GetPosition() or nil
end


local PerdBrain = Class(Brain, function(self, inst)
    print("gggggg")
    Brain._ctor(self, inst)
end)

--------------------------------------------------------------------------

function PerdBrain:OnStart()
    print("gggggg 2")
    local root = PriorityNode(
    {
        WhileNode(function() return true end, "wander repeat", Wander(self.inst, HomePos, 20)),
        Wander(self.inst, HomePos, 20),
    }, .25)
    self.bt = BT(self.inst, root)
end

return PerdBrain
