require "UI/Base/UISprite"

UIButton = class("UIButton",UISprite)

local this = UIButton

function this:ctor(go,...)
    this.base.ctor(self,go,...)
    self._eventTrigger = self:GetComponent(typeof(EventTrigger))
end

--点击事件
function this:SetClickCB(callback)
    self:AddTriggerListener(EventTriggerType.PointerClick, callback)
end

--弹起事件
function this:SetClickUpCB(callback)
    self:AddTriggerListener(EventTriggerType.PointerUp, callback)
end

--按下事件
function this:SetClickDownCB(callback)
    self:AddTriggerListener(EventTriggerType.PointerDown, callback)
end

function this:SetClickUpCB(callback)
    self:AddTriggerListener(EventTriggerType.PointerUp, callback)
end

--得到焦点
function this:SetPointEnter(callback)
    self:AddTriggerListener(EventTriggerType.PointerEnter, callback)
end

--失去焦点
function this:SetPointExit(callback)
    self:AddTriggerListener(EventTriggerType.PointerExit, callback)
end


-- type：
-- PointerEnter                       = 0,
-- PointerExit                        = 1,
-- PointerDown                        = 2,
-- PointerUp                          = 3,
-- PointerClick                           = 4,
-- Drag                               = 5,
-- Drop                                = 6,
-- Scroll                                  = 7,
-- UpdateSelected                               = 8,
-- Select                               = 9,
-- Deselect                                 = 10,
-- Move                                 = 11,
-- InitializePotentialDrag                              = 12,
-- BeginDrag                                = 13,
-- EndDrag                               = 14,
-- Submit                                = 15,
-- Cancel                               = 16

--添加触发监听器
function this:AddTriggerListener(type, callback)
    if(self._eventTrigger==nil)then
        self._eventTrigger = self._gameObject:AddComponent(typeof(EventTriggerSub))
    end

    local entry = nil

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
        self._eventTrigger.triggers:Add(entry)
    end

	entry.eventID = type
    entry.callback:AddListener(callback)
end