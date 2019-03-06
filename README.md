lua-bit64
=========

Library for 64-bit operations in Lua.

## API

All binary operations only accept two arguments.

```lua
bit64.split(x) -- Splits a 64bit number to its hi/lo 32bits.
bit64.join(a, b) -- Concatenates two Lua numbers into a 64-bit one.
bit64.hi(x) -- Returns the hi 32-bits.
bit64.lo(x) -- Returns the lo 32-bits.
bit64.band(x1 [,x2...]) -- Bitwise AND
bit64.bor(x1 [,x2...]) -- Bitwise OR
bit64.bxor(x1 [,x2...]) -- Bitwise XOR
bit64.bnot(x) -- Bitwise NOT
bit64.lshift(x, n) -- Bitwise logical left-shift.
bit64.rshift(x, n) -- Bitwise logical right-shift.
bit64.arshift(x, n) -- Bitwise arithmetic right-shift.
bit64.rol(x, n) -- Bitwise rotate left
bit64.ror(x, n) -- Bitwise rorate right
bit64.bswap(x) -- Endianness swapping.
bit64.tohex(x [,n]) -- Converts a number to a string.
```

### Differences with the Lua BitOp module

[Lua BitOp](http://bitop.luajit.org/)

## License

MIT Licensed. See the [LICENSE](./LICENSE.txt) file.
