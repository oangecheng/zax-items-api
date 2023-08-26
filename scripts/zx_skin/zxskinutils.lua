

ZX_SKINTYPE = {
    UNKOWN = 0,
    FREE = 1,
    SPONSOR = 2,
    CUSTOM = 3,
}


local WHITE_USERS = {
    "KU_6BQklGIZ",
    "KU_yOQjm62_",
}



local ZXSKINS = require("zx_skin/zxskinsdef")
local ZXUSERSKINS = require("zx_skin/zxuserdata")


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