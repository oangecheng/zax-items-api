


--生成特效
local function spawnFx(inst)
    local offset = {y=0.5,scale=1.2}
	local fx = SpawnPrefab("explode_reskin")
	local x,y,z=inst.Transform:GetWorldPosition()
	local offset_y = offset and offset.y or 0
	local scale = offset and offset.scale or 1
	if fx then
		fx.Transform:SetScale(scale, scale, scale)
		fx.Transform:SetPosition(x,y+offset_y,z)
	end
end


