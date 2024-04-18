
local ch = ZXTUNING.IS_CH



STRINGS.ZX_SKIN_PAGE_TITLE    = ch and "建家党小店" or "Items shop"
STRINGS.ZX_SKIN_PAGE_NOTICE   = ch and "神秘的获取方式(群号600710976)..." or "The mysterious way to get it..."
STRINGS.ZX_SKIN_HAS           = ch and "已拥有" or "owned"
STRINGS.ZX_SKIN_NOT_HAS       = ch and "未拥有" or "not owned"
STRINGS.ZXDESTROY             = ch and "销毁" or "destroy"
STRINGS.ZXUSE                 = ch and "使用" or "use"
STRINGS.ZX_UPGRADE_SUCCESS    = ch and "升级成功!" or "upgrade success!"
STRINGS.ZX_ACCELERATE_SUCCESS = ch and "加足马力生产!" or "Make haste to produce!"



local ACTION_STRS = ch and {
    
    ZXSHOPOPEN = { namestr = "选择模式" },
    ACCELERATE = { namestr = "加速" },

    ZXHATCH = { 
        namestr = "孵化",  
        failstr = {
            NO_HOST   = "附近没有可用的农场！",
            NO_FEEDER = "附近没有可用的饲料盆！",
            BUSY      = "一个新生命正在孵化中!",
            NO_SPACE  = "农场已经挤满小动物了!"
        }
    },

    ZXADDFOOD  = {
        namestr = "添加饲料",
        failstr = {
            FULL = "饲料多的快溢出来了！",
        }
    },

    ZXFARMHARVEST = {
        namestr = "收获产品",
        failstr = {
            EMPTY = "这里面空空如也！",
        }
    },

    UPGRADE = {
        namestr = "升级",
        failstr = {
            MAX = "已经是最高等级了!",
            INVALID_ITEM = "换个材料试试吧!"
        }
    }


} or {

    ZXSHOPOPEN = { namestr = "Select Mode" },
    ACCELERATE = { namestr = "Accelerate" },

    ZXHATCH = {
        namestr = "Hatch",
        failstr = {
            NO_HOST   = "There are no usable farms nearby!",
            NO_FEEDER = "There is no available feed basin nearby!",
            BUSY      = "A new life is hatching!",
            NO_SPACE  = "The farm is already crowded with small animals!"
        }
    },

    ZXADDFOOD  = {
        namestr = "Add food",
        failstr = {
            FULL = "The feed is overflowing!",
        }
    },

    ZXFARMHARVEST = {
        namestr = "Harvest",
        failstr = {
            EMPTY = "There's nothing in here!",
        }
    },

    UPGRADE = {
        namestr = "Upgrade",
        failstr = {
            MAX = "Already max!",
            INVALID_ITEM = "Change the material and retry!"
        }
    }
}

STRINGS.ZXACTION = {}
for k, v in pairs(ACTION_STRS) do
    STRINGS.ZXACTION[k] = v.namestr
    STRINGS.CHARACTERS.GENERIC.ACTIONFAIL[k] = v.failstr
end






