
local famrblueprints = {
    ["perd"] = "zxperdfarm",
    ["pigman"] = "zxpigmanfarm",
    ["beefalo"] = "zxbeefalofarm",
    ["lightninggoat"] = "zxgoatfarm"
}

local animalsouls = {
   ["perd"] = "zxperd_soul",
   ["pigman"] = "zxpigman_soul",
   ["beefalo"] = "zxbeefalo_soul",
   ["lightninggoat"] = "zxgoat_soul",
}

local famrblueprint_ratio = ZXTUNING.DEBUG and 0.8 or 0.2 * ZXTUNING.FRAM_DROP_RATIO
local farmsoul_ratio = ZXTUNING.DEBUG and 0.8 or 0.1 * ZXTUNING.FRAM_DROP_RATIO

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
               local soul = animalsouls[data.victim.prefab]
               lootChance(soul, farmsoul_ratio)
               
               if not builder:KnowsRecipe("zxfarmhatch")then
                   lootChance("zxfarmhatch_blueprint", famrblueprint_ratio)
               end
   
               if not builder:KnowsRecipe("zxfarmbowl") then
                   lootChance("zxfarmbowl_blueprint", famrblueprint_ratio)
               end
           end	
       end
   end		
end


AddPlayerPostInit(function (inst)
   if GLOBAL.TheWorld.ismastersim then
       inst:ListenForEvent("killed", dropFarmItems)
   end
end)