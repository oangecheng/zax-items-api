
require("stategraphs/commonstates")

local actionhandlers = {}
local events = {
    CommonHandlers.OnLocomote(true, false),
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
            inst.AnimState:PlayAnimation("idle", true)
        end,

        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

    }
}



CommonStates.AddRunStates(states,
{
    runtimeline =
    {
        TimeEvent(0, function(inst)
            PlayFootstep(inst)
        end),
        TimeEvent(4 * FRAMES, function(inst)
            PlayFootstep(inst)
        end),
    },
})

return StateGraph("ZxHoundSG", states, events, "idle", actionhandlers)
