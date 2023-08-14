

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
registerSkin("zxflowerbush", 1202, "zxoxalis", 2)




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


return Skin