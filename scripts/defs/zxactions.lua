local ITEMS = require "defs/zxitemdefs"


--移除预制物(预制物,数量)
local function removeItem(item,num)
	if item.components.stackable then
		item.components.stackable:Get(num):Remove()
	else
		item:Remove()
	end
end


local actions = {

    {
        id = "ZXSHOPOPEN",
		str = STRINGS.ZXACTION.ZXSHOPOPEN,
		fn = function(act)
            act.doer:ShowPopUp(POPUPS.ZXTOOL, true, act.invobject)
            return true
		end,
		state = "give",
    },

    {
        id = "ZXHATCH",
        str = STRINGS.ZXACTION.ZXHATCH,
        fn = function (act)
            if act.target and act.invobject then
                if not ZxFarmHasHost(act.target) then
                    return false, "NO_HOST"
                end
                if not ZXFarmHasFeeder(act.target) then
                    return false, "NO_FEEDER"
                end

                if ZxFarmIsFull(act.target) then
                    return false, "NO_SPACE"
                end

                local hatcher = act.target.components.zxhatcher
                if hatcher then
                    if hatcher:IsWorking() then
                        return false, "BUSY"
                    end
                    if hatcher:CanHatch(act.invobject, act.doer) then
                        hatcher:Hatch(act.invobject, act.doer)
                        return true
                    end
                end
            end
            return false
        end,
        state = "dolongaction",
    },

    {
        id = "ZXADDFOOD",
        str = STRINGS.ZXACTION.ZXADDFOOD,
        fn = function (act)
            local feeder = act.target.components.zxfeeder
            if act.doer and act.invobject and feeder then
                if feeder:IsFull() then
                    return false, "FULL"
                end
                if feeder:CanGiveFood(act.invobject, act.doer)  then
                    feeder:GiveFood(act.invobject, act.doer)
                    return true
                end
            end
            return false
        end,
        state = "domediumaction",
    },

    {
        id = "ZXFARMHARVEST",
        str = STRINGS.ZXACTION.ZXFARMHARVEST,
        state = "dolongaction",
        fn = function (act)
            local farm = act.target and act.target.components.zxfarm or nil
            if farm and act.doer and farm:Harvest(act.doer) then
                return true
            end
            return false, "EMPTY"
        end,
    },

    {
        id  = "ZXUPGRADE",
        str = STRINGS.ZXACTION.UPGRADE,
        state = "dolongaction",
        fn  =  function (act)
            local up = act.target and act.target.components.zxupgradable
            if up and act.invobject then
                if up:IsMax() then
                    return false, "MAX"
                elseif not up:IsValidMaterial(act.invobject) then
                    return false, "INVALID_ITEM"
                else
                    up:Upgrade()
                    removeItem(act.invobject)
                    return true
                end
            end
            return false
        end,
    },

    {
        id = "ZXACCELERATE",
        str = STRINGS.ZXACTION.ACCELERATE,
        state = "domediumaction",
        fn = function (act)
            local acc = act.target and act.target.components.zxaccelerate
            -- 先按固定时间加速
            if acc and act.invobject then
                local time = ITEMS.accelerate[act.invobject.prefab] or 0
                acc:Start(time)
                removeItem(act.invobject)
                return true
            end
            return false
        end
    }
}


local componentactions = {
    {
        type = "USEITEM",
		component = "inventoryitem",
		tests = {

            {
                action = "ZXHATCH",
                testfn = function(inst, doer, target, acts, right)
                    return doer and target:HasTag("ZXHATCHER")
                end
            },

            {
                action = "ZXADDFOOD",
                testfn = function (inst, doer, target, acts, right)
                    return doer and target:HasTag("ZXFEEDER") and inst:HasTag("ZXFARM_FOOD")
                end
            },

            {
                action = "ZXUPGRADE",
                testfn = function (inst, doer, target, acts, right)
                    return target:HasTag("ZXUPGRADE") and inst:HasTag("ZXUPGRADE_MATERIAL")
                end
            },

            {
                action = "ZXACCELERATE",
                testfn = function (inst, doer, target, acts, right)
                    return target:HasTag("ZXACCELERATE") and inst:HasTag("ZXACCELERATE_MATERIAL")
                end
            },


        },
    },

    {
        type = "INVENTORY",
        component = "inventoryitem",
        tests = {
            {
                action = "ZXSHOPOPEN",
                testfn = function(inst,doer,actions,right)
                    return doer ~= nil and inst and inst:HasTag("zxshop")
                end
            }, 
        }
    },

    {
        type = "SCENE",
		component = "zxfarm",
        tests = {
			{
				action = "ZXFARMHARVEST",
				testfn = function(inst, doer, _, _)
					return doer ~= nil and inst:HasTag("ZXFARM_HOST")
				end,
			},
        },
    }
}


return {
    actions = actions,
    component_actions = componentactions
}