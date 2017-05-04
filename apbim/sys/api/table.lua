_ENV = module(...,ap.adv)local type_={};local level_=nillocal result_=nil;local endl_ = "\n";----local function str_scale(str,scale)	local result="";	for i=1,scale do		result=result..str;	end	return result;endlocal function get_tip(tip)	local str = str_scale(" \t",level_);	if type(tip)=="string" then tip = "[\""..tip.."\"]" end;	if type(tip)=="number" then tip = "["..tip.."]" end;	str = str..(tip and tip..' = ' or '');	return str;endlocal function tostrt_(tip,src)	if not type_[type(src)] then error(tip.."' is a "..type_[type(src)].."."..endl_) end;	type_[type(src)](tip,src);	return result_;endlocal function tostrt_without_somekey(k,v)	if k=="__index" then return end;	tostrt_(k,v);endlocal function with_met(src)	local met = getmetatable(src);	if met then		with_met(met);	end	for k,v in pairs(src) do		tostrt_without_somekey(k,v);	endend----type_.string = function(tip,src)	local str = get_tip(tip);	local str = str..string.format("%q",src)..';'..endl_;	table.insert(result_,str);endtype_.number = function(tip,src)	local str = get_tip(tip);	local str = str..tostring(src)..';'..endl_;	table.insert(result_,str);endtype_.boolean = type_.number;type_['nil'] = type_.number;type_.table = function(tip,src)	local str = get_tip(tip);	local str = str..'{'..endl_;	level_=level_+1;	table.insert(result_,str);	with_met(src);	level_=level_-1;	table.insert(result_,str_scale(" \t",level_)..'};'..endl_);endtype_["function"] = function(tip,src)endtype_.userdata = function(tip,src)	error(tip.." is a userdata."..endl_);end----local function tostrt(src)	level_ = 0;	result_={};	return tostrt_(nil,src);end-------------------------------function tostr(src)	return table.concat(tostrt(src));end-- arg={file=,tip=,src=}function tofile(arg)	local strt = tostrt(arg.src);	local f = io.open(arg.file,arg.mode or "w");	if not f then return end	local tip = arg.key or arg.tip;	f:write(tip and tip.." = " or "return ");	for k,v in ipairs(strt) do		f:write(v);	end	f:close();endfunction totrace(arg)	local strt = tostrt(arg);	for k,v in ipairs(strt) do		require'sys.str'.totrace(v);	endend--------------------------------- local m = {	-- m1 = "1";	-- m2 = 1;	-- m3 = {		-- mx = 1,	-- };-- }-- m.__index = m;-- local t = {	-- a = "abc";	-- b = 123;	-- c = true;	-- d = nil;	-- e = {		-- x = 100;		-- y = "AAA";		-- z = false;	-- }-- }-- setmetatable(t,m);-- print(tostr{tip="a",src=t.a});-- print(tostr{tip="b",src=t.b});-- print(tostr{tip="c",src=t.c});-- print(tostr{tip="d",src=t.d});-- print("t="..tostr(t));-- trace_out(tostr{tip="a",src=t.a});-- trace_out(tostr{tip="b",src=t.b});-- trace_out(tostr{tip="c",src=t.c});-- trace_out(tostr{tip="d",src=t.d});-- trace_out("t="..tostr(t));function deepcopy(src)    local lookup_table = {}    local function _copy(src)        if type(src) ~= "table" then            return src        elseif lookup_table[src] then            return lookup_table[src]        end        local new_table = {}        lookup_table[src] = new_table        for index, value in pairs(src) do            new_table[_copy(index)] = _copy(value)        end        return setmetatable(new_table, getmetatable(src))    end    return _copy(src)endfunction count(t)	local n = 0;	if type(t)~="table" then return -1 end;	for k,v in pairs(t) do		n = n + 1;	end	return n;endfunction ismet(T,t)	local m = t	repeat		m = getmetatable(m);		if m==T then return true end;	until not m;	return false;end