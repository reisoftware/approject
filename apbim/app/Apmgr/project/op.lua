local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local io = io
local string = string 
local table = table
local type = type
local pairs = pairs
local g_next_ = _G.next
local os_time_ = os.time
local print = print
local ipairs = ipairs
local os_exit_ = os.exit
local error = error
local os_execute_ = os.execute

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local iup = require 'iuplua'

local function require_data_file(file)
	package_loaded_[file] = nil
	return require (file)
end

local lfs = require 'lfs'
local luaext_ = require 'luaext'
local disk_ =  require 'app.Apmgr.disk'
local dlg_create_project_ =  require 'app.apmgr.dlg.dlg_create_project'
local dlg_info_ = require 'app.apmgr.dlg.dlg_info'
local dlg_save_ = require 'app.apmgr.dlg.dlg_save'
local dlg_add_ = require 'app.apmgr.dlg.dlg_add'
local tree_ =  require 'app.apmgr.project.tree'
local version_ = require 'app.Apmgr.version'
local temp_path_ = 'app/apmgr/temp/'
local project_ = require 'app.Apmgr.project.project'


local function table_is_empty(t)
	return g_next_(t) == nil
end

local function get_tpl_data()
	local path = 'app/apmgr/tpl/'
	local require_path = string.gsub(path,'/','.')
	local t = disk_.get_folder_contents(path)
	local data = {}
	for k,v in pairs(t) do 
		local name = string.sub(k,1,-5)
		local str = require_path ..  name
		local t = require_data_file(str)
		table.insert(data,t)
	end
	table.sort(data,
		function (a,b)
			if a.name and b.name then
				return string.lower(a.name) < string.lower(b.name)
			end
		end
	)
	table.insert(data,1,{name = 'Null'})
	return data
end

local function pop_dlg_info(data,readonly)
	local attributes;
	local function on_ok(arg)
		attributes = arg
	end
	dlg_info_.pop{data = data,on_ok = on_ok,readonly = readonly}
	return attributes
end

local function get_project_data()
	local project_info;--{name,path,data,pop,open}
	local function on_next(warning,arg)
		local content = disk_.get_folder_contents('Projects/')
		for k,v in pairs(content) do 
			content[string.lower(k)] = true
		end
		local file = string.lower(arg.name) .. '.apc'
		if content[file] then warning() return end 
		project_info = arg
		return true
	end
	
	dlg_create_project_.pop{on_next = on_next,data = get_tpl_data()}
	if type(project_info) ~= 'table' then return end 
	project_info.data = project_info.data or {}
	local attributes,tpldata = project_info.data.attributes,project_info.data.structure
	if project_info.pop then 
		attributes = pop_dlg_info(attributes) or attributes
	end
	return project_info,attributes,tpldata
end

	
local function save_project_files(arg)
	if type(arg) ~= 'table' then return end 
	local zipfile = arg.zipfile
	local data = arg.data
	for k,v in ipairs (data) do 
		if  v.id  and v.str then 
			disk_.save_to_zipfile(zipfile, v.id,v.str )
		end
	end	
end

local function project_turn_zipdata(arg)
	local saveData = {}
	local filelist = {}
	local gid = arg.gid
	if not gid then return end 
	local gidData = version_.get_gid_data{gid = gid,name = arg.name,info =  arg.info,versions = {}}
	table.insert(saveData,{id =gid,str  = disk_.serialize_to_str(gidData) })
	filelist[gid] = true
	local data =arg.tpl 
	if type(data) == 'table' and not table_is_empty(data) then
		local function loop_data(data,id)
			local folderIndexData =  {}
			for k,v in ipairs(data) do 
				local attr = type(v) == 'table' and v.attributes
				if  type(attr) == 'table' then 
					local gid = luaext_.guid() 
					if #v  ~= 0  then 
						gid = gid .. '0'
						loop_data(v[1],gid)
					else 
						gid = gid .. '1'
						if attr.disklink then 
							local tempid = project_.get_hid_filename(gid)
							table.insert(saveData,{str = disk_.read_file(attr.disklink,'string'),id =  tempid})
							filelist[tempid] = true
						end
					end
					table.insert(saveData,{str =disk_.serialize_to_str( version_.get_gid_data{gid = gid,name = attr.name,info =  attr.info,versions = {}} ) ,id =  gid})
					filelist[gid] = true
					table.insert(folderIndexData,version_.get_folder_data{name = attr.name,gid = gid})
				end
			end
			local tempid = project_.get_hid_filename(id)
			table.insert(saveData,{str =disk_.serialize_to_str( folderIndexData ),id =  tempid })
			filelist[tempid] = true
		end
		loop_data(data,gid)
	end
	return saveData,filelist
end


