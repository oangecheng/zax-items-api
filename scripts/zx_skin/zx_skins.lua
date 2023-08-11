

local skins = {}


local s = {
    ["zx_flower"] = {
        {
            id = 1,
            name = "juhua",
            xml = "images/zx_skins/zx_flower/juhua.xml",
            tex = "juhua.tex",
        },
        {
            id = 2,
            name = "juhua",
            xml = "images/zx_skins/zx_flower/juhua.xml",
            tex = "juhua.tex",
        }
    }
}


local function registerSkin(prefab, skinid, file, index)
    skins[prefab] = skins[prefab] or {}
    skins[prefab].data =  skins[prefab].data or {}
    skins[prefab].index = index

    local skin = {}
    skin.id = skinid
    skin.name = STRINGS.ZX_SKIN_NAMES[prefab][file]
    skin.xml = "images/zx_skins/"..prefab.."/"..file..".xml"
    skin.tex = file..".tex"
    skin.file = file
    
    table.insert(skins[prefab].data, skin)
end




registerSkin("zx_flower", 1001, "daisy_bushes", 1)
registerSkin("zx_flower", 1002, "oxalis"      , 1)


registerSkin("zx_light" , 1101, "oxalis"      , 0)




return skins