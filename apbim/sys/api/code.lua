--[[
	File description:
		Interface : save 
		parameter : 
			The parameter type is 'table';
		for example :
			require 'table_save'.save{file = 'test.lua',  data= {},key = 'db';returnKey = true}
--]]

-- _ENV = module_seeall(...,package.seeall) 
local io = io
local tostring = tostring
local type = type
local string = string
local pairs = pairs
local error = error
local table = table
local ipairs = ipairs

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local function basicSerialize(o,saved)
	if type(o) == "number" then
		return tostring(o)
	elseif type(o) == "table" then
		return saved[o]
	elseif type(o) == "boolean" then
		return tostring(o)
	else
		return string.format("%q",o)
	end
end

local function lua_save(name,value,saved)
	if not name then return end
	io.write(name,' = ')
	if type(value) == "number" or type(value) == "string" or type(value) =="boolean" then
		io.write(basicSerialize(value),"\n")	
	elseif type(value) == "table" then
		saved = saved or {}
		if saved[value] then
			io.write(saved[value],"\n")
		else
			saved[value] = name
			io.write("{}\n")
			for k,v in pairs(value) do
				k = basicSerialize(k,saved)
				if k then 
					local fname =  string.format("%s[%s]",name,k)
					lua_save(fname,v,saved)
				end
			end
		end
	-- else
		-- error("cannot save a "..type(value))
	end
end

local function save_table(file,content,key,returnKey)
	local temp = io.output()
	io.output(file)
	local t = {}
	local key = key or 'db'
	if type(content) == 'table' then 
		lua_save( key,{},t)
		for k,v in pairs(content) do
			if type(k) == "number" then 
				lua_save(key .. "[" .. k .. "]",v,t)
			else
				lua_save(key .. "[\"" .. k .. "\"]",v,t)
			end
		end
		if returnKey  then 
			io.write('return ',key)
		end 
	else 
		if type(content) == "number" or type(content) == "string" or type(content) =="boolean" then
			io.write(basicSerialize(content),"\n")	
		end
	end
	io.flush()
	io.output():close()
	io.output(temp)
end

--arg = {key,file,data,returnKey}
function save(arg)
	arg = arg or {}
	if not arg.file or not arg.data then return end 
	save_table(arg.file,arg.data,arg.key,arg.returnKey)
end


function serialize_to_str(data,key,t,state)
	local t = t or {};
	local curkey = key or 'db'
	
	local tempt = {}
	for k,v in pairs(data) do 
		if type(k) == 'number' or type(k) == 'string'  then 
			table.insert(tempt,k)
		end
	end
	table.sort(tempt,function(a,b) return tostring(a) < tostring(b) end )
	
	for k,key in ipairs (tempt) do 
		if type(key) == 'number' then 
			str = curkey .. '[' .. key .. ']'
		elseif type(key) == 'string' then 
			str = curkey .. '[\'' .. key .. '\']'
		end
		local v =data[key]
		if type(v) == 'table' then 
			table.insert(t,str .. ' = {};\n')
			serialize_to_str(v,str,t,true)
		elseif type(v) == 'string' then 	
			table.insert(t, str .. ' = \'' .. v .. '\';\n')
		elseif type(v) == 'number' or type(v) == 'boolean' then 
			table.insert(t,str .. ' = ' .. tostring(v).. ';\n')
		end
	end
	if not state  then 
		table.insert(t,1,curkey .. ' = {};\n')
		return table.concat(t,'')
	end
end

--arg = {key,data}
function serialize(arg)
	if type(arg) ~= 'table' then return end 
	if not arg.data then return end 
	return serialize_to_str(arg.data,arg.key)
end


-- print(serialize{key = 'll',data = {a =2,c = 3,da = {a=2,22,44}}})