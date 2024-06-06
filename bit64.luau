--[[
    Luau bit manipulation for 64-bit numbers.
    Adapted for luau from the lua-bit64 library by ManuelBlanc.

    Copyright 2024 Maxwell Ruben
    Copyright 2019 ManuelBlanc
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

--!strict
--!native

--- Joins the bits of two 32-bit integers into one 64-bit integer.
local function join(high: number, low: number): number
    return high * 0x100000000 + low % 0x100000000
end

--- Splits a 64-bit integer into two 32-bit integers.
local function split(n: number): (number, number)
    return n // 0x100000000, n % 0x100000000
end

--- Returns the least significant bits.
local function low(n: number): number
    return n % 0x100000000
end

--- Returns the most significant bits.
local function high(n: number): number
    return n // 0x100000000
end

local function bop(op: (...number) -> number, n1: number, n2: number, ...: number): number
    -- Makes the function returns consistent with bit32
    if not n2 then
        if not n1 then
            return join(op(), op())
        end
        return n1
    end

    local h2, l2 = split(n2)
    local h1, l1 = split(n1)
    local high, low = op(h1, h2), op(l1, l2)
    for i = 1, select('#', ...) do
        local h, l = split(select(i, ...))
        high = op(high, h)
        low = op(low, l)
    end
    return join(high, low)
end

local function band(...: number): number
    return bop(bit32.band, ...)
end

local function bor(...: number): number
    return bop(bit32.bor, ...)
end

local function bxor(...: number): number
    return bop(bit32.bxor, ...)
end

local function btest(...: number): boolean
    return band(...) ~= 0
end

local function bnot(n: number): number
    local high, low = split(n)
    return join(bit32.bnot(high), bit32.bnot(low))
end

local function lshift(n: number, i: number): number
    if bit32.band(i, 63) == 0 then
        return n
    end
    local high, low = split(n)
    if bit32.band(i, 32) == 0 then
        low, high = bit32.lshift(low, i), bit32.bor(bit32.lshift(high, i), bit32.rshift(low, 32 - i))
    else
        high = bit32.lshift(low, (i - 32))
        low = 0
    end
    return join(high, low)
end

local function rshift(n: number, i: number): number
    if bit32.band(i, 63) == 0 then
        return n
    end
    local high, low = split(n)
    if bit32.band(i, 32) == 0 then
        low, high = bit32.bor(bit32.rshift(low, i), bit32.lshift(high, 32 - i)), bit32.rshift(high, i)
    else
        low, high = bit32.rshift(high, i - 32), 0
    end
    return join(high, low)
end

local function arshift(n: number, i: number): number
    if bit32.band(i, 63) == 0 then
        return n
    end
    local high, low = split(n)
    if bit32.band(i, 32) == 0 then
        low, high = bit32.bor(bit32.rshift(low, i), bit32.lshift(high, 32 - i)), bit32.arshift(high, i)
    else
        low, high = bit32.arshift(high, i - 32), bit32.arshift(high, 31)
    end
    return join(high, low)
end

-- local function lrotate(n: number, i: number): number
--     if bit32.band(i, 63) == 0 then
--         return n
--     end
--     local high, low = split(n)
--     if bit32.band(i, 32) ~= 0 then
--         low, high = high, low
--     end
--     if bit32.band(i, 31) ~= 0 then
--         low, high = bit32.bor(bit32.lshift(low, i), bit32.rshift(high, 32 - i)), bit32.bor(bit32.lshift(high, i), bit32.rshift(low, 32 - i))
--     end
--     return join(high, low)
-- end

local function lrotate(n: number, i: number): number
    return bor(lshift(n, i), rshift(n, 64 - i))
end

local function rrotate(n: number, i: number): number
    return lrotate(n, 64 - i)
end

local bit64 = {
    join = join,
    split = split,
    low = low,
    high = high,
    band = band,
    bor = bor,
    bxor = bxor,
    bnot = bnot,
    lshift = lshift,
    rshift = rshift,
    arshift = arshift,
    lrotate = lrotate,
    rrotate = rrotate,
    btest = btest,
}

return bit64
