require "UI/Base/UIBase"

UIView = class("UIView", UIBase)

local this = UIView

function UIView:ctor(go, ...)
	this.base.ctor(self, go, ...)

	self._UISlots = self:GetComponent("UISlots")
	self:Init(...)
	self:AfterInit()
end

function UIView:Init(...)
	printc("UIView:Init(...)")
end

function UIView:AfterInit()

end

function UIView:Show()
	
end

function UIView:Hide()
	
end

--2018年7月19日11:03:48 zjw
--@用于本地事件的自动回收
function UIView:Close()
	-- if(self._eventDict~=nil)then
	-- 	OvercomeModule.ColorLog("事件回收")
	-- 	for eventType,list in pairs(self._eventDict) do
	-- 		if(list~=nil)then
	-- 			for i,info in ipairs(self._eventDict) do
	-- 				EventManager.RemoveEventListener(eventType,unpack(info))
	-- 			end
	-- 		end
	-- 	end
	-- 	self._eventDict = nil
	-- end
end

function UIView:AddLocalEventListener(eventType, func, target)
	if(self._eventDict == nil)then
		self._eventDict = {}
	end
	if self._eventDict[eventType] == nil then
		self._eventDict[eventType] = {}
	end
	table.add(self._eventDict[eventType], table.pack(func, target))
	EventManager.AddEventListener(eventType,func,target)
end

--
function UIView:RemoveLocalEventListener(eventType, func, target)
	if(self._eventDict==nil)then
		self._eventDict = {}
		return
	end
	if self._eventDict[eventType] == nil then
		self._eventDict[eventType] = {}
		return
	end
	if self._eventDict[eventType] ~= nil and #self._eventDict[eventType] > 0 then
		for idx, t in ipairs(self._eventDict[eventType]) do
			if t[1] == func and t[2] == target then
				table.remove(self._eventDict[eventType], idx)
				EventManager.RemoveEventListener(eventType,unpack(t))
			end
		end
    end
end
--@
