local MedalSkinPopupScreen = require "screens/medalskinpopupscreen"--皮肤界面


AddClassPostConstruct("screens/playerhud",function(self, anim, owner)
	--添加皮肤界面
	self.ShowMedalSkinScreen = function(_, attach)
		if attach==nil then
			return
		end
		self.medalskinpopupscreen = MedalSkinPopupScreen(self.owner, attach)
        self:OpenScreenUnderPause(self.medalskinpopupscreen)
        return self.medalskinpopupscreen
	end
end)


AddPopup("MEDALSKIN")
POPUPS.MEDALSKIN.fn = function(inst, show, staff)
    if inst.HUD then
        if not show then
            inst.HUD:CloseMedalSkinScreen()
        elseif not inst.HUD:ShowMedalSkinScreen(staff) then
            POPUPS.MEDALSKIN:Close(inst)
        end
    end
end


