TaskSystem = class("TaskSystem")

local list = {}
local finshs = {}
local init = false

local IsEmpty = function()
    return not list or #list==0
end

TaskSystem.Init = function()
    if(init)then
        if(not running)then
            TaskSystem.Start()
        end
        return
    end
    init = true
    list = {}
    TaskSystem.Start()
end
TaskSystem.Start = function()
    DeUpdate(TaskSystem.Tick)
    EnUpdate(TaskSystem.Tick)
end

TaskSystem.Stop = function()
    DeUpdate(TaskSystem.Tick)
end


TaskSystem.Add = function(condition,onDone,delay,onUpdate)
    TaskSystem.AddObject(TaskObject.New(condition,onDone,delay,onUpdate))
end

TaskSystem.AddObject = function(taskobject)
    table.insert(list,taskobject:Start())
end

TaskSystem.Tick = function()
    --无任务停止
    if(IsEmpty())then TaskSystem.Stop() return end
    --轮询
    for index,tobject in ipairs(list)do
        tobject:Tick()
    end
    --清理
    TaskSystem.Clear(function(arg) return arg:isDone() end)
end

--predicate  function(tobject)  return tobject.?==? end
TaskSystem.Clear = function(predicate)
    if(IsEmpty())then return end

    if(not predicate)then
        list = {}
        return
    end

    local temp = {}
    local len = #list
    for i=1,len do
        local tobject = table.remove(list,1)
        if(not predicate(tobject))then
            table.insert(temp,tobject)
        end
    end

    list = temp
end

TaskSystem.Remove = function(taskObject)
    for i,v in ipairs(list)do
        if(v==taskObject)then
            table.remove(list,i)
            return
        end
    end
end

TaskSystem.RunningTaskCount = function()
    local ts = table.ifinds(list,function(arg) return arg.running==true end)
    return #ts,#list
end

