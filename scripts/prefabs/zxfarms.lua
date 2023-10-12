
local BIND_RADIUS = 4

local FARMS = require "defs/zxfarmdefs"


local assets = {
    Asset("ANIM", "anim/zxfarmperd1.zip")
}


local function onHammered(inst, doer)
    if inst.components.lootdropper then
        inst.components.lootdropper:DropLoot()
    end

    local ents = ZXFarmGetBindItems(inst)
    if ents then
        local bindId = inst.components.zxbindable:GetBindId()
        for k, value in pairs(ents) do
            value.components.zxbindable:Remove(bindId)
        end
    end

    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()


end



--- 当农场的其他物品被建造时
--- 如果在范围内，就将其与农场主体绑定
local function onFarmItemBuild(inst, item)
    local fx, _, fz = inst.Transform:GetWorldPosition()
    local ix, _, iz = item.Transform:GetWorldPosition()
    local bindId = inst.components.zxbindable:GetBindId()
    -- 数据合法
    if bindId and inst.farmdata and fx and ix then
        -- 范围内
        if math.abs(fx-ix) <= BIND_RADIUS and math.abs(fz-iz) <= BIND_RADIUS then
            if item.components.zxbindable and item.components.zxbindable:CanBind() then
                item.components.zxbindable:Bind(bindId, inst.farmdata)
            end
        end
    end
end



local function MakeFarm(name, farm)
     
    --- 建造主体的时候会生成地皮
    local function onBuild(inst)
        local x,y,z = inst.Transform:GetWorldPosition()
        local bindId = inst.prefab.."x"..tostring(x).."y"..tostring(y).."z"..tostring(z)
        -- 数据就在主体结构这里，不需要绑定数据
        inst.components.zxbindable:Bind(bindId)
        local land = SpawnPrefab("zxfarmland")
        land.components.zxbindable:Bind(bindId, inst.farmdata)
        land.Transform:SetPosition(x, y, z)
    end


    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState() 
        inst.entity:AddMiniMapEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst:AddTag("structure")
        inst:AddTag("zxfarm")
        inst:AddTag("ZXFARM_HOST")

        MakeObstaclePhysics(inst, 1)
        RemovePhysicsColliders(inst)
        inst.AnimState:SetBank("zxfarmperd1") 
        inst.AnimState:SetBuild("zxfarmperd1")
        inst.AnimState:PlayAnimation("idle")
    
        inst.entity:SetPristine()
        
        if not TheWorld.ismastersim then
            return inst
        end

        inst.farmdata = farm
    
        inst:AddComponent("timer")

        inst:AddComponent("inspectable")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        inst.components.workable:SetOnFinishCallback(onHammered)
    
        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)


        inst:AddComponent("zxfarm")
        inst.components.zxfarm:SetChild(farm.animal)
        inst.components.zxfarm:SetChildMaxCnt(farm.animalcnt)
        inst.components.zxfarm:SetProduct(farm.products)
        inst.components.zxfarm:SetProduceTime(farm.producetime)
        inst.components.zxfarm:SetFoodNum(farm.foodnum)

        inst:AddComponent("zxbindable")
        TheWorld:ListenForEvent(ZXEVENTS.FARM_ITEM_BUILD, function (_, data)
            onFarmItemBuild(inst, data.item)
        end)
        inst:ListenForEvent(ZXEVENTS.FARM_ADD_FOOD, function ()
            inst.components.zxfarm:StartProduce()
        end)
        inst:ListenForEvent(ZXEVENTS.FARM_HATCH_FINISHED, function ()
            inst.components.zxfarm:AddFarmAnimal()
        end)

        inst:ListenForEvent("onbuilt", onBuild)
        
        return inst
    end
    
    return Prefab(name, fn, assets, nil)
end


local farmlist = {}
for k, v in pairs(FARMS) do
    table.insert(farmlist, MakeFarm(k, v))
    table.insert(farmlist, MakePlacer(k.."_placer", "zxfarmperd1", "zxfarmperd1", "idle"))
    -- table.insert(farmlist, MakePlacer(k.."_placer", v.initskin.file, v.initskin.file, v.initanim))
end
return unpack(farmlist)