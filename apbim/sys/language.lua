local package_loaded_ = package.loaded
local require = require
local io_open_ =  io.open
local print = print
local type = type
local pairs = pairs

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
local code_ = require 'sys.api.code'
local language_file_ = 'cfg/language.lua'
local language_list_file_ = 'cfg/languageList.lua'
local require_language_list_file_ = 'cfg.languageList'
local require_language_file_ = 'cfg.language'

local language_list_ = {
	['English'] = 'English';
	['���ļ���'] = 'Chinese';
}

local reg_changes_ = {}

local function save(file,t)
	code_.save{file=file;src=t}
end

local function get_data(file,require_file)
	local file =io_open_(file,'r')
	if file then 
		file:close()
		package_loaded_[require_file] = nil
		return   require (require_file) 
	end
end

local function get_language()
	local file,require_file = language_file_,require_language_file_;
	local t =  get_data(file,require_file)
	if type(t) == 'table' and t.language and language_list_[t.language] then 
		return  t.language
	else 
		save(file,{language = 'English'})
		return  'English'
	end 
end

local function get_language_list_file_data()
	local file,require_file = language_list_file_,require_language_list_file_;
	return  get_data(file,require_file)
end

function get()
	local language = get_language() 
	return language_list_[language]
end

local function reload_reg()
	local lan = get() or 'English'
	for k,f in pairs(reg_changes_) do 
		if type(f) == 'function' then 
			f(lan)
		end
	end
end

function set(language)
	save(language_file_,{language = language})
	require 'sys.menu'.reload()
	require 'sys.toolbar'.reload()
	reload_reg()
end



function get_language_list()
	return language_list_
end

function init()
	reg_changes_ = {}
	-- get_language_list()
end

function reg_language_change(hw,f)
	if not reg_changes_[hw] then 
		reg_changes_[hw] = f
	end
end
