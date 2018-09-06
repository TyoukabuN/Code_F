require "UI/Base/UISprite"

UIButton = class("UIButton",UISprite)

local this = UIButton

function this:ctor(go,...)
    this.base.ctor(self,go,...)
    self._eventTrigger = self:GetComponent(typeof(EventTrigger))
end

function this:SetClickCB(callback)
    self:AddTriggerListener(EventTriggerType.PointerClick, callback) 
end

function UIButton:SetClickUpCB(callback)
    self:AddTriggerListener(EventTriggerType.PointerUp, callback) 
end

function UIButton:SetClickDownCB(callback)
    self:AddTriggerListener(EventTriggerType.PointerDown, callback) 
end

-- PointerEnter = 0,
-- PointerExit = 1,
-- PointerDown = 2,
-- PointerUp = 3,
-- PointerClick = 4,
-- Drag = 5,
-- Drop = 6,
-- Scroll = 7,
-- UpdateSelected = 8,
-- Select = 9,
-- Deselect = 10,
-- Move = 11,
-- InitializePotentialDrag = 12,
-- BeginDrag = 13,
-- EndDrag = 14,
-- Submit = 15,
-- Cancel = 16

function this:AddTriggerListener(type, callback)
    if(self._eventTrigger==nil)then
        self._eventTrigger = self._gameObject:AddComponent(typeof(EventTrigger))
    end

    local entry
    
    local triggers = self._eventTrigger.triggers
    for i = 0,triggers.Count - 1 do
        local e = triggers[i]
        if(e.eventID == type)then
            entry = e
            break
        end
    end

    if(not entry)then
        entry = Entry()
    end

	entry.eventID = type
    entry.callback:AddListener(callback)	
    
	self._eventTrigger.triggers:Add(entry)
end