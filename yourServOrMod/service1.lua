local skynet = require "skynet"
require "skynet.manager"
local skynet_util = require "skynet_util"

local MOD = {}
local last_result
function MOD.add(a, b)
    last_result = a + b
    return last_result
end

function MOD.cache(a, b)
    return last_result
end

skynet.init(function()
    last_result = 0
end)
    
skynet.start(function()
    skynet.dispatch("lua", function(session, address, cmd, ...)
        return skynet_util.luacmd(session, address, MOD, cmd, ...)
    end)
    skynet.register(".service1")
end)
