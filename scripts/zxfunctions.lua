

function ZxFindFarmItems(inst)
    local bindId = inst.components.zxbindable and inst.components.zxbindable:GetBindId() or nil
    local x,y,z = inst.Transform:GetWorldPosition()
    local ret = {}
    if x and y and z and bindId then
        local ents = TheSim:FindEntities(x, y, z, 6, { "zxfarmitem" }, nil)
        for _, value in ipairs(ents) do
            if value and value.components.zxbindable:GetBindId() == bindId then
                ret[value.prefab] = value
            end
        end
    end
    return ret
end