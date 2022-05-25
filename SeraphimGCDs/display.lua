-- %c1


function()
    local strs = {}

    local cdFmtStr = "%.1f"

    local seraDurS
    if aura_env.seraDur == nil then
        seraDurS = "nil"
    else
        seraDurS = string.format(cdFmtStr, aura_env.seraDur)
    end
    table.insert(strs, seraDurS)

    return unpack(strs)
end
