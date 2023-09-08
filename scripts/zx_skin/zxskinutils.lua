
local isCh = ZXTUNING.isCh
local skinnamesdef = {
    ["0000"] = isCh and "暗夜杖" or "dark staff",
    ["0001"] = isCh and "仙女杖"  or "fairy staff",
    ["1000"] = isCh and "紫色酢浆草" or "oxalis",
    ["1001"] = isCh and "小雏菊花丛" or "daisy",
    ["1002"] = isCh and "绣球花" or "hydrangea",
    ["1100"] = isCh and "垃圾桶" or "ashcan",
    ["1200"] = isCh and "花园灯" or "garden lamp",
    ["1202"] = isCh and "蘑菇灯" or "mushroom lamp",
    ["1211"] = isCh and "铃兰花灯" or "flower lamp",
    ["1212"] = isCh and "POPO" or "bubble lamp",
    ["1250"] = isCh and "猫猫灯(左)" or "black kitty(left)",
    ["1251"] = isCh and "猫猫灯(右)" or "black kitty(right)",
    ["1252"] = isCh and "典藏卡基米(左)" or "cat lamp",
    ["1253"] = isCh and "典藏卡基米(右)" or "cat lamp",
    ["1254"] = isCh and "小蛛灯" or "flower lamp",
    ["1255"] = isCh and "星星灯" or "flower lamp",
    ["1300"] = isCh and "森林小屋" or "forest house",
    ["1400"] = isCh and "甜心花蜜罐" or "sweety honey jar",
    ["1500"] = isCh and "复古竹艺" or "bamboo art",
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
    
    table.sort(skinlist[prefab].data, function(a,b) return a.id < b.id end)
    table.insert(skinlist[prefab].data, skin)
end

-- 法杖
registerSkin("zxskintool", "0000", "zxskintool1", 0, ZX_SKINTYPE.FREE, true)
registerSkin("zxskintool", "0001", "zxskintool2", 0, ZX_SKINTYPE.FREE)

-- 花丛
registerSkin("zxflowerbush", "1000", "zxoxalis",     1, ZX_SKINTYPE.FREE, true)
registerSkin("zxflowerbush", "1001", "zxdaisy",      1, ZX_SKINTYPE.FREE)
registerSkin("zxflowerbush", "1002", "zxhydrangea",  1, ZX_SKINTYPE.FREE)
-- 垃圾桶
registerSkin("zxashcan", "1100", "zxashcan",  2, ZX_SKINTYPE.FREE, true)
--- 灯
registerSkin("zxlight",  "1200", "zxgardenlight",   3, ZX_SKINTYPE.FREE, true)
registerSkin("zxlight",  "1202", "zxmushroomlight", 3, ZX_SKINTYPE.FREE)
registerSkin("zxlight",  "1211", "zxflowerlight",   3, ZX_SKINTYPE.SPONSOR)
registerSkin("zxlight",  "1212", "zxbubblelight",   3, ZX_SKINTYPE.SPONSOR)
registerSkin("zxlight",  "1250", "zxcatllight",     3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  "1251", "zxcatrlight",     3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  "1252", "zxcatsleftlight", 3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  "1253", "zxcatsrightlight",3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  "1254", "zxstartalllight", 3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  "1255", "zxstarshortlight",3, ZX_SKINTYPE.CUSTOM)
-- 柴房
registerSkin("zxlogstore", "1300", "zxlogstoreforest", 4, ZX_SKINTYPE.FREE, true)
-- 蜂蜜罐子
registerSkin("zxhoneyjar", "1400", "zxhoneyjar1", 5, ZX_SKINTYPE.FREE, true)
-- 蛋篮子
registerSkin("zxeggbasket", "1500", "zxeggbasket1", 6, ZX_SKINTYPE.FREE, true)



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
            if v.type == ZX_SKINTYPE.FREE then
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
            TheSim:QueryServer("https://43.138.31.203:8080/dst/homebuilding/userskins?userId="..userid, requestSuccess)
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

