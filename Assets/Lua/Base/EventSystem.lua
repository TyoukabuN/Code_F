EventSystem = class("EventSystem")

EventType = {
    Test = 0,
}

EventSystem._eventMap = {}

--注册
EventSystem.Register = function(eventType,callback,instance)
    local eventConfig = EventConfig.New(eventType,callback,instance)
    local events = EventSystem._eventMap[eventType]
    if(events == nil)then
        EventSystem._eventMap[eventType] = {}
        events = EventSystem._eventMap[eventType]
    end
    local config = table.ifind(events,function(arg) return arg:Equal(eventConfig) end)
    if(config)then
        return
    end
    table.insert(events,eventConfig)
end

--注销
EventSystem.Cancel = function(eventType,callback,instance)
    local eventConfig = EventConfig.New(eventType,callback,instance)
    local events = EventSystem._eventMap[eventType]
    if(events == nil)then
        EventSystem._eventMap[eventType] = {}
        events = EventSystem._eventMap[eventType]
        return
    end
    local config,index = table.ifind(events,function(arg) return arg:Equal(eventConfig) end)
    if(not config)then
        return
    end
    table.remove(events,index)
end

--广播
EventSystem.Broadcast = function(eventType,...)
    local msg = {...}
    local events = EventSystem._eventMap[eventType]
    if(events == nil)then
        EventSystem._eventMap[eventType] = {}
        events = EventSystem._eventMap[eventType]
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

function EventConfig:Equal(eventConfig)
    return self._eventType == eventConfig._eventType and
           self._callback == eventConfig._callback and
           self._instance == eventConfig._instance
end
