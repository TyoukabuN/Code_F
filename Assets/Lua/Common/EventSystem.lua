EventSystem = class("EventSystem")

EventType = {
    Test = 0,
}

local _eventMap = {}

--注册
EventSystem.Register = function(eventType,callback,instance)
    local events = _eventMap[eventType]
    if(events == nil)then
        _eventMap[eventType] = {}
        events = _eventMap[eventType]
    end
    local config = table.ifind(events,function(arg) return arg:EqualField(eventType,callback,instance) end)
    if(config)then
        return
    end
    table.insert(events,eventConfig)
end

EventSystem.RegisterByConfig = function(eventConfig)
    EventSystem.Register(eventConfig._eventType,eventConfig._callback,eventConfig._instance)
end

--注销
EventSystem.Cancel = function(eventType,callback,instance)
    local eventConfig = EventConfig.New(eventType,callback,instance)
    local events = _eventMap[eventType]
    if(events == nil)then
        _eventMap[eventType] = {}
        events = _eventMap[eventType]
        return
    end
    local config,index = table.ifind(events,function(arg) return arg:EqualField(eventType,callback,instance) end)
    if(not config)then
        return
    end
    table.remove(events,index)
end

--注销
EventSystem.CancelByConfig = function(eventConfig)
    EventSystem.Cancel(eventConfig._eventType,eventConfig._callback,eventConfig._instance)
end

--广播
EventSystem.Broadcast = function(eventType,...)
    local msg = {...}
    local events = _eventMap[eventType]
    if(events == nil)then
        _eventMap[eventType] = {}
        events = _eventMap[eventType]
        return
    end
    for i,config in ipairs(events)do
        if(config)then
            config:Invoke(...)
        end
    end
end

--事件配置
EventConfig = class("EventConfig")
function EventConfig:ctor(eventType,callback,instance)
    self._eventType =eventType
    self._callback =callback
    self._instance =instance
end

function EventConfig:Invoke(...)
    if(self._callback)then
        if(self._instance)then
            self._callback(self._instance,...)
        else
            self._callback(...)
        end
    end
end

function EventConfig:AddMark(mask)
    self._mask = mask
end

function EventConfig:Equal(eventConfig)
    return self.Equal(eventConfig._eventType,eventConfig._callback,eventConfig._instance)
end

function EventConfig:EqualField(eventType,callback,instance)
    return self._eventType == eventConfig._eventType and
           self._callback == eventConfig._callback and
           self._instance == eventConfig._instance 
end
