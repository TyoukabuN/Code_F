DynamicOption = class("DynamicOption",UIView)

local this = DynamicOption

function this:ctor(go,...)
    this.base.ctor(self,go,...)
end

function this:Init(...)
    self._text = self:GetText(0)
    self._button = UIButton.New(self._gameObject)
    self._button:SetClickCB(function() self:OnClick() end)
end

function this:SetContent(content)
    self._text:SetText(content)
    return self
end

function this:OnClick()
    if(self.func)then
        self.func()
    end
end

function this:SetClick(func)
    self.func = func
    return self
end

