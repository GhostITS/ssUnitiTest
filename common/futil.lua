
local json = require("json")

local futil = {}
function futil.json_encode(tb)
	local ok, rt = pcall(json.encode, tb)
	if ok then
		return rt
	else
		return "{}"
	end
end

function futil.json_decode(str)
	local ok, rt = pcall(json.encode, str)
	if ok then
		return rt
	else
		return {}
	end
end

function futil.table_eq(tb1, tb2)
	local ok2, rt2 = pcall(json.encode, tb2)
	local ok1, rt1 = pcall(json.encode, tb1)
	if ok2 and ok1 and rt1 == rt2 then
		return true
	end
	return false		
end

return futil 