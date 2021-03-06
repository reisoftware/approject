

local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local print = print
local table = table
local os_exit_ = os.exit
local pairs = pairs
local string = string

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M

_ENV = M

local language_ = require 'sys.language'
local cur_language_ = 'English'
local tree_ = require 'app.projectmgr.workspace.tree'
local main_ =  require 'app.projectmgr.workspace.main'

--[[
	local tree = tree_.get()
	local id = tree_.get_current_id()
--]]
--------------------------------------------------------------------------------------------------------
-- define var
local language_support_ = {English = 'English',Chinese = 'Chinese'}

local title_property_ = {English = 'Persional Information',Chinese = '个人信息'}
local title_change_pwd_ = {English = 'Change Password',Chinese = '修改密码'}
local title_logout_ = {English = 'Logout',Chinese = '登出'}
local title_change_user_ = {English = 'Change User',Chinese = '切换用户'}
local title_update_ = {English = 'Update',Chinese = '更新'}

local item_property_ = {};
local item_change_pwd_ = {};
local item_logout_ = {};
local item_change_user_ = {};
local item_update_ = {};


--------------------------------------------------------------------------------------------------------
--item

--------------------------------------------------------------------------------------------------------
--api
local function init()

	local lan = language_.get()
	cur_language_=  lan and language_support_[lan] or 'English'
	item_property_.title = title_property_[cur_language_]
	item_change_pwd_.title = title_change_pwd_[cur_language_]
	item_change_user_.title = title_change_user_[cur_language_]
	item_logout_.title = title_logout_[cur_language_]
	item_update_.title = title_update_[cur_language_]
	
end

function get()
	init()
	return {
		-- item_update_;
		-- '';
		item_property_;
		'';
		item_change_user_;
		item_change_pwd_;
		'';
		item_logout_;
	}
end
--------------------------------------------------------------------------------------------
--action function
local dlg_reg_ = require 'app.loginpro.dlg_register'
local dlg_login_ = require 'app.loginpro.dlg_login'
local dlg_cg_pwd_ = require 'app.loginpro.dlg_change_password'
local server_ = require 'app.projectmgr.net.server'

item_property_.action = function ()
	local function pop()
		local data = require 'sys.user'.get_userinfo()
		local tree = tree_.get()
		dlg_reg_.pop{data = data,show = true}
	end
	server_.get_user_info{cbf = pop}
end

item_change_pwd_.action = function() 
	dlg_cg_pwd_.pop()
end 

item_change_user_.action = function() 
	local function on_ok()
		-- require 'sys.main'.init()
		main_.update()
	end
	dlg_login_.pop{on_ok = on_ok,on_cancel = on_cancel}
end 

item_logout_.action = function() 
	local function save()
	end
	local function close()
		os_exit_ ()
	end
	-- save()
	close()
end 

item_update_.action = function()
	local function cbf()
		main_.update()
	end
	server_.update_user_list{cbf = cbf}
	
end
