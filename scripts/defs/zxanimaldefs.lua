

local farmperd = {
    assets = {
        Asset("ANIM", "anim/perd_basic.zip"),
        Asset("ANIM", "anim/perd.zip"),
        Asset("SOUND", "sound/perd.fsb"),
    },

    initfunc = function (inst)
        inst.Transform:SetFourFaced()
    end,

    anim = {
        bank = "perd",
        build = "perd",
        idle = "idle_loop",
        size = ZXTUNING.ZXPERD_SIZE,
    },


    walkspeed = 2,
    sound = "dontstarve/creatures/perd/gobble",
    loots = {
        "drumstick",
        "drumstick",
        "zxperd_soul"
    },

    producefn = function (inst)
        if math.random() <= 0.5 then
            return { "drumstick", 1 }
        else 
            return { "bird_egg", 1 }
        end
    end
}



local farmpigman = {
    assets = {
        Asset("ANIM", "anim/ds_pig_basic.zip"),
        Asset("ANIM", "anim/ds_pig_actions.zip"),
        Asset("SOUND", "sound/pig.fsb"),
    },

    initfunc = function (inst)
        inst.Transform:SetFourFaced()
    end,


    anim = {
        bank = "pigman",
        build = "pig_build",
        idle = "idle_loop",
        size = ZXTUNING.ZXPIGMAN_SIZE,
    },

    walkspeed = 2,
    sound = "dontstarve/pig/grunt",
    loots = {
        "meat",
        "pigskin",
        "zxpigman_soul"
    },

    producefn = function(inst)
        -- 月圆的时候，必然生产2个猪皮
        if TheWorld.state.isfullmoon then return { "pigskin", 2 } end
        if math.random() <= 0.5 then
            return { "pigskin", 1 }
        else
            return { "meat", 1 }
        end
    end
}



local farmbeefalo = {

    assets = {
        Asset("ANIM", "anim/beefalo_basic.zip"),
        Asset("ANIM", "anim/beefalo_actions.zip"),
        Asset("SOUND", "sound/beefalo.fsb"),
    },

    initfunc = function (inst)
        inst.Transform:SetSixFaced()
    end,

    anim = {
        bank = "beefalo",
        build = "beefalo_build",
        idle = "idle_loop",
        size = ZXTUNING.ZXBEEFALO_SIZE,
        extrafunc = function (inst)
            inst.AnimState:Hide("HEAT")
        end
    },

    walkspeed = 1,
    sound = "dontstarve/beefalo/yell",
    loots = {
        "beefalowool",
        "beefalowool",
        "meat",
        "zxbeefalo_soul"
    },

    producefn = function (inst)
        -- 春天有百分之10的概率生产一个牛角
        if TheWorld.state.isspring then
            if math.random() <= 0.1 then
                return {"horn", 1}
            end
        end

        if math.random() <= 0.7 then
            return {"beefalowool", 4}
        else
            return { "meat", 1 }
        end 
    end
}




local farmgoat = {

    assets = {
        Asset("ANIM", "anim/lightning_goat_build.zip"),
        Asset("ANIM", "anim/lightning_goat_shocked_build.zip"),
        Asset("ANIM", "anim/lightning_goat_basic.zip"),
        Asset("ANIM", "anim/lightning_goat_actions.zip"),
        Asset("SOUND", "sound/lightninggoat.fsb"),
    },

    initfunc = function (inst)
        inst.Transform:SetFourFaced()
    end,
    sg = "ZxGoatSG",
    anim = {
        bank = "lightning_goat",
        build = "lightning_goat_build",
        idle = "idle_loop",
        size = ZXTUNING.ZXBEEFALO_SIZE,
        extrafunc = function (inst)
            inst.AnimState:Hide("fx")
        end
    },

    walkspeed = 1,
    sound = "dontstarve_DLC001/creatures/lightninggoat/jacobshorn",
    loots = {
        "meat",
        "meat",
        "zxgoat_soul"
    },

    producefn = function (inst)
        -- 春天下雨的时候有百分之10的概率生产一个奶
        if TheWorld.state.israining and TheWorld.state.isspring then
            if math.random() <= 0.3 then
                return {"goatmilk", 1}
            end
        end
        if math.random() <= 0.5 then
            return { "lightninggoathorn", 1}
        else
            return { "meat", 1}
        end
    end
}


