local string = string
local require  = require 
local pairs = pairs
local print = print
local table = table
local type = type
local ipairs = ipairs
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded


local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
local lfs_ =require 'lfs'
local disk_ =  require 'app.Apmgr.disk'
local project_path_ = 'Projects/'
lfs_.mkdir(project_path_)
local current_project_ ;
local project_cache_ = {}

function init()
	current_project_ = nil
	project_cache_ = {}
end


local function add_cache_data(id)
	project_cache_[id] = disk_.read_zipfile( get(),id)
end


function get_folder_indexId(gid)
	return gid .. '.nextIndex'
end

function init_folder_data(id)
	local indexId = get_folder_indexId(id)
	add_cache_data(indexId)
	return indexId
end



function get()
	return current_project_
end

function get_id_data(id)
	return project_cache_[id]
end



function get_project_path()
	return project_path_
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

--pro =file
function set(file)
	current_project_ = file
	project_cache_ = {}
end

function open()
	local zipfile = get()
	local projectid = disk_.read_project(zipfile)
	print(projectid)
	project_cache_.__index = projectid
	return init_folder_data(projectid)
end

