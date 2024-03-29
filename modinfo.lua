---@diagnostic disable: lowercase-global
local ch = locale == "zh" or locale == "zhr"

local VERSION = "0.4.5"

-- 名称
name = "建家党狂喜(more items)"


-- 描述
description = ch and

"版本 "..VERSION.."\n"
.."交流&bug反馈群 600710976 \n"
.."团队成员 @浮生 @兔子\n"
.."大版本更新内容:\n"
.."1. 建家党专属法杖切换物品样式，法杖拥有两种风格，自行选择佩戴\n"
.."2. 新增了蜂蜜罐、鸡蛋篮、蘑菇小屋等物品\n"
.."3. 永亮灯可以自己调节颜色，配置方式等同官方蘑菇灯\n"
.."4. 永亮灯可以设置光照范围，默认初始值为5，放满物品为10，放置的物品不会腐烂\n"
.."5. 具备保鲜的箱子兼容勋章，保鲜设置不为永鲜或者返鲜时，可使用不朽宝石升级\n"

or

"version "..VERSION.."\n"
.."team member @浮生 @兔子\n"
.."More items to improve game experience.\n"
.."You can use skin staff change the item's style. \n"
.."Add honey jar, egg basket, mushroom house. \n"



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

configuration_options = {
	
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

	Title(ch and "箱子设置" or "container settings"),
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
		label = ch and "粮仓建造难度" or "difficulty of granary",
		options = {
			{description = ch and "默认" or "default", data = 0},
			{description = ch and "简单" or "esay", data = 1},
			{description = ch and "困难" or "difficult", data = 2},
		},
		default = 0,
	},


	Title(ch and "农场设置" or "farm settings"),
	{
		name = "zxfarmenable",
		label = ch and "启用农场功能" or "enable animal farm",
		options = {
			{description = ch and "启用" or "enable" , data = true},
			{description = ch and "关闭" or "disable", data = false},
		},
		default = true
	},

	{
		name = "zxfarmarea",
		label = ch and "范围设置" or "farm area settings",
		options = {
			{description = ch and "2格地皮" or "2 turfs size", data = 1},
			{description = ch and "3格地皮" or "3 turfs size", data = 1.5},
			{description = ch and "4格地皮" or "4 turfs size", data = 2},
			{description = ch and "5格地皮" or "5 turfs size", data = 2.5},
		},
		default = 1
	},

	{
		name = "zxfarmmaxlv",
		label = ch and "农场等级上限设置" or "farm max level setting",
		options = {
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
		},
		default = 3
	},

	{
		name = "zxfarmdroprate",
		label = ch and "农场物品掉落几率" or "farm items drop ratio",
		options = {
			{ description = ch and "默认" or "default", data = 1 },
			{ description = ch and "低" or "low", data = 0.5 },
			{ description = ch and "高" or "high", data = 2 },
			{ description = ch and "很高" or "super", data = 3 },
		},
		default = 1
	},

	{
		name = "zxperd_size",
		label = ch and "小火鸡尺寸设置" or "farm perd size settings",
		options = {
			{description = ch and "默认" or "default", data = 0.4},
			{description = ch and "小" or "small", data = 0.3},
			{description = ch and "较大" or "big", data = 0.5},
			{description = ch and "大" or "large", data = 0.6},
			{description = ch and "原版" or "origin", data = 1},

		},
		default = 0.4
	},
	{
		name = "zxpigman_size",
		label = ch and "小猪人尺寸设置" or "farm pigman size settings",
		options = {
			{description = ch and "默认" or "default", data = 0.4},
			{description = ch and "小" or "small", data = 0.3},
			{description = ch and "较大" or "big", data = 0.5},
			{description = ch and "大" or "large", data = 0.6},
			{description = ch and "原版" or "origin", data = 1},
		},
		default = 0.4
	},
	{
		name = "zxbeefalo_size",
		label = ch and "小野牛尺寸设置" or "farm beefalo size settings",
		options = {
			{description = ch and "默认" or "default", data = 0.4},
			{description = ch and "小"   or "small"  , data = 0.3},
			{description = ch and "较大" or "big"    , data = 0.5},
			{description = ch and "大"   or "large"  , data = 0.6},
			{description = ch and "原版" or "origin" , data = 1  },

		},
		default = 0.4
	},
	{
		name = "zxgoat_size",
		label = ch and "小山羊尺寸设置" or "farm goat size settings",
		options = {
			{description = ch and "默认" or "default", data = 0.4},
			{description = ch and "小" or "small", data = 0.3},
			{description = ch and "较大" or "big", data = 0.5},
			{description = ch and "大" or "large", data = 0.6},
			{description = ch and "原版" or "origin", data = 1},

		},
		default = 0.4
	},

	{
		name = "zxkoalefant_size",
		label = ch and "考拉象大小设置" or "farm koalefant size settings",
		options = {
			{description = ch and "默认" or "default", data = 0.4},
			{description = ch and "小" or "small", data = 0.3},
			{description = ch and "较大" or "big", data = 0.5},
			{description = ch and "大" or "large", data = 0.6},
			{description = ch and "原版" or "origin", data = 1},

		},
		default = 0.4
	},

	{
		name = "zxcat_size",
		label = ch and "浣猫大小设置" or "cat size settings",
		options = {
			{description = ch and "默认" or "default", data = 1},
			{description = ch and "小" or "small", data = 0.7},
			{description = ch and "较大" or "big", data = 1.2},
			{description = ch and "大" or "large", data = 1.5},

		},
		default = 1
	},



	Title(ch and "永亮灯设置" or "Perpetual light settings"),
	{
		name  = "zxlightradius",
		label = ch and "光照范围" or "light radius",
		options = {
			{description = ch and "较小" or "small", data = 0.5},
			{description = ch and "默认" or "default", data = 1},
			{description = ch and "超大" or "large", data = 2},
		},
		default = 1,
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