function project_new()
	local project_info,attributes,tpldata = get_project_data()
	if type(project_info) ~= 'table' then return end 
	local gid = luaext_.guid() .. '0'
	local filename = project_info.name .. '.apc'
	local path = project_.get_project_path()
	local zipfile =  path.. filename
	disk_.create_project(zipfile,gid)
	local posid = tree_.add_project{name =  project_info.name,file = zipfile}
	local data,filelist = project_turn_zipdata{gid = gid,name = project_info.name,tpl = tpldata,info = attributes}
	project_.save_project_filelist(filelist,zipfile)
	save_project_files{zipfile = zipfile,data = data}
	if project_info.open then 
		project_open(posid)
	end
end

local function is_go_on(id)
	local tree = tree_.get()
	local tid =id or  tree_.get_id()
	if not tid or tid == 0 then return end 
	local data = tree:get_node_data(tid)
	if not data or data.opened then return end
	return data,tid
end

function open_folder(id)
	local data,tid = is_go_on(id)
	if not data then return end 
	local gid = data.gid or project_.get_project_gid()
	local nextIndexId = project_.get_hid_filename(gid)
	if not nextIndexId then return end 
	project_.add_read_data(nextIndexId)
	local data = project_.get_cache_data(nextIndexId)
	if not data then return end 
	for k,v in ipairs(data) do 
		if v.gid and string.sub(v.gid,-1,-1) == '0' then 
			local nextIndexId = project_.get_hid_filename(v.gid)
			project_.add_read_data(nextIndexId)
		end
	end
	tree_.open_folder(tid)
end

local function open(data,id)
	tree_.set_marked(id)
	project_.init(data.file)
	local gid = project_.get_project_gid()
	local hid = project_.get_hid_filename(gid)
	project_.add_read_data(hid)
	local data = project_.get_cache_data(hid)
	if data then 
		tree_.add_folder_list(data,id)
		open_folder(id)
	end
end

project_open = function (id)
	local tree = tree_.get()
	local id =  id or tree:get_tree_selected()
	if not id  then return end 
	local data = tree:get_node_data(id)
	local pro = project_.get_project()
	if  pro and  data.file ~= pro then
		if not project_close('Open') then return end 
	end 
	open(data,id)
end

local function save(id)
	local function waiting_init(tree,arg)
		local count =tree:get_totalchildcount(id)
		count = count + 1
		if type(arg.waiting_guage) == 'function' then
			arg.waiting_guage(count)
		end
		local curid = id
		for i = 1,count do 
			
		end
		local data = project_.get_project_filelist()
	end

	local function init(arg)
		arg = arg  or {}
		local tree =  tree_.get()
		waiting_init(tree,arg)
	end
	dlg_save_.pop{init = init}
end

local function get_project_id()
	local zipfile = project_.get_project()
	if not zipfile then return end
	local id = tree_.get_index_id(zipfile)
	return id
end

project_save = function (f)
	print('project_save')
	-- local id = get_project_id()
	-- if not id then return end 
	-- save(id)
	-- project_.save()
end

function project_close(str)
	print('project_close')
	-- if str and str == 'Open' then 
		-- local a =  iup.Alarm('Notice','Whether to quit and save the existing project  ? ','yes','no')
		-- if a  ~= 1 then return  end 
	-- end
	-- project_save()
	-- tree_.close_project()
	-- project_.init()
	-- return true
end

function quit()
	print('quit')
	-- project_close(str)
	-- os_exit_()
end

function project_submit()	
	print('project_submit')
	-- local id = get_project_id()
	-- if not id then return end 
end

function edit_info(readonly)
	local tree = tree_.get()
	local id = tree:get_tree_selected()
	local gid ;
	local data = tree:get_node_data(id)
	if tree:get_node_depth(id) == 1 then 
		gid = disk_.read_project(data.file)
	else 
		gid =data and data.gid
	end
	if not gid then error('data error !') return end 
	local zipfile = project_.get_project()
	local t = disk_.read_zipfile(zipfile,gid)
	local info = pop_dlg_info(t and t.info,readonly) 
	if not info then return end 
	t.info = info
	project_.edit(gid,t)
end

function delete()
	local tree = tree_.get()
	local id = tree:get_tree_selected()
	local alarm = iup.Alarm('Notice','Whether to delete it !','Yes','No')
	if alarm ~= 1 then return end 
	if tree:get_node_depth(id) == 1 then 
		local data =  tree:get_node_data(id)
		local zipfile = data.file
		project_.delete_project(zipfile)
	else 
		local data = tree:get_node_data(id)
		gid =data and data.gid
	end
	tree_.delete(id)
end

function set_style()
	
end

function properties()
	edit_info(true)
end

local function add_folder(arg)
	local gid = luaext_.guid() .. '0' 
	local t = {name = arg.name,gid = gid,opened = arg.opened}
	local id;
	if not arg.state then 
		id = tree_.add_folder(t,arg.id)
	else 
		id = tree_.add_branch(t,arg.id)
	end
	return id
end

local function add_file(arg)
	local gid = luaext_.guid() .. '1' 
	local t = {name =arg.name,gid = gid,file =arg.file}
	if not arg.state then 
		tree_.add_file(t,arg.id)
	else 
		tree_.add_leaf(t,arg.id)
	end
