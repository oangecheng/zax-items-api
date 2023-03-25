local cooking = require("cooking")
local containers = require "containers"



local default_pos = {
	zx_granary_meat = Vector3(0, 220, 0),
	zx_granary_veggie = Vector3(0, 220, 0),
}


local params = containers.params


params.zx_granary_meat = {
	widget =
    {
        slotpos = {},
        animbank = "ui_zx_5x10",
        animbuild = "ui_zx_5x10",
        pos = default_pos.zx_granary_meat,
        side_align_tip = 160,
    },
    type = "chest",
}
for y = 4, 0, -1 do
	for x = 0, 9 do
		local offsetX = x<=4 and -20 or 10
		table.insert(params.zx_granary_meat.widget.slotpos, Vector3(80 * (x - 5) + 40 + offsetX, 80 * (y - 3) + 80, 0))
	end
end

local meat_types = {
	FOODTYPE.MEAT,
}

local meat_whitelist = {
	"spoiled_food",
	"spoiled_fish",
	"spoiled_fish_small",
	"rottenegg",
}

function params.zx_granary_meat.itemtestfn(container, item, slot)
	if item == nil then return false end
	for _,v in ipairs(meat_types) do
		local tag = "edible_"..v
		if item:HasTag(tag) then 
			return true
		end
	end

	for _,v in ipairs(meat_whitelist) do
		if v == item.prefab then
			return true
		end 
	end
	return false
end


params.zx_granary_veggie = {
	widget =
    {
        slotpos = {},
        animbank = "ui_zx_5x10",
        animbuild = "ui_zx_5x10",
        pos = default_pos.zx_granary_veggie,
        side_align_tip = 160,
    },
    type = "chest",
}
for y = 4, 0, -1 do
	for x = 0, 9 do
		local offsetX = x<=4 and -20 or 10
		table.insert(params.zx_granary_veggie.widget.slotpos, Vector3(80 * (x - 5) + 40 + offsetX, 80 * (y - 3) + 80, 0))
	end
end


local veggie_types = {
	FOODTYPE.VEGGIE,
	FOODTYPE.SEEDS,
	FOODTYPE.GENERIC,
	FOODTYPE.GOODIES,
	FOODTYPE.BERRY,
}

local veggie_whitelist = {
	"spoiled_food",
	"acorn",
}


function params.zx_granary_veggie.itemtestfn(container, item, slot)
	if item == nil then return false end
	for _,v in ipairs(veggie_types) do
		local tag = "edible_"..v
		if item:HasTag(tag) then 
			return true
		end
	end

	for _,v in ipairs(veggie_whitelist) do
		if v == item.prefab then
			return true
		end 
	end
	return false
end


--加入容器
local containers = require "containers"
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
