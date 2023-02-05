
local assets = {
    Asset("ANIM", "anim/ui_zx_5x10.zip"),	
    Asset("ANIM", "anim/zx_granary_meat.zip"),	
    Asset("ATLAS", "images/inventoryimages/zx_granary_meat.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_granary_meat.tex"),
    Asset("ATLAS", "images/minimap/zx_granary_meat.xml"),
    Asset("IMAGE", "images/minimap/zx_granary_meat.tex")
}

local prefabs = {
    "collapse_small",
}


-- 被锤掉落里面的物品
local function on_hit(inst, worker)
    inst.components.container:DropEverything()
    inst.components.container:Close()
end

-- 锤坏了之后移除仓库
local function on_hammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end


-- 烧毁掉落物品
local function on_burnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
    inst:Remove()
end


-- 着火的时候不可以打开
local function on_ignite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end
-- 扑灭火之后可以打开
local function on_extinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end


-- 打开/关闭播放声音，这里使用盐盒的音效
local function on_open(inst)
    inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
end
local function on_close(inst)
    inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
end


local function fresh_rate()
    return TUNING.ZX_GRANARY_FRESHRATE or 0.2
end


local function fn()
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState() 
    inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("zx_granary_meat.tex")
	
    inst:AddTag("structure")
	inst:AddTag("wildfirepriority")

	MakeObstaclePhysics(inst, 1.5)
	
    inst.AnimState:SetBank("zx_granary_meat") 
    inst.AnimState:SetBuild("zx_granary_meat")
    inst.AnimState:PlayAnimation("idle")
	
	MakeSnowCoveredPristine(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("zx_granary_meat")
    inst.components.container.onopenfn = on_open
    inst.components.container.onclosefn = on_close
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true
	
	-- 可以用锤子拆
    inst:AddComponent("workable") 
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(6)
    inst.components.workable:SetOnFinishCallback(on_hammered)
    inst.components.workable:SetOnWorkCallback(on_hit) 

    -- 添加保鲜组件
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(fresh_rate)
	
    AddHauntableDropItemOrWork(inst)
    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)


    inst.components.burnable:SetOnBurntFn(on_burnt)
    inst.components.burnable:SetOnIgniteFn(on_ignite)
    inst.components.burnable:SetOnExtinguishFn(on_extinguish)
	
	MakeSnowCovered(inst)
	
    return inst
end

return Prefab("zx_granary_meat", fn, assets, prefabs),
	MakePlacer("zx_granary_meat_placer", "zx_granary_meat", "zx_granary_meat", "idle")