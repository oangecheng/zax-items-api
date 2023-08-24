
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


-- 干草车
AddRecipe2(
	"zx_hay_cart",
	{Ingredient("boards", 10)},
	TECH.SCIENCE_TWO,
	{
		placer = "zx_hay_cart_placer",
        atlas = "images/inventoryimages/zx_hay_cart.xml",
        image = "zx_hay_cart.tex",
    },
	{"STRUCTURES", "CONTAINERS"}
)

-- 水井
AddRecipe2(
    "zx_well",
    {Ingredient("goldenshovel", 1), Ingredient("cutstone", 5), Ingredient("boards", 2), Ingredient("rope", 1)},
    TECH.SCIENCE_TWO,
    {
        placer = "zx_well_placer",
        atlas = "images/inventoryimages/zx_well.xml",
        image = "zx_well.tex",
    },
    {"GARDENING", "STRUCTURES"}
)




--------------------------------- 下面可以换肤 --------------------------------------


-- 花丛
AddRecipe2(
	"zxflowerbush",
	{Ingredient("butterfly", 2),},
	TECH.SCIENCE_ONE,
	{
		placer = "zxflowerbush_placer",
        atlas = "images/zxskins/zxflowerbush/zxoxalis.xml",
        image = "zxoxalis.tex",
        min_spacing = 0,
    },
	{"STRUCTURES", "DECOR"}
)


-- 垃圾桶
AddRecipe2(
	"zxashcan",
	{Ingredient("butterfly", 2),},
	TECH.SCIENCE_ONE,
	{
		placer = "zxashcan_placer",
        atlas = "images/zxskins/zxashcan/zxashcan.xml",
        image = "zxashcan.tex",
        min_spacing = 0,
    },
	{"STRUCTURES", "DECOR"}
)



-- 花园灯
AddRecipe2(
	"zxlight",
	{Ingredient("fireflies", 1), Ingredient("cutstone", 2), Ingredient("gears", 2), Ingredient("yellowgem", 1)},
	TECH.SCIENCE_TWO,
	{
		placer = "zxlight_placer",
        atlas = "images/zxskins/zxlight/zxgardenlight.xml",
        image = "zxgardenlight.tex",
        min_spacing = 1,
    },
	{"STRUCTURES", "DECOR", "LIGHT"}
)
