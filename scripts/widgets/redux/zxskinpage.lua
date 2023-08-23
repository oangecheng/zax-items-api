local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"
local TEMPLATES = require "widgets/redux/templates"
local Spinner = require "widgets/spinner"
local PopupDialogScreen = require "screens/redux/popupdialog"

local ZXSKINS= require("zx_skin/zx_skins").GetSkins("")


local GridPage = Class(Widget, function(self, parent_widget, owner)
    Widget._ctor(self, "GridPage")

    self.parent_widget = parent_widget
	self.root = self:AddChild(Widget("root"))

	--皮肤面板
	self.skin_grid = self.root:AddChild(self:BuildSkinScrollGrid())
	self.skin_grid:SetPosition(-15, -12)

	--当前货币数量
	self.skin_money = self.root:AddChild(Text(CODEFONT, 24))
	self.skin_money:SetPosition(-345, 242)
	self.skin_money:SetRegionSize( 70, 24 )
	self.skin_money:SetHAlign( ANCHOR_LEFT)
	self.skin_money:SetString("888")
	self.skin_money:SetColour(UICOLOURS.GOLD)

	--已解锁皮肤数量(文字)
	self.skin_num = self.root:AddChild(Text(CODEFONT, 24))
	self.skin_num:SetPosition(-250, 243)
	self.skin_num:SetRegionSize( 150, 24 )
	self.skin_num:SetHAlign( ANCHOR_LEFT)
	self.skin_num:SetString("已拥有:2/5")
	self.skin_num:SetColour(UICOLOURS.GOLD)

	--提示文字
	self.skin_help = self.root:AddChild(Text(CODEFONT, 24))
	self.skin_help:SetPosition(0, 243)
	self.skin_help:SetRegionSize( 250, 24 )
	self.skin_help:SetHAlign( ANCHOR_LEFT)
	self.skin_help:SetString("提示文字")
	self.skin_help:SetColour(UICOLOURS.GOLD)


	local skin_grid_data = {}--皮肤数据
	for k,v in pairs(ZXSKINS) do--遍历皮肤数据表
		table.insert(skin_grid_data, { prefab = k, info = v.data, currentid = 1 })
	end
	-- table.sort(skin_grid_data, function(a,b) return a.index < b.index end)--排序(免得pairs打乱了)
	self.skin_grid:SetItemsData(skin_grid_data)
	self.parent_default_focus = self.skin_grid
	self:SetSkinNumText()
end)

local textures = {
	arrow_left_normal = "arrow2_left.tex",
	arrow_left_over = "arrow2_left_over.tex",
	arrow_left_disabled = "arrow_left_disabled.tex",
	arrow_left_down = "arrow2_left_down.tex",
	arrow_right_normal = "arrow2_right.tex",
	arrow_right_over = "arrow2_right_over.tex",
	arrow_right_disabled = "arrow_right_disabled.tex",
	arrow_right_down = "arrow2_right_down.tex",
	bg_middle = "blank.tex",
	bg_middle_focus = "blank.tex",
	bg_middle_changing = "blank.tex",
	bg_end = "blank.tex",
	bg_end_focus = "blank.tex",
	bg_end_changing = "blank.tex",
	bg_modified = "option_highlight.tex",
}


