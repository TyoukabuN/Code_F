--Copyright (C)
--版本      : 1.0
--作者      : 
--创始日期  : 2018年8月9日11:21:30
--功能描述  : luaClass
--------------------------------------------------------
globalClass = {}

class = function(className,base)
    local cls
    base = base or classBase
    if(base)then
        cls = setmetatable({},{__index = base})
        cls.base = base
    end
    cls.__cname = className
    cls.New = function(...)
        local instance = setmetatable({},{__index = cls})
        instance.class = cls
        instance:ctor(...)
        return instance
    end
    globalClass[className] = cls
    return cls
end

classBase = {}
function classBase:ctor () end
function classBase:onEnabled() end
function classBase:onDisabled()end
function classBase:onUpdate()  end
function classBase:onDestroy() end

