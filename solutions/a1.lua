local function foo(aa)
	local function cut(a1)
		return a1
	end
	return cut(x(aa))
end
