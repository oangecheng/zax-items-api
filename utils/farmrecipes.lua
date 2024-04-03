
local function zxStone(num)
    return Ingredient("zxstone", num, "images/inventoryimages/zxstone.xml")
end

local function getFarmIngredients(extras)
    return JoinArrays(
        { Ingredient("livinglog", 5), zxStone(10) },
        extras
    )
end


local function addStructureRecipe(isfarm, structure, extras)
    local ingredients = isfarm and getFarmIngredients(extras) or extras
    local tabs = { "GARDENING", "STRUCTURES" }
    local placedata = {
        placer = structure .. "_placer",
        atlas  = "images/zxskins/" .. structure .. "/" .. structure .. ".xml",
        image  = structure .. ".tex"
    }
    AddRecipe2(
        structure, 
        ingredients, 
        TECH.LOST, 
        placedata, 
        tabs
    )
end


local function addFarmRecipe(structure, extras)
    addStructureRecipe(true, structure, extras)
end


local function addItemRecipe(structure, extras)
    addStructureRecipe(false, structure, extras)
end

--- 农场
addFarmRecipe("zxperdfarm"     , { Ingredient("dug_berrybush", 1) })
addFarmRecipe("zxpigmanfarm"   , { Ingredient("pigskin", 2) })
addFarmRecipe("zxbeefalofarm"  , { Ingredient("horn", 1) })
addFarmRecipe("zxgoatfarm"     , { Ingredient("lightninggoathorn", 1) })
addFarmRecipe("zxcatfarm"      , { Ingredient("coontail", 2) })
addFarmRecipe("zxkoalefantfarm", { Ingredient("trunk_winter", 1) })
addFarmRecipe("zxhoundfarm"    , { Ingredient("houndstooth", 10), Ingredient("redgem", 1), Ingredient("bluegem", 1) })
addFarmRecipe("zxspiderfarm"   , { Ingredient("spidereggsack", 1) })
addFarmRecipe("zxtallbirdfarm" , { Ingredient("tallbirdegg", 1) })
--- 农场建筑
addItemRecipe("zxfarmbowl"     , { Ingredient("cutstone", 2), zxStone(3) })
addItemRecipe("zxfarmhatch"    , { Ingredient("gears", 1), Ingredient("twigs", 5), zxStone(5) })

-- 通用型饲料
AddRecipe2(
    "zxfarmfood_normal",
    { Ingredient("corn", 2), Ingredient("berries", 2), Ingredient("monstermeat", 1), },
    TECH.SCIENCE_TWO,
    {
        atlas = "images/inventoryimages/zxfarmfood_normal.xml",
        image = "zxfarmfood_normal.tex",
    },
    { "GARDENING" }
)
