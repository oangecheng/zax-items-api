local ch = ZXTUNING.IS_CH


ZXACTIONS = {}

ZXACTIONS.SHOP = {
    NAME = "ZXSHOPOPEN",
    DESC = ch and "选择模式" or "Select Mode", 
}


local HATCH_CODES = { FULL = -1, NO_HOST = -2, NO_FEEDER = -3, BUSY = -4, }
ZXACTIONS.HATCH =  {
    NAME = "ZXHATCH",
    DESC = ch and "孵化" or "Hatch",
    CODE = HATCH_CODES,
    MSGS = {
        [HATCH_CODES.FULL]      = ch and "农场已经挤满小动物了！" or "The farm is already crowded with small animals!",
        [HATCH_CODES.NO_HOST]   = ch and "附近没有可用的农场！" or "There are no usable farms nearby!",
        [HATCH_CODES.NO_FEEDER] = ch and "附近没有可用的饲料盆！" or "There is no available feed basin nearby!",
        [HATCH_CODES.BUSY]      = ch and "一个新生命正在孵化中!" or "A new life is hatching!",
    }
}





ZXACTIONS = {
    SUCCESS = 1,

    SHOP = {
        NAME = "ZXSHOPOPEN",
        DESC = ch and "选择模式" or "Select Mode",
    },

    HATCH = {
        NAME = "ZXHATCH",
        DESC = ch and "孵化" or "Hatch",
        CODE = { FULL = -1, NO_HOST = -2, NO_FEEDER = -3, BUSY = -4, },
        MSGS = {
            [-1] = ch and "农场已经挤满小动物了！" or "The farm is already crowded with small animals!",
            [-2] = ch and "附近没有可用的农场！" or "There are no usable farms nearby!",
            [-3] = ch and "附近没有可用的饲料盆！" or "There is no available feed basin nearby!",
        }
    }
}


ZXACTIONS = {
    SHOP  = "ZXSHOPOPEN",
    HATCH = "ZXHATCH",
    FEED  = "ZXADDFOOD", 
}

ZXACTIONS.ERR_CODES = {
    [ZXACTIONS.HATCH] = { NO_HOST = 2, NO_FEEDER = 3, BUSY = 4, FULL = 5 },
}

ZXACTIONS.STRS = {
    [ZXACTIONS.HATCH] = {
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
    }
}