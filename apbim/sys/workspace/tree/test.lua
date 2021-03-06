require 'iup_dev'
local iuptree = require 'iupTree'
require 'iuplua'
tree = iuptree.Class:new()
local function rule(str,path,status)
	local title = str
	if status ==0 then 
		title = 1
	end
	return {
		icon = 'd:/user_open.bmp';
		tip = str;
		
		title =title;
	}
end

local This = {}
This['cfg/Family/'] = {title='族',icon='cfg/Family/Family.bim'}
This['cfg/Family/Assistant/'] = {title='辅助',icon='cfg/Family/Assistant/Assistant.bmp'}
This['cfg/Family/Assistant/Line'] = {title='辅助线',icon='cfg/Family/Assistant/Line.bmp',tip='自定义辅助线'}
This['cfg/Family/Structure/'] = {title='结构'}
This['cfg/Family/Structure/Column'] = {title='柱'}


-- tree:init_path_data('E:\\Sync\\workingGit\\apbim\\apbim\\sys\\api',rule)
tree:set_rastersize('400x400')
tree:set_expand_all('YES')

local data = tree:init_family_data(This)
tree:set_data(data)
-- tree:set_tree_tip('')
local f1 = function(id,status)
	-- print(id,status)
end

tree:set_selection_cb(f1)

local function f(id)
	tree:set_expand_all('YES')
	
	print(tree:get_selected_path())
end

tree:set_lbtn(f)


local dlg = iup.dialog{
	tree:get_tree();
}



dlg:popup()

