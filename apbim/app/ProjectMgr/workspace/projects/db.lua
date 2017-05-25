local require  = require 
local package_loaded_ = package.loaded
local io = io
local string = string 
local table = table
local type = type

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local file = 'app.ProjectMgr.info.user_gid_projects_file'

local function init_data()
	return {
		{
			name = '���',id = 1,

			{
				{
					name = 'folder';id=4;
					{
						{
							name ='file',id =5;
						};
					};
				};
			};
		};
		{
			name = '�ϵ»�',id = 2,
		};
		{
			name = '����',id = 3,
		};--]]
	}
end

local function init_file()
	local filename = string.gsub(file,'%.','/')
	local file = io.open(filename,'w+')
	if file then file:close() return true end 
end 

function init()
	package_loaded_[file] = nil
	data_ = init_file() and type(require (file)) == 'table' and require (file)  or init_data()
end

function get()
	return data_
end

function add(arg)
end

function edit(arg)
end

function delete(arg)
end




