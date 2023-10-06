local cooking = require("cooking")
local containers = require "containers"


local default_pos = Vector3(0, 220, 0)


-- 特色容器的大小都是 5x10 的尺寸
local function createBox5x10Param(anim, slotbg)
	local p = {
		widget =
		{
			slotpos = {},
			animbank = anim and anim or "ui_zx_5x10",
			animbuild = anim and anim or "ui_zx_5x10",
			pos = default_pos,
			side_align_tip = 160,
		},
		type = "chest",
	}

	for y = 4, 0, -1 do
		for x = 0, 9 do
			local offsetX = x<=4 and -20 or 10
			table.insert(p.widget.slotpos, Vector3(80 * (x - 5) + 40 + offsetX, 80 * (y - 3) + 80, 0))
			if slotbg then
				table.insert(p.widget.slotbg, slotbg)
			end
		end
	end

	return p;
end

local function createBox5x5Param(anim, slotbg)
	local p =  {
		widget =
		{
			slotpos = {},
			slotbg = slotbg and {} or nil,
			animbank = anim and anim or "zx5x5_normal",
			animbuild = anim and anim or "zx5x5_normal",
			pos = default_pos,
			side_align_tip = 160,
		},
		type = "chest",
	}

	for y = 4, 0, -1 do
		for x = 0, 4 do
			table.insert(p.widget.slotpos, Vector3(80 * (x - 3) + 80, 80 * (y - 3) + 80, 0))
			if slotbg then
				table.insert(p.widget.slotbg, slotbg)
			end
		end
	end

	return p
end



local function creatBox3x3Param(anim, slotbg)
	local p = {
		widget =
		{
			slotpos = {},
			animbank = "ui_chest_3x3",
			animbuild = "ui_chest_3x3",
			pos = default_pos,
			side_align_tip = 160,
		},
		type = "chest",
	}
	for y = 2, 0, -1 do
		for x = 0, 2 do
			table.insert(p.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
			if slotbg then
				table.insert(p.widget.slotbg, slotbg)
			end
		end
	end
	return p
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





---------------------------------  以下是各种容器的定义 ----------------------------------------------
local params = containers.params



------------------- 肉仓 ------------------
params.zx_granary_meat = createBox5x10Param()
params.zx_granary_meat.widget.buttoninfo = {
	text = "整理",
	position = Vector3(0, -230, 0),
	fn = containerSortFn,
	validfn = containerSortValidFn,
}

local meat_types = { FOODTYPE.MEAT,}
local meat_whitelist = {"spoiled_food","spoiled_fish","spoiled_fish_small","rottenegg",}
params.zx_granary_meat.itemtestfn = function(container, item, slot)
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



------------------- 菜仓 ------------------
params.zx_granary_veggie = createBox5x10Param()
params.zx_granary_veggie.widget.buttoninfo = {
	text = "整理",
	position = Vector3(0, -230, 0),
	fn = containerSortFn,
	validfn = containerSortValidFn,
}

local veggie_types = { FOODTYPE.VEGGIE, FOODTYPE.SEEDS, FOODTYPE.GENERIC, FOODTYPE.GOODIES, FOODTYPE.BERRY}
local veggie_whitelist = { "spoiled_food", "acorn",}
params.zx_granary_veggie.itemtestfn= function(container, item, slot)
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



------------------- 永亮灯 ------------------
params.zxlight = {
    widget = {
        slotpos = {
            Vector3(0, 64 + 32 + 8 + 4, 0),
            Vector3(0, 32 + 4, 0),
            Vector3(0, -(32 + 4), 0),
            Vector3(0, -(64 + 32 + 8 + 4), 0),
        },
        animbank = "ui_lamp_1x4",
        animbuild = "ui_lamp_1x4",
        pos = Vector3(200, 0, 0),
        side_align_tip = 100,
    },
    acceptsstacks = false,
    type = "cooker",
}

params.zxlight.itemtestfn = function(container, item, slot)
    return (item:HasTag("lightbattery") or item:HasTag("lightcontainer") or item:HasTag("spore")) and not container.inst:HasTag("burnt")
end



------------------- 干草车 ------------------
params.zx_hay_cart = createBox5x10Param()
--- 草、芦苇
local grassdef = { "cutgrass", "cutreeds" }
function params.zx_hay_cart.itemtestfn(container, item, slot)
	---@diagnostic disable-next-line: undefined-field
	return table.contains(grassdef, item.prefab)
end



------------------- 柴房 ------------------
params.zxlogstore = createBox5x10Param()
local logsdef = { "livinglog", "twigs", "log", "boards", "driftwood_log", "pinecone", "charcoal"}
function params.zxlogstore.itemtestfn(container, item, slot)
	---@diagnostic disable-next-line: undefined-field
	if table.contains(logsdef, item.prefab) then return true end
	return false
end



------------------- 蜂蜜蜜罐 ------------------
local honeyslotbg = { image = "zx_slotbg_honey.tex", atlas = "images/zx_slotbg_honey.xml" }
params.zxhoneyjar = createBox5x5Param("zx5x5_honey", honeyslotbg)
local huneydefs = { "medal_withered_royaljelly", "royal_jelly", "honey" }
function params.zxhoneyjar.itemtestfn(container, item, slot)
	---@diagnostic disable-next-line: undefined-field
	return table.contains(huneydefs, item.prefab)
end



------------------- 垃圾桶 ------------------
params.zxashcan = creatBox3x3Param()
params.zxashcan.widget.buttoninfo = {
	text = STRINGS.ZXDESTROY,
	position = Vector3(0, -140, 0),
	fn = function (inst, doer)
		if inst.components.container ~= nil then
			inst.btnfn(inst, doer)
		elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
			SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
		end
	end,
}



------------------- 蛋篮子 ------------------
params.zxeggbasket = createBox5x5Param()
local eggbasketdef = { "bird_egg", "rottenegg", "tallbirdegg" }
function params.zxeggbasket.itemtestfn(container, item, slot)
	---@diagnostic disable-next-line: undefined-field
	return table.contains(eggbasketdef, item.prefab)
end



------------------- 蘑菇房子 ------------------
params.zxmushroomhouse = createBox5x5Param()
local mushroomdef = {"red_cap_cooked", "green_cap_cooked", "blue_cap_cooked", "moon_cap_cooked" }
function params.zxmushroomhouse.itemtestfn(container, item, slot)
	---@diagnostic disable-next-line: undefined-field
	return table.contains(mushroomdef, item.prefab) or item:HasTag("spore") or item:HasTag("mushroom") or item:HasTag("medal_spore")
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
		if mod.postinitfns and mod.postinitfns.PrefabPostInit and mod.postinitfns.PrefabPostInit.treasurechest then
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
