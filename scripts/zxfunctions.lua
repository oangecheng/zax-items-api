function ZXLog(msg, info1, info2, info3)
    print("ZXLogTag  "..msg.."  "..tostring(info1).."  "..tostring(info2).."  "..tostring(info3))
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