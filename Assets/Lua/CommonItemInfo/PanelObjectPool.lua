--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 石展晖
--创始日期  : 2019-05-20
--功能描述  : 界面周期内的UI对象池
---------------------------------------------------------

PanelObjectPool = class("PanelObjectPool", SimpleObjectPool)
local this = PanelObjectPool

-- param1:预制体 param2:预制体对应的lua类 param3:生命周期内的界面
-- 对象池生命周期 ：界面开始时获取 PanelObjectPool.GetInstance(...)
-- 界面销毁时释放 insetance:Dispose()
function this.GetInstance(prefab, prefab_class, panel)
	if prefab_class.super.__cname ~= "PrefabClass" then
		print_error("必须继承预制体类")
	end
	local onConstruct = function ()
		local gameObject = GameObject.Institate(prefab)
		return prefab_class.New(gameObject)
	end

	local onEnable = function (prefab_class, parent, data)
		if parent == nil then
			print_error("父节点为空")
			return
		end
		prefab_class:SetParent(parent)
		prefab_class:SetActive(true)
		prefab_class:SetData(data)
	end

	local onDisable = function (prefab_class)
		prefab_class:Reset()
		prefab_class:SetActive(false)
	end

	local onDestroy = function (prefab_class)
		prefab_class:onDestroy()
	end

	return PanelObjectPool.New(onConstruct, onEnable, onDisable, onDestroy)
end

function this:ctor(onConstruct, onEnable, onDisable, onDestroy)
	this.super:ctor(onConstruct, onEnable, onDisable, onDestroy)
end


-- 加到父节点下
function this:Add(parent)
	this.super:Add(parent)
end

function this:Remove(prefab_class)
	this.super:Remove(prefab_class)
end