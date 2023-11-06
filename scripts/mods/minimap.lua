local map_icons = {
    "zx_well",
    "zxlight",
}

local farms = require("defs/zxfarmdefs").farms
for key, _ in pairs(farms) do
    table.insert(map_icons, key)
end


local boxes = require("defs/zxboxdefs")
for key, _ in pairs(boxes) do
    table.insert(map_icons, key)
end


for _, v in ipairs(map_icons) do
    local skin = ZxGetPrefabDefaultSkin(v)
    local xml = skin and skin.xml
    if xml then
        AddMinimapAtlas(xml)
    end

    AddPrefabPostInit(v, function (inst)
        if skin.tex then
            inst.MiniMapEntity:SetIcon(skin.tex)
        end
    end)
end