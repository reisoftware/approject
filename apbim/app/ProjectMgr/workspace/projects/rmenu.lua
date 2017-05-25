local require  = require 
local package_loaded_ = package.loaded
local print = print
local table = table

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M


local language_ = require 'sys.language'
local cur_language_ = 'English'
local project_ = require 'app.projectmgr.project'
local tree_ = require 'app.ProjectMgr.workspace.projects.tree'
--[[
	local tree = tree_.get()
	local id = tree_.get_current_id()
--]]
local language_support_ = {English = 'English',Chinese = 'Chinese'}

--------------------------------------------------------------------------------------------------------
-- define project list menu

local title_create_ = {English = 'Create',Chinese = '��������'}
local title_import_project_ = {English = 'Import',Chinese = '���빤��'}--����Ĺ��̣��п�����һ��idҲ������һ�����ع��̰�
local title_sort_ = {English = 'Sort',Chinese = '����'}
local title_sort_date_ = {English = 'Date',Chinese = '���ʱ��'}
local title_sort_name_ = {English = 'Name',Chinese = '��������'}
local title_statistics_ = {English = 'Statistics',Chinese = 'ͳ��'}
local title_manage_ = {English = 'Manage',Chinese = '������'}

local action_create_;
local action_import_project;
local action_sort_name_;
local action_sort_date_;
local action_statistics_;
local action_manage_;

local item_create_;
local item_import_project_;
local item_sort_;
local item_sort_date_;
local item_sort_name_;
local item_statistics_;
local item_manage_;

item_create_ = {action = action_create_}
item_import_project_ = {action = action_import_project}
item_sort_date_ = {action = action_sort_date_}
item_sort_name_ = {action = action_sort_name_}
item_statistics_ = {action = action_statistics_}
item_manage_ = {action = action_manage_}
local function submenu_sort()
	return {
		item_sort_date_;
		item_sort_name_;
	}
end
item_sort_ = {submenu = submenu_sort}

--------------------------------------------------------------------------------------------------------
local title_information_ = {English = 'Information',Chinese = '������Ϣ'}
local title_add_ = {English = 'Add',Chinese = '���'}
local title_add_file_  = {English = 'File',Chinese = '�ļ�'}
local title_add_folder_ = {English = 'Folder',Chinese = '�ļ���'}
local title_chmod_ = {English = 'Cooperate',Chinese = 'Эͬ����'}
local title_import_ = {English = 'Import',Chinese= '����'}
local title_import_folder_ = {English = 'Folder',Chinese= '�ļ���'}
local title_import_file_ = {English = 'File',Chinese= '�ļ�'}
local title_import_id_ = {English = 'Id',Chinese= '�ļ�Id'}
local title_hide_project_ = {English = 'Hide',Chinese = '����'}
local title_delete_project_ = {English = 'Delete',Chinese = 'ɾ��'}
local title_edit_information_ = {English = 'Edit',Chinese = '�༭'}
local title_save_project_ = {English = 'Save',Chinese = '����'}
local title_server_ = {English = 'Server',Chinese = '������'}
local title_server_backup_ = {Englist = 'Backup',Chinese = '����'}
local title_server_update_ = {English = 'Update',Chinese = '����'}
local title_server_history_ = {English = 'Backup History',Chinese = '��ʷ��¼'}
local title_workflow_ = {English = 'Workflow',Chinese = '������'}
local title_workflow_start_ = {English = 'Start',Chinese = '����'}
local title_workflow_stop_ = {English = 'Stop',Chinese = 'ֹͣ'}
local title_workflow_commit_ = {English = 'Commit',Chinese = '�ύ'}
local title_workflow_status_ = {English = 'Status',Chinese = '״̬'}
local title_personal_folder_ = {English = 'Personal Folder',Chinese = '˽���ļ���'}
local title_add_to_ = {English = 'Add To ',Chinese = '��ӵ�'}
local title_ins_ = {English = 'Insert',Chinese = '����'}
local title_ins_file_  = {English = 'File',Chinese = '�ļ�'}
local title_ins_folder_ = {English = 'Folder',Chinese = '�ļ���'}
local title_link_to_ = {English = 'Link To ',Chinese = '���ӵ�'} 
local title_link_to_file_ = {English = 'File',Chinese = '�ļ�'} --�������ӵ����ص��ļ���Ҳ�������ӵ������е�ĳ���ļ�����ɿ�ݷ�ʽ��
local title_link_to_folder_ = {English = 'Folder',Chinese = '�ļ���'}-- �ļ���Ҳһ��
local title_link_to_exe_ = {English = 'Installable Program',Chinese = '�ɰ�װ����'}
local title_link_to_member_ = {English = 'Member',Chinese = '����'}
local title_link_to_view_ = {English = 'View',Chinese = '��ͼ'}

