
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})


PrefabFiles = {
	-- "myth_granary",
	"lg_granary",
}


 modimport("scripts/mods/zx_containers.lua")

AddRecipe2(
	"lg_granary",
	{Ingredient("bearger_fur", 1)},
	TECH.SCIENCE_TWO,
	{
		placer = "lg_granary_placer",
        atlas = "images/inventoryimages/lg_granary.xml",
        image = "lg_granary.tex",
    },
	{"STRUCTURES", "CONTAINERS"}
)


