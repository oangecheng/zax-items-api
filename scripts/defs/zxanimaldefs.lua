

local farmperd = {
    assets = {
        Asset("ANIM", "anim/perd_basic.zip"),
        Asset("ANIM", "anim/perd.zip"),
        Asset("SOUND", "sound/perd.fsb"),
    },

    anim = {
        bank = "perd",
        build = "perd",
        idle = "idle_loop"
    },
}



local farmpig = {
    assets = {
        Asset("ANIM", "anim/ds_pig_basic.zip"),
        Asset("ANIM", "anim/ds_pig_actions.zip"),
        Asset("ANIM", "anim/ds_pig_attacks.zip"),
        Asset("ANIM", "anim/ds_pig_boat_jump.zip"),
        Asset("ANIM", "anim/pig_build.zip"),
        Asset("ANIM", "anim/pigspotted_build.zip"),
        Asset("ANIM", "anim/pig_guard_build.zip"),
        Asset("ANIM", "anim/pigman_yotb.zip"),
        Asset("ANIM", "anim/werepig_build.zip"),
        Asset("ANIM", "anim/werepig_basic.zip"),
        Asset("ANIM", "anim/werepig_actions.zip"),
        Asset("ANIM", "anim/pig_token.zip"),
        Asset("SOUND", "sound/pig.fsb"),
        Asset("ANIM", "anim/merm_actions.zip"),
    },

    anim = {
        bank = "pigman",
        build = "pig_build",
        idle = "idle_loop"
    },
}



local farmcow = {

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

    anim = {
        bank = "beefalo",
        build = "beefalo_build",
        idle = "idle_loop"
    },

    face = 6;
}



local def  = {}
def.zxfarmperd = farmperd
def.zxfarmpig = farmpig
def.zxfarmcow = farmcow
return def