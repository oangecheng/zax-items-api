
-- 老奶奶晾肉架，制作消耗和普通
AddRecipe2(
    "meatrack_hermit",
    {Ingredient("charcoal", 2), Ingredient("twigs", 3), Ingredient("rope", 3)},
    TECH.SCIENCE_TWO,
    {
		placer = "zx_meatrack_hermit_placer",
        atlas = "images/inventoryimages/zx_meatrack_hermit.xml",
        image = "zx_meatrack_hermit.tex",
    },
    {"STRUCTURES", "COOKING"}
)

-- 被锤
local function on_meatrack_hammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    if inst.components.dryer ~= nil then
        inst.components.dryer:DropItem()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function on_meatrack_hit(inst, worker)
    if inst:HasTag("burnt") then
        return
    end

    if inst.components.dryer ~= nil and inst.components.dryer:IsDrying() then
        inst.AnimState:PlayAnimation("hit_full")
        inst.AnimState:PushAnimation("drying_pre", false)
        inst.AnimState:PushAnimation("drying_loop", true)
    elseif inst.components.dryer ~= nil and inst.components.dryer:IsDone() then
        inst.AnimState:PlayAnimation("hit_full")
        inst.AnimState:PushAnimation("idle_full", false)
    else
        inst.AnimState:PlayAnimation("hit_empty")
        inst.AnimState:PushAnimation("idle_empty", false)
    end
end

-- 原版不能拆毁，这里改成可拆毁可烧毁，类似普通晾肉架
AddPrefabPostInit("meatrack_hermit", function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    -- 兼容其他mod
    if inst.lootdropper ~= nil or inst.workable ~= nil then
        return
    end

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(on_meatrack_hammered)
    inst.components.workable:SetOnWorkCallback(on_meatrack_hit)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)
end)