local function registerStr(prefabstr, chstrs, enstrs)
    local strs = ZXTUNING.IS_CH and chstrs or enstrs
    STRINGS.NAMES[prefabstr] = strs[1]
    STRINGS.RECIPE_DESC[prefabstr] = strs[2]
    STRINGS.CHARACTERS.GENERIC.DESCRIBE[prefabstr] = strs[3]
end


------------------------------ 废弃物品  ------------------------------
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
    "ZX_LIGHT_1",
    { "花园灯", "", "" },
    { "Garden Lamp", "", "" }
)
------------------------------ 废弃物品  ------------------------------




registerStr(
    "BEEBOX_HERMIT",
    { "隐士蜂箱", "寄居蟹奶奶建的蜂箱!", "好多小蜜蜂!" },
    { "BeeBox hermit", "Built by hermit crab grandma!", "So many bees!" }
)


registerStr(
    "MEATRACK_HERMIT",
    { "隐士晾肉架", "寄居蟹奶奶建的!", "挂上肉更好看!" },
    { "Meatrack hermit", "Built by hermit crab grandma!", "It looks better to hang the meat!" }
)


registerStr(
    "ZX_GRANARY_VEGGIE",
    { "蔬菜仓", "它能存很多蔬菜!", "仓库里面的蔬菜上去很新鲜~" },
    { "Vegetable granary", "It can store a lot of vegetables!", "The vegetables inside are fresh~" }
)


registerStr(
    "ZX_GRANARY_MEAT",
    { "肉仓", "它能存很多肉！", "新鲜的肉味道就是好!" },
    { "Meat granary", "It can store a lot of meat!", "Fresh meat tastes good!" }
)


registerStr(
    "ZX_HAY_CART",
    { "干草车", "可以放入大量的草和树枝~", "上面堆满了草" },
    { "Hay cart", "Can store a lot of grass", "Too much grass!" }
)


registerStr(
    "ZXASHCAN",
    { "垃圾桶", "可以销毁任意的物品", "闻着有点味道!" },
    { "Ashcan", "Destroy any thing", "It smells a little bad!" }
)


registerStr(
    "ZX_WELL",
    { "花园水井", "用不完的水!", "这下种地方便多了!" },
    { "Garden Well", "A lot of water!", "Farming is much more convenient now!" }
)


registerStr(
    "ZXSKINTOOL",
    { "建家魔法杖", "多种功能的法杖!", "这下方便多了!" },
    { "Skin staff", "Change the style of mod items!", "It's amazing!" }
)


registerStr(
    "ZXFLOWERBUSH",
    { "花丛", "可以更换皮肤的花丛!", "这下方便多了!" },
    { "Flowerbush", "Flowers that can be replaced with skin!", "This is so much easier!" }
)


registerStr(
    "ZXLIGHT",
    { "永亮灯", "晚上自动打开的灯!", "见鬼去吧，查理!" },
    { "Perpetual light", "Lights that turn on automatically at night!", "Go to hell, Charlie!" }
)


registerStr(
    "ZXLOGSTORE",
    { "柴房", "存放木材的地方!", "里面堆满了柴火!" },
    { "Log house", "store logs!", "a lot of logs!" }
)


registerStr(
    "ZXHONEYJAR",
    { "蜜罐", "存放蜂蜜的陶罐!", "熊大应该很喜欢!" },
    { "Honey jar", "can store honey!", "bear may like it!" }
)


registerStr(
    "ZXEGGBASKET",
    { "蛋篮子", "存放蛋类的小竹篮!", "小竹篮!" },
    { "Egg basket", "a basket can store eggs!", "cute basket!" }
)


registerStr(
    "ZXMUSHROOMHOUSE",
    { "蘑菇小屋", "可以存放各种蘑菇!", "漂亮的小房子!" },
    { "Mushroom house", "can store a lot of mushroom!", "beautiful house!" }
)


registerStr(
    "ZXBOXSTONE",
    { "矿洞", "存放各种矿物!", "鼹鼠应该很喜欢!" },
    { "Mine cave", "Store all kinds of minerals!", "The mole will love it!" }
)


registerStr(
    "ZXSTONE",
    { "建家石", "", "一种神奇的建筑材料~" },
    { "Home building stone", "", "a magical building materials ~" }
)

registerStr(
    "ZXBOXTOY",
    { "玩具箱", "", "存放各种玩具" },
    { "Toy box", "", "Store toys!" }
)
