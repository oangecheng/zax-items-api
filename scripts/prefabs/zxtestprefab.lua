local assets =
{
    Asset("ANIM", "anim/perd_basic.zip"),
    Asset("ANIM", "anim/perd.zip"),
    Asset("SOUND", "sound/perd.fsb"),
}

local prefabs =
{
    "drumstick",
    "redpouch",
}

local brain = require "brains/perdbrain"

local loot =
{
    "drumstick",
    "drumstick",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    -- inst:AddTag("character")


    MakeCharacterPhysics(inst, 1000, 1)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()
    inst.Physics:Stop()


    inst.AnimState:SetBank("perd")
    inst.AnimState:SetBuild("perd")
    inst.AnimState:Hide("hat")

    -- inst.AnimState:PlayAnimation("idle_loop", true)
    inst.entity:SetPristine()

    inst.AnimState:SetScale(0.5, 0.5, 0.5)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:SetStateGraph("ZxPerdSG")

    
    
    inst:AddComponent("inspectable")
    inst:SetBrain(brain)

    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = TUNING.PERD_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.PERD_WALK_SPEED

    return inst
end

return Prefab("zxperd", fn, assets, prefabs)