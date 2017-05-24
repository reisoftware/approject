
local require = require
local type = type
local setmetatable = setmetatable
local table = table
local next_ = _G.next
local ipairs = ipairs
local print = print

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M
---------------------------------------------------------------------------------------------------
--[[
	data�ṹʾ����
		data = {
			{title = ,action = ,active = }; -- һ��item���˵��е�һ���
			{	
				title = ,
				submenu = {  -- �μ��˵�
					{title = ,action = ,active = }; -- һ��item���˵��е�һ���
					{title = ,action = ,active = }; -- һ��item���˵��е�һ���
				};
			};
			''; -- �ָ���,ע��ֻҪ����table�ṹ��Ĭ��Ϊ�Ƿָ���
			{title = ,action = ,active = };
		}
	item ��⣺
	item = {title,action,active,...} --��Щ�ؼ������Դ󲿷ַ���iup����
		title ����item���⣬ֵͨ��Ϊstring����,
		action ���������Ϣ��ֵͨ��Ϊfunction����
		active ��Ӧ�ò˵���״̬,ֵ�����Ϳ���ֱ�Ӹ��� string ���͵�ֵ��Ҳ�����Ǹ�function ���͸ú����б����з���ֵ��ֵ��������string��
			�ɽ��ܵ�string��ֵ��'yes','no','hide'
--]]
---------------------------------------------------------------------------------------------------
local iup = require 'iuplua'

local function create_item(arg)
	if type(arg) ~= "table" then return end 
	return iup.item(arg)
end

function create(arg)
	if type(arg) ~= "table" then return end 
	return iup.menu(arg)
end

function create_submenu(arg)
	if type(arg) ~= "table" then return end 
	return iup.submenu(arg);
end

function separator()
	return iup.separator{sep_ = true}
end

function refresh_menu(menu)
	iup.Refresh(menu)
end
---------------------------------------------------------------------------------------------------

local Class = {
}

function new(t)
	local t = t or {}
	setmetatable(t,Class)
	Class.__index = Class;
	return t
end

local function table_is_empty(t)
	return next_(t) == nil
end

function Class:get_rmenu()
	return self.rmenu
end

function Class:set_data(datas)
	self.data = datas
end

function Class:get_data()
	return self.data
end

function Class:add_item(menu,item)
	if not menu or  not item then return end 
	local cur_item;
	if type(item) == 'table' then 
		local active;
		if type(item.active) == 'string' then 
			active = item.active
		elseif  type(item.active) == 'function' then 
			active = item.active()
		end 
		if active and active == 'hide' then return end 
		cur_item = create_item{title = item.title,action = item.action,active = active,}
	else
		cur_item = separator()
	end 	
	if type(menu) == 'table' then
		table.insert(menu,cur_item)
	elseif type(menu) == 'userdata' then
		iup.Append(menu,cur_item)
	end
end

function Class:add_submenu(menu,title,submenu)
	local item = create_submenu{
		title = title;
		create(submenu);
	}
	table.insert(menu,item)
end

local function init_data(data,menu)
	for k,v in ipairs(data) do 
		if v.submenu then 
			local submenu = {}
			if type(v.submenu) == 'table' then 
				init_data(v.submenu,submenu)
			elseif type(v.submenu) == 'function' then 
				local t = v.submenu() or {}
				init_data(t,submenu)
			end 
			Class:add_submenu(menu,v.title,submenu)
		else 
			Class:add_item(menu,v)
		end 
	end 
end

function Class:init()
	if type(self.data) ~= 'table' or table_is_empty(self.data) then return end 
	local menu = {}
	init_data(self.data,menu)
	self.rmenu = create(menu)
	self.rmenu.menuclose_cb = function() iup.Destroy(t.rmenu) t.rmenu = nil end
	return true
end

function Class:show()
	if not self:init() then return end 
	if not self.rmenu then return end 
	iup.Refresh(self.rmenu)
	self.rmenu:popup(iup.MOUSEPOS,iup.MOUSEPOS)
end
