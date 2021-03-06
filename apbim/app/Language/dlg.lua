local string = string
local print = print
local type = type
local require =require
local pairs = pairs
local enablewindow = enablewindow
local frm_hwnd = frm_hwnd
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] =M
_ENV = M

local language_ = require 'sys.language'
local language_file_ = "cfg/language.lua";
local iup = require 'iuplua'
local default_language_ = 'English'
local language_package_ = {
	support_ = {English = 'English',Chinese = 'Chinese'};
	dlg = {English = 'Change Language',Chinese = '�л�����'};
	ok = {English = 'Ok',Chinese = 'ȷ��'};
	cancel = {English = 'Cancel',Chinese = 'ȡ��'};
	title = {English = 'Language : ',Chinese = '���� �� '};
}

local lab_wid = '80x'
local lab_title_ = iup.label{rastersize = lab_wid}
local list_title_ = iup.list{
	expand="HORIZONTAL",editbox="NO",DROPDOWN="Yes",rastersize = '200x',
	alignment = 'ARIGHT';
	}


local btn_wid = '80x'
local btn_ok_ = iup.button{rastersize = btn_wid}
local btn_cancel_ = iup.button{rastersize = btn_wid}


local dlg_ = iup.dialog{
	iup.vbox{
		iup.hbox{lab_title_,list_title_};
		iup.hbox{btn_ok_,btn_cancel_};
		margin ='5x5';
		alignment = 'ARIGHT';
		-- rastersize = '400x';
	};
	expand = 'YES';
}


local function get_lan()
	local s = require"sys.io".read_file{file=language_file_};
	if type(s)~="table" then s={} end
	return s;
end

local function save_lan(name)
	local t = {}
	t.language = name
	require'sys.table'.tofile{file=language_file_,src=t};
	language_.set(name)
end

local function init_callback(arg)
	arg = arg or {}
	local function quit()
		enablewindow(frm_hwnd,true)
	end
	
	function btn_ok_:action()
		local name = list_title_[list_title_.value]
		save_lan(name)
		dlg_:hide()
		quit()
	end

	function btn_cancel_:action()
		dlg_:hide()
		quit()
	end
	
	function dlg_:close_cb()
		quit()
	
	end
	
	function dlg_:show_cb()
		enablewindow(frm_hwnd,false)
	end
	
		
end

local function init_data(data)
	local data = language_.get_language_list()
	for k,v in pairs(data) do 
		list_title_.appenditem= k
		if v == language_.get() then	
			list_title_.value = list_title_.count
		end
	end
end

function pop(arg)
	arg  = arg or {}
	local lan =  language_.get()
	lan = lan and language_package_.support_[lan] or 'English'

	local function init_title()
		lab_title_.title = language_package_.title[lan]
		dlg_.title = language_package_.dlg[lan]
		btn_ok_.title = language_package_.ok[lan]
		btn_cancel_.title = language_package_.cancel[lan]
		list_title_[1] = nil
	end
	
	local function init()
		init_title()
		init_callback(arg)
	end
	
	

	local function show()
		dlg_:map()
		init_data()
		dlg_:popup()
	end
	init()
	show()

end
