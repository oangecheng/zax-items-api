require("stategraphs/commonstates")

local actionhandlers =
{

}

local events=
{
    CommonHandlers.OnStep(),
    CommonHandlers.OnLocomote(true, true),
}

local function Gobble(inst)
    --if not inst.SoundEmitter:PlayingSound("gobble") then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/gobble")--, "gobble")
    --end
end

local states =
{
    State{
        name = "gobble_idle",
        tags = { "idle" },

        onenter = function(inst)
            inst.Physics:Stop()
            Gobble(inst)

            inst.AnimState:PlayAnimation("idle_loop", true)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "appear",
        tags = { "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/scream")
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("appear")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },
}


CommonStates.AddWalkStates(states,
{
    starttimeline =
    {
        TimeEvent(0, Gobble),
    },

    walktimeline =
    {
        TimeEvent(0, PlayFootstep),
        TimeEvent(12 * FRAMES, PlayFootstep),
    },
})

CommonStates.AddRunStates(states,
{
    starttimeline =
    {
        TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/run") end),
    },

    runtimeline =
    {
        TimeEvent(0, PlayFootstep),
        TimeEvent(5 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/run") end),
        TimeEvent(10 * FRAMES, PlayFootstep),
    },
})

CommonStates.AddIdle(states, "gobble_idle")


return StateGraph("zxperd", states, events, "idle", actionhandlers)
