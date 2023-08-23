

local Skin = {}


local USER_SKIN_DEF = {
    ["123"] = { 1001 }
}


local skinlist = {}


local function registerSkin(prefab, skinid, file, index, isfree)
    skinlist[prefab] = skinlist[prefab] or {}
    skinlist[prefab].data = skinlist[prefab].data or {}
    skinlist[prefab].index = skinlist[prefab].index or index

    local skin = {}
    skin.id = skinid
    skin.name = STRINGS.ZX_SKIN_NAMES[prefab][file]
    skin.xml = "images/zxskins/"..prefab.."/"..file..".xml"
    skin.tex = file..".tex"
    skin.file = file
    skin.isfree = isfree

    --- 用文件名命名动画文件
    skin.bank = file
    skin.build = file
    
    table.insert(skinlist[prefab].data, skin)
end


registerSkin("zxflowerbush", 1000, "zxdaisy",      1, true)
registerSkin("zxflowerbush", 1001, "zxoxalis",     1, true)
registerSkin("zxflowerbush", 1002, "zxhydrangea",  1, true)


registerSkin("zxashcan", 1100, "zxashcan",  1, true)




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


Skin.GetSkins = function(useid)
    return skinlist
end

Skin.GetUserPrefabSkins = function (userid, prefab)
    local ret = {}
    local userskins = USER_SKIN_DEF[userid] or {}
    local skins = skinlist[prefab] and skinlist[prefab].data or nil

    if skins then
        -- 遍历皮肤列表，找到用户具备的所有皮肤
        -- 在这里定义的都是能够换肤的，只是部分玩家没有该皮肤就没法换，但是还有个默认的皮肤
        for _, v in ipairs(skins) do
            ---@diagnostic disable-next-line: undefined-field
            if v.isfree or table.contains(userskins, v.id) then
                table.insert(ret, v)
            end
        end
    end
    return ret
end


Skin.GetPrefabSkins = function(prefab)
    return skinlist[prefab] and skinlist[prefab].data or nil
end


return Skin