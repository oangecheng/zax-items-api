


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



return skinlist