local skynet = require "skynet"
require "skynet.manager"
local skynet_util = require "skynet_util"
local futil = require("futil")



local service_test_list = {

}

local ignore_test = {
    sevice = {

    },
    mod = {

    }
}

local mod_test_list = {

}

local wait_co = {}

function recycle_awake_test()
    -- while true do

    -- end
end
local pt = skynet.error

local function test_serv(service_name)
    local fun, rs, _in, _out
    local cmds = service_test_list[service_name] or {}

    for cmd, testdatas in pairs(cmds) do
        for _, v in pairs(testdatas)  do
            _in, _out = v[1], v[2]
            rs = {skynet.call(service_name, 'lua', cmd, table.unpack(_in or {}))}
            if futil.table_eq(_out, rs) then
                pt(string.format("\27[32m%s.%s %s, correct\27[m", 
                    service_name, cmd, _)
                )
            else
                local x=3
                pt(string.format("\27[31m %s.%s %s, res not correct,\n\z            
                    _in = %s, expected _out = %s,\n\z
                    real out = %s \27[m", 
                    service_name, cmd, _, futil.json_encode(_in), 
                    futil.json_encode(_out), futil.json_encode(rs))
                )
            end
        end
    end
end

local function test_mod(mod_name)
    local mod = require(mod_name)
    if not mod then
        skynet.error(string.format("module %s notfound", mod_name))
        return
    end
    
    local fun, rs, _in, _out
    local cmds = mod_test_list[mod_name] or {}

    for cmd, testdatas in pairs(cmds) do
        fun = mod[cmd]
        if not fun then
            skynet.error(string.format("%s.%s notfound", mod_name, cmd))
        else
            for _, v in pairs(testdatas)  do
                _in, _out = v[1], v[2]
                rs = {fun(table.unpack(_in or {}))}
                if futil.table_eq(_out, rs) then
                    pt(string.format("\27[32m%s.%s %s, correct\27[m", 
                        mod_name, cmd, _)
                    )
                else
                    local x=3
                    pt(string.format("\27[31m %s.%s %s, res not correct,\n\z            
                        _in = %s, expected _out = %s,\n\z
                        real out = %s \27[m", 
                        mod_name, cmd, _, futil.json_encode(_in), 
                        futil.json_encode(_out), futil.json_encode(rs))
                    )
                end
            end
        end
    end
end

local function test()
    for serv_name, _ in pairs(service_test_list) do
        skynet.fork(function()
            test_serv(serv_name)
        end)
    end
    for mod_name, _ in pairs(mod_test_list) do
        skynet.fork(function()
            test_mod(mod_name)
        end)
    end
end



local function start()
    test()
    --recycle_awake_test()
end

local ts_ls_name = {...}

skynet.init(function()
    local ts_ls = {}
    if ts_ls_name then
        for _, v in pairs(ts_ls_name) do
            pt("sdfsdfsdf", v)
            ts_ls[v] = require(v) or {a =1}
        end
    end
    
    for _, ts in pairs(ts_ls) do
        if ts.mod_test_list then
            for k, v in pairs(ts.mod_test_list) do
                mod_test_list[k] = v
            end
            pt(futil.json_encode(mod_test_list))
        end
        if ts.service_test_list then
            for k, v in pairs(ts.service_test_list) do
                service_test_list[k] = v
            end
            pt(futil.json_encode(mod_test_list))   end
        if ts.ignore_test then
            for k, v in pairs(ts.ignore_test) do
                ignore_test[k] = v
            end
        end
    end
end)

skynet.start(function()
    -- skynet.dispatch("lua", function(session, address, cmd, ...)
    -- end)
    start()
    skynet.register(".unittest")
end)
