
local default_pos = {
	myth_granary = Vector3(0, 220, 0),
	lg_granary = Vector3(0, 220, 0),
}


local params = {}


params.myth_granary = {
    widget =
	{
		slotpos = {},
		animbank = "ui_chester_shadow_3x4",
		animbuild = "ui_chester_shadow_3x4",
		pos = default_pos.myth_granary,
		side_align_tip = 160,
	},
	type = "chest",
}
for y = 2.5, -0.5, -1 do
	for x = 0, 2 do
		table.insert(params.myth_granary.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
	end
end


params.lg_granary = {
	widget =
    {
        slotpos = {},
        animbank = "ui_fish_box_3x4",
        animbuild = "ui_lg_granary_4x4",
        pos = default_pos.lg_granary,
        side_align_tip = 160,
    },
    type = "chest",
}
for y = 2.5, -0.5, -1 do
    for x = -0.5, 2.5 do
        table.insert(params.lg_granary.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end


--加入容器
local containers = require "containers"
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local containers_widgetsetup = containers.widgetsetup

function containers.widgetsetup(container, prefab, data)
    local t = data or params[prefab or container.inst.prefab]
    if t~=nil then
        for k, v in pairs(t) do
			container[k] = v
		end
		container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    else
        return containers_widgetsetup(container, prefab, data)
    end
end