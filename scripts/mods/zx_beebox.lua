-- 老奶奶蜂箱，制作消耗和普通
AddRecipe2(
    "beebox_hermit",
    {Ingredient("boards", 2),Ingredient("honeycomb", 1),Ingredient("bee", 4)},
    TECH.SCIENCE_TWO,
    {
		placer = "zx_beebox_hermit_placer",
        atlas = "images/inventoryimages/zx_beebox_hermit.xml",
        image = "zx_beebox_hermit.tex",
    },
    {"STRUCTURES", "GARDENING"}
)

local function on_hammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.SoundEmitter:KillSound("loop")
    if inst.components.harvestable ~= nil then
        inst.components.harvestable:Harvest()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function on_hit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation(inst.anims.hit)
        inst.AnimState:PushAnimation(inst.anims.idle, false)
    end
end

local function on_ignite(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren()
        inst.components.childspawner:StopSpawning()
    end
end

AddPrefabPostInit("beebox_hermit", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(on_hammered)
    inst.components.workable:SetOnWorkCallback(on_hit)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)
    inst:ListenForEvent("onignite", on_ignite)
end)