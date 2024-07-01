
local function timefn(stage)
    return 20
end


local bush_stages = {
    {
        name = "bud",
        time = timefn,
        fn = function (inst, stage)
            inst.AnimState:PlayAnimation("stage_"..stage, true)
        end
    },
    {
        name = "grow",
        time = timefn,
        fn = function (inst, stage)
            inst.AnimState:PlayAnimation("stage_"..stage, true)
        end
    },
    {
        name = "ripe",
        time = timefn,
        fn = function (inst, stage)
            inst.AnimState:PlayAnimation("stage_"..stage, true)
        end
    },
    {
        name = "ripe_2",
        time = timefn,
        fn = function (inst, stage)
            inst.AnimState:PlayAnimation("stage_"..stage, true)
        end
    },
    {
        name = "ripe_3",
        time = timefn,
        fn = function (inst, stage)
            inst.AnimState:PlayAnimation("stage_"..stage, true)
        end
    }
}


local function onDigFinished(inst, worker)
    inst.components.lootdropper:SpawnLootPrefab(inst.prefab.."_dug")
    inst:Remove()
end



local function MakePlantBush(prefab, data)

    local prefabs = {}

    local assets = {}
    local res = ZxGetPrefabAnimAsset(prefab)
    for i, v in ipairs(res) do
        table.insert(assets, v)
    end

    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState() 
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
        inst.entity:SetPristine()
        MakeSmallObstaclePhysics(inst, .1)

        ZxInitItemForClient(inst, prefab, "stage_1", true)
        if not TheWorld.ismastersim then
            return inst
        end
        ZxInitItemForServer(inst, prefab)

        inst:AddComponent("lootdropper")
        inst:AddComponent("inspectable")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(onDigFinished)

        inst:AddComponent("growable")
        inst.components.growable.stages = bush_stages
        inst.components.growable:SetStage(1)
        inst.components.growable:StartGrowing()

        -- 野火
        inst:AddComponent("witherable")
        MakeMediumBurnable(inst)
        MakeMediumPropagator(inst)

        return inst
    end

    return Prefab(prefab, fn, assets, prefabs)
end


return MakePlantBush("zxmorning_glory"),
MakePlacer("zxmorning_glory_placer", "zxmorning_glory", "zxmorning_glory", "stage_1")


