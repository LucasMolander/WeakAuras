-- %c1

-- %c2

-- %c3

-- %c4


function()
    local strs = {}

    local cdFmtStr = "%.1f"

    -- local seraDurS
    -- if aura_env.seraDur == nil then
    --     seraDurS = "nil"
    -- else
    --     seraDurS = string.format(cdFmtStr, aura_env.seraDur)
    -- end
    -- table.insert(strs, seraDurS)

    table.insert(strs, string.format(cdFmtStr, aura_env.seraDur))
    table.insert(strs, string.format(cdFmtStr, aura_env.gcdCD))
    table.insert(strs, string.format(cdFmtStr, aura_env.predGCD))
    table.insert(strs, string.format(cdFmtStr, aura_env.nGCDs))

    return unpack(strs)
end
