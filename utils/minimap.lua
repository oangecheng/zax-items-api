local map_icons = {
	"zx_granary_meat",
    "zx_granary_veggie",
    "zx_well",
}

for k,v in pairs(map_icons) do
	table.insert(Assets, Asset( "IMAGE", "images/inventoryimages/"..v..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/inventoryimages/"..v..".xml" ))
    AddMinimapAtlas("images/inventoryimages/"..v..".xml")
end
