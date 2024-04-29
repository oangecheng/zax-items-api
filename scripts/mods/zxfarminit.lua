
local VICTIM_DROP = {
    perd             = { farm = "zxperdfarm", },
    beefalo          = { farm = "zxbeefalofarm" },
    catcoon          = { farm = "zxcatfarm" },

    pigman           = {
        farm  = "zxpigmanfarm",
        ratiofn = function(inst)
            return inst:HasTag("werepig") and 0.25 or 0.1
        end
    },

    lightninggoat    = {
        farm  = "zxgoatfarm",
        ratiofn = function(inst)
            return inst:HasTag("charged") and 0.25 or 0.1
        end
    },

    koalefant_winter = {
        farm    = "zxkoalefantfarm",
        ratiofn = function(inst)
            return 0.25
        end
    },

    spiderqueen = {
        farm = "zxspiderfarm",
        ratiofn = function (_)
            return 0.5
        end
    },

    warg = {
        farm = "zxhoundfarm",
        ratiofn = function ()
            return 0.5
        end
    },

    tallbird = {
        farm = "zxtallbirdfarm",
        ratiofn = function ()
            return 0.25
        end
    }
}




---概率掉落
---@param prefab string|nil
---@param chance number 概率
---@param inst table 玩家
---@param victim table 怪物
local function dropByRatio(prefab, chance, inst, victim)
    if prefab and math.random() <= chance then
        if inst.components.zxusergiver then
            inst.components.zxusergiver:Give(prefab)
        end
    end
end



local function dropFarmItems(inst, data)

    local victim = data.victim
    local fdrop = victim and VICTIM_DROP[victim.prefab]
    local builder = inst.components.builder
    if not (fdrop and builder) then
        return
    end

    local farm   = fdrop.farm
    local _rfarm = (fdrop.ratiofn and fdrop.ratiofn(victim) or 0.1) * ZXTUNING.FRAM_DROP_RATIO
    _rfarm = ZXTUNING.DEBUG and 1 or math.min(0.5, _rfarm)

    if not builder:KnowsRecipe(farm) then
        dropByRatio(farm.."_blueprint", _rfarm, inst, victim)
    end
end



AddPlayerPostInit(function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:ListenForEvent("killed", dropFarmItems)
        inst:AddComponent("zxusergiver")
    end
end)


local ITEMS = require "defs/zxitemdefs"


for _, v in ipairs(ITEMS.upgrade.all) do
	AddPrefabPostInit(v, function (inst)
		inst:AddTag(ZXTAGS.UP_ITEM)
	end)
end


for k, _ in pairs(ITEMS.foods.all) do
	AddPrefabPostInit(k, function (inst)
		inst:AddTag("ZXFARM_FOOD")
	end)
end