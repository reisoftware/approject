
local require  = require 
local package_loaded_ = package.loaded
local load = nil
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local language_package_ = {
	support_ = {English = 'English',Chinese = 'Chinese'};
	close = {English = 'Close',Chinese = '�ر�'};
	change = {English = 'Change',Chinese = '�޸�'};
	name = {English = 'Name : ',Chinese = '�û� ��'};
	pwd = {English = 'Password : ',Chinese = '���� ��'};
	mail = {English = 'Mail : ',Chinese = '�ʼ� ��'};
	pwd = {English = 'Phone : ',Chinese = '�绰 ��'};
	--pwd = {English = 'Company : ',Chinese = '������Ϣ ��'};
} 


local dlg_;
local lab_wid = '70x'
local lab_name_ = iup.label{rastersize = lab_wid}
local lab_mail_ = iup.label{rastersize = lab_wid}
local lab_pwd_ = iup.label{rastersize = lab_wid}
local lab_phone_ = iup.label{rastersize = lab_wid}
local lab_note_ = iup.label{rastersize = lab_wid}
