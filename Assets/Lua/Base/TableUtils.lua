--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : csq
--创始日期  : 2018年5月22日09:53:20
--功能描述  : Table操作函数
--------------------------------------------------------

local json = require "cjson"

--是否存在key
function table.containKey(t, key)
    for k, v in pairs(t) do
        if key == k then
            return true
        end
    end
    return false
end

--是否存在值
function table.containValue(t, value)
    for k, v in pairs(t) do
        if value == v then
            return true
        end
    end
    return false
end

--根据值找key
function table.getKeyByValue(t, value)
    for k, v in pairs(t) do
        if value == v then
            return k
        end
    end
    return nil
end

--key总数
function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

--key总数除去空值
function table.keyNum(t)
    local count = 0
    for k, v in ipairs(t) do
        count = count + 1
    end
    return count
end

--取得所有key
function table.keys(t)
    local keys = {}
    if t == nil then
        return keys
    end
    for k, v in pairs(t) do
        keys[#keys + 1] = k
    end
    return keys
end

--取得所有值
function table.values(t)
    local values = {}
    if t == nil then
        return values
    end
    for k, v in pairs(t) do
        values[#values + 1] = v
    end
    return values
end

--移除第一个等于val的元素
function table.removeByValue(t, val)
  for i, v in ipairs(t) do
      if val == v then
          table.remove(t, i)
          break
      end
  end
end

--尾部插入
function table.add(t, val)
  if t then
    t[#t+1] = val
  end
end

--table a中插入table b
function table.merge(tba, tbb)
  for k,v in pairs(tbb) do
    tba[k] = v
  end
  return tba
end

--反转
function table.reverse(t)
  for i = 1, #t/2 do
    t[i], t[#t-i+1] = t[#t-i+1], t[i]
  end
  return t
end

--拷贝
function table.copy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local newObject = {}
        lookup_table[object] = newObject
        for key, value in pairs(object) do
            newObject[_copy(key)] = _copy(value)
        end
        return setmetatable(newObject, getmetatable(object))
    end
    return _copy(object)
end


--递归打印table内容
function table.print(sth, extraMsg)
	if type(sth) ~= "table" then
		print(sth)
		return
	end

	local cache = {  [sth]="<self>" }

	local space, deep = string.rep(' ', 2), 2
	local function _dump(pkey, t)
		local key
		local printstr = ""
		for k,v in pairs(t) do
			if type(k) == 'number' then
				key = string.format("[%s]", k)
			else
				key= tostring(k)
			end

			if cache[v] then
				printstr = printstr.."\n"..string.format("%s%s=%s,", string.rep(space, deep), key, cache[v])
			elseif type(v) == "table" then
				cache[v] = string.format("%s.%s", pkey, key)
				printstr = printstr.."\n"..string.format("%s%s = {", string.rep(space, deep), key)
				deep = deep + 2
				printstr = printstr.._dump(string.format("%s.%s", pkey, key), v)
				deep = deep - 2
				printstr = printstr.."\n"..string.format("%s},", string.rep(space, deep))
			else
				if type(v) == 'string' then
					printstr = printstr.."\n"..string.format("%s%s = '%s',", string.rep(space, deep), key, v)
				else
					printstr = printstr.."\n"..string.format("%s%s = %s,", string.rep(space, deep), key, tostring(v))
				end
			end
		end
		return printstr
	end

	local tableStr = tostring(sth).." = {".._dump("<self>", sth).."\n}"
	if extraMsg then
		print(tostring(extraMsg).."\n"..tableStr)
	else
		print(tableStr)
	end
end

--取得排序后的key列表
function table.getSortKey(t)
  local key_table = {}
  --取件
  for key,_ in pairs(t) do
    table.insert(key_table, key)
  end
  --排序
  table.sort(key_table)

  return key_table
end

--保存txt文件
function table.saveTxtFiles(tb,path)
  local wirtjson = json.encode(tb)--转换成json格式
  local test = assert(io.open(path, "w"))
  test:write(wirtjson)
  test:close()
end 

--获取txt文件
function table.readTxtFiles(path)
  local test = io.open(path, "r")
  if not test then
    return
  end
  local readjson= test:read("*a")
  local tb =json.decode(readjson)
  test:close()
  return tb
end

--lua table.pack
--2018年7月20日10:43:42 zjw
table.pack = function(...)
    return {...}
end


--获取表元素索引值 
--2018年6月21日11:36:58 zjw
table.index = function(table, element)
	for k, v in pairs(table) do
		if (v == element) then
			return k
		end
	end
	
	return -1
end

--类System.Linq.All
--table表(数组)      	       table
--predicate谓语(检索的要求) 	function
--2018年6月21日11:36:58 zjw
table.all = function(table, predicate)
	for k, v in pairs(table) do
		if(predicate(v) == false) then
			return false
		end
	end
	return true
end

--类System.Linq.Any
--2018年6月21日11:36:58 zjw
table.any = function(table, predicate)
	for k, v in pairs(table) do
		if(predicate(v) == true) then
			return true
		end
	end
	return false
end

--类System.Linq.Any
--2018年6月21日11:36:58 zjw
table.iany = function(table, predicate)
	for k, v in ipairs(table) do
		if(predicate(v) == true) then
			return true
		end
	end
	return false
end

--类System.Linq.where
--2018年6月21日11:36:58 zjw
table.find = function(table, predicate)
	if(table==nil)then
		return nil
	end
	for k, v in pairs(table) do
		if(predicate(v) == true) then
			return v
		end
	end
	return nil
end

table.ifind = function(table, predicate)
	if(table==nil)then
		return nil
	end
	for k, v in ipairs(table) do
		if(predicate(v) == true) then
			return v,k
		end
	end
	return nil
end

--
table.finds = function(tab, predicate)
	if(tab==nil)then
		return {}
    end
    local res = {}
	for k, v in pairs(tab) do
		if(predicate(v) == true) then
			table.insert(res,v)
		end
	end
	return res
end

--2018年6月21日11:36:58 zjw
table.IndexOf = function(table, predicate)
	if(table==nil)then
		return nil
	end
	for k, v in pairs(table) do
		if(predicate(v) == true) then
			return k
		end
	end
	return nil
end

--类System.Linq.Max
--2018年6月21日11:36:58 zjw
table.max = function(table, predicate)
    local maxValue = -1 * 2 ^ 54
    local index = nil
	for k, v in pairs(table) do
		if(predicate(v) > maxValue) then
            maxValue = predicate(v)
            index = k
		end
	end
	return maxValue,index
end

--类System.Linq.Min
--2018年6月21日11:36:58 zjw
table.min = function(table, predicate)
	if(predicate==nil)then
		predicate = function(arg) return arg end
	end
    local minValue = 2 ^ 54
    local index = nil
	for k, v in pairs(table) do
		if(predicate(v) < minValue) then
            minValue = predicate(v)
            index = k
		end
	end
	return minValue,index
end