--构造皮肤列表
function GridPage:BuildSkinScrollGrid()
    local row_w = 160
    local row_h = 230
	local row_spacing = 2

	local width_spinner = 135
	local width_label = 135
	local height = 25

	local font = HEADERFONT
	local font_size = 20

	local function ScrollWidgetsCtor(context, index)
		local root = self

		local w = Widget("skin-cell-".. index)
		w.cell_root = w:AddChild(ImageButton("images/plantregistry.xml", "plant_entry.tex", "plant_entry_focus.tex"))

		w.focus_forward = w.cell_root

		w.cell_root.ongainfocusfn = function()
			self.skin_grid:OnWidgetFocus(w)
		end
		--外框
		w.skin_seperator = w.cell_root:AddChild(Image("images/plantregistry.xml", "plant_entry_seperator.tex"))
		w.skin_seperator:SetPosition(0, 88)

		--皮肤贴图
		w.skin_img = w.cell_root:AddChild(Image())
		w.skin_img:SetPosition(0, 0)
		w.skin_img:SetScale(0.8, 0.8)

		--皮肤预制物名称
		w.skin_label = w.cell_root:AddChild(Text(font, font_size))
		w.skin_label:SetPosition(0, 100)
		w.skin_label:SetRegionSize( width_label, height )
		w.skin_label:SetHAlign( ANCHOR_MIDDLE )

		--皮肤预制物名称
		w.skin_name = w.cell_root:AddChild(Text(font, font_size))
		w.skin_name:SetPosition(0, 78)
		w.skin_name:SetRegionSize( width_label, height )
		w.skin_name:SetHAlign( ANCHOR_MIDDLE )
		w.skin_name:SetColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
		
		--已购买文字显示
		w.skin_label = w.cell_root:AddChild(Text(font, font_size))
		w.skin_label:SetPosition(0, -95)
		w.skin_label:SetRegionSize( width_label, height )
		w.skin_label:SetHAlign( ANCHOR_MIDDLE )
		w.skin_label:SetString("已拥有")
		w.skin_label:SetColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
		

		local lean = true
		--皮肤切换箭头
		w.skin_spinner = w.cell_root:AddChild(Spinner({}, width_spinner, height, {font = font, size = font_size}, nil, "images/plantregistry.xml", textures, lean))

		w.skin_spinner:SetPosition(0, -85)
		w.skin_spinner:SetTextColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
		w.skin_spinner.text:SetPosition(8, 12)

		--按钮
		w.skin_btn = w.cell_root:AddChild(
			TEMPLATES.StandardButton(
				nil,
				"确定",--按钮文字
				{60, 30}--按钮尺寸
			)
		)
		w.skin_btn:SetTextSize(18)
		w.skin_btn:SetPosition(0, -95, 0)
		
		--皮肤选项卡展示
		function w:SetSkinPage(prefab, skinid)
			local data=w.data
			if not data then return end
			data.currentid = skinid

			local skin = data.info[skinid]
			if skin then
				w.skin_img:SetTexture(skin.xml, skin.tex)
				w.skin_name:SetString(skin.name)
			end

			w.skin_btn:SetOnClick(function()
				-- local popup
				-- popup = PopupDialogScreen("title", "desc",
				-- 	{
				-- 		{text = "按钮1", cb = function()
				-- 			TheFrontEnd:PopScreen(popup)
				-- 		end},
				-- 		{text = "按钮2", cb = function()
				-- 			TheFrontEnd:PopScreen(popup)
				-- 		end},
				-- 	}
				-- )
				-- TheFrontEnd:PushScreen(popup)
			end)
			w.skin_btn:Enable()
		end

		local _OnControl = w.cell_root.OnControl
		w.cell_root.OnControl = function(_, control, down)
			if w.skin_spinner.focus or (control == CONTROL_PREVVALUE or control == CONTROL_NEXTVALUE) then if w.skin_spinner:IsVisible() then w.skin_spinner:OnControl(control, down) end return true end
			if w.skin_btn.focus or (control == CONTROL_PREVVALUE or control == CONTROL_NEXTVALUE) then if w.skin_btn:IsVisible() then w.skin_btn:OnControl(control, down) end return true end
			return _OnControl(_, control, down)
		end

		local _OnGainFocus = w.cell_root.OnGainFocus
		function w.cell_root.OnGainFocus()
			_OnGainFocus(w.cell_root)
			w.skin_seperator:SetTexture("images/plantregistry.xml", "plant_entry_seperator_focus.tex")
			w.skin_label:SetColour(PLANTREGISTRYUICOLOURS.LOCKEDBROWN)
			w.skin_spinner:SetTextColour(PLANTREGISTRYUICOLOURS.LOCKEDBROWN)
		end
		local _OnLoseFocus = w.cell_root.OnLoseFocus
		function w.cell_root.OnLoseFocus()
			_OnLoseFocus(w.cell_root)
			if not w.data then return end
			if ThePlantRegistry:IsAnyPlantStageKnown(w.data.plant) then
				w.skin_seperator:SetTexture("images/plantregistry.xml", "plant_entry_seperator_active.tex")
			else
				w.skin_seperator:SetTexture("images/plantregistry.xml", "plant_entry_seperator.tex")
			end
			if w.skin_label:GetString() == STRINGS.UI.PLANTREGISTRY.MYSTERY_PLANT then
				w.skin_label:SetColour(PLANTREGISTRYUICOLOURS.LOCKEDBROWN)
			else
				w.skin_label:SetColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
			end
			w.skin_spinner:SetTextColour(PLANTREGISTRYUICOLOURS.UNLOCKEDBROWN)
		end

		function w.cell_root:GetHelpText()
			if not w.skin_spinner.focus and w.skin_spinner:IsVisible() then
				return w.skin_spinner:GetHelpText()
			end
		end

		return w
	end
	--设定皮肤数据
	local function ScrollWidgetSetData(context, widget, data, index)
		if data == nil then
			widget.cell_root:Hide()
			return
		else
			widget.cell_root:Show()
		end

		widget.data = data
		widget:SetSkinPage(data.prefab, data.currentid)

		widget.skin_label:SetString(STRINGS.NAMES[string.upper(data.prefab)])

		local spinner_options = {}--皮肤选项卡数据
		for i, v in ipairs(data.info) do --遍历数据表，加入到选项卡里
			table.insert( spinner_options, { text= 100, data = i } )
		end

		widget.cell_root:SetTextures("images/plantregistry.xml", "plant_entry_active.tex", "plant_entry_focus.tex")
		widget.skin_seperator:SetTexture("images/plantregistry.xml", "plant_entry_seperator_active.tex")
		widget.skin_spinner:SetOptions(spinner_options)
		widget.skin_spinner:SetOnChangedFn(function(spinner_data)
			print("KsfunLog onchange3 ".. spinner_data)
			widget:SetSkinPage(data.prefab, spinner_data)
		end)
		widget.skin_spinner:SetSelected(data.currentid)
    end

    local grid = TEMPLATES.ScrollingGrid(
        {},
        {
            context = {},
            widget_width  = row_w + row_spacing,
            widget_height = row_h + row_spacing,
			force_peek    = true,
            num_visible_rows = 2,
            num_columns      = 5,
            item_ctor_fn = ScrollWidgetsCtor,
            apply_fn     = ScrollWidgetSetData,
            scrollbar_offset = 15,
			scrollbar_height_offset = -60,
			peek_percent = 30/(row_h + row_spacing),
			end_offset = math.abs(1 - 5/(row_h + row_spacing)),
		})

	--滚动条设定
	grid.up_button:SetTextures("images/plantregistry.xml", "plantregistry_recipe_scroll_arrow.tex")
	grid.up_button:SetScale(0.5)

	grid.down_button:SetTextures("images/plantregistry.xml", "plantregistry_recipe_scroll_arrow.tex")
	grid.down_button:SetScale(-0.5)

	grid.scroll_bar_line:SetTexture("images/plantregistry.xml", "plantregistry_recipe_scroll_bar.tex")
	grid.scroll_bar_line:SetScale(.8)

	grid.position_marker:SetTextures("images/plantregistry.xml", "plantregistry_recipe_scroll_handle.tex")
	grid.position_marker.image:SetTexture("images/plantregistry.xml", "plantregistry_recipe_scroll_handle.tex")
	grid.position_marker:SetScale(.6)

    return grid
end


function GridPage:OnControl(control, down)
	if self.plantregistrywidget then
		self.plantregistrywidget:OnControl(control, down)
		return true
	end
	return GridPage._base.OnControl(self, control, down)
end

--更新数据
function GridPage:OnUpdateInfo()
	self:SetSkinNumText()
	self.skin_grid:RefreshView()--更新数据
end

--设置已解锁皮肤的文字
function GridPage:SetSkinNumText()
	self.skin_num:SetString("1/100")
end

return GridPage
