local Widget = require "widgets/widget" 
local ImageButton = require "widgets/imagebutton"

local medalPage = Class(Widget, function(self)
	Widget._ctor(self, "zxskinentry")
	self.root = self:AddChild(Widget("ROOT"))		
	self.pageIcon = self.root:AddChild(ImageButton("images/inventoryimages/zx_granary_meat.xml", "zx_granary_meat.tex", nil, nil, nil, nil, {1,1}, {0,0}))
	self.pageIcon:SetScale(1.2, 1.2, 1.2)
	self.pageIcon:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
	self.pageIcon:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
	self.pageIcon:SetPosition(60,100,0)
	self.pageIcon:SetTooltip(STRINGS.ZX_SKIN_PAGE_TITLE)
	self.pageIcon:SetOnClick(function()
		if ThePlayer and ThePlayer.HUD then
            if ThePlayer.zxskinscreen ~= nil then
                ThePlayer.HUD:CloseZxSkinScreen()
            else
                ThePlayer.HUD:ShowZxSkinScreen()
            end
		end
	end)
end)

return medalPage