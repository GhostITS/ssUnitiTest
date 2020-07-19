local skynet = require "skynet"
local mod = {}
function mod.luacmd(session, address, MOD, cmd, ...)
	if not MOD then
		error("MOD is not found")
		return
	end	
	local f = MOD[cmd]
	if not f then
		error("cmd is not found")
	end
	if session == 0 then
		f(...)
	else
		skynet.ret(skynet.pack(f(...)))
	end	
end
return mod