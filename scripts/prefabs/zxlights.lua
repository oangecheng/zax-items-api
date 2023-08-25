local PREABLE = "zxlight"
local assets = ZxGetPrefabAnimAsset(PREABLE)
local defalutSKin = ZxGetPrefabDefaultSkin(PREABLE)


local prefabs = {
    "collapse_small",
}


local function onhit(inst, worker)
	inst.AnimState:PushAnimation("close", true)
end

local function open(inst)
    if not inst.broken then
		inst.Light:Enable(true)
		inst.AnimState:PlayAnimation("open", true)
		inst.lightson = true
	end
end


local function close(inst)
    if not inst.broken then
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("close")
        inst.lightson = false
	end
end


local function tryopen(inst, isnight)
    if isnight then
        if not inst.lightson then
            open(inst)
        end
    elseif inst.lightson then
        inst:DoTaskInTime(3.0, close)
    end
end


local function onbuild(inst)
    tryopen(inst, TheWorld.state.isnight)
end


local function onhammered(inst)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:DropLoot()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end


local function on_burnt(inst)
    inst:Remove()
end


local function MakeLight(name, initSkinId)

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        inst.entity:AddLight()

        inst.Light:SetRadius(10)
        inst.Light:SetFalloff(.7)
        inst.Light:SetIntensity(.7)
        inst.Light:SetColour(.65, .65, .5)
        inst.Light:Enable(false)

        inst:AddTag("structure")
        MakeObstaclePhysics(inst, .2)


        local skin = ZxFindSkin(name, initSkinId)
        inst.AnimState:SetBank(defalutSKin.bank)
        inst.AnimState:SetBuild(defalutSKin.build)
        inst.AnimState:PlayAnimation("close")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("lootdropper")
        inst:AddComponent("zxskinable")
        inst.components.zxskinable:SetInitSkinId(defalutSKin.id)


        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)

        inst:ListenForEvent("onbuilt", onbuild)
        inst:WatchWorldState("isnight", tryopen)
        tryopen(inst, TheWorld.state.isnight)


        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)
        AddHauntableDropItemOrWork(inst)

        inst.components.burnable:SetOnBurntFn(on_burnt)


        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end


return MakeLight(PREABLE),
MakePlacer(PREABLE.."_placer", defalutSKin.bank, defalutSKin.bank, "close")