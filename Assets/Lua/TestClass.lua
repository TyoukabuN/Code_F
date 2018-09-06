

TestClass = class("TestClass")

local this = TestClass

function this:ctor(...)
    self._value = "初始"
    EventSystem.Register(EventType.Test,self.OnTestEvent,self)
end

function this:OnTestEvent(msg)
    self:onUpdate()
end

function this:onUpdate()
    this.base.onUpdate(self)
    print(self)
end

function this:Init(...)
end

function this:SetValue(val)
    self._value = val
end

function this:ToString()
    print(self._value)
end