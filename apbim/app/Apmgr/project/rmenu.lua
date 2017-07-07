

local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local print = print
local table = table
local os_exit_ = os.exit
local pairs = pairs
local ipairs = ipairs
local string = string

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local tree_ =  require 'app.apmgr.project.tree'
local project_ = require 'app.Apmgr.project.project'

local language_ = require 'sys.language'
local cur_language_ = 'English'
local op_ = require 'app.apmgr.project.op'
local language_support_ = {English = 'English',Chinese = 'Chinese'}

local title_create_project_ = {English = 'Create Project',Chinese = '创建工程'}
local title_properties_ = {English = 'Properties',Chinese = '属性'}
local title_project_properties_ = {English = 'Project Properties',Chinese = '工程属性'}
local title_create_ = {English = 'Create',Chinese = '创建'}
local title_file_  = {English = 'File',Chinese = '文件'}
local title_folder_ = {English = 'Folder',Chinese = '文件夹'}
local title_open_ = {English = 'Open',Chinese = '打开'}
local title_save_ = {English = 'Save',Chinese = '保存'}
local title_close_ = {English = 'Close',Chinese = '关闭'}
local title_close_project_ = {English = 'Close Project',Chinese = '关闭工程'}
local title_delete_ = {English = 'Delete',Chinese = '删除'}
local title_delete_project_ = {English = 'Delete Project',Chinese = '删除工程'}
local title_edit_ = {English = 'Edit',Chinese = '编辑'}
local title_edit_project_ = {English = 'Edit Information',Chinese = '编辑信息'}
local title_show_style_ = {English = 'Project Show Style',Chinese = '工程显示样式'}
local title_import_ = {English = 'Import',Chinese= '导入'}
local title_create_ = {English = 'Create',Chinese = '创建'}
local title_rename_ = {English = 'Rename',Chinese = '重命名'}
local title_link_to_ = {English = 'Link To ',Chinese = '链接到'} 
local title_link_to_exe_ = {English = 'Installable Program',Chinese = '可安装程序'}
local title_model_ = {English = 'Selected Model',Chinese = '选中的模型'}
local title_view_ = {English = 'Current View',Chinese = '当前视图'}
local title_submit_ = {English = 'Submit',Chinese = '提交'}
local title_load_ = {English = 'Load Project',Chinese = '加载工程'}
local title_create_folder_ = {English = 'Create Folder',Chinese = '创建文件夹'}
local title_import_folder_ = {English = 'Import Folder',Chinese = '导入文件夹'}
local title_save_template_ = {English = 'Create Project Template',Chinese = '创建工程模板'}
local title_import_template_ = {English = 'Import Template',Chinese = '导入模板'}
local title_pack_ = {English = 'Packing To Declare',Chinese = '申报项目打包'}
local title_extended_ = {English = 'Function plug-in',Chinese = '功能插件'}
local title_import_db_ = {English = 'Model File',Chinese = '模型数据文件'}
local title_bim_number_ =  {English = 'Set Number',Chinese = '设置编号名'}
local title_show_model_ =  {English = 'Show Model',Chinese = '显示模型'}

local title_insert_ =  {English = 'Insert',Chinese = '插入'}
local title_link_db_ =  {English = 'SQLite Table',Chinese = 'SQLite 表'}
local title_auto_link_ = {English = 'Auto Link',Chinese = '自动链接'}

local item_create_project_ = {}
local item_quit_ = {}
local item_open_project_ = {}
local item_save_project_ = {}
local item_close_project_ = {}
local item_delete_project_ = {}
local item_edit_project_ = {}
local item_show_style_ = {}
local item_import_ = {};
local item_import_file_ = {};
local item_import_folder_ = {};
local item_import_db_ = {};
local item_create_ = {};
local item_create_file_ = {};
local item_create_folder_ = {};
local item_properties_ = {}
local item_project_properties_ = {}
local item_delete_= {}
local item_link_to_ = {};
local item_link_to_file_ = {};
local item_link_to_folder_ = {};
local item_link_to_exe_ = {};
local item_link_to_model_ = {};
local item_link_to_view_ = {};
local item_rename_ = {};
local item_edit_ = {};
local item_submit_project_ = {}
local item_open_ = {};
local item_project_create_folder_ = {}
local item_project_import_folder_ = {}

