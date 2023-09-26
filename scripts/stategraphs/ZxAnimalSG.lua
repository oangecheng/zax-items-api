
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
}



CommonStates.AddWalkStates(states, {})
CommonStates.AddIdle(states, "idle")

return StateGraph("ZxAnimalSG", states, events, "idle", actionhandlers)
