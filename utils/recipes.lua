
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
        atlas = "images/zxskins/zx_granary_meat/zxgranarymeat.xml",
        image = "zxgranarymeat.tex",
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
        atlas = "images/zxskins/zx_granary_veggie/zx_granary_veggie.xml",
        image = "zx_granary_veggie.tex",
    },
	{"STRUCTURES", "CONTAINERS"}
)




--------------------------------- 下面可以换肤 --------------------------------------
-- 法杖
AddRecipe2(
    "zxskintool",
    {Ingredient("twigs", 1),Ingredient("petals", 4)},
    TECH.SCIENCE_ONE,
    {
        atlas="images/zxskins/zxskintool/zxskintool1.xml",
        image="zxskintool1.tex",
    },
    {"TOOLS"}
)


-- 花丛
AddRecipe2(
	"zxflowerbush",
	{Ingredient("butterfly", 2)},
	TECH.SCIENCE_ONE,
	{
		placer = "zxflowerbush_placer",
        atlas = "images/zxskins/zxflowerbush/zxoxalis.xml",
        image = "zxoxalis.tex",
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
        min_spacing = 2,
    },
	{"STRUCTURES", "DECOR", "LIGHT"}
)


-- 垃圾桶
AddRecipe2(
	"zxashcan",
	{Ingredient("boards", 2), Ingredient("goldnugget", 1)},
	TECH.SCIENCE_ONE,
	{
		placer = "zxashcan_placer",
        atlas = "images/zxskins/zxashcan/zxashcan.xml",
        image = "zxashcan.tex",
        min_spacing = 2,
    },
	{"STRUCTURES", "DECOR", "CONTAINERS"}
)


-- 柴房
AddRecipe2(
	"zxlogstore",
	{Ingredient("boards", 5), Ingredient("cutstone", 5)},
	TECH.SCIENCE_TWO,
	{
		placer = "zxlogstore_placer",
        atlas = "images/zxskins/zxlogstore/zxlogstoreforest.xml",
        image = "zxlogstoreforest.tex",
    },
	{"STRUCTURES", "DECOR", "CONTAINERS"}
)


-- 蜜罐
AddRecipe2(
	"zxhoneyjar",
	{Ingredient("boards", 1), Ingredient("cutstone", 5)},
	TECH.SCIENCE_TWO,
	{
		placer = "zxhoneyjar_placer",
        atlas = "images/zxskins/zxhoneyjar/zxhoneyjar1.xml",
        image = "zxhoneyjar1.tex",
        min_spacing = 2,
    },
	{"STRUCTURES", "DECOR", "CONTAINERS"}
)

-- 蛋篮子
AddRecipe2(
	"zxeggbasket",
	{Ingredient("rope", 2), Ingredient("twigs", 10)},
	TECH.SCIENCE_TWO,
	{
		placer = "zxeggbasket_placer",
        atlas = "images/zxskins/zxeggbasket/zxeggbasket1.xml",
        image = "zxeggbasket1.tex",
        min_spacing = 2,
    },
	{"STRUCTURES", "DECOR", "CONTAINERS"}
)


-- 干草车
AddRecipe2(
	"zx_hay_cart",
	{Ingredient("boards", 10)},
	TECH.SCIENCE_TWO,
	{
		placer = "zx_hay_cart_placer",
        atlas = "images/zxskins/zx_hay_cart/zxhaycart1.xml",
        image = "zxhaycart1.tex",
    },
	{"STRUCTURES", "CONTAINERS"}
)


-- 蘑菇房子
AddRecipe2(
	"zxmushroomhouse",
	{Ingredient("boards", 5), Ingredient("red_cap", 1), Ingredient("green_cap", 1), Ingredient("blue_cap", 1)},
	TECH.SCIENCE_TWO,
	{
		placer = "zxmushroomhouse_placer",
        atlas = "images/zxskins/zxmushroomhouse/zxmushroomhouse1.xml",
        image = "zxmushroomhouse1.tex",
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
        atlas = "images/zxskins/zx_well/zx_well.xml",
        image = "zx_well.tex",
    },
    {"GARDENING", "STRUCTURES"}
)




-- 火鸡农场
AddRecipe2(
    "zxperdfarm",
    {Ingredient("boards", 5), Ingredient("dug_berrybush", 1), Ingredient("zxstone", 10, "images/inventoryimages/zxstone.xml")},
    TECH.LOST,
    {
        placer = "zxperdfarm_placer",
        atlas = "images/zxskins/zxperdfarm/zxperdfarm.xml",
        image = "zxperdfarm.tex",
        min_spacing = 2,
    },
    {"GARDENING", "STRUCTURES"}
)


-- 猪人农场
AddRecipe2(
    "zxpigmanfarm",
    {Ingredient("boards", 5), Ingredient("pigskin", 2), Ingredient("zxstone", 10, "images/inventoryimages/zxstone.xml")},
    TECH.LOST,
    {
        placer = "zxpigmanfarm_placer",
        atlas = "images/zxskins/zxpigmanfarm/zxpigmanfarm.xml",
        image = "zxpigmanfarm.tex",
        min_spacing = 2,
    },
    {"GARDENING", "STRUCTURES"}
)

-- 皮弗娄牛农场
AddRecipe2(
    "zxbeefalofarm",
    {Ingredient("boards", 5), Ingredient("horn", 1), Ingredient("zxstone", 10, "images/inventoryimages/zxstone.xml")},
    TECH.LOST,
    {
        placer = "zxbeefalofarm_placer",
        atlas = "images/zxskins/zxbeefalofarm/zxbeefalofarm.xml",
        image = "zxbeefalofarm.tex",
        min_spacing = 2,
    },
    {"GARDENING", "STRUCTURES"}
)


-- 山羊农场
AddRecipe2(
    "zxgoatfarm",
    {Ingredient("boards", 5), Ingredient("lightninggoathorn", 1), Ingredient("zxstone", 10, "images/inventoryimages/zxstone.xml")},
    TECH.LOST,
    {
        placer = "zxgoatfarm_placer",
        atlas = "images/zxskins/zxgoatfarm/zxgoatfarm.xml",
        image = "zxgoatfarm.tex",
        min_spacing = 2,
    },
    {"GARDENING", "STRUCTURES"}
)




-- 孵化器
AddRecipe2(
    "zxfarmhatch",
    {Ingredient("gears", 1), Ingredient("twigs", 5), Ingredient("zxstone", 5, "images/inventoryimages/zxstone.xml") },
    TECH.LOST,
    {
        placer = "zxfarmhatch_placer",
        atlas = "images/zxskins/zxfarmhatch/zxfarmhatch.xml",
        image = "zxfarmhatch.tex",
        min_spacing = 2,
    },
    {"GARDENING", "STRUCTURES"}
)


-- 饲料盆
AddRecipe2(
    "zxfarmbowl",
    {Ingredient("cutstone", 2), Ingredient("zxstone", 3, "images/inventoryimages/zxstone.xml") },
    TECH.LOST,
    {
        placer = "zxfarmbowl_placer",
        atlas = "images/zxskins/zxfarmbowl/zxfarmbowl.xml",
        image = "zxfarmbowl.tex",
        min_spacing = 2,
    },
    {"GARDENING", "STRUCTURES"}
)




-- 通用型饲料
AddRecipe2(
    "zxfarmfood_normal",
    {Ingredient("corn", 2), Ingredient("berries", 2), Ingredient("monstermeat", 1), },
    TECH.SCIENCE_TWO,
    {
        atlas="images/inventoryimages/zxfarmfood_normal.xml",
        image="zxfarmfood_normal.tex",
    },
    {"GARDENING"}
)

