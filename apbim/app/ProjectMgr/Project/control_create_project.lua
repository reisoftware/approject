----[[
local require  = require 
local package_loaded_ = package.loaded
local print = print
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local dlg_create_project_ =  require 'app.ProjectMgr.project.dlg_create_project'
local op_create_project_ =  require 'app.ProjectMgr.project.op_create_project'

function main()
	op_create_project_.init()
	dlg_create_project_.pop{
		data = op_create_project_.init();
		on_next = op_create_project_.on_next;
		languagePack = op_create_project_.get_language_data();
		language = op_create_project_.get_cur_language();
	}
	-- return op_create_project_.get_data()
end

function next()
	op_create_project_.next() 
end

function get_data()
	return op_create_project_.get_data()
end


--pop()

