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
	file = string.lower(file)
	package_loaded_[file] = nil
	return require (file)
end

local lfs = require 'lfs'
local luaext_ = require 'luaext'
local disk_ =  require 'app.Apmgr.disk'
local dlg_create_project_ =  require 'app.apmgr.dlg.dlg_create_project'
local dlg_info_ = require 'app.apmgr.dlg.dlg_info'
local dlg_progress_ = require 'app.apmgr.dlg.dlg_progress'
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
		if string.find(k,'.lua') then 
			local name = string.sub(k,1,-5)
			local str = require_path ..  name
			local t = require_data_file(str)
			if type(t) == 'table' then 
				t.name = t.name or name
				table.insert(data,t)
			end
		end
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
	local ar = disk_.zipfile_open(zipfile)
	local filelist = {}
	for k,v in ipairs (data) do 
		if  v.id  and v.str then 
			disk_.save_to_zipfile(zipfile, v.id,v.str ,ar)
			filelist[filelist] = true
		end
	end	
	ar:close()
	project_.save_project_filelist(zipfile, filelist)
end

local function project_turn_zipdata(arg)
	local saveData = {}
	local filelist = {}
	local gid = arg.gid
	if not gid then return end 
	local gidData = version_.get_gid_data{gid = gid,name = arg.name,info =  arg.info}
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
	save_project_files{zipfile = zipfile,data = data}
	project_.save_project_filelist(zipfile,filelist)
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

-- function open_folder(id)
	-- local data,tid = is_go_on(id)
	-- if not data then return end 
	-- local gid = data.gid or project_.get_project_gid()
	-- local nextIndexId = project_.get_hid_filename(gid)
	-- if not nextIndexId then return end 
	-- project_.add_read_data(nextIndexId)
	-- local data = project_.get_cache_data(nextIndexId)
	-- if not data then return end 
	-- for k,v in ipairs(data) do 
		-- if v.gid and string.sub(v.gid,-1,-1) == '0' then 
			-- local nextIndexId = project_.get_hid_filename(v.gid)
			-- project_.add_read_data(nextIndexId)
		-- end
	-- end
	-- tree_.open_folder(tid)
-- end

local function open(data,id)
	project_.init(data.file)
	local id = tree_.get_index_id(data.file)
	tree_.set_marked(id)
	local tree = tree_.get()
	local filelist = project_.get_project_filelist() or {}
	local nums = 0
	for k,v in pairs(filelist) do 
		nums = nums + 1
	end
	
	
	local gid = project_.get_project_gid()
	local hid = project_.get_hid_filename(gid)
	local zipfile = project_.get_project()
	local data = disk_.read_zipfile(zipfile,hid)
	
	local tempt = tree:get_node_data(id)
	tempt.gid = gid
	tree:set_node_data(tempt,id)
	
	local function run(f,stop)
		f(2);
		local function loop(data,id)
			for k,v in ipairs(data) do 
				if v.gid and string.sub(v.gid,-1,-1) == '0' then 
					local newid = tree_.add_branch(v,id)
					local hid = project_.get_hid_filename(v.gid)
					local t = disk_.read_zipfile(zipfile,hid)
					loop(t,newid)
				elseif v.gid and string.sub(v.gid,-1,-1) == '1' then 
					local t = disk_.read_zipfile(zipfile,v.gid)
					v.gidData = t
					tree_.add_leaf(v,id)
				end
				f(2);
			end
		end
		loop(data,id)
		stop()
		local tree = tree_.get()
		tree:set_node_state('EXPANDED',id)
		
	end
	dlg_progress_.pop{run = run,totalnums =nums}
	-- run()
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
	local tree = tree_.get()
	local count =tree:get_totalchildcount(id)
	count = count + 1
	local zipfile = project_.get_project()
	local filelist = project_.get_project_filelist() or {}
	local newlist = {}
	local function run(f,stop)
		local curid = id
		local ar,close = disk_.zipfile_open(zipfile)
		
		local function deal_save_id(curid)
			local data = tree:get_node_data(curid)
			-- require 'sys.table'.totrace(data,curid)
			if data.gidChanged then 
				disk_.save_to_zipfile(zipfile, data.gid,  disk_.serialize_to_str(data.gidData),ar)
			end
			filelist[data.gid] = nil
			newlist[data.gid] = true
			f()
			if data.hidChanged then
				local str;
				if type(data.hidData) == 'function' then 
					str = data.hidData()
				elseif type(data.hidData) == 'table' then 
					str = disk_.serialize_to_str(data.hidData)
				elseif type(data.hidData) == 'string' then 
					str = data.hidData
				end
				local id = project_.get_hid_filename(data.gid)
				disk_.save_to_zipfile(zipfile, id,  str,ar)
			end
			filelist[id] = nil
			newlist[id] = true
			f()
		end
		deal_save_id(curid)
		
		local function loop(id)
			local count = tree:get_childcount(id)
			local curid = id+1
			for i = 1,count do 
				deal_save_id(curid)
				if tree:get_node_kind(curid) == 'BRANCH' then
					loop(curid)
				end
				curid = curid + 1 + tree:get_totalchildcount(curid)
			end
		end
		loop(curid)
		if close then close() end
		stop()
	end
	-- run()
	dlg_progress_.pop{run = run,totalnums = count*2,stop_cbf = stop_cbf }
	project_.save_project_filelist(zipfile, newlist)
	if not table_is_empty(filelist) then 
		local nums = 0
		for k,v in pairs(filelist) do 
			nums = nums + 1
		end
		
		local function run(f,stop)
			local ar,close = disk_.zipfile_open(zipfile)
			for k,v in pairs(filelist) do 
				disk_.zipfile_remove_file(zipfile,k,ar)
				f()
			end
			if close then close() end
			stop()
		end
		dlg_progress_.pop{run = run,totalnums =nums}
		-- run()
	end
	
	