local action_information_;
local action_add_file_;
local action_add_folder_;
local action_chmod_;
local action_import_folder_;
local action_import_file_;
local action_import_id_;
local action_hide_project_;
local action_delete_project_;
local action_edit_information_;
local action_save_project_;
local action_server_backup_;
local action_server_update_;
local action_server_history_;
--local action_workflow_;
local action_workflow_start_;
local action_workflow_stop_;
local action_workflow_status_;
local action_workflow_commit_;
local action_personal_folder_;
local action_ins_folder_;
local action_ins_file_;
local action_link_to_file_;
local action_link_to_folder_;
local action_link_to_exe_;
local action_link_to_member_;
local action_link_to_view_;

local item_information_;
local item_add_;
local item_add_file_;
local item_add_folder_;
local item_chmod_;
local item_import_;
local item_import_file_;
local item_import_folder_;
local item_import_id_;
local item_hide_project_;
local item_delete_project_;
local item_edit_information_;
local item_save_project_;
local item_server_;
local item_server_backup_;
local item_server_update_;
local item_server_history_;
--local item_workflow_;
local item_workflow_start_;
local item_workflow_stop_;
local item_workflow_status_;
local item_workflow_commit_;
local item_personal_folder_;
local item_ins_;
local item_ins_folder_;
local item_ins_file_;
local item_link_to_;
local item_link_to_file_;
local item_link_to_folder_;
local item_link_to_exe_;
local item_link_to_member_;
local item_link_to_view_;

item_information_ = {action = action_information_}
local function sub_add_items()
	return {
		item_add_folder_;
		item_add_file_;
	}
end
item_add_ = {submenu = sub_add_items}
item_add_folder_ = {action = action_add_folder_}
item_add_file_ = {action = action_add_file_}
item_chmod_ = {action = action_chmod_}
local function sub_import_items()
	return {
		item_import_folder_;
		item_import_file_;
		'';
		item_import_id_;
	}
end
item_import_ = {submenu = sub_import_items}
item_import_folder_ = {action = action_import_folder_}
item_import_file_ = {action = action_import_file_}
item_import_id_ = {action = action_import_id_}
item_hide_project_ = {action = action_hide_project_}
item_delete_project_ = {action = action_delete_project_}
item_edit_information_= {action = action_edit_information_}
item_save_project_= {action = action_save_project_}
local function sub_server_items()
	return {
		item_server_backup_;
		item_server_update_;
		'';
		item_server_history_;
	}
end
item_server_= {submenu = sub_server_items}
item_server_backup_ = {action = action_server_backup_}
item_server_update_ = {action = action_server_update_}
item_server_history_ = {action = action_server_history_}
local function sub_workflow_items()
	return {
		item_workflow_start_;
		item_workflow_commit_;
		item_workflow_stop_;
		'';
		item_workflow_status_;
	}
end
item_workflow_ = {submenu = sub_workflow_items}
item_workflow_start_ = {action = action_workflow_start_}
item_workflow_stop_ = {action = action_workflow_stop_}
item_workflow_commit_ = {action = action_workflow_commit_}
item_workflow_status_ = {action = action_workflow_status_}
item_personal_folder_ = {action = action_personal_folder_}
local function sub_ins_items()
	return {
		item_ins_folder_;
		item_ins_file_;
	}
end
item_ins_ = {submenu = sub_ins_items}
item_ins_file_ = {action = item_ins_file_}
item_ins_folder_ = {action = item_ins_folder_}
local function sub_link_to_items()
	return {
		item_link_to_folder_;
		item_link_to_file_;
		'';
		item_link_to_member_;
		item_link_to_view_;
		'';
		item_link_to_exe_;
	}
