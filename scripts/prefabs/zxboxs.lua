
local assets = {
    Asset("ANIM", "anim/ui_chest_3x3.zip"),
}

local prefabs = {
    "collapse_small",
}

local function freshRate()
    return TUNING.ZX_GRANARY_FRESHRATE or 0.2
end


local function MakeZxBox(prefabname, data)

    local res = ZxGetPrefabAnimAsset(prefabname)
    for i, v in ipairs(res) do
        table.insert(assets, v)
    end

    local skin = data.initskin

    local function onHammered(inst, doer)
        if inst.components.lootdropper then
            inst.components.lootdropper:DropLoot()
        end
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("wood")
        inst:Remove()
    end
     
    local function onHit(inst, doer)
        if inst.components.container then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
        if data.onhitfn then
            data.onhitfn(inst, doer)
        end        
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


    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState() 
        inst.entity:AddMiniMapEntity()
	    inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

	
        inst:AddTag("structure")
	    inst:AddTag("wildfirepriority")
        inst:AddTag("chest")

	    MakeObstaclePhysics(inst, 0.5)
        if skin == nil then
            return inst
        end
	
        inst.MiniMapEntity:SetIcon(skin.tex)
        inst.AnimState:SetBank(skin.file)
        inst.AnimState:SetBuild(skin.file)
        inst.entity:SetPristine()
        if data.oninitfn then
            data.oninitfn(inst)
        end
        if not TheWorld.ismastersim then
            return inst
        end

        inst:ListenForEvent("onbuilt", data.onbuildfn)

        inst:AddComponent("inspectable")
        inst:AddComponent("lootdropper")
        if data.isicebox then
            local rate = freshRate()
            inst:AddComponent("preserver")
	        inst.components.preserver:SetPerishRateMultiplier(rate)
        end

        inst:AddComponent("container")
        inst.components.container:WidgetSetup(prefabname)
        inst.components.container.onopenfn = data.onopenfn
        inst.components.container.onclosefn = data.onclosefn
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true

        inst:AddComponent("zxskinable")
        -- 可以用锤子拆
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        inst.components.workable:SetOnFinishCallback(onHammered)
        inst.components.workable:SetOnWorkCallback(onHit)

        MakeLargeBurnable(inst)
        inst.components.burnable:SetOnBurntFn(onBurnt)
        inst.components.burnable:SetOnIgniteFn(onIgnite)
        inst.components.burnable:SetOnExtinguishFn(onExtinguish)

        AddHauntableDropItemOrWork(inst)
        MakeSnowCovered(inst)
        
        inst.btnfn = data.btnfn
        inst.OnLoad = function(d)
            if data.oninitfn then
                data.oninitfn(inst)
            end
        end

        return inst
    end

    return Prefab(prefabname, fn, assets, prefabs)
end



local BOXDEFS = require("defs/zxboxdefs")
local boxlist = {}
for k, v in pairs(BOXDEFS) do
    table.insert(boxlist, MakeZxBox(k, v))
    table.insert(boxlist, MakePlacer(k.."_placer", v.initskin.file, v.initskin.file, v.placeanim))
end

return unpack(boxlist)