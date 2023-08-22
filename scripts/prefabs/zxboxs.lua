
local assets = {
    Asset("ANIM", "anim/ui_zx_5x5.zip"),
    -- 干草车
    Asset("ANIM",  "anim/zxashcan.zip"),	
    Asset("ATLAS", "images/inventoryimages/zxashcan.xml"),
    Asset("IMAGE", "images/inventoryimages/zxashcan.tex"),
}


local prefabs = {
    "collapse_small",
}



local function freshRate()
    return TUNING.ZX_GRANARY_FRESHRATE or 0.2
end


local boxesdef = {

    ["zxashcan"] = {

        onopenfn = function(inst, doer)
            inst.AnimState:PlayAnimation("open")
            if inst.cleartask then
                inst.cleartask:Cancel()
                inst.cleartask = nil
            end
        end,

        onclosefn = function (inst, doer)
            inst.AnimState:PlayAnimation("idle")
            if inst.cleartask then
                inst.cleartask:Cancel()
                inst.cleartask = nil
            end
            inst.cleartask = inst:DoTaskInTime(5, function ()
                if inst.components.container then
                    local items = inst.components.container:RemoveAllItems()
                    if items then
                        for _, v in ipairs(items) do
                            v:Remove()
                        end
                    end
                end
            end)
        end
    }
}




local function MakeZxBox(name)

    local data = boxesdef[name]


    local function onHit(inst, _)
        if inst.components.container then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
    end
    
    
    local function onHammered(inst, _)
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
    local function onOpen(inst, doer)
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
        if data.onopenfn then
            data.onopenfn(inst, doer)
        end
    end

    local function onClose(inst, doer)
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
        if data.onclosefn then
            data.onclosefn(inst, doer)
        end
    end


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

	    MakeObstaclePhysics(inst, 1)
	
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

        if data.skinable then
            inst:AddComponent("zxskinable")
        end
	
	    -- 可以用锤子拆
        inst:AddComponent("workable") 
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(onHammered)
        inst.components.workable:SetOnWorkCallback(onHit) 

        -- 如果存放食物的容器，添加保鲜组件
        if data.icebox then
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


return MakeZxBox("zxashcan"),
MakePlacer("zxashcan_placer", "zxashcan", "zxashcan", "empty")

