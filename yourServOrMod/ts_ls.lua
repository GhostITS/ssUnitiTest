
local test_list = {}

test_list.service_test_list = {
    [".service1"] = {
        add = {
            {{1,3},{4}},
            {{-1,3},{2}}
        },

    }
}

test_list.mod_test_list = {
    mod1 = {
        add = {
            {
                {1,3}, {4}
            },
            {{-1,3}, {2}}
        },

    }
}

return test_list --{q = q, a= 3}