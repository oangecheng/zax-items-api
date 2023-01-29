


PrefabFiles = {
	"myth_granary"
}


modimport("scripts/mods/zx_containers.lua")



local Recipes = { 

	{
        name = "zx_granary",
        ingredients = {
            {
				Ingredient("bearger_fur", 1), Ingredient("boards", 5),Ingredient("bundlewrap", 8),MedalIngredient("immortal_essence", 6),
			},
			{
				Ingredient("bearger_fur", 1), Ingredient("boards", 3),Ingredient("bundlewrap", 4),MedalIngredient("immortal_essence", 3),
			},
        },
        level = TECH.LOST,
		placer = "zx_granary_placer", 
		no_deconstruction = true,
		min_spacing = 1.5,
		filters = {"STRUCTURES","CONTAINERS"},
    }
}

AddRecipe2(
	"myth_granary",
	{Ingredient("bearger_fur", 1)},
	TECH.SCIENCE_TWO,
	{
		placer = "myth_granary_placer",
        atlas = "images/myth_granary.xml",
        image = "myth_granary.tex",
    },
	{"STRUCTURES", "CONTAINERS"}
)


