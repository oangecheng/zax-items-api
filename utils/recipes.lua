
local granary_ingredient

-- 困难
if TUNING.ZX_GRANARY_DIFFICULT == 2 then
    granary_ingredient = {
        Ingredient("bearger_fur", 2),
        Ingredient("gears", 4),
        Ingredient("bluegem", 2),
        Ingredient("boards", 10),
        Ingredient("cutstone", 10),
    }
-- 简单
elseif TUNING.ZX_GRANARY_DIFFICULT == 1 then
    granary_ingredient = {
        Ingredient("gears", 1),
        Ingredient("boards", 5),
        Ingredient("cutstone", 5),
    }
-- 默认
else
    granary_ingredient = {
        Ingredient("bearger_fur", 1),
        Ingredient("gears", 2),
        Ingredient("boards", 5),
        Ingredient("cutstone", 5),
    }
end

-- 肉仓
AddRecipe2(
	"zx_granary_meat",
	granary_ingredient,
	TECH.SCIENCE_TWO,
	{
		placer = "zx_granary_meat_placer",
        atlas = "images/inventoryimages/zx_granary_meat.xml",
        image = "zx_granary_meat.tex",
    },
	{"STRUCTURES", "CONTAINERS"}
)
-- 蔬菜仓
AddRecipe2(
	"zx_granary_veggie",
	granary_ingredient,
	TECH.SCIENCE_TWO,
	{
		placer = "zx_granary_veggie_placer",
        atlas = "images/inventoryimages/zx_granary_veggie.xml",
        image = "zx_granary_veggie.tex",
    },
	{"STRUCTURES", "CONTAINERS"}
)


-- 小雏菊花丛
AddRecipe2(
	"zx_flower_1",
	{Ingredient("butterfly", 2),},
	TECH.SCIENCE_ONE,
	{
		placer = "zx_flower_1_placer",
        atlas = "images/inventoryimages/zx_flower_1.xml",
        image = "zx_flower_1.tex",
        min_spacing = 0,
    },
	{"STRUCTURES", "DECOR"}
)