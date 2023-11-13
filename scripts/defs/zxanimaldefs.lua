

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
    }
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
    }
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
    }
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
    }
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
        loots = { "meat", "meat", soul }
    }
end 






local def  = {}
def.zxperd      = farmperd
def.zxpigman    = farmpigman
def.zxbeefalo   = farmbeefalo
def.zxgoat      = farmgoat
def.zxkoalefant_w = farmKoalefant(true)
def.zxkoalefant_s = farmKoalefant(false)

return def