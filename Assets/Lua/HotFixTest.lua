
--十进制转16进制  decimal
local DecToHex =  function(...)
    local args = {...}
    local vals = {}
    for i = 1,#args do
        vals[#vals+1] = string.format("%x",args[i])
    end
    return vals
end

local HexToDec =  function(...)
    local args = {...}
    local vals = {}
    for i = 1,#args do
        vals[#vals+1] = string.format("%d","0x"..args[i])
    end
    return vals
end

ToRichTextFormat = function(...)
    local args = {...}
    local res = "#"
    for i = 1,#args do
        res = res .. args[i]
    end
    return "<color="..res..">颜色</color>"
end

StrCode2Hexs = function(str)
    local res = {}
    if(#str==7)then
        for i = 2,#str,2 do
            res[#res+1] = string.format("%s%s",str)
        end
    end
end
--类System.String.Split
function string.split(str, delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(str, delimiter, pos, true) end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end

--print(table.unpack(string.split("Role\\H017\\H017M","\\")))
--黄色
--print(ToRichTextFormat(table.unpack(DecToHex(222,169,65))))
--红色
--print(ToRichTextFormat(table.unpack(DecToHex(226,19,16))))
--
-- print(ToRichTextFormat(table.unpack(DecToHex(144,93,43))))
-- --绿色
-- print(ToRichTextFormat(table.unpack(DecToHex(52,193,91))))
-- --蓝色
-- print(ToRichTextFormat(table.unpack(DecToHex(104,215,243))))

-- print(ToRichTextFormat(table.unpack(DecToHex("104","215","243"))))

-- print(table.unpack(HexToDec(table.unpack({"00","FF","00"}))))


--5555B1
-- 		icon = string.lower("icon/icon_play_003","icon/")
-- 		icon = string.gsub(icon,"ui/","")
-- 		icon = string.gsub(icon,"icon/","")
		
-- 		print(icon)

-- func1 = function() print("originFunc") end

-- tem_p = func1

-- func2 = function() tem_p() print("exFunc") end

-- func1 = func2

-- func1()

-- func1 = tem_p

-- func1()

-- protocol = {
--     sc_protocol = function(val) print("sc_protocol",val) end
-- }

-- temp = nil

-- func3 = function(protocol_table,key) 
--     temp = protocol_table[key]
--     func = function(val) print("#附加#",val) temp(val) print("#附加#",val) end 
--     protocol_table[key] = func
--     end

-- protocol.sc_protocol(1)
-- func3(protocol,"sc_protocol")
-- protocol.sc_protocol(1)

-- protocol["sc_protocol"] = temp

function GetPointInCircleByAngle(circleCentre, radius, angle) 
    local x = circleCentre.x + radius * math.cos(angle * 0.0174532924)
    local y = circleCentre.y + radius * math.sin(angle * 0.0174532924)
    return string.format("{x=%s,y=%s},",x,y)
end

function GetAngle(angle) 
    return angle ,math.cos(angle * 0.0174532924),math.sin(angle * 0.0174532924)
end
-- print(GetAngle(90))
-- print(GetAngle(89))
-- print(GetAngle(0))
-- print(360/10)
-- print(GetPointInCircleByAngle({x = 0,y = 0},200,90))
-- print(GetPointInCircleByAngle({x = 0,y = 0},200,18*3))
-- print(GetPointInCircleByAngle({x = 0,y = 0},200,18))
-- print(GetPointInCircleByAngle({x = 0,y = 0},200,360-18))
-- print(GetPointInCircleByAngle({x = 0,y = 0},200,360-18*3))
-- print(GetPointInCircleByAngle({x = 0,y = 0},200,360-18*5))
-- print(GetPointInCircleByAngle({x = 0,y = 0},200,270-18*2))
-- print(GetPointInCircleByAngle({x = 0,y = 0},200,270-18*4))
-- print(GetPointInCircleByAngle({x = 0,y = 0},200,180-18))
-- print(GetPointInCircleByAngle({x = 0,y = 0},200,180-18*3))


-- NumImage = {
-- 	[0] = {cn = ""},--2018年7月25日21:05:39 zjw  20，30整十会有问题
-- 	[1] = {cn = "一"},
-- 	[2] = {cn = "二"},
-- 	[3] = {cn = "三"},
-- 	[4] = {cn = "四"},
-- 	[5] = {cn = "五"},
-- 	[6] = {cn = "六"},
-- 	[7] = {cn = "七"},
-- 	[8] = {cn = "八"},
-- 	[9] = {cn = "九"},
-- 	[10^1] = {cn = "十"},
-- 	[10^2] = {cn = "百"},
-- 	[10^3] = {cn = "千"},
-- 	[10^4] = {cn = "万"},
-- 	[10^8] = {cn = "亿"},
-- 	[10^12] = {cn = "兆"},
-- }

-- function NumberToChinese3(strValue)
--     strValue = tostring(strValue)
--     unitDatas = {}
--     numDatas = {}
--     for k in string.gmatch(strValue,"%d")do
--         table.insert(numDatas,k)
--     end
--     str = ""
--     for i,value in ipairs(numDatas)do
--         value = tonumber(value)
--         local index = #numDatas-i 
--         local unit_index = 10^index
--         if(unit_index==1)then
--             unit_index = 0
--         end
--         local unit_cn = NumImage[unit_index]
--         if(value>0)then

--             if(unit_cn==nil)then
--                 print(unit_index)
--                 index = index%4
--                 unit_cn = NumImage[10^index].cn
--             else
--                 unitDatas[i] = unit_index
--                 unit_cn = unit_cn.cn
--             end
--             local num_cn = NumImage[value].cn
--             local ext_str = ""
--             if(numDatas[i-1] and tonumber(numDatas[i-1])==0)then
--                 print(i-1,i)
--                 ext_str = "零"
--             end
--             if(index==1 and not numDatas[i-1])then
--                 num_cn = ""
--             end
--             str = str..ext_str..num_cn..unit_cn
--         else
--             if(unit_cn and not unitDatas[i-1] and numDatas[i-1] and tonumber(numDatas[i-1])>0 and numDatas[i+1] and tonumber(numDatas[i+1])==0)then
--                 print(unit_cn.cn)
--                 str = str..unit_cn.cn
--             end
--         end
--     end
--     return str
-- end

local NumImage = {
	[0] = {cn = ""},--2018年7月25日21:05:39 zjw  20，30整十会有问题
	[1] = {cn = "一"},
	[2] = {cn = "二"},
	[3] = {cn = "三"},
	[4] = {cn = "四"},
	[5] = {cn = "五"},
	[6] = {cn = "六"},
	[7] = {cn = "七"},
	[8] = {cn = "八"},
	[9] = {cn = "九"},
	--2018年7月27日15:53:13 zjw
	[10^1] = {cn = "十"},
	[10^2] = {cn = "百"},
	[10^3] = {cn = "千"},
	[10^4] = {cn = "万"},
	[10^5] = {cn = "十"},
	[10^6] = {cn = "百"},
	[10^7] = {cn = "千"},
	[10^8] = {cn = "亿"},
	[10^9] = {cn = "十"},
	[10^10] = {cn = "百"},
	[10^11] = {cn = "千"},
	[10^12] = {cn = "兆"},
	[10^13] = {cn = "十"},
	[10^14] = {cn = "百"},
	[10^15] = {cn = "千"},
	[10^16] = {cn = "京"},
}

--上限为NumImage的上限
--2018年7月27日15:53:13 zjw
function NumberToChinese3(val)
    local strValue = tostring(val)
    local numDatas = {}
    for k in string.gmatch(strValue,"%d")do
        table.insert(numDatas,k)
    end
    local str = ""
    for i,value in ipairs(numDatas)do
        value = tonumber(value)
        if(value>0)then
            local index = #numDatas-i
            local unit_index = 10^index
            if(unit_index==1)then
                unit_index = 0
            end
            local unit_cn = NumImage[unit_index].cn
            local num_cn = NumImage[value].cn
            local ext_str = ""
            if(numDatas[i-1] and tonumber(numDatas[i-1])==0)then
                ext_str = "零"
            end
            str = str..ext_str..num_cn..unit_cn
        else
            local index = #numDatas-i
            local unit_index = 10^index
            if(unit_index>1 and index%4 == 0)then
                local unit_cn = NumImage[unit_index].cn
                str = str..unit_cn
            end
        end
    end
    return str
end


print(NumberToChinese3(10043))
-- function string.split(str, delimiter)
--     if (delimiter=='') then return false end
--     local pos,arr = 0, {}
--     -- for each divider found
--     for st,sp in function() return string.find(str, delimiter, pos, true) end do
--         table.insert(arr, string.sub(str, pos, st - 1))
--         pos = sp + 1
--     end
--     table.insert(arr, string.sub(str, pos))
--     return arr
-- end
-- print(table.unpack(string.split("Role\\Wing\\W010M","\\")))

base = class("base")
function base:ctor(...)
    print("base ctor")
end
this = class("this",base)
function this:ctor(...)
    this.super.ctor(...)
   print("this ctor") 
end
this:New()
