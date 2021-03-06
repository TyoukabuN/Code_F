require "UI/Base/UIBase"

UIView = class("UIView", UIBase)

local this = UIView

function this:ctor(go, ...)
	this.base.ctor(self, go, ...)

	self._UISlots = self:GetComponent("UISlots")
	self:Init(...)
	self:AfterInit()
end

function this:Init(...)
end

function this:AfterInit()
	self._eventDict = {}
end

function this:Show()

end

function this:Hide()

end

--2018年7月19日11:03:48 zjw
--@用于本地事件的自动回收
function this:Close()
	if(self._eventDict~=nil)then
		for eventType,list in pairs(self._eventDict) do
			if(list~=nil)then
				for i,config in ipairs(list) do
					EventSystem.CancelByConfig(config)
				end
			end
		end
		self._eventDict = nil
	end
end

function this:AddLocalEventListener(eventType, func, target)
	if(self._eventDict == nil)then
		self._eventDict = {}
	end
    local eventConfig = EventConfig.New(eventType,callback,instance)
	table.insert(self._eventDict, eventConfig )
	EventSystem.RegisterByConfig(eventConfig)
end

--
function this:RemoveLocalEventListener(eventType, func, target)
	if(self._eventDict == nil)then
		self._eventDict = {}
		return
	end
    local config,index = table.ifind(self._eventDict,function(arg) return arg:EqualField(eventType, func, target) end)
    if(not config)then
        return
    end
	local config = table.remove(self._eventDict,index)
	EventSystem.CancelByConfig(config)
end
--@
