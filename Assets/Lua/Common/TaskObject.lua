TaskObject = class("TaskObject")

local this = TaskObject

function this:ctor(condition,onDone,delay,onUpdate)
    self.condition = condition or function() return false end
    self.onDone = onDone
    self.delay = delay or 0
    self.onUpdate = onUpdate
    --
    self.counter = 0        --用于delay的记录
    self.counter0 = 0       --任务的生命记录
    self.updateCount = 0    --任务的Tick执行次数(完成前)
    self.done = false
end

function this:Start()
    self.running  = true
    -- EnUpdate(self.Tick,self)
    return self
end

function this:Invoke()
    if(self.onDone)then
        pcall(function() self.onDone() end)
    end
end

function this:Dispose()
    self:Stop()
    --...
end

function this:Tick()
    if(not self.running)then
        return false
    end

    if(self.done)then
        return true
    end

    self.counter0 = self.counter0 + Time.deltaTime

    if(self.delay and self.counter<self.delay)then
        self.counter = self.counter + Time.deltaTime
        return false
    end

    self.counter = 0

    local isDone = true
    if(self.condition)then
        isDone = self.condition(self.counter0,self.updateCount)
    end

    if(self.onUpdate)then
        self.updateCount = self.updateCount + 1
        pcall(function() self.onUpdate(self.counter0,self.updateCount) end)
    end

    if(isDone)then
        self.done = true
        self:Invoke()
    end

    return isDone
end

function this:Pause()
    self.running = false
end

function this:Stop()
    self:Pause()
    -- DeUpdate(self.Tick,self)
end

function this:isDone()
    return self.done == true
end


--计时任务
TimerTask = class("TimerTask",TaskObject)

function TimerTask:ctor(done,time)
    time = time or 0
    self.super.ctor(self,function(c,u) return c>=time end, done,nil,nil)
end