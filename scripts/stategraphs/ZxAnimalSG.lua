
require("stategraphs/commonstates")

local actionhandlers = {}
local events = {
    CommonHandlers.OnLocomote(false, true),
}


local function Gobble(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/gobble")
end

local states = {
    State {
        name = "idle",
        tags = { "idle" },

        onenter = function(inst)
            inst.Physics:Stop()
            Gobble(inst)
            inst.AnimState:PlayAnimation("idle_loop", true)
        end,

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

    },
}



CommonStates.AddWalkStates(states, {
    walktimeline = {
        TimeEvent(0, PlayFootstep),
        TimeEvent(12 * FRAMES, PlayFootstep),
    },
})



CommonStates.AddIdle(states, "idle")

return StateGraph("ZxAnimalSG", states, events, "idle", actionhandlers)
