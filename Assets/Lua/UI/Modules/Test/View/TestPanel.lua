require "UI/Base/UIPanel"

TestPanel = class("TestPanel",UIPanel)

local this = TestPanel

function this:ctor(go,...)
    this.base.ctor(self,go,...)
end

function this:Init(...)
    self._button_test = self:GetButton(0)
    self._button_test:SetClickCB(function() self:OnClick() end)
end

function this:OnClick()
    print("OnClick")
end