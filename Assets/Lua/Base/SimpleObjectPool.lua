--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 张嘉文
--创始日期  : 2018年8月10日11:44:07
--功能描述  : SimpleObjectPool
--------------------------------------------------------
SimpleObjectPool = class("SimpleObjectPool")

local this = SimpleObjectPool

function this:ctor(onConstruct, onEnable, onDisable, onDestroy)
    self._liveQueue = {}
    self._deadQueue = {}
    self._createStep = 1
    self.onConstruct = onConstruct
    self.onEnable = onEnable or function(obj)
            obj:SetActive(true)
        end
    self.onDisable = onDisable or function(obj)
            obj:SetActive(false)
        end
    self.onDestroy = onDestroy
end

--设着步长
function this:SetCreateStep(step)
    self._createStep = step
end

--获取对象
function this:Get()
    if (self.onConstruct == nil) then
        print("without onConstruct function!")
        return
    end
    local obj = nil
    if (#self._deadQueue > 0) then
        obj = table.remove(self._deadQueue, #self._deadQueue)
    end
    if (obj == nil) then
        obj = self.onConstruct()--self:Get()
    end
    table.insert(self._liveQueue, obj)
    if (self.onEnable) then
        self.onEnable(obj)
    end
    return obj
end

--添加对象
function this:Add()
    local obj
    for i = 1,self._createStep do
        obj = self.onConstruct()
        self.onDisable(obj)
        table.insert(self._deadQueue, obj)
    end
    return obj
end

--移除对象
function this:Remove(obj)
    if (self.onDisable == nil) then
        print("without onDisable function!")
        return
    end
    local index = table.index(self._liveQueue,function(arg) return arg == obj end)
    local obj = table.remove(self._liveQueue,index)
    table.insert(self._deadQueue, obj)
    self.onDisable(obj)
end

--销毁池
function this:Dispose()
    if (self.onDestroy == nil) then
        print("without onDetroy function!")
        return
    end
    if (#self._liveQueue > 0) then
        local length = #self._liveQueue
        for i = 1, length do
            local obj = table.remove(self._liveQueue, #self._liveQueue)
            self.onDestroy(obj)
        end
    end
    if (#self._deadQueue > 0) then
        local length = #self._deadQueue
        for i = 1, length do
            local obj = table.remove(self._deadQueue, #self._deadQueue)
            self.onDestroy(obj)
        end
    end
    self._liveQueue = {}
    self._deadQueue = {}
end

--清理
function this:Clear()
    if (#self._liveQueue > 0) then
        local length = #self._liveQueue
        for i = 1, length do
            local obj = table.remove(self._liveQueue, #self._liveQueue)
            table.insert(self._deadQueue, obj)
            self.onDisable(obj)
        end
    end
end
