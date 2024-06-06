local bit64 = require("bit64")

local function assertEqual(actual, expected, message: string?)
    assert(actual == expected, message or string.format("Expected %s but got %s", tostring(expected), tostring(actual)))
end

local tests = {
    ["join and split"] = function()
        local n = 0xFFFFFFFFFFFFF

        local high, low = bit64.split(n)
        assertEqual(high, 1048575, "split high part failed")
        assertEqual(low, 4294967295, "split low part failed")
        local joined = bit64.join(high, low)
        assertEqual(joined, n, "join failed")
    end,

    ["low and high"] = function()
        local n = 0xFFFFFFFFFFFFF
        assertEqual(bit64.low(n), 4294967295, "low function failed")
        assertEqual(bit64.high(n), 1048575, "high function failed")
    end,

    ["bitwise operations"] = function()
        local n1, n2 = 0x123456789ABCD, 0xFEDCBA9876543
        assertEqual(bit64.band(n1, n2), 318038595412289, "bitwise AND failed")
        assertEqual(bit64.bor(n1, n2), 4485801007116239, "bitwise OR failed")
        assertEqual(bit64.bxor(n1, n2), 4167762411703950, "bitwise XOR failed")
        assertEqual(
            bit64.bnot(0b1111111111110000000000000000000000000000000000000000000000000000),
            0b0000000000001111111111111111111111111111111111111111111111111111,
            "bitwise NOT failed"
        )
    end,

    ["shifts"] = function()
        local n = 0x123456789ABCDEF0
        assertEqual(bit64.lshift(n, 4), 2541551405711093504, "left shift failed")
        assertEqual(bit64.rshift(n, 4), 81985529216486895, "right shift failed")
        assertEqual(bit64.arshift(0xF000000000000000, 4), 18374686479671623680, "arithmetic right shift failed")
    end,

    ["rotations"] = function()
        local n = 0x123456789ABCDEF0
        assertEqual(bit64.lrotate(n, 4), 2541551405711093505, "left rotate failed")
        assertEqual(bit64.rrotate(n, 4), 81985529216486895, "right rotate failed")
    end
}

for name, test in tests do
    print(string.format("Running test '%s'", name))
    test()
end

print("All tests passed!")
