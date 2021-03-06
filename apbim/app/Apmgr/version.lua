local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local ipairs = ipairs
local pairs = pairs
local type = type
local table = table
local string = string
local print = print
local io_open_ = io.open
local os_time_ = os.time


local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local luaext_ = require 'luaext'

function hash_string(str)
	local dig = require"crypto".digest;
	if not dig then return nil end
	local d = dig.new("sha1");
	local s = d:final(str);
	d:reset();
	return s;
end

function hash_file(file)
	if type(file)~='string' then return end
	local f = io_open_(file,"rb");
	if not f then return nil end
	local str = f:read("*all");
	f:close();
	return hash_string(str);
end

function gid_version_data(arg)
	return {
		time = os_time_;
		hid = arg.hid;
		msg = arg.msg;
	}
end

function get_gid_data(arg)
	return {
		gid = arg.gid or (luaext_.guid()  .. (arg.kind and arg.kind == 'file' and 1 or 0)),
		name = arg.name,
		file = arg.file and string.gsub(arg.file,'\\','/');
		info = arg.info or {
			createTime = os_time_;
			
		},
		versions = arg.versions or {};
	}
end

function get_folder_data(arg)
	return {
		gid = arg.gid or (luaext_.guid()  .. (arg.kind and arg.kind == 'file' and 1 or 0));
		name = arg.name ;
		-- hid = arg.hid or '-1';
	}
end