local require  = require 
local package_loaded_ = package.loaded
local io = io
local string = string 
local table = table
local type = type

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local file = 'app.ProjectMgr.info.user_gid_projects_file'

local function init_data()
	return {
		{
			name = '�����Ŀ',id = 1,

			{
				{
					name = 'App';
					{
						{
							name = 'Menu',exe = true;
						};
						{
							name = 'Toolbar',exe = true;
						};
					};
				};
				{
					name = 'ģ��';id=4;
					{
						{
							name ='��',id =5;
							{
								{
									name ='B-1',id =5;
								}	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='C-1',id =5;
								}	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='PL-1',id =5;
								}	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='��һ����',id =5;
								}	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='��һ��',id =5;
								},	
								{
									name ='�ڶ���',id =5;
								},	
								{
									name ='����',id =5;
								},	
								{
									name ='����һ��',id =5;
								},	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='ϵͳ��',id =5;
								},	
								{
									name ='�Զ�����',id =5;
								},	
							};
						};
					};
				};
				{
					
						name = '�ĵ�';id=4;
						{
							{
								name ='ͼֽ',id =5;
								{
									{

										name ='��ͼ',id =5;
									},	
									{
										name ='��ͼ',id =5;
									},	
								};
							};
							{
								name ='�����ļ�',id =5;
								{
									{
										name ='���̼ƻ�.doc',id =5;
									},	
									{
										name ='���.doc',id =5;
									},	
								};
							};
							{
								name ='֪ʶ��',id =5;
								{
									{
										name ='��������',id =5;
									},	
									{
										name ='����ͳ��',id =5;
									},	
								};
							};
							{
								name ='����ͳ��',id =5;
								{
									{
										name ='C�͸�',id =5;
									},	
									{
										name ='	H�͸�',id =5;
									},	
								};
							};
							
						};					
				};
				{
					name = '�Ŷ�';id=4;
					{
						{
							name ='zgb',id =5;
						};
					};
				};
				{
					name = '��ע';id=4;
					{
						{
							name ='2017-5-2��������',id =5;
						};
						{
							name ='2017-5-12��B-23����',id =5;
						};
					};
				};
				{
					name = '������';id=4;
					{
						{
							name ='���й�����',id =5;
						};
						{
							name ='���ڽ���',id =5;
						};
						{
							name ='�����',id =5;
						};
					};
				};
			};
		};
		{
			name = '�ϵ»�',id = 2,

			{
				{
					name = 'ģ��';id=4;
					{
						{
							name ='��',id =5;
							{
								{
									name ='B-1',id =5;
								}	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='C-1',id =5;
								}	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='PL-1',id =5;
								}	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='��һ����',id =5;
								}	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='��һ��',id =5;
								},	
								{
									name ='�ڶ���',id =5;
								},	
								{
									name ='����',id =5;
								},	
								{
									name ='����һ��',id =5;
								},	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='ϵͳ��',id =5;
								},	
								{
									name ='�Զ�����',id =5;
								},	
							};
						};
					};
				};
				{
					
						name = '�ĵ�';id=4;
						{
							{
								name ='ͼֽ',id =5;
								{
									{

										name ='��ͼ',id =5;
									},	
									{
										name ='��ͼ',id =5;
									},	
								};
							};
							{
								name ='�����ļ�',id =5;
								{
									{
										name ='���̼ƻ�.doc',id =5;
									},	
									{
										name ='���.doc',id =5;
									},	
								};
							};
							{
								name ='֪ʶ��',id =5;
								{
									{
										name ='��������',id =5;
									},	
									{
										name ='����ͳ��',id =5;
									},	
								};
							};
							{
								name ='����ͳ��',id =5;
								{
									{
										name ='C�͸�',id =5;
									},	
									{
										name ='	H�͸�',id =5;
									},	
								};
							};
							
						};					
				};
				{
					name = '�Ŷ�';id=4;
					{
						{
							name ='zgb',id =5;
						};
					};
				};
				{
					name = '��ע';id=4;
					{
						{
							name ='2017-5-2��������',id =5;
						};
						{
							name ='2017-5-12��B-23����',id =5;
						};
					};
				};
				{
					name = '������';id=4;
					{
						{
							name ='���й�����',id =5;
						};
						{
							name ='���ڽ���',id =5;
						};
						{
							name ='�����',id =5;
						};
					};
				};
			};		};
		{
			name = '����',id = 3,

			{
				{
					name = 'ģ��';id=4;
					{
						{
							name ='��',id =5;
							{
								{
									name ='B-1',id =5;
								}	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='C-1',id =5;
								}	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='PL-1',id =5;
								}	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='��һ����',id =5;
								}	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='��һ��',id =5;
								},	
								{
									name ='�ڶ���',id =5;
								},	
								{
									name ='����',id =5;
								},	
								{
									name ='����һ��',id =5;
								},	
							};
						};
						{
							name ='��',id =5;
							{
								{
									name ='ϵͳ��',id =5;
								},	
								{
									name ='�Զ�����',id =5;
								},	
							};
						};
					};
				};
				{
					
						name = '�ĵ�';id=4;
						{
							{
								name ='ͼֽ',id =5;
								{
									{

										name ='��ͼ',id =5;
									},	
									{
										name ='��ͼ',id =5;
									},	
								};
							};
							{
								name ='�����ļ�',id =5;
								{
									{
										name ='���̼ƻ�.doc',id =5;
									},	
									{
										name ='���.doc',id =5;
									},	
								};
							};
							{
								name ='֪ʶ��',id =5;
								{
									{
										name ='��������',id =5;
									},	
									{
										name ='����ͳ��',id =5;
									},	
								};
							};
							{
								name ='����ͳ��',id =5;
								{
									{
										name ='C�͸�',id =5;
									},	
									{
										name ='	H�͸�',id =5;
									},	
								};
							};
							
						};					
				};
				{
					name = '�Ŷ�';id=4;
					{
						{
							name ='zgb',id =5;
						};
					};
				};
				{
					name = '��ע';id=4;
					{
						{
							name ='2017-5-2��������',id =5;
						};
						{
							name ='2017-5-12��B-23����',id =5;
						};
					};
				};
				{
					name = '������';id=4;
					{
						{
							name ='���й�����',id =5;
						};
						{
							name ='���ڽ���',id =5;
						};
						{
							name ='�����',id =5;
						};
					};
				};
			};		};--]]
	}
end

local function init_file()
	local filename = string.gsub(file,'%.','/')
	local file = io.open(filename,'w+')
	if file then file:close() return true end 
end 

function init()
	package_loaded_[file] = nil
	data_ = init_file() and type(require (file)) == 'table' and require (file)  or init_data()
end

function get()
	return data_
end

function add(arg)
end

function edit(arg)
end

function delete(arg)
end