local function farmKoalefant(iswinter)

    local build = iswinter and "koalefant_winter_build" or "koalefant_summer_build"
    local soul  = iswinter and "zxkoalefant_w_soul" or "zxkoalefant_s_soul"

    return {
        assets = {
            Asset("ANIM", "anim/koalefant_basic.zip"),
            Asset("ANIM", "anim/koalefant_actions.zip"),
            Asset("ANIM", "anim/koalefant_winter_build.zip"),
            Asset("ANIM", "anim/koalefant_summer_build.zip"),
            Asset("SOUND", "sound/koalefant.fsb"),
        },
    
        initfunc = function (inst)
            inst.Transform:SetSixFaced()
        end,
    
        anim = {
            bank = "koalefant",
            build = build,
            idle = "idle_loop",
            size = ZXTUNING.ZXKOALEFANT_SIZE,
        },
    
        walkspeed = 1,
        sound = nil,
        loots = { "meat", "meat", soul },

        producefn = function (inst)
            local r = math.random()
            if iswinter then
                if r <= (TheWorld.state.iswinter and 0.5 or 0.3)  then
                    return { "trunk_winter", 1} 
                end
            else
                if r <= (TheWorld.state.issummer and 0.5 or 0.3)  then
                    return { "trunk_summer", 1} 
                end
            end
            return { "meat", 1}
        end
    }
end 



-- local catsname = {
--     kitcoon_forest = false,
--     kitcoon_savanna = false,
--     kitcoon_deciduous = false,
--     kitcoon_marsh = false,
--     kitcoon_grass = false,
--     kitcoon_rocky = false,
--     kitcoon_desert = false,
--     kitcoon_moon = false,
--     kitcoon_yot = false,
-- }

