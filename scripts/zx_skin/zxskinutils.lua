

local ZX_SKINTYPE = {
    UNKOWN = 0,
    FREE = 1,
    SPONSOR = 2,
    CUSTOM = 3,
}



local WHITE_USERS = {
    "KU_6BQklGIZ",
    "KU_yOQjm62_",
    "KU_Gi0-qc00",
}

local USER_SKIN_DEF = {
    ["KU_UD4KSaLq"] = { 1250, 1251, 1252, 1253, 1254, 1255 },
    ["KU_0vPtVaaE"] = { 1250, 1251, 1252, 1253, 1254, 1255 },
    ["KU_BJgEZCEU"] = { 1250, 1251, 1252, 1253, 1254, 1255 },

    ["KU_F4GEmay9"] = { 1211, 1212 },
    ["KU_SIyU71VB"] = { 1211, 1212 },
    ["KU_LPW1CXfz"] = { 1211, 1212 },
    ["KU_m5E5k5Xm"] = { 1211, 1212 },
    ["KU_dwt6dovw"] = { 1211, 1212 },
    ["KU_j0Qm7xr0"] = { 1211, 1212 },
    ["KU_cuIT1xT8"] = { 1211, 1212 },
    ["KU_3RvV9nnh"] = { 1211, 1212 },
    ["KU_3NiPPyTS"] = { 1211, 1212 },
    ["KU_K9a7Kkx6"] = { 1211, 1212 },
    ["KU_MAFS6M2M"] = { 1211, 1212 },
    ["KU_cuIT1qdU"] = { 1211, 1212 },
    ["KU_tw1TiToM"] = { 1211, 1212 },
    ["KU_9Ct7yrkB"] = { 1211, 1212 },
    ["KU_nnMF5QXa"] = { 1211, 1212 },
    ["KU_pvwb-HJP"] = { 1211, 1212 },
    ["KU_qRBOnX1n"] = { 1211, 1212 },

    ["KU_GqQ9ffgi"] = { 1211, 1212, 1252, 1253 },
    ["KU_aAgFa01P"] = { 1211, 1212, 1252, 1253 },
    ["KU_rqpw9ctB"] = { 1211, 1212, 1252, 1253 },
    ["KU_cuIT1yFq"] = { 1211, 1212, 1252, 1253 },
    ["KU_q87X4lLl"] = { 1211, 1212, 1252, 1253 },
    ["KU_3RvV9D3I"] = { 1211, 1212, 1252, 1253 },
}

local skinlist = {}


local function registerSkin(prefab, skinid, file, index, skintype, isdefault)
    skinlist[prefab] = skinlist[prefab] or {}
    skinlist[prefab].data = skinlist[prefab].data or {}
    skinlist[prefab].index = skinlist[prefab].index or index

    local skin = {}
    skin.id = skinid
    skin.name = STRINGS.ZX_SKIN_NAMES[prefab][file]
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

-- 花丛
registerSkin("zxflowerbush", 1000, "zxoxalis",     1, ZX_SKINTYPE.FREE, true)
registerSkin("zxflowerbush", 1001, "zxdaisy",      1, ZX_SKINTYPE.FREE)
registerSkin("zxflowerbush", 1002, "zxhydrangea",  1, ZX_SKINTYPE.FREE)
-- 垃圾桶
registerSkin("zxashcan", 1100, "zxashcan",  2, ZX_SKINTYPE.FREE, true)
--- 灯
registerSkin("zxlight",  1200, "zxgardenlight",   3, ZX_SKINTYPE.FREE, true)
registerSkin("zxlight",  1202, "zxmushroomlight", 3, ZX_SKINTYPE.FREE)
registerSkin("zxlight",  1211, "zxflowerlight",   3, ZX_SKINTYPE.SPONSOR)
registerSkin("zxlight",  1212, "zxbubblelight",   3, ZX_SKINTYPE.SPONSOR)
registerSkin("zxlight",  1250, "zxcatllight",     3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  1251, "zxcatrlight",     3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  1252, "zxcatsleftlight", 3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  1253, "zxcatsrightlight",3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  1254, "zxstartalllight", 3, ZX_SKINTYPE.CUSTOM)
registerSkin("zxlight",  1255, "zxstarshortlight",3, ZX_SKINTYPE.CUSTOM)
-- 柴房
registerSkin("zxlogstore", 1300, "zxlogstoreforest", 4, ZX_SKINTYPE.FREE)

--- 没有自定义皮肤切换函数，使用默认的
for k, v in pairs(skinlist) do
    for index, value in ipairs(v.data) do
        if value and value.skinfunc == nil and value.bank and value.build then
            value.skinfunc = function (inst)
                inst.AnimState:SetBank(value.bank)
                inst.AnimState:SetBuild(value.build)
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
        if skinid ~= 0 then
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