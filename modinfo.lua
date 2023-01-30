local ch = locale == "zh" or locale == "zhr"

local VERSION = "0.1.0"

-- 名称
name = ch and "建家党狂喜" or "more items"
-- 描述
description = 
ch and 
"version" .. VERSION .. [[
	一些额外的物品，提升游戏体验
]]
or 
"version" .. VERSION .. [[
	more items to improve game experience
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


configuration_options = 
{
	{
		name = "zx_granary",
		label = ch and "建造仓库" or "build granary",
		options = {
			{description = ch and "开启" or "enable", data = true},
			{description = ch and "关闭" or "disable", data = false},
		},
		default = true,
	}
} 