local item_save_template_ = {}
local item_import_template_ = {}
local item_pack_ = {};
local item_extend_ = {};
local item_bim_number_ = {};
local item_show_model_ = {};
local item_insert_ = {}
local item_insert_folder_ = {}
local item_insert_file_ = {}
local item_link_to_db_ = {}
local item_auto_link_ = {}

local function sub_insert_items()
	return {
		item_insert_folder_;
		item_insert_file_;
	}
end
item_insert_ = {submenu = sub_insert_items}

local function sub_import_items()
	return {
		item_import_folder_;
		item_import_file_;
		'';
		item_import_db_;
	}
end
item_import_ = {submenu = sub_import_items}
local function sub_add_items()
	return {
		item_create_folder_;
		item_create_file_;
	}
end
item_create_ = {submenu = sub_add_items}

local function sub_link_to_items()
	local tree = tree_.get()
	local id = tree_.get_id()
	local kind = tree:get_node_kind(id)
	local file = kind == 'LEAF' and true
	if file then 	
		return {
			item_link_to_file_;
			'';
			item_link_to_model_;
			item_link_to_view_;
			'';
			item_link_to_db_;
			'';
			item_auto_link_;
		}
	else 
		return {
			item_link_to_folder_;
			'';
			item_link_to_model_;
			item_link_to_view_;
			'';
			item_link_to_db_;
			'';
			item_auto_link_;
			-- '';
			-- item_link_to_exe_;
		}
	end
	
end
item_link_to_ = {submenu = sub_link_to_items}

--------------------------------------------------------------------------------------------------------
--api
local function init_title()
	local lan = language_.get()
	cur_language_=  lan and language_support_[lan] or 'English'
	item_close_project_.title = title_close_project_[cur_language_]
	item_create_project_.title = title_create_project_[cur_language_]
	item_open_project_.title = title_load_[cur_language_]
	item_save_project_.title = title_save_[cur_language_]
	item_quit_.title = title_close_[cur_language_]
	item_delete_project_.title = title_delete_project_[cur_language_]
	item_edit_project_.title = title_edit_project_[cur_language_]
	item_show_style_.title = title_show_style_[cur_language_]
	item_project_properties_.title = title_project_properties_[cur_language_]
	
	item_properties_.title = title_properties_[cur_language_]
	item_import_.title = title_import_[cur_language_]
	item_import_file_.title = title_file_[cur_language_]
	item_import_folder_.title = title_folder_[cur_language_]
	item_delete_.title = title_delete_[cur_language_]
	item_rename_.title = title_rename_[cur_language_]
	item_edit_.title = title_edit_[cur_language_]
	
	item_link_to_.title = title_link_to_[cur_language_]
	item_link_to_file_.title = title_file_[cur_language_]
	item_link_to_folder_.title = title_folder_[cur_language_]
	item_link_to_exe_.title = title_link_to_exe_[cur_language_]
	item_link_to_model_.title = title_model_[cur_language_]
	item_link_to_view_.title = title_view_[cur_language_]
	item_create_.title = title_create_[cur_language_]
	item_create_folder_.title = title_folder_[cur_language_];
	item_create_file_.title = title_file_[cur_language_];
	item_submit_project_.title = title_submit_[cur_language_];
	item_open_.title = title_open_[cur_language_];
	item_project_create_folder_.title = title_create_folder_[cur_language_];
	item_project_import_folder_.title = title_import_folder_[cur_language_];
	item_save_template_.title = title_save_template_[cur_language_];
	item_import_template_.title = title_import_template_[cur_language_];
	item_pack_.title = title_pack_[cur_language_];
	item_extend_.title = title_extended_[cur_language_];
	item_import_db_.title = title_import_db_[cur_language_];
	item_show_model_.title = title_show_model_[cur_language_];
	item_bim_number_.title = title_bim_number_[cur_language_];
	item_insert_.title = title_insert_[cur_language_]
	item_insert_file_.title = title_file_[cur_language_]
	item_insert_folder_.title = title_folder_[cur_language_]
	
	item_link_to_db_.title = title_link_db_[cur_language_]
	item_auto_link_.title = title_auto_link_[cur_language_]
end

