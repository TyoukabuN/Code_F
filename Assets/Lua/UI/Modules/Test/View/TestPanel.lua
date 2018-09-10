require "UI/Base/UIPanel"

TestPanel = class("TestPanel",UIPanel)

local this = TestPanel

function this:ctor(go,...)
    this.base.ctor(self,go,...)
end

function this:Init(...)
    self._button_test = self:GetButton(0)
    self._button_test:SetClickCB(function() self:OnClick() end)

    self._option = DynamicOption.New(self:GetObject(1))
    self._layout = self:GetObject(2)

    for i = 1,20 do
        local option = self._option:Clone()
        option:SetContent(i)
        option:SetAsLastSibling()
        option:SetParent(self._layout.transform)
        option:SetActive(true)
    end
end

function this:OnClick()
    UISystem.ClosePanel(PanelName.Test)
end