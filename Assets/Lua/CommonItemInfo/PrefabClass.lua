--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 石展晖
--创始日期  : 2019-05-20
--功能描述  : 预制体类
---------------------------------------------------------

PrefabClass = class("PrefabClass", UIBase)
local this = PrefabClass

function this:Reset()
	-- 提供重写用 用于将放入销毁池的物体进行初始化
end

function this:SetData(data)
	self.data = data
	if self:GetActive() then
		self:Flush()	
	end
end

function this:Flush()
	-- 提供重写用 刷新表现
end

function this:onDestroy()
	
end