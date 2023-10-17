

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




local lootdropper_loot={
	mole = { 
		zxstone = 0.5,
	},
}
for k,v in pairs(lootdropper_loot) do
	AddPrefabPostInit(k,function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.lootdropper then
				for ik,iv in pairs(v) do
					inst.components.lootdropper:AddChanceLoot(ik, iv)
				end
			end
		end
	end)
end


local stones = { 
	["rock2"] = 0.5, 
	["rock_avocado_fruit"] = 0.1 
}
for k,v in pairs(stones) do
	AddPrefabPostInit(k, function (inst)
		if GLOBAL.TheNet:GetIsServer() then
			inst:ListenForEvent("worked", function (inst, data)
				if math.random() <= v then
					local loot = SpawnPrefab("zxstone")
					LaunchAt(loot, inst, data.worker, 1.5, 1, nil, 90)
				end
			end)
		end
	end)
end




--- 显示物品的额外信息
AddClassPostConstruct("widgets/hoverer", function (hoverer)
	local oldSetString = hoverer.text.SetString
	hoverer.text.SetString = function(text,str)
		local target = GLOBAL.TheInput:GetHUDEntityUnderMouse()
		if target and target.GUID and target.zxextrainfostr then
			str = str..target.zxextrainfostr
		end
		return oldSetString(text, str)
	end
end)




local famrblueprints = {
	 ["perd"] = "zxperdfarm",
	 ["pigman"] = "zxpigmanfarm",
}

local animalsouls = {
	["perd"] = "zxperd_soul",
	["pigman"] = "zxpigman_soul",
	["beefalo"] = "zxbeefalo_soul",
	["goat"] = "zxgoat_soul",
}

local famrblueprint_ratio = 0.2
local farmsoul_ratio = 0.1

local function dropFarmItems(inst, data)

	local farm = data.victim and famrblueprints[data.victim.prefab]

	if farm then
	
		local builder = inst.components.builder
		if farm and builder then

			local function lootChance(prefab, chance)
				if prefab and math.random() <= (chance or 1) then
					local blueprint = SpawnPrefab(prefab)
					LaunchAt(blueprint, data.victim, inst, 1, 1, nil, 60)
				end
			end

			if not builder:KnowsRecipe(farm)then
				lootChance(farm.."_blueprint", famrblueprint_ratio)
			else
				local soul = animalsouls[data.victim]
				lootChance(soul, farmsoul_ratio)
			end

			if not builder:KnowsRecipe("zxfarmhatch")then
				lootChance("zxfarmhatch_blueprint", famrblueprint_ratio)
			end

			if not builder:KnowsRecipe("zxfarmbowl") then
				lootChance("zxfarmbowl_blueprint", famrblueprint_ratio)
			end
		end
	end		
end


AddPlayerPostInit(function (inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:ListenForEvent("killed", dropFarmItems)
	end
end)