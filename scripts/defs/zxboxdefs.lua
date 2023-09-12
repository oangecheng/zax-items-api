

local granaryveggie = {
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
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
    end,

    onclosefn = function (inst, doer)
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
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




local logstore = {
    placeanim = "close",
    initskin = ZxGetPrefabDefaultSkin("zxlogstore");

    oninitfn = function (inst)
        inst.AnimState:PlayAnimation("close")
    end,

    onopenfn = function (inst, doer)
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
        inst.AnimState:PlayAnimation("open")
    end,

    onclosefn = function (inst, doer)
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
        inst.AnimState:PlayAnimation("close")
    end,

}




local function eggBasketAnim(inst)
    local container = inst.components.container
    if container == nil then return "empty" end
    if container:IsEmpty() then return "empty"
    elseif container:IsFull() then return "full"
    else return "half" end
end

local eggbasket = {
    placeanim = "empty",
    initskin = ZxGetPrefabDefaultSkin("zxeggbasket");

    oninitfn = function (inst)
        inst.AnimState:PlayAnimation(eggBasketAnim(inst))
    end,

    onopenfn = function (inst, doer)
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
    end,

    onclosefn = function (inst, doer)
        inst.AnimState:PlayAnimation(eggBasketAnim(inst))
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
    end,


    onbuildfn = function (inst)
        inst.AnimState:PlayAnimation("onbuild")
        inst.AnimState:PushAnimation("empty")
    end,

    onhitfn = function (inst, doer)
        inst.AnimState:PlayAnimation("onhit")
        inst.AnimState:PushAnimation(eggBasketAnim(inst))
    end,
}





local function haycartAnim(inst)
    local container = inst.components.container
    if container == nil then return "empty" end
    if container:IsEmpty() then return "empty"
    elseif container:IsFull() then return "full"
    else return "half" end
end

local haycart = {
    placeanim = "empty",
    initskin = ZxGetPrefabDefaultSkin("zx_hay_cart");

    oninitfn = function (inst)
        inst.AnimState:PlayAnimation(haycartAnim(inst))
    end,

    onopenfn = function (inst, doer)
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/open")
    end,

    onclosefn = function (inst, doer)
        inst.AnimState:PlayAnimation(haycartAnim(inst))
        inst.SoundEmitter:PlaySound("saltydog/common/saltbox/close")
    end,


    onbuildfn = function (inst)
        inst.AnimState:PlayAnimation("onbuild")
        inst.AnimState:PushAnimation("empty")
    end,

    onhitfn = function (inst, doer)
        inst.AnimState:PlayAnimation("onhit")
        inst.AnimState:PushAnimation(haycartAnim(inst))
    end,
}






local boxs = {
    ["zxhoneyjar"] = honeyjar,
    ["zxlogstore"] = logstore,
    ["zxashcan"]   = ashcan,
    ["zxeggbasket"] = eggbasket,
    ["zx_hay_cart"] = haycart,
    ["zx_granary_veggie"] = granaryveggie,
}

return  boxs