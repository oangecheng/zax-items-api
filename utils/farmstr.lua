local isch = ZXTUNING.IS_CH

local SOUL_DESC_1 = isch and "它好像能够孕育出一只 %s" or "It seems to be able to give birth to a %s"
local SOUL_DESC_2 = isch and "放入%s的孵化器会有神奇的事情发生" or "Put it in an incubator on a %s and magical things will happen"
local FARM_DESC_1 = isch and "%s们的乐园" or "A paradise for %s"


local ANIMAL_STRS = isch and {
    ZXPERD           = { "小火鸡", "它会打篮球吗?" },
    ZXPIGMAN         = { "小猪人", "你是好人!" },
    ZXBEEFALO        = { "小野牛", "勇敢牛牛，不怕困难!" },
    ZXGOAT           = { "小山羊", "别看我只是一只羊~" },
    ZXKOALEFANT      = { "考拉象", "小飞象来咯!" },
    ZXKOALEFANT_S    = { "小红象", "小飞象来咯!" },
    ZXKOALEFANT_W    = { "小蓝象", "小飞象来咯!" },
    ZXCAT            = { "小浣猫", "喵星萌物!" },
    ZXHOUND          = { "小猎犬", "温顺的汪星人!" },
    ZXHOUND_FIRE     = { "小红犬", "温顺的红色汪星人!" },
    ZXHOUND_ICE      = { "小蓝犬", "温顺的蓝色汪星人!" },
    ZXSPIDER         = { "小蜘蛛", "蜘蛛也变得友善了！" },
    ZXSPIDER_WARRIOR = { "小绿蛛", "再蹦一个瞧瞧?" },
    ZXSPIDER_DROPPER = { "小白蛛", "它应该很爱干净!" },
    ZXSPIDER_HEALER  = { "小花蛛", "花花的皮毛真靓！" },
    ZXTALLBIRD       = { "小高鸟", "还是小小的可爱~" },
} or {
    ZXPERD           = { "Cute Perd", "Does it play basketball?" },
    ZXPIGMAN         = { "Cute Pigman", "You're a good person!" },
    ZXBEEFALO        = { "Cute Beefalo", "Brave Bull, never fear difficulties!" },
    ZXGOAT           = { "Cute Goat", "Don't judge me just because I'm a sheep~" },
    ZXKOALEFANT      = { "Koalefant", "Dumbo is coming!" },
    ZXKOALEFANT_S    = { "Cute Summer Koalefant", "Dumbo is coming!" },
    ZXKOALEFANT_W    = { "Cute Winter Koalefant", "Dumbo is coming!" },
    ZXCAT            = { "Cute Cat", "So cute!" },
    ZXHOUND          = { "Cute Hound", "Gentle Hound!" },
    ZXHOUND_FIRE     = { "Cute Fire Hound", "Gentle Hound!" },
    ZXHOUND_ICE      = { "Cute Ice Hound", "Gentle Hound!" },
    ZXSPIDER         = { "Cute Spider", "Spiders become friendly too!" },
    ZXSPIDER_WARRIOR = { "Cute Green Spider", "Jump again and see?" },
    ZXSPIDER_DROPPER = { "Cute White Spider", "It must love cleanliness!" },
    ZXSPIDER_HEALER  = { "Cute Colorful Spider", "Its colorful fur is so bright!" },
    ZXTALLBIRD       = { "Cute Tallbird", "Still adorable in its small size~" },
}


--- 对应灵魂和农场的名称及描述
for k, v in pairs(ANIMAL_STRS) do
    STRINGS.NAMES[k] = v[1]
    STRINGS.CHARACTERS.GENERIC.DESCRIBE[k] = v[2]
end


for k, v in pairs(ANIMAL_STRS) do
    --- 农场字符串
    local _index  = string.find(k, "_")
    local animKey = _index and string.sub(k, 1, _index - 1) or k
    local farmKey = animKey.."FARM"
    ZXLog("test", k, animKey, farmKey)
    local frmName = STRINGS.NAMES[animKey]..(isch and "农场" or " Farm")
    STRINGS.NAMES[farmKey] = frmName
    STRINGS.RECIPE_DESC[farmKey] = v[1]..string.format(FARM_DESC_1, STRINGS.NAMES[animKey])
    --- 灵魂字符串
    local soulKey = k.."_SOUL"
    STRINGS.NAMES[soulKey] = v[1]..(isch and "的灵魂" or " Soul")
    STRINGS.RECIPE_DESC[soulKey] = string.format(SOUL_DESC_1, v[1])
    STRINGS.CHARACTERS.GENERIC.DESCRIBE[soulKey] = string.format(SOUL_DESC_2, frmName)
end


STRINGS.ZX_HASBIND = isch and "已绑定" or "Bind"

--- 孵化器相关字符串
STRINGS.NAMES.ZXFARMHATCH = isch and "灵魂孵化器" or "Soul Incubator"
STRINGS.RECIPE_DESC.ZXFARMHATCH = isch and "建在农场旁边孵化小动物!" or"Constructing a facility adjacent to the farm for incubating baby animals!"
STRINGS.ZXFARMHATCH_WORKING = isch and "一个小生命正在孕育中~" or "A tiny life is being nurtured!"
STRINGS.ZXFARMHATCH_IDLE = isch and "满满的生命能量~" or "Abundant vitality of life!"
--- 饲料盆相关字符串
STRINGS.NAMES.ZXFARMBOWL = isch and "饲料盆" or "Feeding bowl"
STRINGS.RECIPE_DESC.ZXFARMBOWL = isch and "用来盛放小动物的食物!" or "A container used to hold food for small animals!"
STRINGS.ZXFARMBOWL_FOODLEFT = isch and "饲料剩余: %s" or "Food left: %s"
STRINGS.ZXFARMBOWL_EMPTY = isch and "什么也没剩下~" or "Nothing remaining~"
STRINGS.ZXFARMBOWL_NOTENOUGH = isch and "饲料剩的不多了,赶紧添加吧~" or "The feed is running low, better refill it quickly!"
STRINGS.ZXFARMBOWL_ENOUGH = isch and "饲料充足,小动物们都吃饱了~" or "The feed is ample, all the little animals are well-fed!"
--- 饲料
STRINGS.NAMES.ZXFARMFOOD_NORMAL= isch and "通用型饲料" or "Universal feed"
STRINGS.RECIPE_DESC.ZXFARMFOOD_NORMAL = isch and "用来投喂饥饿的小动物!" or "Used to feed hungry animals!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ZXFARMFOOD_NORMAL = isch and "满满的都是营养!" or "It's full of nutrients!"


