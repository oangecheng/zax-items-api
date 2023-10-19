

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
        Asset("ANIM", "anim/beefalo_actions_domestic.zip"),
        Asset("ANIM", "anim/beefalo_actions_quirky.zip"),
        Asset("ANIM", "anim/beefalo_build.zip"),
        Asset("ANIM", "anim/beefalo_shaved_build.zip"),
        Asset("ANIM", "anim/beefalo_baby_build.zip"),
        Asset("ANIM", "anim/beefalo_domesticated.zip"),
        Asset("ANIM", "anim/beefalo_personality_docile.zip"),
        Asset("ANIM", "anim/beefalo_personality_ornery.zip"),
        Asset("ANIM", "anim/beefalo_personality_pudgy.zip"),
        Asset("ANIM", "anim/beefalo_skin_change.zip"),
        Asset("ANIM", "anim/beefalo_carrat_idles.zip"),
        Asset("ANIM", "anim/yotc_carrat_colour_swaps.zip"),
        Asset("ANIM", "anim/beefalo_carry.zip"),
        Asset("ANIM", "anim/beefalo_fx.zip"),
        Asset("ANIM", "anim/poop_cloud.zip"),
        Asset("SOUND", "sound/beefalo.fsb"),
        Asset("MINIMAP_IMAGE", "beefalo_domesticated"),
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



local def  = {}
def.zxperd    = farmperd
def.zxpigman  = farmpigman
def.zxbeefalo = farmbeefalo
return def