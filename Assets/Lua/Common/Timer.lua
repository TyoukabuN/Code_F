Timer = class("Timer")

local this = Timer

function this:ctor(callback ,durationTime,loopTime,...)
    if(not callback)then
        return
    end

    self.callback = callback
    self.durationTime = durationTime
    self.loopTime = loopTime
    self.args = {...}
    --
    self.start = false
    self.running = false

    self._callback = function() self:OnTimerInvoke() end

    return self
end

function this:Start()
    self.loopCount = 0

    if(not self.callback or self.start)then
        return
    end

    if(self.durationTime<=0)then
        self.callback(table.unpack(self.args))
        return
    end

    TimerSystem.Start(self._callback,self.durationTime,self.loopTime or 0)

    self.running = true
end

function this:OnTimerInvoke()
    self.callback(table.unpack(self.args))

    if(not self.loopCount)then
        return
    end

    self.loopCount = self.loopCount + 1
    if(self.loopCount == self.loopTime)then
        self:Stop(false)
    end
end

function this:Stop(asComplete)
    if(not asComplete)then
        asComplete = false
    end

    if(not self.callback)then
        return
    end

    if(asComplete)then
        self.callback(table.unpack(self.args))
    end

    TimerSystem.Stop(self._callback)

    self.running = false
end

function this:Replay()
    if(self.running)then
        self:Stop(false)
    end

    self:Start()
end
