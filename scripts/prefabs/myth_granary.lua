
local assets = {
    Asset("ANIM", "anim/myth_granary.zip"),
	Asset("ATLAS", "images/myth_granary.xml"),
}

local prefabs = {
    "collapse_small",
}


local function itemPreserverRate()
    return 0
end


local function onopen(inst)
    --inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/common/chest_open")
end

local function onclose(inst)
    --inst.AnimState:PlayAnimation("close")
    inst.SoundEmitter:PlaySound("dontstarve/common/chest_close")
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    -- inst.AnimState:PlayAnimation("hit")
    inst.components.container:DropEverything()
    --inst.AnimState:PushAnimation("closed", false)
    inst.components.container:Close()
end


local function onbuilt(inst)
    -- inst.AnimState:PlayAnimation("place")
    -- inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")
end


local function fn()
    local inst = CreateEntity()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()

    inst.MiniMapEntity:SetIcon("myth_granary.tex")
    inst.AnimState:SetBank("myth_granary")
    inst.AnimState:SetBuild("myth_granary")
    inst.AnimState:PlayAnimation("idle", false)

    inst:AddTag("structure")
    inst:AddTag("chest")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()


    if not TheWorld.ismastersim then
		return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("myth_granary")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(itemPreserverRate)

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)


    inst:ListenForEvent("onbuilt", onbuilt)
    MakeSnowCovered(inst)

    AddHauntableDropItemOrWork(inst)

    return inst
end


return Prefab("myth_granary", fn, assets),
    MakePlacer("myth_granary_placer", "myth_granary", "myth_granary", "idle")
