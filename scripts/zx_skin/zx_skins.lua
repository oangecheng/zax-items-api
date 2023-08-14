

local Skin = {}

local skinlist = {}


local function registerSkin(prefab, skinid, file, index)
    skinlist[prefab] = skinlist[prefab] or {}
    skinlist[prefab].data = skinlist[prefab].data or {}
    skinlist[prefab].index = skinlist[prefab].index or index

    local skin = {}
    skin.id = skinid
    skin.name = STRINGS.ZX_SKIN_NAMES[prefab][file]
    skin.xml = "images/zxskins/"..prefab.."/"..file..".xml"
    skin.tex = file..".tex"
    skin.file = file

    --- 用文件名命名动画文件
    skin.bank = file
    skin.build = file
    
    table.insert(skinlist[prefab].data, skin)
end


registerSkin("zx_flower", 1001, "daisy_bushes", 1)
registerSkin("zx_flower", 1002, "oxalis"      , 1)
registerSkin("zx_light" , 1101, "oxalis"      , 0)


registerSkin("zxflowerbush", 1201, "zxdaisy",   2)
registerSkin("zxflowerbush", 1202, "zxdoxalis", 2)




--- 没有自定义皮肤切换函数，使用默认的
for k, v in pairs(skinlist) do
    if v and v.skinfunc == nil and v.data.bank and v.data.build then
        v.skinfunc = function (inst)
            inst.AnimState:SetBank(v.data.bank)
            inst.AnimState:SetBuild(v.data.build)
        end
    end
end


Skin.GetSkins = function(useid)
    return skinlist
end


return Skin