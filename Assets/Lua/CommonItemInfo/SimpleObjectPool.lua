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
    self.onConstruct = onConstruct

    self.onEnable = onEnable or function(obj)
            obj:SetActive(true)
        end

    self.onDisable = onDisable or function(obj)
            obj:SetActive(false)
        end

    self.onDestroy = onDestroy
end

--添加对象
function this:Add(...)
    if (self.onConstruct == nil) then
        print("without onConstruct function!")
        return
    end

    local obj = nil
    if (#self._deadQueue > 0) then
        obj = table.remove(self._deadQueue, #self._deadQueue)
    end

    if (obj == nil) then
        obj = self.onConstruct(...)
    end

    table.insert(self._liveQueue, obj)

    if (self.onEnable) then
        self.onEnable(obj,...)
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
        print("without onDestroy function!")
        return
    end

    self:Clear()

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

--获取生池
function this:GetLives()
    return self._liveQueue
end


--预设方法@@@@@@@@@@@@@@

--获取ui对象池
--prefabObj --gameObject
--luaclass --gClass["className"]
--layout --UILayout
function this.GetSimpleUIObjectPool(prefabObj,luaclass,layout)
    local onEnabled

    if(layout)then
        if( layout.gameObject)then
            layout = UILayout.New(layout.gameObject)
        end

        onEnabled = function(obj,...)
            obj:SetActive(true)
            layout:AddChild(obj)
        end
    end
    return SimpleObjectPool.New(function(...) return luaclass.New(GameObject.Instantiate(prefabObj),...) end,onEnabled)
end

--物品池
--layout = UILayout  or GameObject
--afterEnabled  显示后你要做的额外处理   luaFunction
function this.GetSimpleItemPool(layout,afterEnabled)
    if(layout.gameObject)then
        layout = UILayout.New(layout.gameObject)
    end

    local ctor = function(flag,value)
        return ItemIcon.New(flag[1], tonumber(flag[2]), nil)
    end
    local en = function(item,flag,value)
        layout:AddChild(item.gameObject,2)
        item:SetIcon(flag[1], tonumber(flag[2]))
        item:SetCount(value)
        item:SetAngle()
        item:SetShard()
        item:SetActive(true)
        if(afterEnabled)then afterEnabled(item) end
    end
    local destroy = function(item)
        item:Destroy()
        GameObject.Destroy(item.gameObject)
    end

    local pool = SimpleObjectPool.New(ctor,en,nil,destroy)
    --内置生成
    function pool:SetReward(flags,values,clear)
        if(clear == nil)then clear = true end
        if(clear)then self:Clear() end
        table.iaction(flags,function(arg,index) self:Add(arg, values[index]) end)
    end

    return pool
end