---@diagnostic disable: lowercase-global
local ch = locale == "zh" or locale == "zhr"

local VERSION = "0.3.0.6"

-- 名称
name = "建家党狂喜(more items)"
-- 描述
description = 
ch and 
[[
	版本 0.3.0.5
	交流&bug反馈群 600710976                
	一些额外的物品，提升游戏体验,
	你可以建造一些物品来装饰自己的基地，
	肉仓/蔬菜仓
	寄居蟹晾肉架
	小雏菊花丛
	寄居蟹蜂箱
	紫色酢浆草
	花园灯
	绣球花
	花园水井
	干草车
	垃圾桶
	支持使用魔法扫帚给物品换肤
	持续更新中...
]]
or 
[[
	version 0.3.0.5                       
	more items to improve game experience，
	You can build items to decorate your base.
	Meat and Veggie Granary
	Meatrack hermit
	Daisy bushes
	Beebox hermit
	Oxalis
	Perpetual Lamp (4 skin)
	Hydrangea
	Garden Well
	Hay cart
	ashcan
	support change skin
	Continuous updates...
]]


author = "Zax"
version = VERSION
forumthread = ""
icon_atlas = "modicon.xml"
icon = "modicon.tex"
dst_compatible = true
client_only_mod = false
all_clients_require_mod = true
api_version = 10


local function Title(name)
	return {
		name = name,
		label = name,
		options = { {description = "", data = false}, },
		default = false,
	}
end

configuration_options = 
{
	Title(ch and "基础设置" or "base settings"),
	{
		name = "zx_items_language",
		label = ch and "选择语言" or "select language",
		options = {
			{description = ch and "中文" or "Chinese", data = "ch"},
			{description = ch and "英文" or "English", data = "eng"},
		},
		default = "ch",
	},
	{
		name = "zxshowshopentry",
		label = ch and "关闭面板入口" or "close panel entry",
		options = {
			{description = ch and "关闭" or "close", data = false},
			{description = ch and "打开" or "open",  data = true},
		},
		default = false,
	},
	
	Title(ch and "粮仓设置" or "granary settings"),
	{
		name = "zx_granary_freshrate",
		label = ch and "保鲜设置" or "keep freshness settings",
		options = {
			{description = ch and "正常(冰箱)" or "normal(icebox)", data = 0.5},
			{description = ch and "缓慢" or "slow", data = 0.3},
			{description = ch and "默认" or "default", data = 0.2},
			{description = ch and "永久" or "always fresh", data = 0},
			{description = ch and "返鲜" or "fresh back", data = -1},
		},
		default = 0.2,
	},
	{
		name = "zx_granary_difficult",
		label = ch and "建造难度" or "difficulty of construction",
		options = {
			{description = ch and "默认" or "default", data = 0},
			{description = ch and "简单" or "esay", data = 1},
			{description = ch and "困难" or "difficult", data = 2},
		},
		default = 0,
	},

	Title(ch and "其他物品" or "other items"),
	{
		name = "zx_meatrack",
		label = ch and "老奶奶晾肉架" or "meatrack hermit",
		options = {
			{description = ch and "允许建造" or "enable", data = true},
			{description = ch and "禁止建造" or "disable", data = false},
		},
		default = true,
	},
	{
		name = "zx_beebox",
		label = ch and "老奶奶蜂箱" or "beebox hermit",
		options = {
			{description = ch and "允许建造" or "enable", data = true},
			{description = ch and "禁止建造" or "disable", data = false},
		},
		default = true,
	}

} 