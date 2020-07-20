local skynet = require "skynet"
local sprotoloader = require "sprotoloader"

local max_client = 64

local function start( ... )
	skynet.newservice("service1")
	local s = skynet.call(".service1", "lua", "add", 1, 3)
	print(s);
	skynet.newservice("unittest", "ts_ls")
end

skynet.init(function( ... )
	-- body
end)

skynet.start(function()
	start()
end)
