
# Introduction

When a function return multiple arguments, how to do to keep only the first one ?

# Sample of the problem

```lua
local function multiple(a) return a, 1, 2, 3 end

local function foo(aa)
	return multiple(aa)
end
print(foo("ok")) -- ok 1 2 3
-- we want only ok
```

Solution 1
==========

```lua
local function foo(aa)
	local function cut(a1)
		return a1
	end
	return cut(x(aa))
end
```
It costs 12 instructions.

Solution 2
==========

```lua
local function foo(aa)
	return (function(a1, ...) return a1 end)(x(aa))
end
```
It costs 11 instructions.

Solution 3
==========

```lua
local function foo(aa)
	local first = x(aa)
	return first
end
```
It costs 7 instructions.

Solution 4
==========

```lua
local function foo(aa)
	return nil or x(aa)
end
```
It costs 7 instructions, like Solution 3 but with 1 local less.

Ugly but better than Solution 1, 2 and 3.

Solution 5
==========

```lua
local function foo(aa)
	return (x(aa)) -- the parenthesis keeps only the 1st argument
end
```
It cost 7 instructions, exactly like Solution 4 but less horrible to read!

Thanks to yalb for this elegant solution !


How to know which code is the best ?
====================================

Basicaly I'm using `luac` to parse and show the bytecode.
I considere the best as the one that have the less instructions.

Sample :
```
$ luac -l -p file.lua
```

Compare all solutions
=====================

The result of [compare.sh](compare.sh) is :
```
a1.lua  total:   12  instructions
0+      params,  2   slots,        1  upvalue,   1  local,   0  constants,  1  function
1       param,   5   slots,        1  upvalue,   2  locals,  1  constant,   1  function
1       param,   2   slots,        0  upvalues,  1  local,   0  constants,  0  functions

a2.lua  total:   11  instructions
0+      params,  2   slots,        1  upvalue,   1  local,   0  constants,  1  function
1       param,   4   slots,        1  upvalue,   1  local,   1  constant,   1  function
1       param,   2   slots,        0  upvalues,  1  local,   0  constants,  0  functions

a3.lua  total:   7   instructions
0+      params,  2   slots,        1  upvalue,   1  local,   0  constants,  1  function
1       param,   3   slots,        1  upvalue,   2  locals,  1  constant,   0  functions

a4.lua  total:   7   instructions
0+      params,  2   slots,        1  upvalue,   1  local,   0  constants,  1  function
1       param,   3   slots,        1  upvalue,   1  local,   1  constant,   0  functions

a5.lua  total:   7   instructions
0+      params,  2   slots,        1  upvalue,   1  local,   0  constants,  1  function
1       param,   3   slots,        1  upvalue,   1  local,   1  constant,   0  functions
```

Conclusion
==========

I
