

local assets = {
    Asset("ANIM", "anim/zx_light_1.zip"),	
    Asset("ATLAS", "images/inventoryimages/zx_light_1.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_light_1.tex"),
}


local prefabs = {
    "collapse_small",
}


local function on_hit(inst, worker)
	inst.AnimState:PushAnimation("close", true)
end

local function open_light(inst)
    if not inst.broken then
		inst.Light:Enable(true)	
		inst.AnimState:PlayAnimation("open")
		inst.lightson = true		
	end
end


local function close_light(inst)
    if not inst.broken then
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("close")
        inst.lightson = false     
	end
end


local function on_is_night(inst, is_night)
    if is_night then
        if not inst.lightson then
            open_light(inst)
        end
    elseif inst.lightson then
        inst:DoTaskInTime(3.0, close_light)
    end
end


local function on_built(inst)
    on_is_night(inst, TheWorld.state.isnight)
end


local function on_hammered(inst)
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


local function MakeLight(light_name)

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
    
            
        inst.AnimState:SetBank(light_name) 
        inst.AnimState:SetBuild(light_name)
        inst.AnimState:PlayAnimation("close")
    
        inst.entity:SetPristine()
        
        if not TheWorld.ismastersim then
            return inst
        end
    
        inst:AddComponent("inspectable")
        inst:AddComponent("lootdropper")

    
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(on_hammered)
        inst.components.workable:SetOnWorkCallback(on_hit)

        inst:ListenForEvent("onbuilt", on_built)
        inst:WatchWorldState("isnight", on_is_night)
        on_is_night(inst, TheWorld.state.isnight)

    
        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)
        AddHauntableDropItemOrWork(inst)

        inst.components.burnable:SetOnBurntFn(on_burnt)

    
        return inst
    end
    
    return Prefab(light_name, fn, assets, prefabs)
end


return MakeLight("zx_light_1"),
MakePlacer("zx_light_1_placer", "zx_light_1", "zx_light_1", "close")