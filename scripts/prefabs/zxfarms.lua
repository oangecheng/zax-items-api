local assets = {
    Asset("ANIM", "anim/zx_flower.zip"),	
    Asset("ATLAS", "images/inventoryimages/zx_flower_1.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_flower_1.tex"),
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
    
        inst:AddTag("structure")
    
        MakeObstaclePhysics(inst, .2)
    
            
        inst.AnimState:SetBank("zx_flower") 
        inst.AnimState:SetBuild("zx_flower")
        inst.AnimState:PlayAnimation("zx_flower_1")
    
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

        inst:AddComponent("zxfarm")
        inst.components.zxfarm:StartSpawnChild()
    
        return inst
    end
    
    return Prefab(flower_name, fn, assets, nil)
end


return MakeFlower("zxfarm"),
MakePlacer("zxfarm_placer", "zx_flower", "zx_flower", "zx_flower_1")