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
local listFile_='__filelist.lua'
lfs_.mkdir(project_path_)
local current_project_ ;
local project_cache_ = {}

function get_hid_filename(gid)
	return gid .. '.hid'
end

local function init_project(zipfile)
	current_project_ = zipfile
	project_cache_ = {}
	project_cache_.read = {}
	project_cache_.save = {}
end

function get_project()
	return current_project_
end

local function init_project_gid()
	local zipfile = get_project()
	project_cache_.gid =  disk_.read_project(zipfile)
end

function get_project_gid()
	return project_cache_.gid 
end

local function init_project_filelist()
	local zipfile = get_project()
	project_cache_.__filelist =  disk_.read_zipfile( zipfile,listFile_) or {}
end

function set_project_filelist(data)
	project_cache_.__filelist =  data
end

function get_project_filelist()
	return project_cache_.__filelist 
end

function save_project_filelist(data,zipfile)
	local str = disk_.serialize_to_str(data or get_project_filelist())
	local zipfile = zipfile or get_project()
	disk_.save_to_zipfile(zipfile,listFile_,str)
end

local function init_project_cache()
	
end

function init(zipfile)
	init_project(zipfile)
	init_project_gid()
	init_project_filelist()
end



function add_read_data(id)
	if not project_cache_.read[id] then 
		project_cache_.read[id] = disk_.read_zipfile( get_project(),id)
	end
end

local function add_change_data(id,data,state)
	project_cache_.save[id] = {data = data,state = state}
end


function get_cache_data(id)
	return  project_cache_.read[id]
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

function init_folder_data(id)
	local indexId = get_hid_filename(id)
	add_read_data(indexId)
	return indexId
end

function save()
	-- save_project_filelist()
end

function edit(gid,data)
	add_change_data(gid,data)
end

function delete_project(zipfile)
	os_remove_(zipfile)
end


