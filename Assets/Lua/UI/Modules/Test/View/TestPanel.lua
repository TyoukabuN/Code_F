require "UI/Base/UIPanel"

TestPanel = class("TestPanel",UIPanel)


local this = TestPanel
this.layer = UILayer.Dialog

function this:ctor(go,...)
    this.base.ctor(self,go,...)
end

function this:Init(...)
    self._button_test = self:GetButton(0)
    -- self._button_test:SetClickCB(function() self:OnClick() end)
    self._button_test:SetClickDownCB(function() self:OnClickDown() end)

    self._option = DynamicOption.New(self:GetObject(1))
    self._layout = self:GetObject(2)

    local onConstruct = function()
        local obj = self._option:Clone()
        return obj
    end

    local onEnable = function(obj)
        obj:SetAsLastSibling()
        obj:SetParent(self._layout.transform)
        obj:SetActive(true)
    end

    local onDisabled = function(obj)
        obj:SetActive(false)
    end

    self._optionPool = SimpleObjectPool.New(onConstruct,onEnable,onDisabled)
end

function this:AfterInit()
    -- local button = self._optionPool:Get():SetContent("EventTriggerTest"):GetButton()
    -- button:AddTriggerListener(EventTriggerType.PointerEnter,function(eventData) printc("PointerEnter") end)
    -- button:AddTriggerListener(EventTriggerType.PointerExit, function(eventData) printc("PointerExit") end)
    -- button:AddTriggerListener(EventTriggerType.PointerDown,function(eventData) printc("PointerDown") end)
    -- button:AddTriggerListener(EventTriggerType.PointerUp,function(eventData) printc("PointerUp") end)
    -- button:AddTriggerListener(EventTriggerType.PointerClick,function(eventData) printc("PointerClick") end)
    -- button:AddTriggerListener(EventTriggerType.Drag,function(eventData)     printc("Drag") end)
    -- button:AddTriggerListener(EventTriggerType.Drop,function(eventData) printc("Drop") end)
    -- button:AddTriggerListener(EventTriggerType.Scroll,function(eventData) printc("Scroll") end)
    -- button:AddTriggerListener(EventTriggerType.UpdateSelected,function(eventData) printc("UpdateSelected") end)
    -- button:AddTriggerListener(EventTriggerType.Select,function(eventData) printc("Select") end)
    -- button:AddTriggerListener(EventTriggerType.Deselect,function(eventData) printc("Deselect") end)
    -- button:AddTriggerListener(EventTriggerType.Move,function(eventData) printc("Move") end)
    -- button:AddTriggerListener(EventTriggerType.InitializePotentialDrag,function(eventData) printc("InitializePotentialDrag") end)
    -- button:AddTriggerListener(EventTriggerType.BeginDrag,function(eventData) printc("BeginDrag") end)
    -- button:AddTriggerListener(EventTriggerType.EndDrag,function(eventData) printc("EndDrag") end)
    -- button:AddTriggerListener(EventTriggerType.Submit,function(eventData) printc("Submit") end)
    -- button:AddTriggerListener(EventTriggerType.Cancel,function(eventData) printc("Cancel") end)

    -- self._optionPool:Get():SetContent("Add"):GetButton():SetClickCB(function() self:OnAdd() end)
    -- self._optionPool:Get():SetContent("Remove"):GetButton():SetClickCB(function() self:OnRemove() end)
    self.count = 0
end



function this:OnAdd()
    printc(self.count)
    self.count = self.count + 1
    if(self.count>100)then
        self.count = 100
    end
end

function this:OnRemove()
    printc(self.count)
    self.count = self.count - 1
    if(self.count<1)then
        self.count = 1
    end
end

function this:OnClick()
    UISystem.ClosePanel(PanelName.Test)
end