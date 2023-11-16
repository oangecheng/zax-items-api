
local BLUEPRINTS = {
    ["perd"] = "zxperdfarm",
    ["pigman"] = "zxpigmanfarm",
    ["beefalo"] = "zxbeefalofarm",
    ["lightninggoat"] = "zxgoatfarm"
}

local SOULS = {
   ["perd"] = "zxperd_soul",
   ["pigman"] = "zxpigman_soul",
   ["beefalo"] = "zxbeefalo_soul",
   ["lightninggoat"] = "zxgoat_soul",
}

local rfarm = ZXTUNING.DEBUG and 0.8 or 0.2 * ZXTUNING.FRAM_DROP_RATIO
local rsoul = ZXTUNING.DEBUG and 0.8 or 0.1 * ZXTUNING.FRAM_DROP_RATIO


---概率掉落
---@param prefab string|nil
---@param chance number 概率
---@param inst table 玩家
---@param victim table 怪物
---@param blueprint boolean 是否是蓝图
local function dropByRatio(prefab, chance, inst, victim, blueprint)
    if prefab and math.random() <= chance then
        local item = blueprint and prefab.."_blueprint" or prefab
        local ent = SpawnPrefab(item)
        if ent then
            LaunchAt(ent, victim, inst, 1, 1, nil, 60)
        end
    end
end

local function dropFarmItems(inst, data)
    local victim = data.victim
    local farm = victim and BLUEPRINTS[victim.prefab]
    local builder = inst.components.builder

    if not (farm and builder) then
        return
    end

    if not builder:KnowsRecipe(farm) then
        dropByRatio(farm, rfarm, inst, victim, true)
        return
    end

    local _rsoul = rsoul
    --- 电羊+50%
    if inst:HasTag("charged") then
        _rsoul = _rsoul + 0.5
    end
    --- 疯猪+20%
    if inst:HasTag("werepig") then
        _rsoul = _rsoul + 0.25
    end
    dropByRatio(SOULS[victim.prefab], _rsoul, inst, victim, false)

    if not builder:KnowsRecipe("zxfarmhatch") then
        dropByRatio("zxfarmhatch", rfarm, inst, victim, true)
    end

    if not builder:KnowsRecipe("zxfarmbowl") then
        dropByRatio("zxfarmbowl", rfarm, inst, victim, true)
    end
end



AddPlayerPostInit(function (inst)
   if GLOBAL.TheWorld.ismastersim then
       inst:ListenForEvent("killed", dropFarmItems)
   end
end)