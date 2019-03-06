lua-bit64
=========

Lua library for bitwise operations on 64-bit integers.

As of 2019-04-06, LuaJIT does not support native bit operations on 64-bit types. (source https://luajit.org/ext_ffi_semantics.html#status)

## API

The call semantics are the same as in the [Lua BitOp](http://bitop.luajit.org/) extension module.

```lua
a, b = bit64.split(x) -- Splits a 64-bit number to its hi/lo 32-bit components.
y = bit64.join(a, b) -- Concatenates two Lua numbers into a 64-bit one.
a = bit64.hi(x) -- Returns the hi 32-bits.
b = bit64.lo(x) -- Returns the lo 32-bits.
y = bit64.band(x1 [,x2...]) -- Bitwise AND of all its arguments.
y = bit64.bor(x1 [,x2...]) -- Same for bitwise OR.
y = bit64.bxor(x1 [,x2...]) -- Same for bitwise XOR.
y = bit64.bnot(x) -- Bitwise NOT of its argument.
y = bit64.lshift(x, n) -- Bitwise logical left-shift by n bits.
y = bit64.rshift(x, n) -- Same for bitwise logical right-shift.
y = bit64.arshift(x, n) -- Same for bitwise arithmetic right-shift.
y = bit64.rol(x, n) -- Bitwise left rotation by n bits.
y = bit64.ror(x, n) -- Same for bitwise right rotation.
y = bit64.bswap(x) -- Swaps the bytes of its argument and returns it.
y = bit64.tohex(x [,n]) -- Converts 1st arg to a hex string. 2nd arg is length.
```

**Types**:

+ `a`, `b` and `n` always are Lua numbers.
+ `y` is always a 64-bit unsigned integer.
+ `x` can be a Lua number or a 64-bit integer (signed or unsigned).

## Modifying & Testing

The repository includes a C program that generates a test suite for the module. To run the tests make sure you have a C compiler and execute:

```sh
make test
```

## License

MIT Licensed. See the [LICENSE](./LICENSE.txt) file.
