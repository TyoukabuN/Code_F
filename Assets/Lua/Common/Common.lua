--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : zjw
--创始日期  : 2018年8月9日11:21:30
--功能描述  : 测试
--------------------------------------------------------
Common = class("Common")

Common.debugSwitch = true
Common.format_rankText_other = "<color=#68d7f3>%s</color>"

printc = function(...)
    local arg = {...}
    for i = 1,#arg do
        arg[i] = tostring(arg[i])
    end
    local content = table.concat(arg,"  ")
    local format_log = "<color=yellow>%s</color>"
    local format_log_color = "<color=%s>%s</color>"
    if(Common.debugSwitch)then
        if(color)then
            print(string.format(format_log_color,color,content))
        else
            print(string.format(format_log,content))
        end
    end

    print(debug.traceback())
end

--获取根母表
getrootmetatable = function(table)
    local meta = getmetatable(table)
    if(not meta)then
        return table
    end
    return getrootmetatable(meta)
end

--比例映射
map = function(val,val1_1,val1_2,val2_1,val2_2)
    local x = (val-val1_1)/(val1_2-val1_1) * (val2_2-val2_1)
    x = x + val2_1
    return x
end

--区间限制
clamp = function(value,min,max)
    if(min and value<min)then
        value = min
    end

    if(max and value>max)then
        value = max
    end

    return value
end

--范围内
inRange = function(value,val1,val2)
    local tab = {val1,val2}
    table.sort(tab,function(v1,v2) return v1<=v2 end)
    return value >= tab[1] and value <=tab[2]
end



-- SetParent = function(trans,parentTrans)
--     trans:SetParent(parentTrans,false)
-- end