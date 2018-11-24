TaskObject = class("TaskObject")

local this = TaskObject

function this:ctor(condition,onDone,delay)
    self.condition = condition
    self.onDone = onDone
    self.delay = delay
    self.counter = 0
end

function this:Start()
    self.runnsing  = true
    -- EnUpdate(self.Tick,self)
end

function this:Invoke()
    if(self.onDone)then
        self.onDone()
    end
end

function this:Dispose()
    self:Stop()
end

function this:Tick()
    if(not self.running)then
        return false
    end

    if(self.done)then
        return true
    end

    if(self.delay and self.counter<self.delay)then
        self.counter = self.counter + Time.deltaTime
        return false
    end

    local isDone = true
    if(self.condition)then
        isDone = self.condition()
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