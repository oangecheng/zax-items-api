function ZXLog(msg, info1, info2, info3)
    print("ZXLogTag  "..msg.."  "..tostring(info1).."  "..tostring(info2).."  "..tostring(info3))
end


function ZXSay(doer, msg)
    if doer and doer.components.talker then
        doer.components.talker:Say(tostring(msg))
    end
end

---是否开启了勋章
---@return boolean 
function ZXIsMedal()
    return TUNING.FUNCTIONAL_MEDAL_IS_OPEN
end


function ZXSpawnPrefabs(prefab, num)
    local temp = SpawnPrefab(prefab)
    if temp and num > 0 then
        local items = {}
        if temp.components.stackable then
            local maxsize = temp.components.stackable.maxsize
            local left = num
            while left > 0 do
                local ent = SpawnPrefab(prefab)
                ent.components.stackable:SetStackSize(math.min(maxsize, left))
                left = left - maxsize
                table.insert(items, ent)
            end
        else
            for i = 1, num do
                local ent = SpawnPrefab(prefab)
                table.insert(items, ent)
            end
        end
        temp:Remove()
        return items
    end

    return nil
end




---初始化物品的样式和形态，只能在客户端调用
---如果有特殊需要，用的官方皮肤的，不要调用此函数
---@param inst any 物品
---@param prefab string 物品代码
---@param anim string|nil 初始动画
---@param loop boolean|nil 是否循环播放
function ZxInitItemForClient(inst, prefab, anim, loop)
    local defskin = ZxGetPrefabDefaultSkin(prefab)
    if defskin == nil then return end
    inst.AnimState:SetBank(defskin.bank)
    inst.AnimState:SetBuild(defskin.build)
    if anim then
        inst.AnimState:PlayAnimation(anim, loop)
    end    
end



---初始化物品的样式和形态，按需添加换肤功能
---@param inst table 预制物
---@param prefab string 物品代码
---@param defsize number|nil 初始化大小，不传为1
function ZxInitItemForServer(inst, prefab, defsize)
    local defskin = ZxGetPrefabDefaultSkin(prefab)
    if inst.components.zxresizeable == nil then
        inst:AddComponent("zxresizeable")
    end
    inst.components.zxresizeable:SetSize(defsize or 1)
    if defskin ~= nil then
        inst:AddComponent("zxskinable")
        inst.components.zxskinable:SetSkinChangedFunc(function(_, skinid)
            local scale = ZxGetSkinScale(skinid)
            inst.components.zxresizeable:SetSize(scale)
        end)
    end
end


---comment 根据权重获取随机物品(权重表,随机值)
---表格式{ key = { w = 1, num = 2 } }
---@param loot table
---@return string,integer
function ZxGetRandomItem(loot)

	local function totalWeightFn(source)
		local sum = 0
		for _, v in pairs(source) do
			sum = sum + v.w
		end
		return sum
	end

	local seed = math.random()
	local threshold = seed * totalWeightFn(loot)

	local target, cnt
	for k, v in pairs(loot) do
		threshold = threshold - v.w
		if threshold <= 0 then return k, v.num or 1 end
		target = k
		cnt = v.num or 1
	end

	return target, cnt
end



---comment 监听网络数据同步至客户端
---@param inst table 实体
function ZXNetInfo(inst)
    inst._zxname = net_string(inst.GUID, "_zxname", "zx_itemsapi_itemdirty")
    inst._zxinfo = net_string(inst.GUID, "_zxinfo", "zx_itemsapi_itemdirty")

    inst:ListenForEvent("zx_itemsapi_itemdirty", function(_)
        local newname = inst._zxname:value()
        if newname then
            inst.displaynamefn = function(_)
                return newname
            end
        end

        local info = inst._zxinfo:value()
        inst.zxinfostr = info or nil
    end)
end


--获取堆叠数量
local function GetStackSize(item)
    return item.components.stackable ~= nil and item.components.stackable:StackSize() or 1
end


---comment 尝试消耗
---@param user table 玩家
---@param items table key=prefab, value=数量
---@return boolean 是否成功
function ZXItemConsume(user, items)
    local inventory = user.components.inventory
    if not inventory then
        return false
    end

    local cache = {}
    for k, v in pairs(items) do
        local temp = inventory:FindItems(function (i) return i.prefab == k end)
        local cnt = 0
        for _, v1 in ipairs(temp) do
            cnt = cnt + GetStackSize(v1)
        end
        if v <= cnt then
            cache[k] = v
        end
    end

    --- 每一项都满足，才能认为材料足够
    local cousume = true
    for k, _ in pairs(items) do
        local valid = cache[k]
        cousume = cousume and valid and valid > 0
    end
    if cousume then
        for k, v in pairs(items) do
            inventory:ConsumeByName(k, v)
        end
        return true
    end

    return false
end