local function init_active(state)
	item_close_project_.active = state;
	item_create_project_.active = state;
	item_open_project_.active = state;
	item_save_project_.active = state;
	item_quit_.active = state;
	item_delete_project_.active = state;
	item_edit_project_.active = state;
	item_show_style_.active = state;
	
	item_properties_.active = state;
	item_import_.active = state;
	item_import_file_.active = state;
	item_import_folder_.active = state;
	item_delete_.active = state;
	item_rename_.active = state;
	item_edit_.active = state;
	
	item_link_to_.active = state;
	item_link_to_file_.active = state;
	item_link_to_folder_.active = state;
	item_link_to_exe_.active = state;
	item_link_to_model_.active = state;
	item_link_to_view_.active = state;
	item_create_.active = state;
	item_create_folder_.active = state;
	item_create_file_.active = state;
	item_submit_project_.active = state;
	item_open_.active = state;
	item_project_create_folder_.active = state;
	item_project_import_folder_.active = state;
	item_save_template_.active = state
	item_import_template_.active = state
	
	item_pack_.active = state
	item_extend_.active = state
end

local function init()
	init_title()
	-- init_active('yes')
end

function get_root()
	init()
	return {
		item_create_project_;
		'';
		item_quit_;
	}
end

local function init_project_menu()
	local tree = tree_.get()
	local id = tree_.get_id()
	local data = tree:get_node_data(id)
	local pro = project_.get_project()
	local style = project_.get_project_style()
	if style  then 
		if style.fixed then 
			return {
				item_project_properties_;
			}
		else 
			return {
				item_show_style_;
				'';
				item_project_properties_;
			}
		end
	end 
	if pro and pro == data.file then 
		return  {
			item_project_create_folder_;
			item_project_import_folder_;
			item_import_template_;
			'';
			item_edit_project_;
			item_delete_project_;
			'';
			item_show_style_;
			item_pack_;
			item_extend_;
			'';
			item_show_model_;
			-- item_save_project_;
			item_save_template_;
			'';
			item_project_properties_;
			item_close_project_;
		}
	else 
		return {
			item_open_project_;
			'';
			item_delete_project_;
		}
	end
end

function get_project()
	init()
	return init_project_menu()
end

function get_folder()
	init()
	local style = project_.get_project_style()
	if style  then 
		return {
			item_properties_;
		}
	end 
	return {
		item_create_;
		item_insert_;
		item_import_;
		'';
		item_rename_;
		item_bim_number_;
		'';
		item_edit_;
		item_delete_;
		'';
		item_link_to_;
		'';
		item_properties_;
	}
end

function get_file()
	init()
	local style = project_.get_project_style()
	if style  then 
		return {
			item_open_;
			'';
			item_properties_;
		}
	end 
	
	return {
		item_open_;
		item_insert_;
		'';
		item_rename_;
		item_bim_number_;
		'';
		item_edit_;
		item_delete_;
		'';
		item_link_to_;
		'';
		item_properties_;
	}
end
--------------------------------------------------------------------------------------------
--action function
item_quit_.action = op_.quit;
item_create_project_.action = function() op_.project_new() end;
item_open_project_.action = function() op_.project_open() end;
item_save_project_.action = function() op_.project_save() end;
item_edit_project_.action = function() op_.edit_info() end;
item_delete_project_.action = function() op_.delete() end;
item_show_style_.action = function() op_.show_style() end;
item_properties_.action = function() op_.properties() end;
item_project_properties_.action = function() op_.properties() end;

item_close_project_.action = function() op_.project_close() end;

item_create_folder_.action = function() op_.create_folder() end;
item_create_file_.action = function() op_.create_file() end;
item_import_folder_.action = function() op_.import_folder() end;
item_import_file_.action = function() op_.import_file() end;
item_rename_.action = function() op_.rename() end;
item_edit_.action = function() op_.edit_info() end;
item_delete_.action = function() op_.delete() end;

item_open_.action = function() op_.open_file() end;
item_link_to_file_.action = function() 
	-- op_.link_to_file()
 end;
item_link_to_model_.action = function() 
	-- op_.link_to_model() 
end;
item_link_to_view_.action = function() 
	-- op_.link_to_view() 
end;
item_link_to_db_.action = function()  end;

item_project_create_folder_.action = function() op_.create_folder() end;
item_project_import_folder_.action = function() op_.import_folder() end;

item_save_template_.action = function() op_.save_project_template() end;
item_import_template_.action = function() op_.import_template() end;
item_bim_number_.action = function() op_.bim_number() end;
item_show_model_.action = function() op_.show_model() end;
item_import_db_.action = function() op_.import_db() end;

item_insert_file_.action = function() op_.insert_file() end;
item_insert_folder_.action = function() op_.insert_folder() end;
-- item_link_to_folder_;
-- item_link_to_file_;
-- item_link_to_model_;
-- item_link_to_view_;
-- item_link_to_exe_;