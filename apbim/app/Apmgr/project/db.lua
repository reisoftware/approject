local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local io = io
local string = string 
local table = table
local type = type
local ipairs = ipairs
local pairs = pairs
local print = print

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local cache_ = {}
local project_path_ = 'Projects/'
local disk_ =  require 'app.Apmgr.disk'

function get_project_path()
	return project_path_
end

function init()
	cache_ = {}
end

function get_projectlist()
	local t = disk_.get_folder_contents(project_path_)
	local project_files = {}
	for k,v in pairs(t) do 
		if type(v) == 'string' and string.lower(v) == 'apc' then 
			local name = string.sub(k,1,-5)
			table.insert(project_files,{name = name,file = project_path_ .. k})
		end
	end
	table.sort(project_files,function(a,b) return string.lower(a.name) < string.lower(b.name) end)
	return project_files
end


function get_project_list()
	return get_projectlist()
end









