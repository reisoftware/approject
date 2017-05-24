local require  = require 
local package_loaded_ = package.loaded
local print = print
local table = table

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local project_ = require 'app.projectmgr.project'
local tree_ = require 'app.ProjectMgr.workspace.workspace.tree'
--[[
	local tree = tree_.get()
	local id = tree_.get_current_id()
--]]
--item = {title,action,active,...}
local add_folder_ = {title = 'Folder'}
local add_file_ = {title = 'File'}
local function get_add_submenu()
	return {
		add_folder_;
		add_file_;
	}
end
local item_add_ ={title = 'Add',submenu = get_add_submenu()}

local ins_folder_ = {title = 'Folder'}
local ins_file_ = {title = 'File'}
local function get_ins_submenu()
	return {
		ins_folder_;
		ins_file_;
	}
end
local item_insert_ ={title = 'Insert',submenu = get_ins_submenu()}

local import_folder_ = {title = 'Folder'}
local import_file_ = {title = 'File'}
local import_zipfile_ = {title = 'ZipFile'}
local import_project_ = {title = 'Project'}
local function get_import_submenu()
	return {
		import_folder_;
		import_file_;
		'';
		import_project_;
	}
end

local item_import_ ={title = 'Import',submenu = get_import_submenu()}




local item_open_ = {title = 'Open',}
local item_edit_ = {title = 'Edit',}
local item_delete_ ={title = 'Delete'}
local item_zip_ ={title = 'Zip To'}
local item_save_ ={title = 'Save'}
local link_model_ = {title = 'Model'}
local link_view_ = {title = 'View'}
local link_file_ = {title = 'File'}
local link_db_ = {title = 'DataBase'}

local function get_link_submenu()
	return {
		link_model_;
		link_view_;
		'';
		link_file_;
		link_db_;
	}
end
local item_link_ = {title = 'Link to',submenu = get_link_submenu()}

local server_backup_ = {title = 'Backups'}
local server_update_ = {title = 'Update'}
local server_history_ = {title = 'History'}
local server_checkout_ = {title = 'Checkout'}
local function get_server_submenu()
	return {
		server_backup_;
		server_update_;
		'';
		server_history_;
		server_checkout_;
	}
end
local item_server_ = {title = 'Server',submenu = get_server_submenu()}
local item_property_ = {title = 'Property'}
local item_send_ = {title = 'Send To',}

local function deal_items(arg)
	return 
	{
		item_add_;
		item_insert_;
		item_import_;
		'';
		
		item_open_;
		item_edit_;
		item_delete_;
		'';
		item_link_;
		item_send_;
		item_server_;
		'';
		item_zip_;
		item_save_;
		'';
		item_property_;
		--]]
	}
end

local function init(arg)
	return  deal_items(arg)
end
--------------------------------------------------------------------------------------------
local item_sort_by_name_ =  {title = 'Name',action = nil,active = nil}
local item_sort_by_date_ =  {title = 'Date',action = nil,active = nil}
local item_sort_by_company_ =  {title = 'Company',action = nil,active = nil}
local function get_sort_by_submenu()
	return {
		item_sort_by_name_;
		item_sort_by_date_;
		item_sort_by_company_;
	}
end

local item_add_project_ = {title = 'Create'}
local sub_sort_by_ = {title = 'Show By',submenu = get_sort_by_submenu()}
local item_statistics_ = {title = 'Statistics'}

function get_projectlist_menu()
	return {
		item_add_project_;
		sub_sort_by_;
		item_statistics_;
	}
end

local item_hide_ = {title = 'Hide'}
local item_cooperate_group_ = {title = 'Group'};
	
local function get_cooperate_items()
	return {
		item_cooperate_group_;
	}
end
local item_cooperate_ = {title = 'Cooperate',submenu = get_cooperate_items()}

function get_project_menu()
	return {
		item_add_;
		item_import_;
		'';
		item_edit_;
		item_delete_;
		'';
		item_send_;
		item_server_;
		'';
		item_zip_;
		item_save_;
		'';
		item_property_;
		item_hide_;
	}
end

function get()
	return get_projectlist_menu()
end

