

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
        idle = "idle_loop",
        size = 0.7,
    },

    walkspeed = 1,
    sound = nil,
    loots = { "meat", "zxcat_soul" },

    producefn = function(inst, host)
        local x, _, z = host.Transform:GetWorldPosition()
        --- 掉黄油初始概率为5%
        local rbutter = 0.05
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
        --- 随机一个物品
        local item, num = GetRandomItemWithIndex(catproducts)
        return { item, num }
    end
}




local def  = {}
def.zxperd    = farmperd
def.zxpigman  = farmpigman
def.zxbeefalo = farmbeefalo
def.zxgoat    = farmgoat
def.zxcat     = farmcat
def.zxkoalefant_w = farmKoalefant(true)
def.zxkoalefant_s = farmKoalefant(false)

return def