end

function create_folder()
	local tree = tree_.get()
	local id = tree_.get_id()
	local data = tree:get_child_titles(id)
	local function Warning(str)
		if data[str] then 
			iup.Message('Notice','The name already exist ! Please reset it !')
			return true
		end
	end
	
	local function set_data(str)
		add_folder{name = str,opened = true} 
	end

	dlg_add_.pop{Warning = Warning,set_data = set_data}
end

function create_file()
	local tree = tree_.get()
	local id = tree_.get_id()
	local data = tree:get_child_titles(id)
	local function Warning(str)
		if data[str] then 
			iup.Message('Notice','The name already exist ! Please reset it !')
			return true
		end
	end
	
	local function set_data(str)
		add_file{name = str} 
	end

	dlg_add_.pop{Warning = Warning,set_data = set_data}
	
end

local function deal_import_data(data,id)
	local curid = id 
	for k,v in ipairs(data) do 
		if #v ~= 0  then 
			curid = add_folder{name = v.name,state = k ~= 1 and true,id = id,opened = true}
			deal_import_data(v[1],curid)
		else
			add_file{name= v.name,file = v.file,state = k ~= 1 and true,id = id}
		end
	end
end

function import_folder()
	local filedlg = iup.filedlg{DIALOGTYPE = 'DIR'}
	filedlg:popup()
	local value = filedlg.value
	if not value then return end 
	local t = disk_.import_folder(value,true)
	local id = tree_.get_id()
	deal_import_data(t,id)
end

function import_file()
	local filedlg = iup.filedlg{DIALOGTYPE = 'OPEN',MULTIPLEFILES = 'yes'}
	filedlg:popup()
	local count = filedlg.MULTIVALUECOUNT
	local files = {}
	if count then 
		local path;
		for i = 1,count do 
			if i == 1 then 
				path =  filedlg['MULTIVALUE' .. (i -1)]
				path = string.sub(path,-1,-1) == '\\' and path or (path .. '\\')
			else 
				local filename = filedlg['MULTIVALUE' .. (i -1)]
				table.insert(files,{file = path ..  filename,name =filename })
			end
		end
	else 
		local value  = filedlg.value
		if not value then return end 
		table.insert(files,{file = value,name =string.match(value,'.+\\([^\\]+)') })
	end 
	if #files== 0 then return end 
	for i=#files,1,-1 do 
		local t = files[i]
		add_file(t)
	end
end

function rename()
	local tree = tree_.get()
	local id = tree_.get_id()
	local data = tree:get_child_titles(id)
	local function Warning(str)
		if data[str] then 
			iup.Message('Notice','The name already exist ! Please reset it !')
			return true
		end
	end
	
	local function set_data(str)
		tree:set_node_title(str,id)
	end

	dlg_add_.pop{Warning = Warning,set_data = set_data,name = tree:get_node_title(id)}
end

function open_file()
	local tree = tree_.get()
	local data = tree:get_node_data()
	if data and data.file then 
		if disk_.file_is_exist(data.file) then 
			local file = string.gsub(data.file,'/','\\')
			os_execute_("start  \"\" " .. "\"" .. file .. "\"")
		end
	end
end

function link_to_file()
	local filedlg = iup.filedlg{DIALOGTYPE = 'OPEN'}
	filedlg:popup()
	local val = filedlg.value
	if not val then return end
	local tree = tree_.get()
	local data = tree:get_node_data()
	data.file = string.gsub(val,'\\','/')
	tree:set_node_data(data)
end

function link_to_model()
	
end


function save_project_template()
end


local function deal_import_template(data,id)
	local curid = id 
	for k,v in ipairs(data) do 
		if #v ~= 0  then 
			curid = add_folder{name = v.name,state = k ~= 1 and true,id = id,opened = true}
			deal_import_data(v[1],curid)
		else
			add_file{name= v.name,file = v.file,state = k ~= 1 and true,id = id}
		end
	end
end

function import_template()
	local filedlg = iup.filedlg{DIALOGTYPE = 'OPEN',DIRECTORY = 'app/apmgr/tpl/',EXTFILTER  = 'LUA files|*.lua|'}
	filedlg:popup()
	local file = filedlg.value
	if not file then return end 
	local tree = tree_.get()
	local count = tree:get_childcount()
	if count and count ~= 0 then 
		local alarm = iup.Alarm('Notice','Whether to clear the project files !','Yes','No')
		if alarm == 1 then 
			tree:delete_nodes('CHILDREN')
		end
	end
	file = string.sub(file,1,-5)
	file = string.gsub(file,'\\','.')
	local data = require_data_file(file)
	if type(data) ~= 'table' or not data.structure then
		iup.Message('Notice','It is not a tpl file !')
		return
	end 
	local data = data.structure
	local id = tree_.get_id()
	deal_import_template(data,id)
end