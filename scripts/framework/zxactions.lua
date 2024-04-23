local ch = ZXTUNING.IS_CH

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
            [-4] = ch and "一个新生命正在孵化中!" or "A new life is hatching!",
        }
    },

    FEED = {
        NAME = "ZXADDFOOD",
        DESC = ch and "添加饲料" or "Add Food",
        CODE = { FULL = -1 },
        MSGS = {
            [-1] = ch and "饲料多的快溢出来了！" or "The feed is overflowing!",
        }
    },

    HARVEST = {
        NAME = "ZXFARMHARVEST",
        DESC = ch and "收获产品" or "Harvest",
        CODE = { EMPTY = -1 },
        MSGS = {
            [-1] = ch and "空空如也~" or "There's nothing here!",
        }
    },

    UPGRADE = {
        NAME = "ZXUPGRADE",
        DESC = ch and "升级" or "Upgrade",
        CODE = { MAX = -1, ITEM_ERR = -2 },
        MSGS = {
            [-1] = ch and "已经是最高等级了!" or "Already max!",
            [-2] = ch and "换个材料试试吧!" or "Change the material and retry!"
        }
    },

    TRANSFORM = {
        NAME = "ZXTRANSFORM",
        DESC = ch and "变异" or "Transform",
        CODE = { INVALID = -1, UNLUCKY = -2 },
        MSGS = {
            [-1] = ch and "这小东西就一个品种" or "This little guy only has one breed.",
            [-2] = ch and "运气不太好，变异失败了~" or "Unlucky, transform failed~"
        }
    }
}

local ACTION_DATA = {}
local ACTION_CMP = {}
local function registerAction(actstr, data, action, fn, cmpdata, testfn)

    table.insert(ACTION_DATA, {
        id    = actstr.NAME,
        str   = actstr.DESC,
        state = data.state,
        act   = action,
        fn    = fn
    })

    local cmp = ACTION_CMP[cmpdata.NAME] or {}
    local fns = cmp[cmpdata.TYPE] or {}
    table.insert(fns, testfn)
    cmp[cmpdata.TYPE] = fns
    ACTION_CMP[cmpdata.NAME] = cmp
    
end



registerAction(
    ZXACTIONS.SHOP,
    { state = "give" },
    nil,
    function (act)
        
    end,

    { cmp = "inventoryitem", type = "USEITEM" },
    function ()
        
    end

)