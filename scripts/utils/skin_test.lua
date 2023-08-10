function BuySkin(inst,skinname,skinid,price)
    -- if inst.components.finiteuses and inst.components.finiteuses:GetUses()>= price then
    --     if inst.skin_data then
    --         local result=false--购买结果
    --         if inst.skin_data[skinname] then
    --             if not table.contains(inst.skin_data[skinname],skinid) then
    --                 inst.skin_data[skinname][#inst.skin_data[skinname]+1]=skinid
    --                 result=true
    --             end
    --         else
    --             inst.skin_data[skinname]={skinid}
    --             result=true
    --         end
    --         if result then
    --             inst.components.finiteuses:Use(price)
    --             --给客户端同步皮肤解锁数据
    --             if inst.skin_data and inst.skin_str then
    --                 local info_str=json.encode(inst.skin_data)
    --                 inst.skin_str:set(info_str)
    --             end
    --         end
    --         return result
    --     end
    -- end

    local skindata = {}
    skindata[STRINGS.MEDAL_SKIN_NAME.MEDAL_STATUE_GUGUGU_SKIN2] = {1}
    return json.encode(skindata)

end