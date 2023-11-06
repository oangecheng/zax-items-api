local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local PopupDialogScreen = require "screens/redux/popupdialog"

local TEMPLATES = require "widgets/redux/templates"
local ScrollableList = require "widgets/scrollablelist"

local LINE_MAX = 50

local ZXToolScreen =
    Class(
    Screen,
    function(self, owner, attach, hasdictionary)
        Screen._ctor(self, "ZxSelectScreen")

        self.owner = owner
        self.attach = attach

        ZXLog("Screen", owner.prefab, attach.prefab)

        self.isopen = false

        self._scrnw, self._scrnh = TheSim:GetScreenSize()--屏幕宽高

        self:SetScaleMode(SCALEMODE_PROPORTIONAL)--等比缩放模式
        self:SetMaxPropUpscale(MAX_HUD_SCALE)--设置界面最大比例上限
        self:SetPosition(0, 0, 0)--设置坐标
        self:SetVAnchor(ANCHOR_MIDDLE)
        self:SetHAnchor(ANCHOR_MIDDLE)

        self.scalingroot = self:AddChild(Widget("zxselectroot"))
        self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
		--监听从暂停状态恢复到继续状态，更新尺寸
        self.inst:ListenForEvent(
            "continuefrompause",
            function()
                if self.isopen then
                    self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
                end
            end,
            TheWorld
        )
		--监听界面尺寸变化，更新尺寸
        self.inst:ListenForEvent(
            "refreshhudsize",
            function(hud, scale)
                if self.isopen then
                    self.scalingroot:SetScale(scale)
                end
            end,
            owner.HUD.inst
        )

        self.root = self.scalingroot:AddChild(TEMPLATES.ScreenRoot("root"))

        -- secretly this thing is a modal Screen, it just LOOKS like a widget
        --全屏全透明背景板，点了直接关闭界面
		self.black = self.root:AddChild(Image("images/global.xml", "square.tex"))
        self.black:SetVRegPoint(ANCHOR_MIDDLE)
        self.black:SetHRegPoint(ANCHOR_MIDDLE)
        self.black:SetVAnchor(ANCHOR_MIDDLE)
        self.black:SetHAnchor(ANCHOR_MIDDLE)
        self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
        self.black:SetTint(0, 0, 0, 0)
        self.black.OnMouseButton = function()
            self:OnCancel()
        end
		--总界面
        -- self.destspanel = self.root:AddChild(TEMPLATES.RectangleWindow(350, 550))
        self.destspanel = self.root:AddChild(TEMPLATES.CurlyWindow(200, 320))
        self.destspanel:SetPosition(0, 25)
		--标题
        self.title = self.destspanel:AddChild(Text(BODYTEXTFONT, 35))
        self.title:SetPosition(0, 200, 0)--坐标
        self.title:SetRegionSize(250, 50)--设置区域大小
        self.title:SetHAlign(ANCHOR_MIDDLE)
		self.title:SetString("选择模式")
        self.title:SetColour(1, 1, 1, 1)--默认颜色

        -- self.content = self.destspanel:AddChild(Text(BODYTEXTFONT, 24))
        -- self.content:SetPosition(0, 150, 0)--坐标
        -- self.content:SetRegionSize(250, 150)--设置区域大小
        -- self.content:SetHAlign(ANCHOR_LEFT)
        -- self.content:SetMultilineTruncatedString("\t我是内容，哈哈哈哈", 6, 250, 18, true, true)
        -- self.content:SetColour(1, 1, 1, 1)--默认颜色

        self:InitButton()
        if hasdictionary then
            self:LoadExamData()
        end

        self:Show()--显示
        self.isopen = true--开启

        SetAutopaused(true)
    end
)
--按钮信息
local button_data={
    {--选项A
        name="option_btn1",
        text="换肤模式",
        fn=function(self)
            self:MakeChoice(0)
        end
    },
    {--选项B
        name="option_btn2",
        text="镜像模式",
        fn=function(self)
            self:MakeChoice(1)
        end
    },
    {--选项C
        name="option_btn3",
        text="放大模式",
        fn=function(self)
            self:MakeChoice(2)
        end
    },
    {--选项D
        name="option_btn4",
        text= "缩小模式",
        fn=function(self)
            self:MakeChoice(3)
        end
    },

    {
        name = "option_btn5",
        text = "打开小店",
        fn = function (self)
            self:MakeChoice(4)
        end
    }
}

--初始化选项按钮
function ZXToolScreen:InitButton()
	for i, v in ipairs(button_data) do
        self[v.name] = self.destspanel:AddChild(
            TEMPLATES.StandardButton(
                --点击按钮执行的函数
                function()
                    v.fn(self)
                end,
                v.text,--按钮文字
                {200, 50}--按钮尺寸
            )
        )
        self[v.name]:SetPosition(0, 150-50*i)
    end
end

--加载题目数据
function ZXToolScreen:LoadExamData()
end

--做出选择
function ZXToolScreen:MakeChoice(answer)
    self:OnCancel()
    if answer == 4 then
        self.owner.HUD:ShowZxSkinScreen(self.attach)
    else
        self.attach.switchMode(self.attach, answer)
    end
end

--关闭
function ZXToolScreen:OnCancel()
	if not self.isopen then
        return
    end
	--关闭界面
    self.owner.HUD:CloseZxToolScreen()
end

--其他控制
function ZXToolScreen:OnControl(control, down)
    if ZXToolScreen._base.OnControl(self, control, down) then
        return true
    end

    if not down and (control == CONTROL_MAP or control == CONTROL_CANCEL) then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
        TheFrontEnd:PopScreen()
        SetAutopaused(false)
        return true
    end
	return false
end
--关闭
function ZXToolScreen:Close()
	if self.isopen then
        self.black:Kill()
        self.isopen = false

        self.inst:DoTaskInTime(
            .2,
            function()
                TheFrontEnd:PopScreen(self)
            end
        )
    end
    SetAutopaused(false)
end

return ZXToolScreen
