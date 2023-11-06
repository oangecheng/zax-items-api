local ZxSkinPopupScreen = require "screens/zxskinscreen"--皮肤界面
local ZxSkinToolScreen = require "screens/zxselectscreen"--法杖选项界面



AddClassPostConstruct("screens/playerhud",function(self, anim, owner)
	--添加皮肤界面
	self.ShowZxSkinScreen = function(_, holder)
		self.zxskinscreen = ZxSkinPopupScreen(self.owner, holder)
        self:OpenScreenUnderPause(self.zxskinscreen)
        return self.zxskinscreen
	end

    self.CloseZxSkinScreen = function(_)
		if self.zxskinscreen ~= nil then
            if self.zxskinscreen.inst:IsValid() then
                TheFrontEnd:PopScreen(self.zxskinscreen)
            end
            self.zxskinscreen = nil
        end
	end

    --添加考试界面
	self.ShowZxToolScreen = function(_, attach, hasdictionary)
		if attach == nil then
			return
		end
		self.zxtoolscreen = ZxSkinToolScreen(self.owner, attach, hasdictionary)
		self:OpenScreenUnderPause(self.zxtoolscreen)
		return self.zxtoolscreen
	end

	self.CloseZxToolScreen = function(_)
		if self.zxtoolscreen then
			self.zxtoolscreen:Close()
			self.zxtoolscreen = nil
		end
	end
end)



AddPopup("ZXSKIN")
POPUPS.ZXSKIN.fn = function(inst, show, holder)
    if inst.HUD then
        if not show then
            inst.HUD:CloseZxSkinScreen()
        elseif not inst.HUD:ShowZxSkinScreen(holder) then
            POPUPS.ZXSKIN:Close(inst)
        end
    end
end



AddPopup("ZXTOOL")
POPUPS.ZXTOOL.fn = function(inst, show, attach, hasdictionary)
    if inst.HUD then
        if not show then
            inst.HUD:CloseZxSkinScreen()
        elseif not inst.HUD:ShowZxSkinScreen(attach, hasdictionary) then
            POPUPS.ZXTOOL:Close(inst)
        end
    end
end

-- local skinentry = require("widgets/zxskinentry")
-- AddClassPostConstruct("widgets/controls", function(self)
-- 	self.skinentry = self:AddChild(skinentry())
-- end)


