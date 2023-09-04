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
            act.target.components.zxstorable:Store(act.invobject, act.doer)
            removeItem(act.invobject)
            return true
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
    }
}


local componentactions = {
    {
        type = "USEITEM",
		component = "zxstorable",
		tests = {
			{
				action = "ZXSTOREPUT",
				testfn = function(inst, doer, target, _, _)
                    local st = target.components.zxstorable
					return doer and st and st:CanStore(inst, doer)
				end,
			},
        },
    },

    {
        type = "SCENE",
		component = "zxstorable",
        tests = {
			{
				action = "ZXSTORETAKE",
				testfn = function(inst, doer, target, _, _)
					return doer and target.components.zxstorable
				end,
			},
        },
    }
}


return {
    actions = actions,
    component_actions = componentactions
}