end

local function get_project_id()
	local zipfile = project_.get_project()
	if not zipfile then return end
	local id = tree_.get_index_id(zipfile)
	return id
end

project_save = function (f)
	local id = get_project_id()
	if not id then return end 
	save(id)
end

function project_close(str)
	if str and str == 'Open' then 
		local a =  iup.Alarm('Notice','Whether to quit and save the existed project  ? ','yes','no')
		if a  ~= 1 then return  end 
	end
	project_save()
	tree_.close_project()
	project_.close()
	return true
end

function quit()
	project_close(str)
	os_exit_()
end

function project_submit()	
	print('project_submit')
	-- local id = get_project_id()
	-- if not id then return end 
end


function get_gidData(zipfile,data)
	return data.gidData or disk_.read_zipfile(zipfile,data.gid)  or {}
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
	if not gid then return end 
	local zipfile = project_.get_project()
	local t =get_gidData(zipfile,data) 
	local info = pop_dlg_info(t and t.info,readonly) 
	if not info then return end 
	t.info = info
	data.gidData = t
	data.gidChanged = true
	tree:set_node_data(data,id)
end

local function get_folder_hid_data(id)
	local tree = tree_.get()
	local count = tree:get_childcount(id)
	if count == 0 then return {} end 
	local curid = id + 1
	local data = {}
	for i =1,count do 
		local name = tree:get_node_title(curid)
		local gid = tree: get_node_data(curid).gid
		local t = {name = name,gid =gid }
		table.insert(data,t)
		curid = curid + 1+tree:get_totalchildcount(curid)
	end
	return data
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
		tree_.delete(id)
		project_.init()
		return 
	else 
		local data = tree:get_node_data(id)
		gid =data and data.gid
	end
	tree_.delete(id)
	local pid = tree:get_node_parent(id)
	local data =  tree:get_node_data(pid)
	data.hidChanged = true
	data.hidData = get_folder_hid_data(pid)
	tree:set_node_data(data)
end

function set_style()
	-- dlg_style_.pop()
end

function properties()
	edit_info(true)
end

local function add_folder(arg)
	local gid = luaext_.guid() .. '0' 
	local t = {name = arg.name,gid = gid,data = arg.data}
	local id;
	if not arg.state then 
		id = tree_.add_folder(t,arg.id)
	else 
		id = tree_.add_branch(t,arg.id)
	end
	return id
end

-- local function add_file(arg)
	-- local gid = luaext_.guid() .. '1' 
	-- local t = {name =arg.name,gid = gid,file =arg.file,data = arg.data}
	-- if not arg.state then 
		-- tree_.add_file(t,arg.id)
	-- else 
		-- tree_.add_leaf(t,arg.id)
	-- end
-- end

local function init_folder_data(name)
	local gid = luaext_.guid() .. '0' 
	local data = version_.get_gid_data{gid = gid,name = name}
	return data
end

local function init_file_data(name,file)
	local gid = luaext_.guid() .. '1' 
	local data = version_.get_gid_data{gid = gid,name = name,file = file}
	return data
end


