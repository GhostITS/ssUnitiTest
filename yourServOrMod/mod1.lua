
local mod = {}
function mod.add(a, b)
    return a + b
end

local upv = 111

function mod.getlocal()
    return upv
end

return mod