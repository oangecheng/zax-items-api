local ASSETSDEF = require "defs/animalassets"

local BASE_TIME = ZXTUNING.DEBUG and 30 or TUNING.TOTAL_DAY_TIME * 2.5
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

    types = { TYPES.EGG, TYPES.MEAT },
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

    types = { TYPES.FUR, TYPES.MEAT },
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

    types = { TYPES.FUR, TYPES.MEAT },
    foodnum = 2,
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


local goatdata = {
    sg = "ZxGoatSG",
    assets = ASSETSDEF.lightninggoat,
    anim = {
        bank = "lightning_goat",
        build = "lightning_goat_build",
        idle = "idle_loop",
        size = 0.4
    },
    initfunc = function (inst)
        inst.Transform:SetFourFaced()
        inst.AnimState:Hide("fx")
    end,

    speed = 1,
    loots = { "meat", "zxgoat_soul" },

    types = { TYPES.MILK, TYPES.MEAT },
    foodnum = 3,
    producetime = BASE_TIME * 3,
    producefn = function (inst)
        local items = {
            meat = { w = 7, num = 1 },
            lightninggoathorn = { w = 2, num = 1 },
            goatmilk = { w = 0, num = 1 }
        }

        if TheWorld.state.israining and TheWorld.state.isspring then
            items.goatmilk.w = 1
        end

        local t = getAnimalType(inst)
        if t == TYPES.MEAT then
           items.lightninggoathorn.w = 0
        elseif t == TYPES.MILK then
            items.meat.w = 0
        end

        local it, cnt = ZxGetRandomItem(items)
        return {
            [it] = cnt
        }
    end
}



local koalefantfn = function (iswinter)
    local build = iswinter and "koalefant_winter_build" or "koalefant_summer_build"
    local soul  = iswinter and "zxkoalefant_w_soul" or "zxkoalefant_s_soul"

    return {
        assets = ASSETSDEF.koalefant,
        anim = {
            bank = "koalefant",
            build = build,
            idle = "idle_loop",
            size = 0.4
        },
        initfunc = function (inst)
            inst.Transform:SetSixFaced()
        end,

        speed = 1,
        loots = { "meat", soul },

        foodnum = 5,
        producetime = BASE_TIME * 3,
        producefn = function (inst)
            local truck = iswinter and "trunk_winter" or "trunk_summer"
            local items = {
                meat = { w = 7, num = 1 },
                [truck] = { w = 3, num = 1}
            }
            local it, cnt = ZxGetRandomItem(items)
            return {
                [it] = cnt
            }
        end
    }
end



local catdata = {
    assets = ASSETSDEF.cat,
    anim = {
        bank  = "kitcoon",
        build = "kitcoon_yot" .. "_build",
        idle  = "idle_loop",
        size  = 1,
    },
    initfunc = function(inst)
        inst.Transform:SetSixFaced()
    end,

    speed = 1,
    loots = { "meat", "zxcat_soul" },

    foodnum = 2,
    producetime = BASE_TIME * 1.5,
    producefn = function(inst, host)
        --- 掉黄油初始概率为10%
        local r = 0.1
        local x, _, z = host.Transform:GetWorldPosition()
        if x and z and host.radius then
            --- 农场范围内种花，可以提升概率，最高能提升10%
            local ents = TheSim:FindEntities(x, 0, z, host.radius, { "flower" })
            if ents then
                r = r + math.min(#ents * 0.01, 0.1)
            end
        end

        if math.random() <= r then
            return { butter = 1 }
        else
            local catproducts = {
                --各种鸟的羽毛
                feather_crow = 1,
                feather_robin = 1,
                feather_robin_winter = 1,
                feather_canary = 1,
                boneshard = 1,
            }
            --- 开了勋章，加入鱼骨
            if ZXIsMedal() then
                catproducts.medal_fishbones = 1
            end
            local item, num = GetRandomItemWithIndex(catproducts)
            return { [item] = num }
        end
    end
}


local hounds = {
    hound     = { build = "hound_ocean",     loots = { "zxhound_soul" } },
    houndfire = { build = "hound_red_ocean", loots = { "zxhound_fire_soul" } },
    houndice  = { build = "hound_ice_ocean", loots = { "zxhound_ice_soul" } }
}
local houndfn = function (hound)
    local build = hounds[hound].build
    local loots = hounds[hound].loots

    return {
        sg = "ZxHoundSG",
        assets = ASSETSDEF.hound,
        anim = {
            bank = "hound",
            build = hounds[hound].build,
            idle = "idle",
            size = 0.6
        },
        initfunc = function(inst)
            inst.Transform:SetFourFaced()
        end,

        speed = 2.5,
        loots = loots,

        foodnum = 3,
        producetime = BASE_TIME * 1.5,
        producefn = function(inst)
            if hound == "houndfire" and math.random() < 0.1 then
                return { redgem = 1 }
            elseif hound == "houndice" and math.random() < 0.1 then
                return { bluegem = 1 }
            else
                return { houndstooth = 2 }
            end
        end
    }
end





local userfns =   {
    FollowLeader = function (_) end,
    GetPeepChance = function (_) return 0.1 end,
    SpawnTeen = function (_) end,
    SpawnAdult = function (_) end,
}
local smallbirddata = {
    sg = "SGsmallbird",
    assets = ASSETSDEF.smallbird,
    anim = {
        bank = "smallbird",
        build = "smallbird_basic",
        idle = "idle",
        size = 0.9,
    },
    initfunc = function (inst, ismaster)
        inst.Transform:SetFourFaced()
        if ismaster then
            inst.userfunctions = userfns
        end
    end,
    

    speed = 1,
    loots = {"meat", "zxtallbird_soul" },

    foodnum = 4,
    producetime = BASE_TIME * 3,
    producefn = function (inst)
        if math.random() <= 0.1 then
            return { tallbirdegg =  1}
        else
            return { meat = 1}
        end
    end
}



local spiderbuilds = {
    spider         = "spider_build",
    spider_warrior = "spider_warrior_build",
    spider_dropper = "spider_white",
    spider_healer  = "spider_wolf_build"
}


local function spiderfn(spidername)
    local build = spiderbuilds[spidername]
    local loots = { "monstermeat", "zx"..spidername.."_soul" }

    return {
        sg = "SGzxspider",
        assets = ASSETSDEF[spidername],
        anim = {
            bank = "spider",
            build = build,
            idle = "idle",
            size = 0.8
        },
        initfunc = function (inst)
            inst.Transform:SetFourFaced()
        end,

        speed = 1,
        loots = loots,

        foodnum = 2,
        producetime = BASE_TIME,
        producefn = function (inst, host)
            if spidername == "spider_healer" then
                return { spidergland = 2 }
            else
                return math.random() < 0.7 and { silk = 2 } or { spidergland = 2 }
            end
        end
    }
end



return {
    zxperd = perddata,
    zxpigman = pigdata,
    zxbeefalo = beefalodata,
    zxgoat = goatdata,
    zxtallbird = smallbirddata,
    zxcat = catdata,

    zxkoalefant_w = koalefantfn(true),
    zxkoalefant_s = koalefantfn(false),

    zxhound = houndfn("hound"),
    zxhound_fire = houndfn("houndfire"),
    zxhound_ice = houndfn("houndice"),

    zxspider = spiderfn("spider"),
    zxspider_warrior = spiderfn("spider_warrior"),
    zxspider_dropper = spiderfn("spider_dropper"),
    zxspider_healer = spiderfn("spider_healer"),

}
