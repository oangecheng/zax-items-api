local ASSETSDEF = require "defs/animalassets"

local BASE_TIME = ZXTUNING.DEBUG and 60 or TUNING.TOTAL_DAY_TIME * 2.5
local TYPES = ZXFARM.ANIMAL_TYPES


local function getAnimalType(inst)
    return inst.components.zxanimal:GetType()
end



local perddata = {
    sg = "SGperd",
    assets = ASSETSDEF.perd,
    anim = {
        bank = "perd",
        build = "perd",
        idle = "idle_loop",
        size = 0.4
    },

    initfunc = function (inst, ismastersim)
        inst.Transform:SetFourFaced()
    end,

    speed = 2,
    loots = { "drumstick", "zxperd_soul" },

    foodnum = 2,
    producetime = BASE_TIME,
    producefn = function (inst)
        local items = {
            bird_egg  = { w = 9, num = 1 },
            drumstick = { w = 9, num = 1 }
        }
        --- 肉鸡产肉，蛋鸡产蛋
        --- 普通鸡各50%概率
        local t = getAnimalType(inst)
        if t == TYPES.EGG then
            items.drumstick.w = 0
        elseif t == TYPES.MEAT then
            items.bird_egg.w = 0
        end
        local it,cnt = ZxGetRandomItem(items)
        return { [it] = cnt }
    end
}




local pigdata = {
    assets = ASSETSDEF.pigman,
    anim = {
        bank = "pigman",
        build = "pig_build",
        idle = "idle_loop",
        size = 0.4
    },

    initfunc = function (inst, ismastersim)
        inst.Transform:SetFourFaced()
    end,

    speed = 2,
    loots = { "meat", "zxpigman_soul" },

    foodnum = 2,
    producetime = BASE_TIME * 1.5,
    producefn = function(inst)
        local items = {
            meat    = { w = 9, num = 1 },
            pigskin = { w = 9, num = 1 }
        }
        --- 肉猪产肉，皮毛猪产猪皮
        --- 普通猪各50%概率
        local t = getAnimalType(inst)
        if t == TYPES.FUR then
            items.meat.w = 0
        elseif t == TYPES.MEAT then
            items.pigskin.w = 0
        end
        local it, cnt = ZxGetRandomItem(items)
        -- 25%概率额外获得一个便便
        local poopcnt = math.random() < 0.25 and 1 or 0
        return {
            [it] = cnt,
            poop = poopcnt
        }
    end
}


local beefalodata = {
    assets = ASSETSDEF.beefalo,
    anim = {
        bank = "beefalo",
        build = "beefalo_build",
        idle = "idle_loop",
        size = 0.4
    },
    initfunc = function (inst)
        inst.AnimState:Hide("HEAT")
        inst.Transform:SetSixFaced()
    end,

    speed = 1,
    loots = { "meat", "zxbeefalo_soul" },

    producetime = BASE_TIME * 2,
    producefn = function(inst)
        local items = {
            meat    = { w = 4, num = 1 },
            beefalowool = { w = 6, num = 1 },
        }
        --- 肉牛产肉，毛牛产毛
        --- 普通牛各60%概率产毛，40%概率产肉
        local t = getAnimalType(inst)
        if t == TYPES.FUR then
            items.meat.w = 0
        elseif t == TYPES.MEAT then
            items.pigskin.w = 0
        end
        local it, cnt = ZxGetRandomItem(items)
        -- 25%概率额外获得一个便便
        local poopcnt = math.random() < 0.25 and 1 or 0
        return {
            [it] = cnt,
            poop = poopcnt
        }
    end
}


return {
    zxperd = perddata,
    zxpigman = pigdata,
    zxbeefalo = beefalodata,   
}