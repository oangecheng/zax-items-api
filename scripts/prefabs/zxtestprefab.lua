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


    MakeCharacterPhysics(inst, 1, 0.0001)
    RemovePhysicsColliders(inst)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()
    inst.Physics:Stop()


    inst.AnimState:SetBank("perd")
    inst.AnimState:SetBuild("perd")
    -- inst.AnimState:Hide("hat")

    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.entity:SetPristine()

    inst.AnimState:SetScale(0.3, 0.3, 0.3)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:SetStateGraph("ZxPerdSG")
    -- inst:SetBrain(brain)

    -- inst:AddComponent("homeseeker")


    inst:DoPeriodicTask(5, function ()
        if inst.x == nil then
            local x,y,z = inst.Transform:GetWorldPosition()
            inst.x = x
            inst.y = y
            inst.z = z
        end 
        local deltaX = math.random(1, 3.5)
        local d = math.random() < 0.5
        deltaX =  d and deltaX or -deltaX


        local deltaY = math.random(1, 3.5)
        local c = math.random() < 0.5
        deltaY =  c and deltaY or -deltaY


        local p = Vector3(inst.x + deltaX, inst.y + deltaY, inst.z + deltaY)
        inst.components.locomotor:GoToPoint(p, nil, false)
    end)


    inst:AddComponent("inspectable")

    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = 2
    inst.components.locomotor.walkspeed = 2

    return inst
end

return Prefab("zxperd", fn, assets, prefabs)