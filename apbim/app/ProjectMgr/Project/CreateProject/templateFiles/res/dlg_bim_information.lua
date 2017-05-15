local require  = require 
local package_loaded_ = package.loaded
local frm_hwnd  = frm_hwnd 
local ipairs = ipairs
local string = string
local table = table
local type = type
local print = print
local tonumber = tonumber

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local iup = require 'iuplua'
require 'iupluacontrols'
require "iupluaimglib"
local language_;
local language_pack_ ;

local function init_language_pack()
	language_pack_ = {
		['English'] =true;
		['Chinese'] = true;
		btn_ok = {
			['English'] = 'Ok';
			['Chinese'] = '����';
		};
		btn_cancel = {
			['English'] = 'Cacnel';
			['Chinese'] = 'ȡ��';
		};
		tabtile_project_introduction = {
			['English'] = 'Introduction';
			['Chinese'] = '����';
		};
		lab_project_id = {
			['English'] = 'No. : ';
			['Chinese'] = '��� �� ';
		};
		lab_project_category = {
			['English'] = 'Category  : ';
			['Chinese'] = '��� �� ';
		};
		lab_project_property = {
			['English'] = 'Property : ';
			['Chinese'] = '���� �� ';
		};
		lab_start_time= {
			['English'] = 'Start Time : ';
			['Chinese'] = '����ʱ�� �� ';
		};
		lab_end_time= {
			['English'] = 'End Time : ';
			['Chinese'] = '����ʱ�� �� ';
		};
		lab_plan_time= {
			['English'] = 'Plan Time : ';
			['Chinese'] = 'Ԥ��ʱ�� �� ';
		};
		frame_description = {
			['English'] = 'Description';
			['Chinese'] = '����';
		};
		dlg_title =  {
			['English'] = 'Setting Project Base information';
			['Chinese'] = '���ù��̻�����Ϣ';
		};
	}
end

local btn_ok_;
local btn_cancel_;
local lab_company_;
local list_company_;
local lab_address_;
local list_address_;
local tab_;
local lab_project_id_;
local txt_project_id_;
local dlg_;

local function init_language()
	-- language_ = require 'sys.language'.get()
	if not language_ or not language_pack_[language_] then 
		language_ ='English'  --'English' 
	end
end

local function init_buttons()
	local wid = '70x'
	btn_ok_ = iup.button{}
	btn_ok_.title =  language_pack_.btn_ok[language_] 
	btn_ok_.rastersize = wid
	
	btn_cancel_ = iup.button{}
	btn_cancel_.title = language_pack_.btn_cancel[language_] 
	btn_cancel_.rastersize = wid
end

local function init_controls()
	local lab_wid = '100x'
	
	lab_project_id_ = iup.label{}
	lab_project_id_.title =  language_pack_.lab_project_id[language_] 
	lab_project_id_.rastersize = lab_wid
	txt_project_id_ = iup.text{expand = 'HORIZONTAL';rastersize = '200x'}
	
	lab_project_category_ = iup.label{}
	lab_project_category_.title =  language_pack_.lab_project_category[language_] 
	lab_project_category_.rastersize = lab_wid
	txt_project_category_ = iup.text{expand = 'HORIZONTAL';rastersize = '200x'}
	
	lab_project_property_ = 	iup.label{}
	lab_project_property_.title =  language_pack_.lab_project_property[language_] 
	lab_project_property_.rastersize = lab_wid
	txt_project_property_ = iup.text{expand = 'HORIZONTAL';rastersize = '200x'}

	lab_start_time_ = 	iup.label{}
	lab_start_time_.title =  language_pack_.lab_start_time[language_] 
	lab_start_time_.rastersize = lab_wid
	txt_start_time_ = iup.datepick{ZEROPRECED= 'yes',ORDER = 'MDY',CALENDARWEEKNUMBERS = 'yes',expand = 'HORIZONTAL'}
	
	lab_end_time_ = 	iup.label{}
	lab_end_time_.title =  language_pack_.lab_end_time[language_] 
	lab_end_time_.rastersize = lab_wid
	-- txt_end_time_ = iup.text{expand = 'HORIZONTAL';rastersize = '200x'}
	txt_end_time_ = iup.datepick{ZEROPRECED= 'yes',ORDER = 'MDY',CALENDARWEEKNUMBERS = 'yes',expand = 'HORIZONTAL'}
	
	lab_plan_time_ = 	iup.label{}
	lab_plan_time_.title =  language_pack_.lab_plan_time[language_] 
	lab_plan_time_.rastersize = lab_wid
	txt_plan_time_ = iup.datepick{ZEROPRECED= 'yes',ORDER = 'MDY',CALENDARWEEKNUMBERS = 'yes',expand = 'HORIZONTAL'}
	
	txt_description_ = iup.text{expand = 'HORIZONTAL';rastersize = '400x200',multiline = 'YES',}
	frame_description_ = iup.frame{
		txt_description_;
		title = language_pack_.frame_description[language_] ;
	}
	
	frame_project_introduction_ --= iup.frame{
	=	iup.vbox{
			iup.hbox{lab_project_id_,txt_project_id_};
			iup.hbox{lab_project_category_,txt_project_category_};
			iup.hbox{lab_project_property_,txt_project_property_};
			iup.hbox{lab_start_time_,txt_start_time_};
			iup.hbox{lab_plan_time_,txt_plan_time_};
			iup.hbox{lab_end_time_,txt_end_time_};
			iup.hbox{frame_description_};
			margin = '5x5';
			alignment = 'ALEFT';
			tabtitle =  language_pack_.tabtile_project_introduction[language_] 
		};
		
	-- }
	tabs_ = iup.tabs{frame_project_introduction_}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			tabs_;
			iup.hbox{btn_ok_,btn_cancel_};
			margin = '10x10';
			alignment = 'ARIGHT';
		};
		title =  language_pack_.dlg_title[language_] 
	}
end

local function init_callback()
	function btn_cancel_:action()
		dlg_:hide()
	end
	
	function btn_ok_:action()
		data_ = {}
		data_.number = txt_project_id_.value
		data_.number = txt_project_id_.value
		data_.number = txt_project_id_.value
		data_.number = txt_project_id_.value
		data_.number = txt_project_id_.value
	end
end

local function init_data()
	data_ = nil
end

local function init()
	init_language_pack()
	init_language()
	init_buttons()
	init_controls()
	init_dlg()
end

local function show()
	init_callback()
	dlg_:map()
	init_data()
	dlg_:popup()
end

function pop()
	if not dlg_ then init() end 
	show()
end

function get_data()
	return data_
end