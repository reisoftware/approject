local string = string
local require  = require 
local pairs = pairs
local print = print
local table = table
local type = type
local ipairs = ipairs
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local os_remove_ = os.remove


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
	project_cache_.read = {}
	project_cache_.save = {}
end


function add_cache_data(id)
	if not project_cache_.read[id] then 
		project_cache_.read[id] = disk_.read_zipfile( get(),id)
	end
end

local function add_change_data(id,data,state)
	project_cache_.save[id] = {data = data,state = state}
end


function get_hid_indexId(gid)
	return gid .. '.hid'
end

function get()
	return current_project_
end

function get_id_data(id)
	return project_cache_.save[id] or project_cache_.read[id]
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
	init()
	current_project_ = file
end


function init_folder_data(id)
	local indexId = get_hid_indexId(id)
	add_cache_data(indexId)
	return indexId
end

function project_index_id(zipfile)
	if zipfile then 
		return 
	end
	return project_cache_.__index
end


function open()
	local zipfile = get()
	project_cache_.__index =  disk_.read_project(zipfile)
	-- init_folder_data(projectid)
end

function save()
end

function edit(gid,data)
	add_change_data(gid,data)
end

function delete_project(zipfile)
	os_remove_(zipfile)
end


