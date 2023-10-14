
local isCh = ZXTUNING.IS_CH
local skinnamesdef = {
    ["0000"] = isCh and "暗夜杖" or "dark staff",
    ["0001"] = isCh and "仙女杖"  or "fairy staff",
    ["0010"] = isCh and "经典" or "custom",
    ["0011"] = isCh and "浮生的潘多拉魔盒" or "pandro chest",
    ["0100"] = isCh and "经典" or "custom",
    ["0101"] = isCh and "浮生的肉铺" or "ocean meat granary",
    ["1000"] = isCh and "紫色酢浆草" or "oxalis",
    ["1001"] = isCh and "小雏菊花丛" or "daisy",
    ["1002"] = isCh and "绣球花" or "hydrangea",
    ["1100"] = isCh and "垃圾桶" or "ashcan",
    ["1200"] = isCh and "花园灯" or "garden lamp",
    ["1202"] = isCh and "蘑菇灯" or "mushroom lamp",
    ["1203"] = isCh and "蜘蛛灯" or "spider lamp",
    ["1211"] = isCh and "铃兰花灯" or "flower lamp",
    ["1212"] = isCh and "POPO" or "bubble lamp",
    ["1213"] = isCh and "浮生儿" or "panda lamp",
    ["1214"] = isCh and "胖达" or "lucky panda",
    ["1250"] = isCh and "猫猫灯(左)" or "black kitty(left)",
    ["1251"] = isCh and "猫猫灯(右)" or "black kitty(right)",
    ["1252"] = isCh and "典藏卡基米(左)" or "cat lamp",
    ["1253"] = isCh and "典藏卡基米(右)" or "cat lamp",
    ["1254"] = isCh and "小蛛灯" or "flower lamp",
    ["1255"] = isCh and "星星灯" or "flower lamp",
    ["1300"] = isCh and "森林小屋" or "forest house",
    ["1301"] = isCh and "柴胡(白)" or "cottage",
    ["1302"] = isCh and "柴胡(绿)" or "cottage(green)",
    ["1400"] = isCh and "甜心花蜜罐" or "sweety honey jar",
    ["1401"] = isCh and "小熊蜜罐" or "bear honey jar",
    ["1411"] = isCh and "花盈琉璃瓶" or "glazed vase",

    ["1500"] = isCh and "复古竹艺" or "bamboo art",
    ["1501"] = isCh and "姥姥的手提篮" or "grandmother’s basket",
    ["1502"] = isCh and "毛绒篮子" or "plush basket",
    ["1503"] = isCh and "实木箱子" or "wood basket",

    ["1600"] = isCh and "木质手推车" or "trolley",
    ["1601"] = isCh and "牛仔卷" or "grass rolls",
    ["1700"] = isCh and "多彩蘑菇房" or "mushroom house",
    ["1800"] = isCh and "多彩蔷薇" or "rosebush well",
    ["1801"] = isCh and "宫廷风" or "court style",
}



local ZX_SKINTYPE = {
    UNKOWN = 0,
    FREE = 1,
    SPONSOR = 2,
    CUSTOM = 3,
}



local WHITE_USERS = {}
local USER_SKIN_DEF = {}


local skinlist = {}



function ZxGetSwapSymbol(inst)
    if inst.components.zxskinable then
        local id = inst.components.zxskinable.skinid
        local skin = ZxFindSkin(inst.prefab, id)
        if skin then
            local file = skin.file
            return "swap_"..file
        end
    end
end



---comment
---@param prefab string
---@param skinid string
---@param file string
---@param index number
---@param skintype number
---@param isdefault any
local function registerSkin(prefab, skinid, file, index, skintype, isdefault)
    skinlist[prefab] = skinlist[prefab] or {}
    skinlist[prefab].data = skinlist[prefab].data or {}
    skinlist[prefab].index = skinlist[prefab].index or index

    local skin = {}
    skin.id = skinid
    skin.name = skinnamesdef[skinid] or "未知"
    skin.xml = "images/zxskins/"..prefab.."/"..file..".xml"
    skin.tex = file..".tex"
    skin.file = file
    skin.type = skintype
    skin.isdefault = isdefault

    --- 用文件名命名动画文件
    skin.bank = file
    skin.build = file
    table.insert(skinlist[prefab].data, skin)
end

-- 法杖
registerSkin("zxskintool", "0000", "zxskintool1", 0, ZX_SKINTYPE.FREE, true)
registerSkin("zxskintool", "0001", "zxskintool2", 0, ZX_SKINTYPE.FREE)
registerSkin("zx_granary_veggie", "0010", "zx_granary_veggie", 0.1, ZX_SKINTYPE.FREE, true)
registerSkin("zx_granary_veggie", "0011", "zxgranaryveggie1" , 0.1, ZX_SKINTYPE.CUSTOM)
registerSkin("zx_granary_meat", "0100", "zxgranarymeat", 0.2, ZX_SKINTYPE.FREE, true)
registerSkin("zx_granary_meat", "0101", "zxgranarymeat1", 0.2, ZX_SKINTYPE.CUSTOM)


