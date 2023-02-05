local map_icons = {
	"zx_granary_meat",
    "zx_granary_veggie",
}

for k,v in pairs(map_icons) do
	table.insert(Assets, Asset( "IMAGE", "images/minimap/"..v..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/minimap/"..v..".xml" ))
    AddMinimapAtlas("images/minimap/"..v..".xml")
end
