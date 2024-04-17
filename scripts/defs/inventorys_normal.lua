local DIR = "images/inventoryimages/"

local ITEMS = {}

local function assestsfn(prefab)
    return {
        Asset("ANIM" , "anim/"..prefab..".zip"),
        Asset("ATLAS", DIR..prefab..".xml"),
        Asset("IMAGE", DIR..prefab..".tex")
    }
end


--- 建家石
local STONE = "zxstone"
local zxstonedata = {
    assets = assestsfn(STONE),
    bank   = STONE,
    build  = STONE,
    loop   = false,
    tags   = { "molebait", "ZXSTONE" },
    image  = STONE,
    atlas  = STONE,
}


ITEMS[STONE] = zxstonedata


return ITEMS