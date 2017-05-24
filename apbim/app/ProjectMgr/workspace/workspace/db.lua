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

local file = 'app.ProjectMgr.info.user_gid_file'
local user_ = 'Sjy' -- require 'user'.get()

local function init_data()
	return {
		user = {
			title = user_,
			data= {
				rmenu = require 'app.projectmgr.workspace.workspace.rmenu'.get;
			};
			image = {open ='app/ProjectMgr/res/user_open.bmp',close =  'app/ProjectMgr/res/user_close.bmp'} ;
			state = 'expanded',
		};
		project = {
			title = '�����б�',
			
			image = {open ='app/ProjectMgr/res/projects_open.bmp',close =  'app/ProjectMgr/res/projects_close.bmp'} ;
			data= {
				rmenu = require 'app.projectmgr.workspace.projects.rmenu'.get;
			};
		};
		contact = {
			title = '��ϵ���б�',
			
			image = {open ='app/ProjectMgr/res/user_open.bmp',close =  'app/ProjectMgr/res/user_close.bmp'} ;
			data= {
				rmenu = require 'app.projectmgr.workspace.contacts.rmenu'.get;
			};
		};
		recycle  = {
			title = '����վ',
			image = {open ='app/ProjectMgr/res/recycles_open.bmp',close =  'app/ProjectMgr/res/recycles_close.bmp'} ;
			data= {
				rmenu = require 'app.projectmgr.workspace.recycles.rmenu'.get;
			};
		};
		private  = {
			title = '˽���ļ���',
			image = {open ='app/ProjectMgr/res/privates_open.bmp',close =  'app/ProjectMgr/res/privates_close.bmp'} ;
			data = {
				rmenu = require 'app.projectmgr.workspace.privates.rmenu'.get;
			};
		};
		family = {
			title = '��';
			image = {open ='app/ProjectMgr/res/family.bmp',close =  'app/ProjectMgr/res/family.bmp'} ;
			data = {
				rmenu = require 'app.projectmgr.workspace.family.rmenu'.get;
			};
		};
		{
			index = 'user';
			{
				{
					index = 'private';
					{};
				};
				{
					index='project';
					{};
				};
				{
					index='contact';
					{};
				};
				{
					index='family';
					{};
				};
				{
					index='recycle';
					{};
				};
			};
		};

	};
	--save_file()
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




