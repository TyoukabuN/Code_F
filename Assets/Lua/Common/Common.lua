--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 
--创始日期  : 2018年8月9日11:21:30
--功能描述  : 测试
--------------------------------------------------------
Common = class("Common")

Common.debugSwitch = true
Common.format_rankText_other = "<color=#68d7f3>%s</color>"

Common.ColorLog = function(content,color)
    local format_log = "<color=yellow>%s</color>"
    local format_log_color = "<color=%s>%s</color>"
    if(Common.debugSwitch)then
        if(color)then
            print(string.format(format_log_color,color,content))
        else
            print(string.format(format_log,content))
        end
    end
end