--[[
    Lua BitOp adapter for 64-bit numbers. Requires LuaJIT.
    Written from scratch, but inspired on bit64.lua by Chessforeva Dev and TsT.

    Copyright 2019 ManuelBlanc
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local bit = require("bit")
local uint64_t = require("ffi").typeof("uint64_t")
-- If the FFI lib isn't available, try this instead:
--local uint64_t = function(x) return (x + 0LL) end

-- ==============================================================================================
-- Constructor and destructuring
-- ==============================================================================================

-- We must clear the sign because the BitOp library uses signed 32-bit integers.
-- We do so by clearing the sign bit with a logical right shift, and multiplying by 2.
local function U64_join(hi, lo)
    local rshift, band = bit.rshift, bit.band
    hi = rshift(hi, 1) * 2 + band(hi, 1)
    lo = rshift(lo, 1) * 2 + band(lo, 1)
    return uint64_t(hi)*0x100000000 + (lo % 0x100000000)
end

local function U64_split(x)
    return tonumber(x / 0x100000000), tonumber(x % 0x100000000)
end

-- ==============================================================================================
-- Accessors
-- ==============================================================================================

local function U64_lo(x)
    return tonumber(x % 0x100000000)
end

local function U64_hi(x)
    return tonumber(x / 0x100000000)
end

-- ==============================================================================================
-- To string conversion
-- ==============================================================================================

-- tohex checks the # of args, so we must use a vararg for the optional arg.
local function U64_tohex(x, ...)
    local tohex = bit.tohex
    local hi, lo = U64_split(x)
    return tohex(hi, ...) .. tohex(lo, ...)
end

-- ==============================================================================================
-- Basic bitwise operators
-- ==============================================================================================

-- Utility functions that map 64-bit int args to their hi/lo part.
local function _U64_map_lo(x, ...)
    if x then
        return U64_lo(x), _U64_map_lo(...)
    end
end
local function _U64_map_hi(x, ...)
    if x then
        return U64_hi(x), _U64_map_hi(...)
    end
end

local function U64_band(...)
    local band = bit.band
    return U64_join(band(_U64_map_hi(...)), band(_U64_map_lo(...)))
end

local function U64_bor(...)
    local bor = bit.bor
    return U64_join(bor(_U64_map_hi(...)), bor(_U64_map_lo(...)))
end

local function U64_bxor(...)
    local bxor = bit.bxor
    return U64_join(bxor(_U64_map_hi(...)), bxor(_U64_map_lo(...)))
end

local function U64_bnot(x)
    local hi, lo = U64_split(x)
    local bnot = bit.bnot
    return U64_join(bnot(hi), bnot(lo))
end

-- ==============================================================================================
-- Bit shifting operators
-- ==============================================================================================

local function U64_lshift(x, n)
    local band = bit.band
    if band(n, 0x3F) == 0 then return x end
    local hi, lo = U64_split(x)
    local lshift = bit.lshift
    if band(n, 0x20) == 0 then
        lo, hi = lshift(lo, n), bit.bor(lshift(hi, n), bit.rshift(lo, 32 - n))
    else
        lo, hi = 0, lshift(lo, n)
    end
    return U64_join(hi, lo)
end

local function U64_rshift(x, n)
    local band = bit.band
    if band(n, 0x3F) == 0 then return x end
    local hi, lo = U64_split(x)
    local rshift = bit.rshift
    if band(n, 0x20) == 0 then
        lo, hi = bit.bor(rshift(lo, n), bit.lshift(hi, 32 - n)), rshift(hi, n)
    else
        lo, hi = rshift(hi, n - 32), 0
    end
    return U64_join(hi, lo)
end

local function U64_arshift(x, n)
    local band = bit.band
    if band(n, 0x3F) == 0 then return x end
    local hi, lo = U64_split(x)
    local arshift = bit.arshift
    if band(n, 0x20) == 0 then
        lo, hi = bit.bor(bit.rshift(lo, n), bit.lshift(hi, 32 - n)), arshift(hi, n)
    else
        lo, hi = arshift(hi, n - 32), arshift(hi, 31)
    end
    return U64_join(hi, lo)
end

-- ==============================================================================================
-- Bit shifting operators
-- ==============================================================================================

local function U64_rol(x, n)
    local band = bit.band
    if band(n, 0x3F) == 0 then return x end
    local hi, lo = U64_split(x)
    if band(n, 0x20) ~= 0 then
        lo, hi = hi, lo
    end
    if band(n, 0x1F) ~= 0 then
        local bor, lshift, rshift = bit.bor, bit.lshift, bit.rshift
        lo, hi = bor(lshift(lo, n), rshift(hi, 32 - n)), bor(lshift(hi, n), rshift(lo, 32 - n))
    end
    return U64_join(hi, lo)
end
-- On my machine, the above version was ~3x faster than the one-liner:
-- return U64_bor(U64_lshift(x, n), U64_rshift(x, 64 - n))

local function U64_ror(x, n)
    return U64_rol(x, 64 - n)
end

local function U64_bswap(x)
    local hi, lo = U64_split(x)
    local bswap = bit.bswap
    return U64_join(bswap(lo), bswap(hi)) -- lo and hi are swapped
end

-- ==============================================================================================
-- Library definition
-- ==============================================================================================

local bit64 = {
    split       = U64_split,
    join        = U64_join,
    hi          = U64_hi,
    lo          = U64_lo,
    band        = U64_band,
    bor         = U64_bor,
    bxor        = U64_bxor,
    bnot        = U64_bnot,
    lshift      = U64_lshift,
    rshift      = U64_rshift,
    arshift     = U64_arshift,
    rol         = U64_rol,
    ror         = U64_ror,
    bswap       = U64_bswap,
    tohex       = U64_tohex,
}

-- Enable the bit64[[DEADBEEF]] shortcut.
setmetatable(bit64, {
    __call = function(_, raw_str)
        local str = string.gsub(raw_str, "^0x", "", 1) -- Remove prefix.
        -- Offsets start from the end (negative) to allow numbers shorter than 16 chars.
        return U64_join(
            tonumber(string.sub(str, -16, -9), 16) or 0,
            tonumber(string.sub(str,  -8, -1), 16) or 0
        )
    end,
})

return bit64
