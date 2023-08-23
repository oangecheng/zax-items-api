local cooking = require("cooking")
local containers = require "containers"



---- 容器排序 ----------------

-- 设置容器的位置
local function init5x5BoxSlot(param)
	for y = 4, 0, -1 do
		for x = 0, 4 do
			table.insert(param.widget.slotpos, Vector3(80 * (x - 3) + 80, 80 * (y - 3) + 80, 0))
		end
	end
end


-- 设置容器的位置
local function init5x10BoxSlot(param)
	for y = 4, 0, -1 do
		for x = 0, 9 do
			table.insert(param.widget.slotpos, Vector3(82 * (x - 5) + 40, 80 * (y - 3) + 80, 0))
		end
	end
end


local function compareStr(str1, str2)
    if (str1 == str2) then
        return 0
    end
    if (str1 < str2) then
        return -1
    end
    if (str1 > str2) then
        return 1
    end
end


local function compareFun(a, b)
    if a and b then
        --尝试按照 prefab 名字排序
        local prefab_a = tostring(a.prefab)
        local prefab_b = tostring(b.prefab)
        return compareStr(prefab_a, prefab_b)
    end
end


--插入法排序函数
local function insertSortFun(list, comp)
    for i = 2, #list do
        local v = list[i]
        local j = i - 1
        while (j > 0 and (comp(list[j], v) > 0)) do
            list[j+1] = list[j]
            j = j-1
        end
        list[j+1] = v
    end
end


--容器排序
local function slotsSortFun(inst)
    if inst and inst.components.container then
        --取出容器中的所有物品
        local items = {}
        for k, v in pairs(inst.components.container.slots) do
            local item = inst.components.container:RemoveItemBySlot(k)
            if (item) then
                table.insert(items, item)
            end
        end

        insertSortFun(items, compareFun)

        for i = 1, #items do
            inst.components.container:GiveItem(items[i])
        end
    end
end

--- 箱子整理函数
--- @param inst table 箱子
--- @param doer table 玩家
local function containerSortFn(inst, doer)
	if inst.components.container ~= nil then
		slotsSortFun(inst)
	elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
		SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
	end
end


--- 按钮是否可点击
--- @param inst table 箱子
local function containerSortValidFn(inst)
	return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()--容器不为空
end

-------------------- 容器排序 ---------------


local default_pos = {
	zx_granary_meat = Vector3(0, 220, 0),
	zx_granary_veggie = Vector3(0, 220, 0),
	zx_box = Vector3(0, 220, 0),
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
		buttoninfo = {
			text = "整理",
			position = Vector3(0, -230, 0),
			fn = containerSortFn,
			validfn = containerSortValidFn,
		}
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
		buttoninfo = {
			text = "整理",
			position = Vector3(0, -230, 0),
			fn = containerSortFn,
			validfn = containerSortValidFn,
		}
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


-- 特色容器的大小都是 5x10 的尺寸
local function createBox5x10Param()
	return {
		widget =
		{
			slotpos = {},
			animbank = "ui_zx_5x10",
			animbuild = "ui_zx_5x10",
			pos = default_pos.zx_box,
			side_align_tip = 160,
		},
		type = "chest",
	}
end

local function createBox5x5Param()
	return {
		widget =
		{
			slotpos = {},
			animbank = "ui_zx_5x5",
			animbuild = "ui_zx_5x5",
			pos = default_pos.zx_box,
			side_align_tip = 160,
		},
		type = "chest",
	}
end


--- 干草车只能放草
params.zx_hay_cart = createBox5x10Param()
init5x10BoxSlot(params.zx_hay_cart)
function params.zx_hay_cart.itemtestfn(container, item, slot)
	if item.prefab == "cutgrass" then return true end
	return false
end



--- 垃圾桶
params.zxashcan =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(params.zxashcan.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end







--加入容器
local containers = require "containers"
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end



--兼容show me的绿色索引，代码参考自风铃草大佬的穹妹--------
--我是参考的勋章，哈哈----
local zx_containers= {
	"zx_granary_meat",
	"zx_granary_veggie",
}
--如果他优先级比我高 这一段生效
for k,mod in pairs(ModManager.mods) do 
	if mod and mod.SHOWME_STRINGS then      
		if mod.postinitfns and mod.postinitfns.PrefabPostInit and mod.postinitfns.PrefabPostInit.treasurechest then     --是的 箱子的寻物已经加上去了
			for _, v in ipairs(zx_containers) do
				mod.postinitfns.PrefabPostInit[v] = mod.postinitfns.PrefabPostInit.treasurechest
			end
		end
	end
end
--如果他优先级比我低 那下面这一段生效
TUNING.MONITOR_CHESTS = TUNING.MONITOR_CHESTS or {}
for _, v in ipairs(zx_containers) do
	TUNING.MONITOR_CHESTS[v] = true
end
