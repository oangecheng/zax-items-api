
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
        tags = { "idle" },

        onenter = function(inst)
            inst.Physics:Stop()
            playIdleSound(inst)
            inst.AnimState:PlayAnimation("idle_loop", true)
        end,

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

    },

    State{
        name = "walk_start",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("walk_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("walk") end),
        },
    },

    State{
        name = "walk",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk")
        end,
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("walk") end),
        },
    },


    State{
        name = "walk_stop",
        tags = { "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("walk_pst", false)
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
}



CommonStates.AddIdle(states, "idle")

return StateGraph("ZxGoatSG", states, events, "idle", actionhandlers)
