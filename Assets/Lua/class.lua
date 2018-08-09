--Copyright (C)
--版本      : 1.0
--作者      : 
--创始日期  : 2018年8月9日11:21:30
--功能描述  : 
--------------------------------------------------------
globalClass = {}

class = function(className,super)
    local cls
    if(super)then
        cls = setmetatable({},{__index = super})
        cls.super = super
    else
        cls = {ctor = function() end}
    end
    cls.New = function(...)
        local instance = setmetatable({},{__index = cls})
        instance.base = cls
        instance:ctor(...)
        return instance
    end
    globalClass[className] = cls
    return cls
end