local function set_folder_data(str,id)
	local tree = tree_.get()
	local id = id or tree_.get_id()
	local data = init_folder_data(str)
	local newid = tree_.add_folder({name = data.name,gid = data.gid},id)
	local t = tree:get_node_data(newid)
	t.gidChanged = true
	t.gidData = data
	t.hidChanged = true
	t.hidData = {}
	tree:set_node_data(t,newid)
	
	local t = tree:get_node_data(id)
	t.hidChanged = true 
	t.hidData = get_folder_hid_data(id)
	tree:set_node_data(t,id)
	return newid
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

	dlg_add_.pop{Warning = Warning,set_data = set_folder_data}
end

local function set_file_data(data,id)
	-- add_file{name = str} 
	local tree = tree_.get()
	local id = id or tree_.get_id()
	local str,file;
	if type(data) == 'string' then 
		str = data
	elseif type(data) == 'table' then  
		str,file = data.name,data.file
	end
	local data = init_file_data(str,file)
	local newid = tree_.add_file({name = data.name,gid = data.gid,file = file},id)
	local t = tree:get_node_data(newid)
	t.gidChanged = true
	t.gidData = data
	if file then 
		t.hidChanged = true
		t.hidData = function() return disk_.read_file(file,'string') end 
	end
	tree:set_node_data(t,newid)
	
	local t = tree:get_node_data(id)
	t.hidChanged = true 
	t.hidData = get_folder_hid_data(id)
	
	tree:set_node_data(t,id)
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
	dlg_add_.pop{Warning = Warning,set_data = set_file_data}
	
end

local function deal_import_data(data,id)
	local tree = tree_.get()
	local id = tree_.get_id()
	local function loop_data(data,id,state)
		local folderhidtab = {}
		for k,v in ipairs (data) do 
			if #v ~=0 then 
				local tab = init_folder_data(v.name)
				local newid;
				if state then 
					newid = tree_.add_branch({name = tab.name,gid = tab.gid},id)
				else 
					newid = tree_.add_folder({name = tab.name,gid = tab.gid},id)
				end
				local t = tree:get_node_data(newid)
				t.gidChanged = true
				t.gidData = tab
				t.hidChanged = true
				t.hidData = {}
				local hidtab = loop_data(v[1],newid,true)
				if hidtab then 
					t.hidData = hidtab
				end
				tree:set_node_data(t,newid)
				table.insert(folderhidtab,{name = tab.name,gid = tab.gid})
			else 
				local tab = init_file_data(v.name,v.file)
				local newid;
				if state then
					newid = tree_.add_leaf({name = tab.name,gid = tab.gid,file = v.file},id)
				else
					newid = tree_.add_file({name = tab.name,gid = tab.gid,file = v.file},id)
				end
				local t = tree:get_node_data(newid)
				t.gidChanged = true
				t.gidData = tab
				t.hidChanged = true
				t.hidData = function() return disk_.read_file(v.file,'string') end 
				tree:set_node_data(t,newid)
				table.insert(folderhidtab,{name = tab.name,gid = tab.gid})
			end
		end
		return folderhidtab
	end
	local t = tree:get_node_data(id)
	t.hidChanged = true
	loop_data(data,id)
	t.hidData = get_folder_hid_data(id)
	tree:set_node_data(t,id)
end

function import_folder()
	local filedlg = iup.filedlg{DIALOGTYPE = 'DIR'}
	filedlg:popup()
	local value = filedlg.value
	if not value then return end 
	local t = disk_.import_folder(value,true)
	deal_import_data(t)
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
		set_file_data(t,id)
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
		local data = tree:get_node_data(id)
		local gid =  data.gid
		local zipfile = project_.get_project()
		data.gidChanged = true
		data.gidData = get_gidData(zipfile,data) 
		data.gidData.name = str
		tree:set_node_data(data,id)
		
		local pid = tree:get_node_parent(id)
		local t = tree:get_node_data(pid)
		t.hidChanged = true
		t.hidData = get_folder_hid_data(pid)
		tree:set_node_data(t,pid)
	end

	dlg_add_.pop{Warning = Warning,set_data = set_data,name = tree:get_node_title(id)}
end

function open_file()
	local tree = tree_.get()
	local data = tree:get_node_data()
	data.gidData = get_gidData(zipfile,data)
	data.file = data.file or data.gidData.file
	if  data.file then 
		if disk_.file_is_exist(data.file) then
			local file = string.gsub(data.file,'/','\\')
			os_execute_("start  \"\" " .. "\"" .. file .. "\"")
			tree:set_node_data(data)
		end
	end
end

function open_model()
end

