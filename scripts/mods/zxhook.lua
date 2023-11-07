

--使预置物拥有不朽能力
local function setCanBeImmortal(inst)
	-- 勋章没提供公共函数，这里copy代码了
	if not TUNING.FUNCTIONAL_MEDAL_IS_OPEN then
		return
	end

	inst:AddTag("canbeimmortal")--可被赋予不朽之力
	inst.immortalchangename = GLOBAL.net_bool(inst.GUID, "immortalchangename", "immortalchangenamedirty")
	inst:ListenForEvent("immortalchangenamedirty", function(inst)
		if inst:HasTag("keepfresh") then
			if inst.immortalchangename:value() then
				--加上不朽前缀
				inst.displaynamefn = function(aaa)
					return subfmt(STRINGS.NAMES["IMMORTAL_BACKPACK"], { backpack = STRINGS.NAMES[string.upper(inst.prefab)] })
				end
			end
		end
	end)
	if GLOBAL.TheNet:GetIsServer() then
		local oldSaveFn=inst.OnSave
		local oldLoadFn=inst.OnLoad
		--赋予不朽之力
		inst.setImmortal = function(inst)
			inst:AddTag("keepfresh")
			if inst.components.preserver==nil then
				inst:AddComponent("preserver")
			end
			inst.components.preserver:SetPerishRateMultiplier(0)
			inst.immortalchangename:set(true)--修改名字
		end
		inst.OnSave = function(inst, data)
			if oldSaveFn~=nil then
				oldSaveFn(inst,data)
			end
			if inst:HasTag("keepfresh") then
				data.immortal=true
			end
		end
		inst.OnLoad = function(inst,data)
			if oldLoadFn~=nil then
				oldLoadFn(inst,data)
			end
			if data~=nil and data.immortal then
				if inst.setImmortal then
					inst.setImmortal(inst)
				end
			end
		end
	end
end

--- 当保鲜度设置>0时，如何开启了勋章，可以添加不朽前缀
if ZXTUNING.BOX_FRESH_RATE > 0 then
	local boxes = require "defs/zxboxdefs"
	for k,v in pairs(boxes) do
		if v.isicebox then
			AddPrefabPostInit(k, setCanBeImmortal)
		end
	end
end



--- 显示物品的额外信息
AddClassPostConstruct("widgets/hoverer", function (hoverer)
	local oldSetString = hoverer.text.SetString
	hoverer.text.SetString = function(text,str)
		local target = GLOBAL.TheInput:GetHUDEntityUnderMouse()
		target = (target and target.widget and target.widget.parent ~= nil and target.widget.parent.item) or TheInput:GetWorldEntityUnderMouse() or nil
		if target and target.GUID and target.zxextrainfostr then
			str = str..target.zxextrainfostr
		end
		if target and ZXTUNING.DEBUG then
			str = str.."\n"..tostring(target.prefab)
		end
		return oldSetString(text, str)
	end
end)