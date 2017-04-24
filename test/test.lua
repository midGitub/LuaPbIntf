local pb = require("luapbintf")

-- test.proto imports common.proto
pb.import_proto_file("test.proto")

local function test_rpc()
    assert(pb.get_rpc_input_name("test.Test", "Foo") == "test.TestMsg")
    assert(pb.get_rpc_output_name("test.Test", "Foo") == "test.CommonMsg")
end  -- test_rpc()

local function test_encode_decode()
    local msg = { uid = 12345 }
    local sz = pb.encode("test.TestMsg", msg)
    local msg2 = pb.decode("test.TestMsg", sz)
    assert(msg2.uid == 12345)
end  -- test_encode_decode()

local function test_many_fields()
    local msg = {
        uid = 12345,
        param = 9876,
        name = "Jin Qing",
        names = {"n1", "n2", "n3"},
        cmd = 10,
        common_msg = {},
    }

    local sz = pb.encode("test.TestMsg", msg)
    assert(#sz)
    
    local msg2 = pb.decode("test.TestMsg", sz)
    assert(msg2.uid == 12345)
    assert(msg2.name == "Jin Qing")
    assert(#msg2.names == 3)
    local n3 = msg2.names[3]
    -- Maybe reordered.
    assert(n3 == "n1" or n3 == "n2" or n3 == "n3")
    assert(10 == msg2.cmd)
    assert(msg2.common_msg)
end  -- test_encode_decode()

--local enum_value = pb.getEnumValue("lm.Cmd", "CMD_TYPE_USER")
--print(enum_value)

test_rpc()
test_encode_decode()
test_many_fields()
print("Test OK!")