function link_to_file()
	local filedlg = iup.filedlg{DIALOGTYPE = 'OPEN'}
	filedlg:popup()
	local val = filedlg.value
	if not val then return end
	local tree = tree_.get()
	local data = tree:get_node_data()
	data.file = string.gsub(val,'\\','/')
	data.gidChanged = true
	local name = tree:get_node_title()
	local zipfile = project_.get_project()
	data.gidData = get_gidData(zipfile,data) 
	data.gidData.file = data.file
	tree:set_node_data(data)
end

function link_to_model()
	
end


function save_project_template()
	local filedlg = iup.filedlg{DIALOGTYPE = 'SAVE',DIRECTORY = 'app/apmgr/tpl/',EXTFILTER  = 'LUA files|*.lua|'}
	filedlg:popup()
	local file = filedlg.value
	if not file then return end 
	
	local data = {}
	local tree = tree_.get()
	local id = tree_.get_id()
	
	local function get_folder_data(data,id)
		local count = tree:get_childcount(id)
		if count == 0 then return end 
		local data = data or {}
		local curid = id+1
		for i = 1,count  do 
			local title = tree:get_node_title(curid)
			local t = {attributes = {}}
			local tempt = t.attributes
			tempt.name = title
			if  tree:get_node_kind(curid) == 'BRANCH' then 
				t[1] = {}
				get_folder_data(t[1] ,curid)
			end
			table.insert(data,t)
			curid = curid + 1+ tree:get_totalchildcount(curid)
		end
	end
	
	get_folder_data(data,id)
	local t = {}
	t.structure = data
	if not string.find(file,'.lua') then 
		file = file .. '.lua'
	end
	disk_.save_require_file(file,t)
	
end


local function deal_import_template(data,id)
	-- local curid = id 
	-- for k,v in ipairs(data) do 
		-- local t = v.attributes 
		-- if t then 
			-- if #v ~= 0  then 
				-- curid = add_folder{name = t.name,state = k ~= 1 and true,id = id,opened = true,data = t}
				-- deal_import_template(v[1],curid)
			-- else
				-- add_file{name= t.name,file = t.file,state = k ~= 1 and true,id = id,data = t}
			-- end
		-- end
	-- end
	
	
	local tree = tree_.get()
	local id = tree_.get_id()
	local function loop_data(data,id)
		local folderhidtab = {}
		for k,v in ipairs (data) do 
			local attr = v.attributes 
			if attr then 
				if #v ~=0 then 
					local tab = init_folder_data(attr.name)
					local newid = tree_.add_branch({name = tab.name,gid = tab.gid},id)
					local t = tree:get_node_data(newid)
					t.gidChanged = true
					for k,v in pairs (attr) do 
						tab[k] = v
					end
					t.gidData = tab
					t.hidChanged = true
					t.hidData = {}
					local hidtab = loop_data(v[1],newid)
					if hidtab then 
						t.hidData = hidtab
					end
					tree:set_node_data(t,newid)
					table.insert(folderhidtab,{name = tab.name,gid = tab.gid})
				else 
					local tab = init_file_data(attr.name,attr.file)
					local newid = tree_.add_leaf({name = tab.name,gid = tab.gid,file = v.file,gidData = tab},id)
					local t = tree:get_node_data(newid)
					t.gidChanged = true
					for k,v in pairs (attr) do 
						tab[k] = v
					end
					t.gidData = tab
					t.hidChanged = true
					t.hidData = function() return disk_.read_file(v.file,'string') end 
					tree:set_node_data(t,newid)
					table.insert(folderhidtab,{name = tab.name,gid = tab.gid})
				end
			end
		end
		return folderhidtab
	end
	local t = tree:get_node_data(id)
	t.hidChanged = true
	t.hidData = loop_data(data,id)
	tree:set_node_data(t,id)
	
	tree_.set_marked(id)
	tree:set_node_state('EXPANDED',id)
end

function import_template()
	local filedlg = iup.filedlg{DIALOGTYPE = 'OPEN',DIRECTORY = 'app/apmgr/tpl/',EXTFILTER  = 'LUA files|*.lua|'}
	filedlg:popup()
	local file = filedlg.value
	if not file then return end 
	local tree = tree_.get()
	local count = tree:get_childcount()
	if count and count ~= 0 then 
		local alarm = iup.Alarm('Notice','The project files will be deleted , whether to go on !','Yes','No')
		if alarm == 1 then 
			tree:delete_nodes('CHILDREN')
		end
		
	end
	file = string.sub(file,1,-5)
	file = string.gsub(file,'\\','.')
	local data = require_data_file(file)
	if type(data) ~= 'table' or not data.structure then
		iup.Message('Notice','It is not a template file !')
		return
	end 
	local data = data.structure
	local id = tree_.get_id()
	deal_import_template(data,id)
end