
require("stategraphs/commonstates")

local actionhandlers = {}
local events = {
    CommonHandlers.OnLocomote(false, true),
}


local function playIdleSound(inst)
    if inst.sound then
        inst.SoundEmitter:PlaySound(inst.sound)
    end
end


-- 后面再加其他的动作，比如吃东西，睡觉
local states = {
    State {
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            inst.Physics:Stop()
            playIdleSound(inst)
            inst.AnimState:PlayAnimation("idle_loop", true)
        end,
    },

    State {
        name = "eat",
        tags = { "busy" },
        onenter = function (inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    }
}



CommonStates.AddWalkStates(states, {})
CommonStates.AddIdle(states, "idle")

return StateGraph("SGzxperd", states, events, "idle", actionhandlers)