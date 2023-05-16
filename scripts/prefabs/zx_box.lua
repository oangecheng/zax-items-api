local assets = {
    Asset("ANIM", "anim/ui_zx_5x5.zip"),
    -- 干草车
    Asset("ANIM", "anim/zx_hay_cart.zip"),	
    Asset("ATLAS", "images/inventoryimages/zx_hay_cart.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_hay_cart.tex"),
    Asset("ATLAS", "images/minimap/zx_hay_cart.xml"),
    Asset("IMAGE", "images/minimap/zx_hay_cart.tex"),
}


local prefabs = {
    "collapse_small",
}


local function onHit(inst, worker)
    if inst.components.container then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
end


local function onHammered(inst, worker)
    if inst.components.lootdropper then
        inst.components.lootdropper:DropLoot()
    end
    if inst.components.container then
        inst.components.container:DropEverything()
    end 
    
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end


-- 烧毁掉落物品
local function onBurnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
    inst:Remove()
end


-- 着火的时候不可以打开
local function onIgnite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end
-- 扑灭火之后可以打开
local function onExtinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end


-- 打开/关闭播放声音，这里使用盐盒的音效
local function onOpen(inst)
    inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
end

-- 关闭的时候根据格子填充的数量判断显示样式
local function onClose(inst)
    inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
    local container = inst.components.container
    if container then
        if container:IsEmpty() then
            inst:PlayAnimation("empty")
        elseif container:IsFull() then
            inst:PlayAnimation("full")
        else
            inst:PlayAnimation("half")
        end
    end
end



local function freshRate()
    return TUNING.ZX_GRANARY_FRESHRATE or 0.2
end



local function makeBox(name, icebox)
    local function fn()
        local inst = CreateEntity()
	
        inst.entity:AddTransform()
        inst.entity:AddAnimState() 
        inst.entity:AddMiniMapEntity()
	    inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.MiniMapEntity:SetIcon(name..".tex")
	
        inst:AddTag("structure")
	    inst:AddTag("wildfirepriority")
        inst:AddTag("chest")

	    MakeObstaclePhysics(inst, 1.5)
	
        inst.AnimState:SetBank(name) 
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("empty")
	
	    MakeSnowCoveredPristine(inst)
	
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
	
        inst:AddComponent("inspectable")
        inst:AddComponent("lootdropper")

	
        inst:AddComponent("container")
        inst.components.container:WidgetSetup(name)
        inst.components.container.onopenfn = onOpen
        inst.components.container.onclosefn = onClose
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true
	
	    -- 可以用锤子拆
        inst:AddComponent("workable") 
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(onHammered)
        inst.components.workable:SetOnWorkCallback(onHit) 

        -- 如果存放食物的容器，添加保鲜组件
        if icebox then
            inst:AddComponent("preserver")
            local rate = freshRate()
	        inst.components.preserver:SetPerishRateMultiplier(rate)
        end

        MakeLargeBurnable(inst)
        inst.components.burnable:SetOnBurntFn(onBurnt)
        inst.components.burnable:SetOnIgniteFn(onIgnite)
        inst.components.burnable:SetOnExtinguishFn(onExtinguish)
	
        AddHauntableDropItemOrWork(inst)
        MakeLargePropagator(inst)
        MakeSnowCovered(inst)
        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end


return makeBox("zx_hay_cart", false),
MakePlacer("zx_hay_cart_placer", "zx_hay_cart", "zx_hay_cart", "empty")

