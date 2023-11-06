

AddModRPCHandler(
	"Zx_itemsapi",
	"UseSkin",
	function(player, inst, skinid)
		inst:useskinclient(skinid)
	end
)


AddModRPCHandler(
	"Zx_itemsapi",
	"SwitchMode",
	function (_, inst, mode)
		inst:switchMode(mode)
	end
)