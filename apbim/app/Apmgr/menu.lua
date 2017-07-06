
local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local g_load_ = load
local load = nil
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local menu_ =  require 'sys.menu'
local op_ = require 'app.Apmgr.project.op'

function on_load()
	menu_.add{
		keyword = 'AP.Apmgr.New';
		action = op_.project_new;
		name = 'File.New';
		view = true;
		frame = true;
	}
	menu_.add{
		keyword = 'AP.Apmgr.Open';
		action = op_.project_open;
		name = 'File.Open';
		view = true;
		frame = true;
	}
	menu_.add{
		keyword = 'AP.Apmgr.Save';
		action = op_.project_save;
		name = 'File.Save';
		view = true;
		frame = true;
	}
	menu_.add{
		keyword = 'AP.Apmgr.Close';
		action = op_.project_close;
		name = 'File.Close';
		view = true;
		frame = true;
	}
	-- menu_.add{
		-- keyword = 'AP.Apmgr.Delete';
		-- action = op_.project_delete;
		-- name = 'File.Delete';
		-- view = true;
		-- frame = true;
	-- }
	menu_.add{
		keyword = 'AP.Apmgr.Show Style';
		action = op_.show_style;
		name = 'File.Set Show Style';
		view = true;
		frame = true;
	}
	menu_.add{
		keyword = 'AP.Apmgr.Packing To Declare';
		action = op_.packing_to_declare;
		name = 'File.Submit';
		view = true;
		frame = true;
	}
	menu_.add{
		keyword = 'AP.Apmgr.Extended Application';
		action = op_.extended_application;
		name = 'File.Submit';
		view = true;
		frame = true;
	}
	menu_.add{
		keyword = 'AP.Apmgr.Properties';
		action = op_.properties;
		name = 'File.Submit';
		view = true;
		frame = true;
	}
end


	
