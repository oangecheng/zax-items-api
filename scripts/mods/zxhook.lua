


--生成特效
local function spawnFx(inst)
    local offset = {y=0.5,scale=1.2}
	local fx = SpawnPrefab("explode_reskin")
	local x,y,z=inst.Transform:GetWorldPosition()
	local offset_y = offset and offset.y or 0
	local scale = offset and offset.scale or 1
	if fx then
		fx.Transform:SetScale(scale, scale, scale)
		fx.Transform:SetPosition(x,y+offset_y,z)
	end
end


--- hook清洁扫帚
AddPrefabPostInit("zxskintool", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local oldtest = inst.components.spellcaster.can_cast_fn
    local spell = inst.components.spellcaster.spell

    inst.components.spellcaster:SetSpellFn(function(tool, target, pos, doer)
        if doer and target and target.components.zxskinable then
            target.components.zxskinable:ChangeSkin(doer)
            spawnFx(target)
        elseif spell then
            spell(tool, target, pos, doer)
        end
        
    end)
    
    inst.components.spellcaster:SetCanCastFn(function (doer, target, pos)
        if doer and target and target.components.zxskinable then
            return target.components.zxskinable:CanChangeSkin(doer)
        else
            return oldtest and oldtest(doer, target, pos)
        end
    end)
    
end)
