local dofile = dofile;
local require = require;
local reload = reload;

_ENV = module(...)

local control_ = require'sys.menu.control';
local dat_ = require'sys.menu.dat';

--[[
tree={
	[1]={
		name="",
		subs={
		[1]={
			name="",
			subs={},
		},
		[2]={
			name="",
			keyword="",
		},
		[3]={name=nil},�ָ���
		...
		},
	},
	[2]={},
	...
}; 
--]]

function update()
	--clear_menu()	--ж�ص�ȫ���˵�Ȼ�����¼���
	-- local style = reload('cfg.menu');
	local style = dofile('cfg/menu.lua');
	local dat = dat_.get_all();
	control_.create_menus(style,dat);
end

function init()
	control_.init_menu();
end

--[[
��Ҫ��
--�����û��Զ���˵��Ľ���
1.��ԭʼ�˵������ļ�
2.���Զ���˵��ļ�
3.�Զ����޸Ĳ˵�
4.д�Զ���˵��ļ�
--]]

