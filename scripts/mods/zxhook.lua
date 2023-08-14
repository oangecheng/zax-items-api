

--- hook清洁扫帚
AddPrefabPostInit("reskin_tool", function(inst)
    local oldtest = inst.components.spellcaster.can_cast_fn
    local oldcb = inst.components.spellcaster.onspellcast

    inst.components.spellcaster:SetSpellFn(function(tool, target, pos, doer)
        if target.components.zxskinable then
            target.components.zxskinable:ChangeSkin(doer)
        elseif oldcb then
            oldcb(tool, target, pos, doer)
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
