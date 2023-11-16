
--- 三个阶段动画
local function threePhaseAnim(inst)
    local container = inst.components.container
    if container ~= nil and not container:IsEmpty() then
        local nums = container:NumItems()
        local max  = container:GetNumSlots()
        if nums >= max * 0.5 then
            return "full"
        else
            return "half"
        end
    end
    return "empty"
end


local function obtainNormalBox(prefab, icebox)
    local sound_open  = "saltydog/common/saltbox/open"
    local sound_close = "saltydog/common/saltbox/close"

    return {
        isicebox = icebox;
        placeanim = "empty",
        initskin = ZxGetPrefabDefaultSkin(prefab),
        oninitfn = function(inst)
            inst.AnimState:PlayAnimation(threePhaseAnim(inst))
        end,
        onopenfn = function(inst, doer)
            inst.SoundEmitter:PlaySound(sound_open)
        end,
        onclosefn = function(inst, doer)
            inst.AnimState:PlayAnimation(threePhaseAnim(inst))
            inst.SoundEmitter:PlaySound(sound_close)
        end,

        onbuildfn = function(inst)
            inst.AnimState:PlayAnimation("onbuild")
            inst.AnimState:PushAnimation("empty")
        end,

        onhitfn = function(inst, doer)
            inst.AnimState:PlayAnimation("onhit")
            inst.AnimState:PushAnimation(threePhaseAnim(inst))
        end,
    }
end



local granaryveggie = {
    isicebox = true,
    placeanim = "idle",
    initskin = ZxGetPrefabDefaultSkin("zx_granary_veggie");

    oninitfn = function (inst)
        inst.AnimState:PlayAnimation("idle", true)
    end,

    onopenfn = function (inst, doer)
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
    end,

    onclosefn = function (inst, doer)
        inst.AnimState:PlayAnimation("idle", true)
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
    end,


    onbuildfn = function (inst)
    end,

    onhitfn = function (inst, doer)

    end,
}



local granarymeat = {
    isicebox = true,
    placeanim = "idle",
    initskin = ZxGetPrefabDefaultSkin("zx_granary_meat");

    oninitfn = function (inst)
        inst.AnimState:PlayAnimation("idle", true)
    end,

    onopenfn = function (inst, doer)
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
    end,

    onclosefn = function (inst, doer)
        inst.AnimState:PlayAnimation("idle", true)
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
    end,


    onbuildfn = function (inst)
        inst.AnimState:PlayAnimation("onbuild")
        inst.AnimState:PushAnimation("idle")
    end,

    onhitfn = function (inst, doer)
        inst.AnimState:PlayAnimation("onhit")
        inst.AnimState:PushAnimation("idle")
    end,
}




local function getHoneyJarAnim(inst, isopen)
    local container = inst.components.container
    if container == nil then return nil end
    if container:IsEmpty() then return isopen and "open_empty" or "close_empty"
    elseif container:IsFull() then return isopen and "open_full" or "close_full"
    else return isopen and "open_half" or "close_half" end
end

local honeyjar = {

    isicebox = true;
    placeanim = "close_empty",
    initskin = ZxGetPrefabDefaultSkin("zxhoneyjar");

    oninitfn = function (inst)
        local a = getHoneyJarAnim(inst, false)
        inst.AnimState:PlayAnimation(a and a or "close_empty")
    end,

    onopenfn = function (inst, doer)
        inst.AnimState:PlayAnimation(getHoneyJarAnim(inst, true))
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
    end,

    onclosefn = function (inst, doer)
        inst.AnimState:PlayAnimation(getHoneyJarAnim(inst, false))
        if doer then
            inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
        end
    end,


    onbuildfn = function (inst)
        inst.AnimState:PlayAnimation("onbuild")
        inst.AnimState:PushAnimation("close_empty")
    end,

    onhitfn = function (inst, doer)
        inst.AnimState:PlayAnimation("onhit")
        inst.AnimState:PushAnimation(getHoneyJarAnim(inst, false))
    end,

}




local ashcan = {

    placeanim = "close",
    initskin = ZxGetPrefabDefaultSkin("zxashcan");

    oninitfn = function (inst)
        inst.AnimState:PlayAnimation("close")
    end,

    onopenfn = function (inst, doer)
        inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
    end,

    onclosefn = function (inst, doer)
        inst.AnimState:PlayAnimation("close")
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
    end,

    onhitfn = function (inst, doer)
        inst.AnimState:PlayAnimation("onhit")
        inst.AnimState:PushAnimation("close")
    end,

    btnfn = function (inst, doer)
        if inst.components.container then
			local items = inst.components.container:RemoveAllItems()
			if items then
				for _, v in ipairs(items) do
					v:Remove()
				end
			end
		end
    end
}


local boxs = {
    ["zxhoneyjar"] = honeyjar,
    ["zxashcan"]   = ashcan,
    ["zx_granary_veggie"] = granaryveggie,
    ["zx_granary_meat"] = granarymeat,

    ["zxlogstore"] = obtainNormalBox("zxlogstore"),
    ["zxeggbasket"] = obtainNormalBox("zxeggbasket", true),
    ["zx_hay_cart"] = obtainNormalBox("zx_hay_cart"),
    ["zxmushroomhouse"] = obtainNormalBox("zxmushroomhouse", true),
    ["zxboxmine"] = obtainNormalBox("zxboxmine"),
    ["zxboxgem"]  = obtainNormalBox("zxboxgem")
}

return  boxs