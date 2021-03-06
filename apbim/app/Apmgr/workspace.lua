
local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local ipairs =ipairs
local print = print
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local iup_ = require 'iuplua'
local disk_ =  require 'app.Apmgr.disk'
local sys_workspace_ = require 'sys.workspace'
local tree_ = require 'app.Apmgr.project.tree';
local project_ = require 'app.Apmgr.project.project';
local language_ = require 'sys.language'
local var_workspace_;
local language_package_ = {
	support_ = {English = 'English',Chinese = 'Chinese'};
	tabtitle = {English = 'Workspace',Chinese = '������'};
}

function require_data_file(file)
	local file = string.lower(file)
	if  disk_.datafile_is_exist(file) then 
		package_loaded_[file] = nil
		return require (file)
	end
end


local function init_control_data()
	local lan = language_.get()
	lan = lan and language_package_.support_[lan] or 'English'
	local title =  language_package_.tabtitle[lan]
	local t = {
		hwnd = iup_.frame{
			iup_.vbox{
				tree_.get_control();
				margin = '0x0';
				alignment = 'ALEFT';
			};
			tabtitle =title;
		}
	}
	language_.reg_language_change(
		t.hwnd,
		function(lan)
			local str =  language_package_.tabtitle[lan]
			sys_workspace_.update_name(t.hwnd.tabtitle,str)
			t.hwnd.tabtitle = str
		end
	)
	return t
end

local function load_project_list()
	var_workspace_ = init_control_data()
	sys_workspace_.add(var_workspace_)
	tree_.set_data( tree_.turn_data(project_.get_project_list()) )
end 

local function unload_project_list()
	if var_workspace_ then 
		sys_workspace_.delete(var_workspace_.hwnd)
		var_workspace_ = nil
	end
	
end

function on_load()
	load_project_list()
end

function on_unload()
	unload_project_list()
end