-- 花丛
registerSkin("zxflowerbush", "1000", "zxoxalis",     1, ZX_SKINTYPE.FREE, true)
registerSkin("zxflowerbush", "1001", "zxdaisy",      1, ZX_SKINTYPE.FREE)
registerSkin("zxflowerbush", "1002", "zxhydrangea",  1, ZX_SKINTYPE.FREE)
-- 垃圾桶
registerSkin("zxashcan", "1100", "zxashcan",  2, ZX_SKINTYPE.FREE, true)
--- 灯
registerSkin("zxlight",  "1200", "zxgardenlight",   3, ZX_SKINTYPE.FREE, true)
registerSkin("zxlight",  "1202", "zxmushroomlight", 3, ZX_SKINTYPE.FREE)
registerSkin("zxlight",  "1203", "zxlight4",        3, ZX_SKINTYPE.FREE)
registerSkin("zxlight",  "1211", "zxflowerlight",   3, ZX_SKINTYPE.SPONSOR)
registerSkin("zxlight",  "1212", "zxbubblelight",   3, ZX_SKINTYPE.SPONSOR)
registerSkin("zxlight",  "1213", "zxlight2",        3, ZX_SKINTYPE.SPONSOR)
registerSkin("zxlight",  "1214", "zxlight3",        3, ZX_SKINTYPE.SPONSOR)

registerSkin("zxlight",  "1250", "zxcatllight",     3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  "1251", "zxcatrlight",     3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  "1252", "zxcatsleftlight", 3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  "1253", "zxcatsrightlight",3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  "1254", "zxstartalllight", 3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  "1255", "zxstarshortlight",3, ZX_SKINTYPE.CUSTOM)
-- 柴房
registerSkin("zxlogstore", "1300", "zxlogstoreforest", 4, ZX_SKINTYPE.FREE, true)
registerSkin("zxlogstore", "1301", "zxlogstore1", 4, ZX_SKINTYPE.SPONSOR)
registerSkin("zxlogstore", "1302", "zxlogstore2", 4, ZX_SKINTYPE.SPONSOR)

-- 蜂蜜罐子
registerSkin("zxhoneyjar", "1400", "zxhoneyjar1", 5, ZX_SKINTYPE.FREE, true)
registerSkin("zxhoneyjar", "1401", "zxhoneyjar3", 5, ZX_SKINTYPE.FREE)
registerSkin("zxhoneyjar", "1411", "zxhoneyjar2", 5, ZX_SKINTYPE.SPONSOR)

-- 蛋篮子
registerSkin("zxeggbasket", "1500", "zxeggbasket1", 6, ZX_SKINTYPE.FREE, true)
registerSkin("zxeggbasket", "1501", "zxeggbasket2", 6, ZX_SKINTYPE.SPONSOR)
registerSkin("zxeggbasket", "1502", "zxeggbasket3", 6, ZX_SKINTYPE.FREE)
registerSkin("zxeggbasket", "1503", "zxeggbasket4", 6, ZX_SKINTYPE.FREE)
-- 草车
registerSkin("zx_hay_cart", "1600", "zxhaycart1",  7, ZX_SKINTYPE.FREE, true)
registerSkin("zx_hay_cart", "1601", "zxhaycart2",  7, ZX_SKINTYPE.FREE)
-- 蘑菇房子
registerSkin("zxmushroomhouse", "1700", "zxmushroomhouse1",  8, ZX_SKINTYPE.FREE, true)
-- 水井
registerSkin("zx_well", "1800", "zx_well", 9, ZX_SKINTYPE.FREE, true)
registerSkin("zx_well", "1801", "zxwell1", 9, ZX_SKINTYPE.SPONSOR)




--- 有些动画制作的时候尺寸不佳
--- 通过这个修改动画的尺寸
local animscales = {
    ["1213"] = 1.5,
    ["1214"] = 0.8,
    ["1301"] = 1.3,
    ["1302"] = 1.3,
    ["1501"] = 0.8,
    ["1503"] = 0.8,
    ["1601"] = 2,
    ["1700"] = 0.8,
    ["1801"] = 1.5,
}



local function tryChangeSymbol(inst, skin)
    if inst.zxowener and skin then
        local symbol = "swap_"..skin.file
        inst.zxowener.AnimState:OverrideSymbol("swap_object", symbol, "swap")
        inst.zxowener.AnimState:Show("ARM_carry")
        inst.zxowener.AnimState:Hide("ARM_normal")
    end
end

local function tryChangeInventoryitem(inst, skin)
    if skin and inst.components.inventoryitem then
        inst.components.inventoryitem.atlasname = skin.xml
        inst.components.inventoryitem.imagename = skin.file
    end
end


