local SKIN_DIR = "images/zxskins/"
local ITEM_DIR = "images/inventoryimages/"

local BOX_FILTER = { "STRUCTURES", "CONTAINERS" }
local STRUCTURE_EXTRA  = { structure = true }


local function getIngredients(ingredients)
    local ret = {}
    for k, v in pairs(ingredients) do
        table.insert(ret, Ingredient(k, v))
    end
    return ret
end


local function getData(prefab, file, skinable, extra)
    local dir = (skinable and SKIN_DIR or ITEM_DIR)
    if skinable then
        dir = dir..prefab.."/"
    end
    local data = {
        atlas = (file and dir..file or dir..prefab)..".xml",
        image = (file or prefab)..".tex"
    }

    if extra and extra.structure then
        data.placer = prefab.."_placer"
        data.min_spacing = extra.min_spacing
    end

    return data
end

---comment
---@param prefab string
---@param ingredients table
---@param tech number
---@param file string|nil
---@param filter table
---@param extra any
local function addSkinRecipe(prefab, ingredients, tech, file, filter, extra)
    AddRecipe2(
        prefab, getIngredients(ingredients), tech,
        getData(prefab, file, true, extra),
        filter
    )
end

---comment
---@param prefab string
---@param ingredients table
---@param tech number
---@param file string|nil
---@param filter table
---@param extra any
local function addNormalRecipe(prefab, ingredients, tech, file, filter, extra)
    AddRecipe2(
        prefab, getIngredients(ingredients), tech,
        getData(prefab, file, false, extra),
        filter
    )
end


--- 法杖
addSkinRecipe(
    "zxskintool",
    { twigs = 1, petals = 4 },
    TECH.SCIENCE_ONE, 
    "zxskintool1", 
     { "TOOLS" }
)


--- 菜仓
addSkinRecipe(
    "zx_granary_veggie",
    {  bearger_fur = 1,  gears = 2, boards =  5, cutstone = 5 },
    TECH.SCIENCE_TWO,
    nil,
    BOX_FILTER,
    STRUCTURE_EXTRA
)


--- 肉仓
addSkinRecipe(
    "zx_granary_meat",
    {  bearger_fur = 1,  gears = 2, boards =  5, cutstone = 5 },
    TECH.SCIENCE_TWO,
    "zxgranarymeat",
    BOX_FILTER,
    STRUCTURE_EXTRA
)


--- 花丛
addSkinRecipe(
    "zxflowerbush",
    { butterfly = 2 },
    TECH.SCIENCE_ONE,
    "zxoxalis",
    { "STRUCTURES", "DECOR" },
    { structure = true, min_spacing = 0 }
)


--- 永亮灯
addSkinRecipe(
    "zxlight",
    { fireflies = 1, cutstone = 2, gears = 2, yellowgem = 1 },
    TECH.SCIENCE_TWO,
    "zxgardenlight",
    { "STRUCTURES", "DECOR", "LIGHT" },
    STRUCTURE_EXTRA
)

--- 垃圾桶
addSkinRecipe(
    "zxashcan",
    { boards = 2, goldnugget = 1 },
    TECH.SCIENCE_ONE,
    nil,
    BOX_FILTER,
    STRUCTURE_EXTRA
)


-- 柴房
addSkinRecipe(
    "zxlogstore",
    { boards = 5, cutstone = 5 },
    TECH.SCIENCE_TWO,
    "zxlogstoreforest",
    BOX_FILTER,
    STRUCTURE_EXTRA
)


-- 蜂蜜罐子
addSkinRecipe(
    "zxhoneyjar",
    { boards = 1, cutstone = 5 },
    TECH.SCIENCE_TWO,
    "zxhoneyjar1",
    BOX_FILTER,
    STRUCTURE_EXTRA
)


--- 鸡蛋篮子
addSkinRecipe(
    "zxeggbasket",
    { rope = 2, twigs = 10 },
    TECH.SCIENCE_TWO,
    "zxeggbasket1",
    BOX_FILTER,
    STRUCTURE_EXTRA
)


--- 草车
addSkinRecipe(
    "zx_hay_cart",
    { boards = 10 },
    TECH.SCIENCE_TWO,
    "zxhaycart1",
    BOX_FILTER,
    STRUCTURE_EXTRA
)


--- 蘑菇房
addSkinRecipe(
    "zxmushroomhouse",
    { boards = 5, red_cap = 1, green_cap = 1, blue_cap = 1 },
    TECH.SCIENCE_TWO,
    "zxmushroomhouse1",
    BOX_FILTER,
    STRUCTURE_EXTRA
)


--- 玩具箱
addSkinRecipe(
    "zxboxtoy",
    { boards = 10 },
    TECH.SCIENCE_TWO,
    nil,
    BOX_FILTER,
    STRUCTURE_EXTRA
)


--- 矿井
addSkinRecipe(
    "zxboxstone",
    { goldenpickaxe = 1, boards = 2, cutstone = 5, pinecone = 2 },
    TECH.SCIENCE_TWO,
    nil,
    BOX_FILTER,
    STRUCTURE_EXTRA
)


--- 水井
addSkinRecipe(
    "zx_well",
    { goldenshovel = 1, boards = 2, cutstone = 5, rope = 2 },
    TECH.SCIENCE_TWO,
    nil,
    { "GARDENING", "STRUCTURES" },
    STRUCTURE_EXTRA
)


--- 建家石
addNormalRecipe(
    "zxstone",
    { goldnugget = 2, rocks = 1 },
    TECH.SCIENCE_TWO,
    nil,
    { "REFINE" }
)