---@diagnostic disable: deprecated


local MIN_DELTA = 1
local MAX_DELTA = 3.5


local function findNextPosition(inst)
    local pt = inst.components.zxanimal:GetFarmPostion()
    if pt then
        local dx = math.random(MIN_DELTA, MAX_DELTA)
        dx = math.random() < 0.5 and dx or -dx
        local dz = math.random(MIN_DELTA, MAX_DELTA)
        dz = math.random() < 0.5 and dz or -dz
        return Vector3(pt.x + dx, pt.y, pt.z + dz)
    end
    return nil
end



local function MakeAnimal(animal, data)

    local assets = data.assets

    local function fn()
        local inst = CreateEntity()
    
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()
        inst:AddTag("character")
    
        MakeCharacterPhysics(inst, 1, 0)
        RemovePhysicsColliders(inst)

        inst.DynamicShadow:SetSize(0.5, .75)
        if data.face == 6 then
            inst.Transform:SetSixFaced()
        else
            inst.Transform:SetFourFaced()
        end
        inst.Physics:Stop()

        inst.AnimState:SetBank(data.anim.bank)
        inst.AnimState:SetBuild(data.anim.build)
        inst.AnimState:SetScale(0.3, 0.3, 0.3)
        inst.AnimState:PlayAnimation("idle_loop", true)
        inst.AnimState:Hide("HEAT")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("locomotor")
        inst.components.locomotor.runspeed = 2
        inst.components.locomotor.walkspeed = 2
        inst:AddComponent("zxanimal")
    
        inst:SetStateGraph("ZxAnimalSG")
        inst:AddComponent("inspectable")

  

        local time = math.random(5, 10)
        inst:DoPeriodicTask(time, function ()
            local p = findNextPosition(inst)
            if p then
                inst.components.locomotor:GoToPoint(p, nil, false)
            end
        end)
    
        return inst
    end
    
    return Prefab(animal, fn, assets, nil)



end



local ANIMALS = require("defs/zxanimaldefs")
local list = {}
for k, v in pairs(ANIMALS) do
    table.insert(list, MakeAnimal(k, v))
end
return unpack(list)