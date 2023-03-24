local assets = {
    Asset("ANIM", "anim/zx_flower.zip"),	
    Asset("ATLAS", "images/inventoryimages/zx_flower_1.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_flower_1.tex"),
    Asset("ATLAS", "images/inventoryimages/zx_flower_2.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_flower_2.tex"),
    Asset("ATLAS", "images/inventoryimages/zx_flower_3.xml"),
    Asset("IMAGE", "images/inventoryimages/zx_flower_3.tex"),
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
    
        inst:AddTag("flower")
        inst:AddTag("structure")
    
        MakeObstaclePhysics(inst, .2)
    
            
        inst.AnimState:SetBank("zx_flower") 
        inst.AnimState:SetBuild("zx_flower")
        inst.AnimState:PlayAnimation(flower_name)
    
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


return MakeFlower("zx_flower_1"),
MakePlacer("zx_flower_1_placer", "zx_flower", "zx_flower", "zx_flower_1"),
MakeFlower("zx_flower_2"),
MakePlacer("zx_flower_2_placer", "zx_flower", "zx_flower", "zx_flower_2"),
MakeFlower("zx_flower_3"),
MakePlacer("zx_flower_3_placer", "zx_flower", "zx_flower", "zx_flower_3")