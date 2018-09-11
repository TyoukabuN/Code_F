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
    self._optionPool:Get():SetContent("测试面板_1")--:SetClick(self.OnClick)
    self._optionPool:Get():SetContent("打开2"):SetClick(function()
        UISystem.OpenPanel(PanelName.Test2,true,self)
    end)
    self._optionPool:Get():SetContent("输出当前面板队列"):SetClick(function() UISystem.ToString() end)
    local btn_close = self._optionPool:Get():SetContent("关闭"):SetClick(self.OnClick)
    btn_close._button:SetPointEnter(function() printc("进入") end)
    btn_close._button:SetPointExit(function() printc("退出") end)
end

function this:OnClick()
    UISystem.ClosePanel(PanelName.Test)
end