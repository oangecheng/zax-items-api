local isdebug = true

ZXTUNING = {
    DEBUG = isdebug,
    IS_CH = true,
    LIGHT_RADIUS_MULTI = 1,
    BOX_FRESH_RATE = 0.2,

    --农场动物尺寸
    ZXPERD_SIZE = 0.4,
    ZXPIGMAN_SIZE = 0.4,
    ZXBEEFALO_SIZE = 0.4,
    ZXGOAT_SIZE = 0.4,
    ZXKOALEFANT_SIZE = 0.4,

    ---农场配置
    FARM_ENABLE = true,
    FARM_AREA = 1,
    FRAM_DROP_RATIO = 1,
    FARM_MAX_LV = 3,

    FOOD_MAX_NUM = 120,

    ---基础加速时间1小时
    ACCELERATE_TIME = isdebug and 60 or TUNING.TOTAL_DAY_TIME * 7.5
}


ZXEVENTS = {
    FARM_ITEM_BUILD = "ZXFRAM_ITEM_BUILD",
    FARM_ADD_FOOD = "ZXFRAM_ADD_FOOD",
    FARM_HATCH_FINISHED = "ZXFARM_HATCH_FINISHED"
}