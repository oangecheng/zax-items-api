

local skins = {}


local function registerSkin(prefab, skinid, userids, index)
    local skin = skins[prefab] or {}
    skin.info = skin.info or {}

    skin.info[skinid] = {}
    local s = skin.info[skinid]
    s.userids = userids
    s.name = STRINGS.ZX_SKIN_NAMES[string.upper(prefab).."_".. string.upper(skinid)]
    s.xml = "images/zx_skins/"..prefab.."/"..skinid..".xml"
    s.tex = skinid..".tex"

    skin.index = index
    skins[prefab] = skin
end


registerSkin("zx_flower", "juhua", "1", 1)
registerSkin("zx_flower", "juhua", "2", 1)



return skins