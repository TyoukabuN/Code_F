TaskQueue = class("TaskQueue")

local this = TaskQueue

function this:ctor(list)
    self.list = list or {}
    self.dones = {}
end

function this:Start()
    if(#self.list==0)then
        return
    end

    table.iaction(self.list,function(arg) arg:Start() end)

    self.running  = true
    return self
    -- EnUpdate(self.Tick,self)
end

function this:Add(task)
    self:AddObject(TaskObject.New(condition,onDone,delay,onUpdate):Start())
end

function this:AddObject(task)
    table.insert(self.list,task)
    if(not self.running and #self.list == 1)then
        self:Start()
    end
end

function this:Tick()
    if(not self.running or #self.list==0)then
        return false
    end

    if(self.list[1]:Tick())then
        table.insert(self.dones,table.remove(self.list,1))
        printc("队列中某个任务完成了","队列中剩余任务数:",#self.list,TaskSystem.RunningTaskCount())
        return true
    end

    return #self.list==0
end

function this:Pause()
    self.running = false
end

function this:Stop()
    self:Pause()
    -- DeUpdate(self.Tick,self)
end

function this:Dispose()
    self:Stop()
    table.iaction(self.list,function(arg) arg:Dispose() end)
    self.list = {}
end

function this:isDone()
    return #self.list==0
end

