
local FARM_R = ZXTUNING.DEBUG and 0.8 or 0.2 * ZXTUNING.FRAM_DROP_RATIO
local SOUL_R = ZXTUNING.DEBUG and 0.8 or 0.1 * ZXTUNING.FRAM_DROP_RATIO

local drop = {
    perd             = { animal = "zxperd", },
    beefalo          = { animal = "zxbeefalo" },
    catcoon          = { animal = "zxcat" },

    pigman           = {
        animal  = "zxpigman",
        ratiofn = function(inst)
            return inst:HasTag("werepig") and 0.25 or 0
        end
    },

    lightninggoat    = {
        animal  = "zxgoat",
        ratiofn = function(inst)
            return inst:HasTag("charged") and 0.25 or 0
        end
    },

    koalefant_winter = {
        animal  = "zxkoalefant_w",
        farm    = "zxkoalefantfarm",
        ratiofn = function(inst)
            return 0.2
        end
    },

    koalefant_summer = {
        animal  = "zxkoalefant_s",
        farm    = "zxkoalefantfarm",
        ratiofn = function(inst)
            return 0.2
        end
    },

    spider = {
        animal = "zxspider",
        farm   = "zxspiderfarm",
    },
    spider_warrior = {
        animal = "zxspider_warrior",
        farm   = "zxspiderfarm",
    },
    spider_dropper = {
        animal = "zxspider_dropper",
        farm   = "zxspiderfarm",
    },
    spider_healer = {
        animal = "zxspider_healer",
        farm   = "zxspiderfarm",
    },

    hound = {
        animal = "zxhound",
        farm   = "zxhoundfarm",
    },
    firehound = {
        animal = "zxhound_fire",
        farm   = "zxhoundfarm",
    },
    icehound = {
        animal = "zxhound_ice",
        farm   = "zxhoundfarm",
    },

    tallbird = {
        animal = "zxtallbird",
        farm   = "zxtallbirdfarm",
        ratiofn = function(inst)
            return 0.1
        end
    }
}


local otherbuildings = {
    "zxfarmhatch",
    "zxfarmbowl" ,
}


---概率掉落
---@param prefab string|nil
---@param chance number 概率
---@param inst table 玩家
---@param victim table 怪物
local function dropByRatio(prefab, chance, inst, victim)
    if prefab and math.random() <= chance then
        local ent = SpawnPrefab(prefab)
        if ent then
            LaunchAt(ent, victim, inst, 1, 1, nil, 60)
        end
    end
end



local function dropFarmItems(inst, data)

    local victim = data.victim
    local fdrop = victim and drop[victim.prefab]
    local builder = inst.components.builder
    if not (fdrop and builder) then
        return
    end

    local farm = fdrop.farm or fdrop.animal.."farm"
    local extraratio = fdrop.ratiofn and fdrop.ratiofn(victim) or 0
    local _rfarm = FARM_R + extraratio

    if not builder:KnowsRecipe(farm) then
        dropByRatio(farm.."_blueprint", _rfarm, inst, victim)
        return
    end

    local soul = fdrop.animal.."_soul"
    local _rsoul = SOUL_R + extraratio
    dropByRatio(soul, _rsoul, inst, victim)

    for _, v in ipairs(otherbuildings) do
        if not builder:KnowsRecipe(v) then
            dropByRatio(v.."_blueprint", _rfarm, inst, victim)
        end
    end
end



AddPlayerPostInit(function (inst)
   if GLOBAL.TheWorld.ismastersim then
       inst:ListenForEvent("killed", dropFarmItems)
   end
end)


local ITEMS = require "defs/zxitemdefs"


for _, v in ipairs(ITEMS.upgrade.all) do
	AddPrefabPostInit(v, function (inst)
		inst:AddTag("ZXUPGRADE_MATERIAL")
	end)
end

for k, v in pairs(ITEMS.accelerate) do
	AddPrefabPostInit(k, function (inst)
		inst:AddTag("ZXACCELERATE_MATERIAL")
	end)
end


for k, _ in pairs(ITEMS.foods.all) do
	AddPrefabPostInit(k, function (inst)
		inst:AddTag("ZXFARM_FOOD")
	end)
end