end
item_link_to_ = {submenu = sub_link_to_items}
item_link_to_file_ = {action = action_link_to_file_}
item_link_to_folder_ = {action = action_link_to_folder_}
item_link_to_member_ = {action = action_link_to_member_}
item_link_to_view_ = {action = action_link_to_view_}
item_link_to_exe_ = {action = action_link_to_exe_}
--------------------------------------------------------------------------------------------------------
--api
local function init()
	local lan = language_.get()
	cur_language_=  lan and language_support_[lan] or 'English'
	item_create_.title = title_create_[cur_language_]
	item_import_project_.title = title_import_project_[cur_language_]
	item_sort_.title = title_sort_[cur_language_]
	item_sort_date_.title = title_sort_date_[cur_language_]
	item_sort_name_.title = title_sort_name_[cur_language_]
	item_statistics_.title = title_statistics_[cur_language_]
	
	item_information_.title = title_information_[cur_language_]
	item_add_.title = title_add_[cur_language_]
	item_add_folder_.title = title_add_folder_[cur_language_]
	item_add_file_.title = title_add_file_[cur_language_]
	item_chmod_.title = title_chmod_[cur_language_]
	item_hide_project_.title = title_hide_project_[cur_language_]
	item_delete_project_.title = title_delete_project_[cur_language_]
	item_edit_information_.title = title_edit_information_[cur_language_]
	item_save_project_.title = title_save_project_[cur_language_]
	item_server_.title = title_server_[cur_language_]
	item_server_backup_.title = title_server_backup_[cur_language_]
	item_server_update_.title = title_server_update_[cur_language_]
	item_server_history_.title = title_server_history_[cur_language_]
	item_personal_folder_.title = title_personal_folder_[cur_language_]
	item_ins_.title = title_ins_[cur_language_]
	item_ins_folder_.title = title_ins_folder_[cur_language_]
	item_ins_file_.title = title_ins_file_[cur_language_]
	item_link_to_.title = title_link_to_[cur_language_]
	item_link_to_file_.title = title_link_to_file_[cur_language_]
	item_link_to_folder_.title = title_link_to_folder_[cur_language_]
	item_link_to_exe_.title = title_link_to_exe_[cur_language_]
	item_link_to_member_.title = title_link_to_member_[cur_language_]
	item_link_to_view_.title = title_link_to_view_[cur_language_]
	item_manage_.title = title_manage_[cur_language_]
	item_import_.title = title_import_[cur_language_]
	item_import_file_.title = title_import_file_[cur_language_]
	item_import_folder_.title = title_import_folder_[cur_language_]
	item_import_id_.title = title_import_id_[cur_language_]
end

function get()
	init()
	return {
		item_create_;
		item_import_project_;
		'';
		item_manage_;
		item_sort_;
		'';
		item_statistics_;
	}
end

function get_project_menu()
	init()
	return {
		item_save_project_;
		'';
		item_add_;
		item_import_;
		'';
		item_edit_information_;
		item_delete_project_;
		item_hide_project_;
		'';
		item_server_;
		'';
		item_chmod_;
		item_information_;
	}
end

function get_branch_menu()
	init()
	return {
		item_add_;
		item_ins_;
		item_import_;
		'';
		item_edit_information_;
		item_delete_project_;
		item_hide_project_;
		'';
		item_personal_folder_;
		item_link_to_;
		'';
		item_server_;
		'';
		item_chmod_;
		item_information_;


	}
end

function get_leaf_menu()
	init()
	return {
		item_ins_;
		'';
		item_edit_information_;
		item_delete_project_;
		item_hide_project_;
		'';
		item_personal_folder_;
		item_link_to_;
		'';
		item_server_;
		'';
		item_chmod_;
		item_information_;
	}
end
--------------------------------------------------------------------------------------------
--action function

action_create_ = function ()
	local tree = tree_.get()
	local id = tree_.get_current_id()
	--do something
end

action_import_project = function() end 
action_sort_name_ = function() end 
action_sort_date_ = function() end 
action_statistics_ = function() end 
action_manage_ = function() end 


action_information_ = function() end
action_add_file_ = function() end
action_add_folder_ = function() end
action_chmod_ = function() end
action_import_folder_ = function() end
action_import_file_ = function() end
action_import_id_ = function() end
action_hide_project_ = function() end
action_delete_project_ = function() end
action_edit_information_ = function() end
action_save_project_ = function() end
action_server_backup_ = function() end 
action_server_update_ = function() end 
action_server_history_ = function() end 
action_workflow_start_ = function() end 
action_workflow_stop_ = function() end 
action_workflow_commit_ = function() end 
action_workflow_status_ = function() end 
action_ins_file_ = function() end 
action_ins_folder_ = function() end 
action_personal_folder_ = function() end 
action_link_to_view_ = function() end 
action_link_to_member_ = function() end 
action_link_to_exe_ = function() end 
action_link_to_folder_ = function () end 
action_link_to_file_ = function() end 