--- 没有自定义皮肤切换函数，使用默认的
for k, v in pairs(skinlist) do
    for index, value in ipairs(v.data) do
        if value and value.skinfunc == nil and value.bank and value.build then
            value.skinfunc = function (inst)
                inst.AnimState:SetBank(value.bank)
                inst.AnimState:SetBuild(value.build)
                local scale = animscales[value.id] or 1
                inst.AnimState:SetScale(scale, scale, scale)
                tryChangeSymbol(inst, value)
                tryChangeInventoryitem(inst, value)
            end        
        end 
    end
end



local ZXSKINS = skinlist
local ZXUSERSKINS = USER_SKIN_DEF


function ZxGetAllSkins()
    return ZXSKINS
end


function ZxGetPrefabSkins(prefab)
    return ZXSKINS[prefab] and ZXSKINS[prefab].data or {}
end


function ZxGetUserPrefabSkins(userid, prefab)
    local ret = {}
    local userskins = ZXUSERSKINS[userid] or {}
    local skins = ZxGetPrefabSkins(prefab)
    ---@diagnostic disable-next-line: undefined-field
    if table.contains(WHITE_USERS, userid) then
        return skins
    end

    if skins then
        for _, v in ipairs(skins) do
            ---@diagnostic disable-next-line: undefined-field
            if v.type == ZX_SKINTYPE.FREE or table.contains(userskins, v.id) then
                table.insert(ret, v)
            end
        end
    end
    return ret
end


function ZxUserHasSkin(userid, skinid)
     ---@diagnostic disable-next-line: undefined-field
     if table.contains(WHITE_USERS, userid) then
        return true
    end
    local userskins = ZXUSERSKINS[userid] or {}
    for k, v in pairs(ZXSKINS) do
        for i, d in ipairs(v.data) do
            if d.id == skinid then
                 ---@diagnostic disable-next-line: undefined-field
                if d.type == ZX_SKINTYPE.FREE or table.contains(userskins, d.id) then
                    return true
                end
            end
        end
    end
    return false
end



function ZxGetCanShowSkins(userid)
    local userskins = ZXUSERSKINS[userid]
    local allskins = deepcopy(ZXSKINS)
    ---@diagnostic disable-next-line: undefined-field
    local white = table.contains(WHITE_USERS, userid)

    for k, s in pairs(allskins) do
        local skins = s.data
        local list = {}
        for i, v in ipairs(skins) do
            ---@diagnostic disable-next-line: undefined-field
            if white or v.type == ZX_SKINTYPE.FREE or table.contains(userskins, v.id) then
                v.canuse = true
                table.insert(list, v)
            elseif v.type == ZX_SKINTYPE.SPONSOR then
                table.insert(list, v)
            end
        end
        allskins[k].data = list
    end
    return allskins
end



function ZxFindSkin(prefab, skinid)
    local skins =  ZxGetPrefabSkins(prefab)
    if skins then
       for _, v in ipairs(skins) do
        if skinid ~= nil then
            if skinid == v.id then
                return v
            end
        else
            if v.isdefault then
               return v
            end
        end
        
       end
    end
    return nil
end



function ZxGetPrefabAnimAsset(prefab)
    local skins = ZxGetPrefabSkins(prefab)
    local asset = {}
    for _, v in ipairs(skins) do
        local anim = "anim/"..v.file..".zip"
        table.insert(asset, Asset("ANIM", anim))
        if v.isdefault then
            table.insert(asset, Asset("ATLAS", v.xml))
            table.insert(asset, Asset("IMAGE", "images/zxskins/"..prefab.."/"..v.file..".tex"))
        end
    end
    return asset
end


function ZxGetPrefabDefaultSkin(prefab)
    local skins = ZxGetPrefabSkins(prefab)
    for _, v in ipairs(skins) do
        if v.isdefault then
            return v
        end
    end
    return {}
end


local function requestSuccess(result, isSuccessful, resultCode)
    if isSuccessful then
        local data = json.decode(result)
        if data.status == 1 and data.userId then
            if data.role == 1 then
                table.insert(WHITE_USERS, data.userId)
            else
                USER_SKIN_DEF[data.userId] = data.skinIds
            end
        end
    end
end


local function net(inst)
    inst.zxuserinit = net_string(inst.GUID, "zxuserinit", "zxitems_itemdirty")
    inst:ListenForEvent("zxitems_itemdirty", function(_)
        local userid = inst.zxuserinit:value()
        print("zxuserinit "..tostring(userid))
        if userid then
            TheSim:QueryServer("https://www.orangezax.cn:8080/dst/homebuilding/userskins?userId="..userid, requestSuccess)
        end
    end)
end


function ZxGetUserSkinFromServer(inst)
    net(inst)
    if TheWorld.ismastersim then
        inst:DoTaskInTime(2, function ()
            if inst.zxuserinit then
                inst.zxuserinit:set(inst.userid)
            end
        end)
    end
end

