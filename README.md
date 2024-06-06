luau-bit64
=========

Luau library for bitwise operations on 64-bit integers. Main use case for this
libarary is to use more than 32 bit flags. This library tries to remain consistent
with the built-in Luau bit32 library.

**WARNING** Luau only has integer precision up to 53 bits. Use with caution.

# API
The call semantics are the same as the [bit32](https://luau-lang.org/library#bit32-library) Luau library and contains many of the same functions.
```lua
bit64.split(n: number): (high: number, low: number) -- Splits a 64-bit number to its high/low 32-bit components.
bit64.join(high: number, low: number): number -- Concatenates two Luau numbers into a 64-bit one.
bit64.high(n: number): number -- Returns the high 32-bits.
bit64.low(n: number): number -- Returns the low 32-bits.
bit64.band(...number): number -- Bitwise AND of all its arguments.
bit64.bor(...number): number -- Same for bitwise OR.
bit64.bxor(...number): number -- Same for bitwise XOR.
bit64.bnot(n: number): number -- Bitwise NOT of its argument.
bit64.lshift(n: number, i: number): number -- Bitwise logical left-shift by i bits.
bit64.rshift(n: number, i: number): number -- Same for bitwise logical right-shift.
bit64.arshift(n: number, i: number): number -- Same for bitwise arithmetic right-shift.
bit64.lrotate(n: number, i: number): number -- Bitwise left rotation by i bits.
bit64.rrotate(n: number, i: number): number -- Same for bitwise right rotation.
bit64.btest(...number): boolean -- Perform a bitwise and of all input numbers, and return true if the result is not 0. If the function is called with no arguments, true is returned.
```

# Testing
Tests can be run simply by running the tests.luau script:
```sh
luau tests.luau
```
