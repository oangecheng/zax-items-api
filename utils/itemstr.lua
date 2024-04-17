
local function registerStr(prefabstr, chstrs, enstrs)
    local strs = ZXTUNING.IS_CH and chstrs or enstrs
    STRINGS.NAMES[prefabstr] = strs[1]
    STRINGS.RECIPE_DESC[prefabstr] = strs[2]
    STRINGS.CHARACTERS.GENERIC.DESCRIBE[prefabstr] = strs[3]
end


registerStr(
    "ZX_FLOWER_1",
    { "小雏菊花丛", "漂亮的小花!", "好看!" },
    { "Daisy bushes", "Beautiful flowers", "Nice!" }
)

registerStr(
    "ZX_FLOWER_2",
    { "紫色酢浆草", "漂亮的小花!", "好看!" },
    { "Oxalis", "Beautiful flowers", "Nice!" }
)

registerStr(
    "ZX_FLOWER_3",
    { "绣球花", "漂亮的小花!", "好看!" },
    { "Hydrangea", "Beautiful flowers", "Nice!" }
)


registerStr(
    "BEEBOX_HERMIT",
    { "隐士蜂箱", "寄居蟹奶奶建的蜂箱!", "好多小蜜蜂!"},
    {"BeeBox hermit", "Built by hermit crab grandma!", "So many bees!"}
)


registerStr(
    "MEATRACK_HERMIT",
    {"隐士晾肉架", "寄居蟹奶奶建的!", "挂上肉更好看!"},
    {"Meatrack hermit",  "Built by hermit crab grandma!", "It looks better to hang the meat!"}
)


registerStr(
    "ZX_GRANARY_VEGGIE",
    { "蔬菜仓", "它能存很多蔬菜!", "仓库里面的蔬菜上去很新鲜~" },
    { "Vegetable granary", "It can store a lot of vegetables!", "The vegetables inside are fresh~" }
)


registerStr(
    "ZX_GRANARY_MEAT",
    { "肉仓",  "它能存很多肉！", "新鲜的肉味道就是好!"},
    {"Meat granary", "It can store a lot of meat!", "Fresh meat tastes good!"}
)


registerStr(
    "ZX_HAY_CART",
    {"干草车", "可以放入大量的草和树枝~",  "上面堆满了草"},
    { "Hay cart", "Can store a lot of grass", "Too much grass!"}  
)


registerStr(
    "ZXASHCAN",
    {"垃圾桶", "可以销毁任意的物品", "闻着有点味道!"},
    {"Ashcan", "Destroy any thing", "It smells a little bad!"}
)






