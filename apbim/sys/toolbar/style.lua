local require = require;
local reload = reload;

_ENV = module(...)

local control_ = require'sys.toolbar.control';
local dat_ = require'sys.toolbar.dat'


--[[
return{
	[1]={
		bmpname = 'cfg/bmp/toolbar1.bmp';
		[1]={
			name="",
			keyword="",
			image=,
		},
		[2]={
			name="",
			keyword="",
			image=,
		},
		[3]={name=nil},--�ָ���
		...
		},
	};
	[2]={
		...
	};
	...
}; 
--]]

function update()
	--clear_toolbar()	--ж�ص�ȫ��������Ȼ�����¼���
	local style = reload('cfg.toolbar');
	local dat = dat_.get_all();
	control_.create_toolbars(style,dat);	
end

function init()
	control_.init_toolbar();
end
--[[
��Ҫ��
--�����û��Զ���˵��Ľ���
1.��ԭʼ�˵������ļ�
2.���Զ���˵��ļ�
3.�Զ����޸Ĳ˵�
4.д�Զ���˵��ļ�
--]]

