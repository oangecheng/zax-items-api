

local assets = {
    Asset("ANIM", "anim/zx_light.zip"),	
    Asset("ATLAS", "images/inventoryimages/zx_light_2.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_light_2.tex"),
}


local function on_hammered(inst)
    local fx = SpawnPrefab("petals")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end


local function MakeFlower(flower_name)

    local function fn()
        local inst = CreateEntity()
        
        inst.entity:AddTransform()
        inst.entity:AddAnimState() 
        inst.entity:AddMiniMapEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        inst.entity:AddLight()

        inst.Light:SetRadius(12)
        inst.Light:SetFalloff(.8)
        inst.Light:SetIntensity(.8)
        inst.Light:SetColour(255/255,255/255,0/255)
        inst.Light:Enable(true)

    
        inst:AddTag("flower")
        inst:AddTag("structure")
    
        MakeObstaclePhysics(inst, .2)
    
            
        inst.AnimState:SetBank(flower_name) 
        inst.AnimState:SetBuild("zx_light")
        inst.AnimState:PlayAnimation("open")
    
        inst.entity:SetPristine()
        
        if not TheWorld.ismastersim then
            return inst
        end
    
        inst:AddComponent("inspectable")
    
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(on_hammered)
    
        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)
    
        return inst
    end
    
    return Prefab(flower_name, fn, assets, prefabs)
end


return MakeFlower("zx_light_2"),
MakePlacer("zx_light_2_placer", "zx_light_2", "zx_light_2", "open")