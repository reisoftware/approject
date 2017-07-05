local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local type = type

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local language_ = require 'sys.language'
local iup = require 'iuplua'

local language_package_ = {
	support_ = {English = 'English',Chinese = 'Chinese'};
	dlg = {English = 'Title Setting',Chinese = '标题设置'};
	ok = {English = 'Ok',Chinese = '确认'};
	cancel = {English = 'Cancel',Chinese = '取消'};
	name = {English = 'Name : ',Chinese = '名称 ： '};
}

local btn_wid = '80x'
local btn_ok_ = iup.button{title = "Ok",rastersize = btn_wid,  };
local btn_cancel_ = iup.button{title = "Close",rastersize = btn_wid};
local lab_name_ = iup.label{title = "Name : ",};
local txt_name_ = iup.text{rastersize = "400x",expand ="HORIZONTAL"};

local dlg_ = iup.dialog{
	iup.vbox{
		iup.hbox{lab_name_,txt_name_};
		iup.hbox{btn_ok_,btn_cancel_};
		alignment = "ARIGHT";
		margin = "5x5"
	};
	title = arg and arg.DlgName or "Title";
	resize = "NO";
}
iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)

--arg = {set_data,Warning}
function pop(arg)
	arg = arg or {}
	local lan =  language_.get()
	lan = lan and language_package_.support_[lan] or 'English'

	local function init_title()
		lab_name_.title = language_package_.name[lan]
		dlg_.title = language_package_.dlg[lan]
		btn_ok_.title = language_package_.ok[lan]
		btn_cancel_.title = language_package_.cancel[lan]
	end

	local function init_callback()
		function btn_ok_:action()
			if not string.find(txt_name_.value,"%S+") then return end 
			if arg.Warning and arg.Warning(txt_name_.value) then
				txt_name_.value = ''
				iup.SetFocus(txt_name_)
				return 
			end 
			dlg_:hide()
			if arg and  type(arg.set_data) == 'function' then 
				arg.set_data(txt_name_.value)
			end 
			
		end
		function btn_cancel_:action()
			dlg_:hide()
		end
	
	end 

	local function init_data()
		txt_name_.value = arg.name or ''
		iup.SetFocus(txt_name_)
	end

	local function init()
		init_title()
		init_callback()
		dlg_:map()
		init_data()
	end 
	init()
	dlg_:popup()
end

