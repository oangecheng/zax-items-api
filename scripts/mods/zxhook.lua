

--- hook清洁扫帚
AddPrefabPostInit("reskin_tool", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local oldtest = inst.components.spellcaster.can_cast_fn
    local spell = inst.components.spellcaster.spell

    inst.components.spellcaster:SetSpellFn(function(tool, target, pos, doer)
        if target.components.zxskinable then
            target.components.zxskinable:ChangeSkin(doer)
        elseif spell then
            spell(tool, target, pos, doer)
        end
        
    end)
    
    inst.components.spellcaster:SetCanCastFn(function (doer, target, pos)
        if target.components.zxskinable then
            return true
        else
            return oldtest and oldtest(doer, target, pos)
        end
    end)
    
end)
