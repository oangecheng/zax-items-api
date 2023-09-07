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
		id = "ZXSTOREPUT",
		str = STRINGS.ZXACTION.ZXSTOREPUT,
		fn = function(act)
            local st = act.target and act.target.components.zxstorable
            if st and act.invobject and act.doer then
                if st:CanStore(act.invobject, act.doer) then
                    st:Store(act.invobject, act.doer)
                    act.invobject:Remove()
                    return true
                end
                
            end
        
            return false
		end,
		state = "give",
	},

    {
        id = "ZXSTORETAKE",
		str = STRINGS.ZXACTION.ZXSTORETAKE,
		fn = function(act)
            local st = act.target.components.zxstorable
            if st then
                if st:CanTake(act.doer) then
                    local item =  st:Take(act.doer)
                    if item then
                        act.doer.components.inventory:GiveItem(item)
                    end
                else
                    return false, "EMPTY"
                end
            end
            return false
		end,
		state = "domediumaction",
    },

    {
        id = "ZXSHOPOPEN",
		str = STRINGS.ZXACTION.ZXSHOPOPEN,
		fn = function(act)
            act.doer:ShowPopUp(POPUPS.ZXSKIN, true, act.invobject)
            return true
		end,
		state = "domediumaction",
    }
}


local componentactions = {
    {
        type = "USEITEM",
		component = "inventoryitem",
		tests = {
			{
				action = "ZXSTOREPUT",
				testfn = function(inst, doer, target, acts, right)
					return doer ~= nil and target and target:HasTag("haha")
				end,
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
                    return doer ~= nil and inst and inst:HasTag("zxskintool")
                end
            }
        }
    },

    {
        type = "SCENE",
		component = "zxstorable",
        tests = {
			{
				action = "ZXSTORETAKE",
				testfn = function(inst, doer, _, _)
					return doer ~= nil
				end,
			},
        },
    }
}


return {
    actions = actions,
    component_actions = componentactions
}