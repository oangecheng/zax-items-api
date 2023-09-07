

AddModRPCHandler(
	"Zx_itemsapi",
	"UseSkin",
	function(player, inst, skinid)
		inst:useskinclient(skinid)
	end
)