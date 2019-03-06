/*
	Unit test generator for the bit64 Lua library.

	Copyright 2019 ManuelBlanc
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/


#include <stdio.h>
#include <inttypes.h>

#define MACRO_BLOCK( body ) \
do { body } while (0) //

// This macro cannnot be wrapped in a MACRO_BLOCK, because that wraps it in a block and we need the
// definition to be from the whole main function.
#define write_test_definition(name, val) \
	printf("local " #name " = 0x%016"PRIx64"ULL\n", (uint64_t)val); \
	uint64_t name = val; //

#define write_test(lua_expr, c_expr) \
	printf("assert(0x%016"PRIx64"ULL == %s, \"0x%016"PRIx64"ULL == %s\")\n", (c_expr), (lua_expr), (c_expr), (lua_expr)); //

#define _raw_write_test_tohex(arg1) \
	printf("assert(\"%016"PRIx64"\" == bit64.tohex(" #arg1 "), \"bit64.tohex(" #arg1 ")\")\n", arg1); \

#define write_test_tohex_op() \
	_raw_write_test_tohex(a); \
	_raw_write_test_tohex(b); \
	_raw_write_test_tohex(c); \
	_raw_write_test_tohex(d); //

#define _raw_write_test_unary_op1(op, arg) \
	write_test("bit64." #op "(" #arg ")", op(arg)) //

#define write_test_unary_op(op) \
	_raw_write_test_unary_op1(op, a); \
	_raw_write_test_unary_op1(op, b); \
	_raw_write_test_unary_op1(op, c); \
	_raw_write_test_unary_op1(op, d); //

#define _raw_write_test_binary_op2(op, arg1, arg2) \
	write_test("bit64." #op "(" #arg1 ", " #arg2 ")", op(arg1, arg2)) //

#define _raw_write_test_binary_op1(op, arg2) \
	_raw_write_test_binary_op2(op, a, arg2); \
	_raw_write_test_binary_op2(op, b, arg2); \
	_raw_write_test_binary_op2(op, c, arg2); \
	_raw_write_test_binary_op2(op, d, arg2); //

#define write_test_binary_op(op) \
	_raw_write_test_binary_op1(op, a); \
	_raw_write_test_binary_op1(op, b); \
	_raw_write_test_binary_op1(op, c); \
	_raw_write_test_binary_op1(op, d); //

#define write_test_shift_op(op) \
	_raw_write_test_binary_op1(op, 0); \
	_raw_write_test_binary_op1(op, 1); \
	_raw_write_test_binary_op1(op, 31); \
	_raw_write_test_binary_op1(op, 32); \
	_raw_write_test_binary_op1(op, 33); \
	_raw_write_test_binary_op1(op, 63); //

uint64_t rotl(uint64_t v, int n) {
    n = n & 63U;
    if (n) v = (v << n) | (v >> (64 - n));
    return v;
}

#define band(x, y)      (x & y)
#define bor(x, y)       (x | y)
#define bxor(x, y)      (x ^ y)
#define bnot(x)         (~x)
#define lshift(x, n)    (x << n)
#define rshift(x, n)    (x >> n)
#define arshift(x, n)   ((int64_t)x >> n)
#define rol(x, n)       rotl(x, n)
#define ror(x, n)       rotl(x, 64 - n)
#define bswap(x)        __builtin_bswap64(x)

int main(void)
{
	// Header
	puts("local bit64 = require \"bit64\"");
	// Definitions
	write_test_definition(a, 0x00000000beefcafeull);
	write_test_definition(b, 0x0000cafebabecafeull);
	write_test_definition(c, 0x876543210fedcba9ull);
	write_test_definition(d, 0x7777777777777777ull);
	// To hex
	write_test_tohex_op();
	// Bitwise
	write_test_binary_op(band);
	write_test_binary_op(bor);
	write_test_binary_op(bxor);
	write_test_unary_op(bnot);
	// Shifts
	write_test_shift_op(lshift);
	write_test_shift_op(rshift);
	write_test_shift_op(arshift);
	write_test_shift_op(rol);
	write_test_shift_op(ror);
	// Misc
	write_test_unary_op(bswap);
	// Header
	puts("print \"bit64: all tests ok\"");

	return 0;
}