--- 用年猫的贴图，浣猫的贴图需要改sg，麻烦
--- 后面有时间改成9个小猫的图
local catproducts = { 
    --各种鸟的羽毛
    feather_crow = 1, 
    feather_robin = 1, 
    feather_robin_winter = 1,
    feather_canary = 1,
    boneshard = 1,
}
local farmcat = {
     assets = {
	    Asset("ANIM", "anim/".."kitcoon_yot".."_build.zip"),
	    Asset("ANIM", "anim/kitcoon_basic.zip"),
    },
    initfunc = function (inst)
        inst.Transform:SetSixFaced()
    end,

    anim = {
        bank  = "kitcoon",
        build = "kitcoon_yot".."_build",
        idle  = "idle_loop",
        size  = ZXTUNING.ZXCAT_SIZE,
    },

    walkspeed = 1,
    sound = nil,
    loots = { "meat", "zxcat_soul" },

    producefn = function(inst, host)
        local x, _, z = host.Transform:GetWorldPosition()
        --- 掉黄油初始概率为10%
        local rbutter = 0.1
        if x and z and host.radius then
            --- 农场范围内种花，可以提升概率，最高能提升10%
            local ents = TheSim:FindEntities(x, 0, z, host.radius, { "flower" })
            if ents then
                rbutter = rbutter + math.min(#ents * 0.01, 0.1)
            end
        end

        if math.random() <= rbutter then
            return { "butter", 1 }
        end
        --- 随机一个物品,开了勋章，骨头会变成鱼骨
        local item, num = GetRandomItemWithIndex(catproducts)
        if item == "boneshard" and ZXIsMedal() then
            item = "medal_fishbones"
        end
        return { item, num }
    end
}




local houndassets = {
    Asset("ANIM", "anim/hound_basic.zip"),
    Asset("ANIM", "anim/hound_basic_water.zip"),
    Asset("ANIM", "anim/hound.zip"),
    Asset("ANIM", "anim/hound_ocean.zip"),
    Asset("PKGREF", "anim/hound_red.zip"),
    Asset("ANIM", "anim/hound_red_ocean.zip"),
    Asset("PKGREF", "anim/hound_ice.zip"),
    Asset("ANIM", "anim/hound_ice_ocean.zip"),
    Asset("ANIM", "anim/hound_mutated.zip"),
    Asset("ANIM", "anim/hound_hedge_ocean.zip"),
    Asset("ANIM", "anim/hound_hedge_action.zip"),
    Asset("ANIM", "anim/hound_hedge_action_water.zip"),
    Asset("SOUND", "sound/hound.fsb"),
}

local hounds = {
    hound =  {
        build = "hound_ocean",
        loots = { "zxhound_soul" }
    },

    houndfire = {
        build = "hound_red_ocean",
        loots = { "zxhound_fire_soul" }
    },

    houndice = {
        build = "hound_ice_ocean",
        loots = { "zxhound_ice_soul" }
    }
}

local function houndfn(hound)
    return {
        assets = houndassets,
        sg = "ZxHoundSG",
        anim = {
            bank = "hound",
            build = hounds[hound].build,
            idle = "idle",
            size = ZXTUNING.ZXHOUND_SIZE
        },
        initfunc = function (inst)
            inst.Transform:SetFourFaced()
        end,
        walkspeed = 1,
        sound = nil,
        loots = hounds[hound],
        producefn = function (inst, host)
            return {
                "houndstooth", 2
            }
        end
    }
end



local farmtallbird = {

    assets = {
        Asset("ANIM", "anim/smallbird_basic.zip"),
    },

    initfunc = function (inst)
        inst.Transform:SetFourFaced()
    end,
    sg = "SGsamllbird",
    anim = {
        bank = "smallbird",
        build = "smallbird_basic",
        idle = "idle",
        size = ZXTUNING.ZXTALLBIRD_SIZE,
    },

    walkspeed = 1,
    sound = nil,
    loots = {
        "meat",
        "zxtallbird_soul"
    },

    producefn = function (inst)
        if math.random() <= 0.1 then
            return { "tallbirdegg", 1}
        else
            return { "meat", 1}
        end
    end
}



local spidersassets = {
    zxspider = {
        Asset("ANIM", "anim/ds_spider_basic.zip"),
        Asset("ANIM", "anim/spider_build.zip"),
        Asset("ANIM", "anim/ds_spider_boat_jump.zip"),
        Asset("SOUND", "sound/spider.fsb"),
    },
    zxspider_warrior = {
        Asset("ANIM", "anim/ds_spider_basic.zip"),
        Asset("ANIM", "anim/ds_spider_warrior.zip"),
        Asset("ANIM", "anim/spider_warrior_build.zip"),
        Asset("SOUND", "sound/spider.fsb"),
    },
    zxspider_dropper = {
        Asset("ANIM", "anim/ds_spider_basic.zip"),
        Asset("ANIM", "anim/ds_spider_warrior.zip"),
        Asset("ANIM", "anim/spider_white.zip"),
        Asset("SOUND", "sound/spider.fsb"),
    },
    zxspider_healer = {
        Asset("ANIM", "anim/ds_spider_cannon.zip"),
        Asset("ANIM", "anim/spider_wolf_build.zip"),
        Asset("SOUND", "sound/spider.fsb"),
    }
}

local spiders = {
    zxspider = { "spider", "spider_build" },
    zxspider_warrior = { "spider", "spider_warrior_build" },
    zxspider_dropper = { "spider", "spider_white" },
    zxspider_healer = { "spider", "spider_wolf_build", }
}


local function spiderfn(spider)
    local asts = spidersassets[spider]
    local bank = spiders[spider][1]
    local build = spiders[spider][2]
    local loots = { "monstermeat", spider.."_soul" }

    return {
        assets = asts,
        sg = "SGspider",
        anim = {
            bank = bank,
            build = build,
            idle = "idle",
            size = ZXTUNING.ZXSPIDER_SIZE
        },
        initfunc = function (inst)
            inst.Transform:SetFourFaced()
        end,
        walkspeed = 1,
        sound = nil,
        loots = loots,
        producefn = function (inst, host)
            return {
                "silk", 2
            }
        end
    }
end


local def  = {}
def.zxperd    = farmperd
def.zxpigman  = farmpigman
def.zxbeefalo = farmbeefalo
def.zxgoat    = farmgoat
def.zxcat     = farmcat
def.zxkoalefant_w = farmKoalefant(true)
def.zxkoalefant_s = farmKoalefant(false)
def.zxhound = houndfn("hound")
def.zxhound_fire = houndfn("houndfire")
def.zxhound_ice = houndfn("houndice")
def.zxspider = spiderfn("zxspider")
def.zxspider_warrior = spiderfn("zxspider_warrior")
def.zxspider_dropper = spiderfn("zxspider_dropper")
def.zxspider_healer = spiderfn("zxspider_healer")


return def