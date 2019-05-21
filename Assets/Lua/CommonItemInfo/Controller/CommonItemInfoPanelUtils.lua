--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 张嘉文
--创始日期  : 2018年7月16日15:07:54
--功能描述  : 通用物品信息面板工具集（避免本类因样式预设方法的增加而膨胀）
--------------------------------------------------------

module("CommonItemInfoPanelUtils", package.seeall)

-------------------------------------样式预设方法---------------------------------

-- // 物品信息结构
-- message pb_item_info
-- {
    -- required uint64 id = 1;
    -- required uint32 base_id = 2;
    -- required uint32 count = 3;
    -- required uint32 bag_type = 4;                       // 背包分类 0 仓库 1 装备 2物品 3材料 4其他
    -- required uint32 bind_type = 5;                      // 是否能交易
    -- repeated pb_item_attr attr_list = 6;                //
    -- required bool prefix = 7;                           // 传世前缀
    -- repeated uint32 destiny = 8;                        // 装备命盘
    -- required uint32 opening_level = 9;                  // 开光等级
    -- required uint32 guard_level = 10;                   // 护主装备强化等级
    -- required uint32 deadline = 11;                      // 最后期限
-- }

-- // 装备槽信息
-- message pb_item_equip
-- {
--     required uint32 index = 1;                  // 装备部位
--     required pb_item_info info = 2;             // 装备物品信息
--     required uint32 strengthen_level = 3;       // 强化等级
--     required uint32 strengthen_fail_times = 4;  // 强化失败次数
--     repeated pb_hole holes = 5;
--     repeated uint32 forgeds = 6;                //锻造 [1,1,2,3,3] 1星 2月亮 3太阳
--     required uint32 original_spirit_lv = 7;     //元神等级
--     required uint32 mastery_lv = 8;             //专精等级
-- }

--@@详参 物品表
--bag_type :
--1装备；2材料；3礼包；4宝石；5图鉴；6护主；7神纹；10其他；11骑具；12灵羽 ；13护符

--item_type:(部位)
--1头盔；2衣服；3护手；4裤子；5鞋子；6武器；7项链；8耳坠；9手镯；10戒指
--21兽盔；22兽甲；23兽爪；24兽鞍；
--25翎华；26翎甲；27翎羽；28翎骨
--31青龙护符、32白虎护符、33玄武护符、34朱雀护符、35麒麟护符


--物品信息面板的宽度 16为左侧空白 352为总宽
ITEM_INFO_WIDTH = 352-16

-- 属性战力计算权重
Attr2Weight = {
    ["att_1"] = 10,
    ["att_2"] = 10,
    ["def_1"] = 5,
    ["def_2"] = 5,
    ["hp_1"] = 0.5,
    ["hp_2"] = 0.5,
    ["crit"] = 10,
    ["antiriot"] = 10,
    ["hit"] = 10,
    ["block"] = 12,
    ["damage_plus"] = 10,
    ["damage_minus"] = 10,
    ["thorn"] = 2.7,
    ["crit_pro"] = 12,
    ["block_pro"] = 12,
    ["crit_damage"] = 12,
    ["g_in_damage"] = 24,
    ["g_out_damage"] = 24,
}

--显示一个物品
--data = pb_item_info 或者 pb_item_equip
--只是最大限度地做通用显示，若存在显示错误请在所处功能自定义显示  (参考 WingEquipItemListPanel:74)
--右侧按钮  (参考 StoneViewItemPanel:108)
function ShowItem(data,view)
    view = view or UIManager.ShowPanel(PanelName.CommonItemInfo)
    local itemInfo = data
    local equipInfo = nil
    local holyEquipInfo = nil
    if(data and data.info)then   --判断data是pb_item_info 还是 pb_item_equip
        equipInfo  =   data
        itemInfo = data.info
    end
   
    if(data and data.item_info)then   --判断data是pb_item_info 还是 pb_holy_costume
        holyEquipInfo  =   data
        itemInfo = data.item_info
    end
    local item_type = ConfigUtils.GetItemType(itemInfo.base_id)
    local bag_type = itemInfo.bag_type

    local panel = nil
   
    if(item_type>=1 and item_type <=10)then
        --print("常规装备")
        --常规装备
        local equip = EquipModule.EquipDatas[item_type] --GetEquipById(data.id)
        local doCompare = equip~=nil and itemInfo.id
        local eInfo = equipInfo
        if(not equipInfo)then
            eInfo = {info = itemInfo}
        end
        panel = AddEquipPanel(eInfo,doCompare,view)
    elseif item_type>=39 and item_type <=48 then 
        --圣装
        local part =HolyEquipModule.partIdx[item_type]
        local holyEquip = HolyEquipModule.HolyEquipDatas[part] --GetEquipById(data.id)
        local doCompare = holyEquip~=nil and itemInfo.id
        local eInfo = holyEquipInfo
        if(not holyEquipInfo)then
            eInfo = {info = itemInfo}
        end
        panel = AddHolyEquipPanel(eInfo,doCompare,view)
      
    else
        --其他没定制的物品
        panel = AddNormalItemPanel(data,view)
    end
    return panel
end

--自动调整位置的
-- 1.道具tips显示规则改为：显示在图标上方
-- 2.位置判断：道具图标位于黄线以下时，tips显示在图标的下方，黄线以上为300像素的高度
-- 3.左右边缘处理：当图标位于屏幕最左边或最右边时，上下规则不变，tips左右不可超出屏幕外
-- 4.以上规则，不包含背包中道具tips
-- 5.接口按各个功能的不同情况调用（参考ItemIcon:249）
function AutoSetPosition(trans)
	local view = UIManager.GetPanel(PanelName.CommonItemInfo)
	if(view and trans)then
		view:AutoPosition(trans)
	end
end

--用base_id来显示item,因item_id==nil数据将根据luaConfig_item的来
function ShowItemByBaseId(base_id)
    local data = GetItemAttributeInfo(base_id)--item_id == nil（非物品栏中）的物品需要自己构建一个pb_item_info格式
    return ShowItem(data)
end

--显示一个普通的物品
--data = pb_item_info
function AddNormalItemPanel(data,view)
    view = view or UIManager.ShowPanel(PanelName.CommonItemInfo)
    local panel = view:AddItemInfoPanel():SetData(data):SetWear(false)
    AddFightBox(panel)
    AddAttrsBox(panel)
    AddTopAttr(panel)
    AddDescBox(panel)
    AddGetWayDesc(panel)
    AddTimeLimitBox(panel)

    --2019年4月19日15:19:19 zjw 控制面板的高度
    panel:SizeCheck()

    return panel
end

--显示一件装备的物品信息（指item_type = 1 ~ 10）
--data = pb_item_info
--doCompare （这个接口的比较只限于item_type = 1 ~ 10的常规装备，其他装备的对比在自己的模块定制即可）
--view = PanelName.CommonItemInfo
--      没传的话会自动打开（panel的Show执行Clear,需要显示多个CommonItemInfoPanel时务必要传view）
function AddEquipPanel(equip,doCompare,view)
    view = view or UIManager.ShowPanel(PanelName.CommonItemInfo)
    local panel = view:AddItemInfoPanel():SetData(equip,function(arg) return arg.info end)
    local itemInfo = panel:GetItemInfo()
    local isWear = EquipModule.GetEquipById(equip.info.id) ~=nil
    panel:SetWear(isWear)
    AddFightBox(panel,true)
    AddAttrsBox(panel,equip)

    AddTopAttr(panel)
    AddMayGainTopAttr(panel)
    AddEquipSuitAttr(panel)
    AddWashAttrBox(panel,equip)
    -- AddSpiritAttrBox(panel) --2019年4月19日15:19:19 zjw 策划说要去掉元神
    AddPrefixBox(panel)
    AddGamAttrBox(panel)
    --比较用
    local panel2
    local equip2 = EquipModule.GetEquipByBaseId(itemInfo.base_id)
    if(EquipModule.GetEquipById(itemInfo.id)==nil and doCompare)then--如果显示的不是当前装备的装备
        if(equip2)then--对应装备槽上有没有装备（用于比较）
            panel2 = AddEquipPanel(equip2,false,view)
        end
    end
    --战斗力比较
    if(panel2)then
        CompareAttrBox(panel:GetBoxs()[1],panel2:GetBoxs()[1])
    end
    --2019年4月19日15:19:19 zjw 控制面板的高度
    panel:SizeCheck()

    return panel,equip2~=nil
end


--显示一件装备的物品信息（指item_type = 1 ~ 10）
--data = pb_item_info
--doCompare （这个接口的比较只限于item_type = 1 ~ 10的常规装备，其他装备的对比在自己的模块定制即可）
--view = PanelName.CommonItemInfo
--      没传的话会自动打开（panel的Show执行Clear,需要显示多个CommonItemInfoPanel时务必要传view）
function AddHolyEquipPanel(equip,doCompare,view)
    view = view or UIManager.ShowPanel(PanelName.CommonItemInfo)
    local panel = view:AddItemInfoPanel():SetData(equip,function(arg) return arg.info end)
    local itemInfo = panel:GetItemInfo()
    local isWear = HolyEquipModule.GetHolyEquipById(equip.info.id) ~=nil
    panel:SetWear(isWear)
    AddFightBox(panel,true)
    AddAttrsBox(panel,equip)
    AddTianDaoAttr(panel)
    AddHolyEquipAttr(panel)

    --比较用
    local panel2
    local equip2 = HolyEquipModule.GetHolyEquipByBaseId(itemInfo.base_id)
    if(HolyEquipModule.GetHolyEquipById(itemInfo.id)==nil and doCompare)then--如果显示的不是当前装备的装备
        if(equip2)then--对应装备槽上有没有装备（用于比较）
            panel2 = AddHolyEquipPanel(equip2,false,view)
        end
    end
    --战斗力比较
    if(panel2)then
        CompareAttrBox(panel:GetBoxs()[1],panel2:GetBoxs()[1])
    end
    --2019年4月19日15:19:19 zjw 控制面板的高度
    panel:SizeCheck()

    return panel,equip2~=nil
end

--战斗力
--panel = CommonItemInfoPanel
--isEquip 指的是你的结构是不是pb_item_equip
function AddFightBox(panel,isEquip)
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()
    local data = itemInfo
    if(isEquip)then
        data = panel:GetOriginData()
    end
    local detail,attrBox
    if(itemInfo)then
        if(itemInfo.id and itemInfo.attr_list and #itemInfo.attr_list>0)then
            --2019年4月10日16:28:34 zjw
            local f = GetFightValue(data,isEquip)
            detail,attrBox = panel:AddAttrBox():AddDetail("战斗力：",f .. "+")
            detail:SetCompareValue(f)
        else
            local bag_type = ConfigUtils.GetItemBagType(itemInfo.base_id)
            --身上没的
            local maxAttr = ConfigUtils.GetItemAttributeValueMax(itemInfo.base_id)
            local minAttr = ConfigUtils.GetItemAttributeValueMin(itemInfo.base_id)
            local isRandom = true
            if(#maxAttr ~= #minAttr)then
                isRandom = false
                maxAttr = minAttr
            end

            --2019年3月8日18:40:18 zjw 策划说要显示非装备物品的属性 古海峰
            local attr_list =  itemInfo.min_attr_list
            if(not attr_list)then
                attr_list = AttrList(ConfigUtils.GetAttributeFlag(itemInfo.base_id),minAttr)
            end

            if attr_list and #attr_list > 0 then
                local minfighting = GetFightValue(data,isEquip,function(arg) return  attr_list end)
                if(bag_type==4 or bag_type == 11 or bag_type == 12 or isRandom == false)then
                    detail,attrBox = panel:AddAttrBox():AddDetail(string.format("<color=#f6e778>战斗力 : %d +</color>", minfighting))
                else
                    local maxfighting = GetFightValue(data,isEquip,function(arg) return  AttrList(ConfigUtils.GetAttributeFlag(itemInfo.base_id),maxAttr) end)
                    detail,attrBox = panel:AddAttrBox():AddDetail(string.format("<color=#f6e778>战斗力 : （%d - %d）+</color>", minfighting, maxfighting))
                end
            end
        end
    end
    return attrBox, panel
end

--以属性名和值获取对应的战斗力
--attrName  = LuaConfig_attribute key
function GetFightValueByAttr(attrName,value)
    if(not Attr2Weight[attrName])then
        return 0
    end

    return math.floor(Attr2Weight[attrName] * value)
end

--用itemInfo获取战斗力
--pb_item_info
--isEquip 指的是你的结构是不是pb_item_equip
--isEquip = true ： data = pb_item_equip
--isEquip = false ： data = pb_item_info
--attrsGetter 你传的是一些** 其他结构 **时，请告诉我怎样获取你的属性列表attr_list
function GetFightValue(data,isEquip,attrsGetter)
    if(data==nil)then
        return
    end
    -- 属性战力计算权重
    local itemInfo = data
    local equip = nil
    if(isEquip and data.info)then
        itemInfo = data.info
        equip = data
    end

    local  attrs = itemInfo.attr_list
    if(attrsGetter)then
        attrs = attrsGetter(data)
    end
    local openinglevel = itemInfo.opening_level
    local item_type =  ConfigUtils.GetItemType(itemInfo.base_id)
    local guard_level = itemInfo.guard_level
    local fighting = 0
    local equip = nil

	for _, attr in ipairs(attrs) do
        local weight = Attr2Weight[attr.attr_type]
		if weight then
			fighting = fighting + weight * attr.attr_value
        end
        --2019年4月10日16:24:26 zjw 注释原因  战力计算公式的修改 只显示物品自身的属性的战斗力 ##策划厉朋专##
        -- --开光
		-- if openinglevel and openinglevel > 0 then
		-- 	local multiple = LuaConfig_light[openinglevel].multiplier
		-- 	fighting = fighting +weight * math.floor(attr.attr_value * (multiple-1))
        -- end
        -- --锻造
        -- if  equip and item_type>=1 and item_type<=10 then
		-- 	local persent = GetPersent(data)
		-- 	fighting = fighting + weight * math.floor(attr.attr_value * (persent/100))
        -- end
        -- --护主
        -- if(item_type>=31 and item_type<=35 and guard_level>0)then
        --     local persent = LuaConfig_talisman_equip[guard_level].attribute_percent
		-- 	fighting = fighting + weight * math.floor(attr.attr_value * persent)
        -- end
    end

    -- --极品属性
    -- if(itemInfo.top_attr_list and #itemInfo.top_attr_list>0)then
    --     for _, attr in ipairs(itemInfo.top_attr_list) do
    --         local weight = Attr2Weight[attr.attr_type]
    --         if weight then
    --             fighting = fighting + weight * attr.attr_value
    --         end
    --     end
    -- end

    --命盘
    if(itemInfo.destiny and #itemInfo.destiny>0) then

    end

	return math.floor(fighting)
end

--如果物品不存在背包，则自己创建属性数据用来界面显示
function GetItemAttributeInfo(baseId)
	local maxattrList   = {}
	local minattrList   = {}
	local attributeFlag = ConfigUtils.GetAttributeFlag(baseId)
	local maxAttrVal    = ConfigUtils.GetItemAttributeValueMax(baseId)
	local minAttrVal    = ConfigUtils.GetItemAttributeValueMin(baseId)
	baseId = tonumber(baseId)
	local data = {
		base_id = baseId,
		bag_type = ConfigUtils.GetItemBagType(baseId),
		count = 1,
		bind_type = 1,
		max_attr_list = maxattrList,
        min_attr_list = minattrList,
        prefix = false,     --传世
		destiny = {},
        deadline = 0,
        guard_level = 0,
	}
	-- 获得最大属性列表
	for idx,val in ipairs(attributeFlag) do
		local list = {}
		list = {attr_value = maxAttrVal[idx],attr_type = val}
		table.insert(maxattrList,list)
	end
	-- 获得最小属性列表
	for idx,val in ipairs(attributeFlag) do
		local list = {}
		list = {attr_value = minAttrVal[idx],attr_type = val}
		table.insert(minattrList,list)
	end
	data.max_attr_list = maxattrList
	data.min_attr_list = minattrList
	return data
end

--{ {attr_value = minAttrVal[idx],attr_type = val} }
function AttrList(flags,values)
    local temp = {}
	for idx,val in ipairs(flags) do
		local list = {}
		list = {attr_value = values[idx],attr_type = val}
		table.insert(temp,list)
    end
    return temp
end

--获得锻造百分数值
function GetPersent(equip)
    local ForceNumList =
    {
        [1] = 2,
        [2] = 5,
        [3] = 10,
    }
    local persent = 0
	for _, pb_hole_2 in ipairs(equip.forgeds) do
		persent = persent + ForceNumList[pb_hole_2.val]
	end
	return persent
end

--洗练属性
--panel = CommonItemInfoPanel
function AddWashAttrBox(panel,equip)
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()

    if(not itemInfo)then
        return
    end

    local equip = equip or EquipModule.GetEquipById(itemInfo.id)
    if(not equip or not EquipModule.SimpleEquipData[equip.index])then
        return
    end
    equip = EquipModule.SimpleEquipData[equip.index]
    if(not equip.wash_attr_list or #equip.wash_attr_list<=0)then
        return
    end
    local attrBox = panel:AddAttrBox()
    local title = attrBox:AddTitle("洗练属性", "<color=#eb8b20>【%s】</color>")

    for i=1,#equip.wash_attr_list do
        local wash_attr = table.ifind(equip.wash_attr_list,function(arg) return arg.id == i end)
        local attr = wash_attr.attr_info
        local name =  GetNormalizeAttrName(attr.attr_type)
        local colorVal = EquipControl.GetWashAttrQualityColor(itemInfo.base_id,attr.attr_type,attr.attr_value)
        local format_name = "<color=#%s>%s</color> "
        local format_value = "<color=#%s>%s</color>"
        local value = nil
        if LuaConfig_attribute[attr.attr_type].show_type == 1 then
             value  = string.format(format_value, colorVal, (attr.attr_value / 100) .. "%" )
        else
             value  = string.format(format_value, colorVal, attr.attr_value)
        end
        --添加一条描述
         attrBox:AddDetail(
             string.format(format_name, colorVal, name),
             value
         ):SetCompareValue(attr.attr_value)--设置比较用的值
    end
end


--一个列出物品所有属性的盒子
--panel = CommonItemInfoPanel
function AddAttrsBox(panel,equip)
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()
    --判断
    if(itemInfo == nil)then
        return
    end
    if(itemInfo.id)then
        if(itemInfo.attr_list == nil or #itemInfo.attr_list <= 0)then
            local attr_list = itemInfo.min_attr_list
            --2019年3月8日18:40:18 zjw 策划说要显示非装备物品的属性 古海峰
            if(itemInfo.id and itemInfo.attr_list and #itemInfo.attr_list<=0)then
                attr_list = AttrList(ConfigUtils.GetAttributeFlag(itemInfo.base_id),ConfigUtils.GetItemAttributeValueMin(itemInfo.base_id))
            end

            if(#attr_list<=0)then
                return
            end
        end
    elseif(itemInfo.min_attr_list == nil or #itemInfo.min_attr_list <=0)then
        return
    end

    --添加一个属性盒子
    local attrBox = panel:AddAttrBox()
    local equip = equip or EquipModule.GetEquipById(itemInfo.id)
    local title
    --基础属性
    local AddBaseAttrFunc = function()
        --计算最大最小属性
        local bag_type = ConfigUtils.GetItemBagType(itemInfo.base_id)
        local maxAttr = ConfigUtils.GetItemAttributeValueMax(itemInfo.base_id)
        local minAttr = ConfigUtils.GetItemAttributeValueMin(itemInfo.base_id)
        local isRandom = true
        if(#maxAttr ~= #minAttr)then
            isRandom = false
            maxAttr = minAttr
        end
        --添加一条标题描述
        local attr_list = itemInfo.attr_list
        if(itemInfo.id == nil)then
            attr_list = itemInfo.min_attr_list
        end
        --2019年3月8日18:40:18 zjw 策划说要显示非装备物品的属性 古海峰
        if(itemInfo.id and itemInfo.attr_list and #itemInfo.attr_list<=0)then
            attr_list = AttrList(ConfigUtils.GetAttributeFlag(itemInfo.base_id),minAttr)
        end
        
        title = attrBox:AddTitle("基础属性", "<color=#eb8b20>【%s】</color>")
        for idx, attr in ipairs(attr_list) do
            --属性名字
            local name =  GetNormalizeAttrName(attr.attr_type)
            
            --数值的品质（颜色）
            -- local value = (attr.attr_value - minAttr[idx]) / (maxAttr[idx] - minAttr[idx])
            -- local colorVal = ColorOfAttrValueQuality(value)
            -- if(not colorVal)then
                --     colorVal = LuaConfig_attribute_quality[#LuaConfig_attribute_quality].color
            -- end
                
            --2019年4月8日17:34:29 zjw  策划说用白色就行 何颖欣
            local colorVal = "ffffff"
            local attr_value = attr.attr_value

            local format_name = "<color=#%s>%s</color> "
            
            local value = "0"
            --浮动属性
            if( minAttr[idx] and maxAttr[idx] and minAttr[idx] ~= maxAttr[idx])then
                local format_value = "<color=#%s>%s</color> <color=#B6B6B6>（%d - %d）</color>"

                if(itemInfo.id == nil)then  --背包中不存在的 不显示属性
                    attr_value = ""
                end
                value  = string.format(format_value, colorVal, attr_value, minAttr[idx], maxAttr[idx])
            else
                --非浮动
                format_value = "<color=#%s>%s</color>"
                value  = string.format(format_value, colorVal, attr_value)
            end
            
            --特殊处理
            --宝石 2019年3月8日18:40:18 zjw 策划说要显示非装备物品的属性 古海峰
            if(bag_type==4 or isRandom == false)then
                format_value = "<color=#%s>%s</color>"
                value  = string.format(format_value, colorVal, minAttr[idx])
            end

            --添加一条描述
            attrBox:AddDetail(
                string.format(format_name, colorVal, name),
                value
            ):SetCompareValue(attr.attr_value)--设置比较用的值
        end
    end
    --开光
    local AddOpeningAttrFunc = function()
        if (itemInfo == nil or itemInfo.opening_level == 0 or itemInfo.opening_level == nil or itemInfo.id == nil) then
            --print("物品没开光")
            return
        end
        local multiple = LuaConfig_light[itemInfo.opening_level].multiplier
        local multipleStr = (multiple - 1) * 100
        local addAttr = math.floor(itemInfo.attr_list[1].attr_value * (multiple-1))
        local detail = attrBox:AddCustomLayout()
        detail:AddText():SetFontSize(20):SetText(string.format("<color=#8484df>开光</color> <color=#dea941>装备基础属性+%s%%</color><color=#59ad6b>（%s</color>", multipleStr,itemInfo.opening_level)):SetPreferSize(ITEM_INFO_WIDTH)
		detail:AddImage():SetSpriteByPath("UI/Common/Sprite/STAR_P"):SetImageHeight(22):SetAnchor(1,0.5,false):SetPivot(0,0.5)
        detail:AddText():SetFontSize(20):SetText("<color=#59ad6b>）</color>"):SetAnchor(1,0.5,false):SetPivot(0,0.5):SetPreferSize(ITEM_INFO_WIDTH)
		detail:RefreshSize()
    end
   --强化
    local AddIntensifyAttrFunc = function()
        if(equip)then
            local level = equip.strengthen_level
            if level and level > 0 then
                local config = LuaConfig_equip_strengthen[level]
                local item_type = ConfigUtils.GetItemType(itemInfo.base_id)
                local attrval = config.attribute_value[item_type]
                local format = "<color=#f6e778>%s</color> <color=#59ad6b>（%s 级）</color>"
                attrBox:AddDetail("<color=#8484df>强化</color> ",string.format(format, attrval, level))
                panel:AddTitleText("<color=#dea941>".. "+" .. level .."</color>")
            end
        end
    end
    --专精
    local AddMastertyAttrFunc = function()
        if(equip)then
            local level = equip.mastery_lv
            if level and level > 0 then
                local config = LuaConfig_equip_mastery[level]
                local item_type = ConfigUtils.GetItemType(itemInfo.base_id)
                local attrval = config.attribute_value[item_type]
                local format = "<color=#f6e778>%s</color> <color=#59ad6b>（%s 级）</color>"
                attrBox:AddDetail("<color=#8484df>专精</color> ",string.format(format, attrval, level))
            end
        end
    end
    --锻造
    local AddForgedsAttrFunc = function()
        if(equip)then
            local forgeds = equip.forgeds
            if forgeds and #forgeds > 0 then
                local persent = GetPersent(equip)
                local attrval = math.floor(equip.info.attr_list[1].attr_value * (persent/100))
                -- local format = "<color=#f6e778>%s</color> <color=#59ad6b>（%d %%）</color>"
                -- attrBox:AddDetail("<color=#8484df>锻造</color> <color=#dea941>装备基础属性+%s%%</color>",string.format(format, attrval, persent))
                attrBox:AddDetail(string.format("<color=#8484df>锻造</color> <color=#dea941>装备基础属性+%s%%</color>",persent))
            end
        end
    end
    --传世
    -- local ExtantSetting = function()
    --     if (itemInfo == nil or  itemInfo.prefix == nil or itemInfo.prefix == false) then
    --         return
    --     end
    --     title:initAsLabel("基础属性（传世+20%）", "<color=#eb8b20>【%s】</color>")
    -- end

    --跟物品属性pb_item_ifo
    AddBaseAttrFunc()           --基础属性
    -- ExtantSetting()                 --传世
    AddOpeningAttrFunc()        --开光属性
    --跟装备槽属性pb_item_equip
    local item_type =  ConfigUtils.GetItemType(itemInfo.base_id)

    if(item_type>=1 and item_type <=10 and          --常规装备才有的属性
        equip and equip.info.id == itemInfo.id      --装备中才会显示这些（跟槽属性）
        and itemInfo.id                             --存在于背包的物品
    )then
        AddIntensifyAttrFunc()  --强化属性
        AddMastertyAttrFunc()   --专精属性
        AddForgedsAttrFunc()    --锻造属性
    end
    if(item_type>=31 and item_type <=35)then    --2018年9月28日14:53:42  zjw 护符的强化属性的通用显示
        ShowGuardEquipLevel(panel)
    end

    if (item_type == 38) then                   -- 2019.4.28 gqq 天罡装备强化等级
        if(itemInfo and itemInfo.highest_day_level and itemInfo.highest_day_level > 0)then
            -- panel:AddTitleText("<color=#dea941>".. "+" .. itemInfo.highest_day_level .."</color>")
            local format = "<color=#59ad6b>（%s 级）</color>"
            attrBox:AddDetail("<color=#8484df>强化</color> ",string.format(format, itemInfo.highest_day_level))
        end
    end
    return attrBox, panel
end


--护符的强化属性
function ShowGuardEquipLevel(panel)
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()
    if (itemInfo and  itemInfo.guard_level and itemInfo.guard_level >0) then
        local attrBox = panel:AddAttrBox()
        local percent = LuaConfig_talisman_equip[itemInfo.guard_level].attribute_percent

        local maxAttr = ConfigUtils.GetItemAttributeValueMax(itemInfo.base_id)
        local minAttr = ConfigUtils.GetItemAttributeValueMin(itemInfo.base_id)

        --添加一条标题描述
        attrBox:AddTitle(itemInfo.guard_level,"<color=#eb8b20>强化属性</color><color=#34c15b>（%s级）</color>")
        local attr_list = itemInfo.attr_list

        if(itemInfo.id == nil)then
            attr_list = itemInfo.max_attr_list
        end

        for idx, attr in ipairs(attr_list) do
            --属性名字
            local name =  GetNormalizeAttrName(attr.attr_type)

            --数值的品质（颜色）
            local value = (attr.attr_value - minAttr[idx]) / (maxAttr[idx] - minAttr[idx])
            local colorVal = ColorOfAttrValueQuality(value)

            local attr_value = math.floor(attr.attr_value * percent)
            if(itemInfo.id == nil)then  --背包中不存在的
                attr_value = ""
            end
            local format_name = "<color=#8484df>%s</color> "
            local format_value = "<color=#%s>%s</color> <color=#B6B6B6>（%d - %d）</color>"
            --添加一条描述
            attrBox:AddDetail(
                string.format(format_name, name),
                string.format(format_value, colorVal, attr_value,  math.floor(minAttr[idx]* percent),  math.floor(maxAttr[idx]* percent))
            ):SetCompareValue(attr.attr_value* percent)--设置比较用的值
        end
    end
    return attrBox,panel
end

--元神属性
function AddSpiritAttrBox(panel)
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end

    local itemInfo = panel:GetItemInfo()
    if (itemInfo == nil or itemInfo.attr_list == nil or #itemInfo.attr_list <= 0) then
        --print("物品无属性")
        return
    end

    local equip = EquipModule.GetEquipByBaseId(itemInfo.base_id)
    local item_type =  ConfigUtils.GetItemType(itemInfo.base_id)

    if(item_type>=1 and item_type <=10 and equip)then
        local item_type = ConfigUtils.GetItemType(equip.info.base_id)          -- 通过物品baseID取得装备部位id
        local simpleData = EquipModule.SimpleEquipData[item_type]

        local quality = ConfigUtils.GetItemQuality(equip.info.base_id)
        if simpleData.original_spirit_lv and simpleData.original_spirit_lv > 0 and quality>=4 then
            --添加一个属性盒子
            local attrBox = panel:AddAttrBox()
            --标题
            attrBox:AddTitle("元神属性","<color=#eb8b20>【%s】</color>")
            --数据
            local config = LuaConfig_original_spirit[simpleData.original_spirit_lv]
            local name = ConfigUtils.GetAttributeShow(config.attribute_flag[item_type])
            local value = config.attribute_value[item_type]
            if(quality>#ConfigUtils.quality2hexcolor)then
                quality = #ConfigUtils.quality2hexcolor
            end
            local addition = config.percent[quality-3]
            local format = "<color=#8484df>%s</color> <color=#f6e778>%s</color>"
            --固定基础属性加成
            attrBox:AddDetail("",string.format(format,name[1][2].."：",value))
            --百分比基础属性加成
            -- format = "<color=#34c15b>+%s%%</color>"
            -- attrBox:AddDetail("装备基础属性",string.format(format,addition*100))
            return attrBox, panel
        end
        return nil,panel
    end
    return nil, panel
end

--添加极品属性的盒子
function AddTopAttr(panel)
 if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()
    if(itemInfo.id == 0 or not itemInfo.id or not itemInfo.top_attr_list)then
        return nil,panel
    end
    if(#itemInfo.top_attr_list<=0)then
        return  nil,panel
    end
    --添加一个属性盒子
   local attrBox = panel:AddAttrBox()
   --标题
   attrBox:AddTitle("极品属性","<color=#eb8b20>【%s】</color>")
   for i, attr in ipairs(itemInfo.top_attr_list) do
        --属性名字
        local name =  GetNormalizeAttrName(attr.attr_type)
        local colorVal = EquipControl.GetBestAttrQualityColor(itemInfo.base_id,attr.attr_type,attr.attr_value)
        local format_name = "<color=#%s>%s</color> "
        local format_value = "<color=#%s>%s</color>"
        local value = nil
        if LuaConfig_attribute[attr.attr_type].show_type == 1 then
             value  = string.format(format_value, colorVal, (attr.attr_value / 100) .. "%" )
        else
             value  = string.format(format_value, colorVal, attr.attr_value)
        end

        --添加一条描述
         attrBox:AddDetail(
             string.format(format_name, colorVal, name),
             value
         ):SetCompareValue(attr.attr_value)--设置比较用的值
   end
    return attrBox, panel
end

--添加天罡极品属性的盒子
function AddHighestDayTopAttr(panel)
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()

    if(itemInfo.id == 0 or not itemInfo.id or not itemInfo.highest_day_attr_list)then
        return nil,panel
    end
    if(#itemInfo.highest_day_attr_list<=0)then
        return  nil,panel
    end
    --添加一个属性盒子
   local attrBox = panel:AddAttrBox()
   --标题
   attrBox:AddTitle("极品属性","<color=#eb8b20>【%s】</color>")
   for i, attr in ipairs(itemInfo.highest_day_attr_list) do
        --属性名字
        local name =  GetNormalizeAttrName(attr.attr_type)
        local colorVal = EquipControl.GetBestAttrQualityColor(itemInfo.base_id,attr.attr_type,attr.attr_value)
        local format_name = "<color=#%s>%s</color> "
        local format_value = "<color=#%s>%s</color>"
        local value = nil
        if LuaConfig_attribute[attr.attr_type].show_type == 1 then
             value  = string.format(format_value, colorVal, (attr.attr_value / 100) .. "%" )
        else
             value  = string.format(format_value, colorVal, attr.attr_value)
        end

        --添加一条描述
         attrBox:AddDetail(
             string.format(format_name, colorVal, name),
             value
         ):SetCompareValue(attr.attr_value)--设置比较用的值
   end
    return attrBox, panel
end

--可能获得极品属性的盒子
function AddHighestDayMayGainTopAttr(panel)
    if(panel == nil or not panel:CheckInit())then
           return nil,panel
       end
       local itemInfo = panel:GetItemInfo()
       if(not itemInfo.mayGain_top_attr_list or #itemInfo.mayGain_top_attr_list<=0)then
           return  nil,panel
       end
       --添加一个属性盒子
      local attrBox = panel:AddAttrBox()
      local star = HighestDayModule.GetItemStarByBaseID(itemInfo.base_id)
      --标题
      attrBox:AddTitle(string.format("随机获得以下极品属性%s条",star),"<color=#eb8b20>【%s】</color>")
      for i, attr in ipairs(itemInfo.mayGain_top_attr_list) do
           --属性名字
           local name =  GetNormalizeAttrName(attr.attr_type)
           local colorVal = B6B6B6
           local format_name = "<color=#%s>%s</color> "
           local format_value = "<color=#%s>%s</color>"
           local value  = string.format(format_value, "B6B6B6", attr.attr_value)
           --添加一条描述
            attrBox:AddDetail(
                string.format(format_name, "00ff00", name),
                value
            ):SetCompareValue(attr.attr_value)--设置比较用的值
      end
       return attrBox, panel
end

--可能获得极品属性的盒子
function AddMayGainTopAttr(panel)
    if(panel == nil or not panel:CheckInit())then
           return nil,panel
       end
       local itemInfo = panel:GetItemInfo()
       if(not itemInfo.mayGain_top_attr_list or #itemInfo.mayGain_top_attr_list<=0)then
           return  nil,panel
       end
       --添加一个属性盒子
      local attrBox = panel:AddAttrBox()
      --标题
      attrBox:AddTitle("随机获得以下极品属性","<color=#eb8b20>【%s】</color>")
      for i, attr in ipairs(itemInfo.mayGain_top_attr_list) do
           --属性名字
           local name =  GetNormalizeAttrName(attr.attr_type)
           local colorVal = B6B6B6
           local format_name = "<color=#%s>%s</color> "
           local format_value = "<color=#%s>%s</color>"
           local value  = string.format(format_value, "B6B6B6", attr.attr_value)
           --添加一条描述
            attrBox:AddDetail(
                string.format(format_name, "00ff00", name),
                value
            ):SetCompareValue(attr.attr_value)--设置比较用的值
      end
       return attrBox, panel
end

--天道属性盒子（只有圣装有）
function AddTianDaoAttr(panel)
    if(panel == nil or not panel:CheckInit())then
           return nil,panel
       end
       local itemInfo = panel:GetItemInfo()
       local base_id = itemInfo.base_id
       local config = LuaConfig_item[base_id]

       if(not config or #config.attribute_flag_3 <= 0)then
            return
       end
       --添加一个属性盒子
      local attrBox = panel:AddAttrBox()
      --标题
      attrBox:AddTitle("天道属性","<color=#eb8b20>【%s】</color>")
      for i, attr in ipairs(config.attribute_flag_3) do
            local attr_value = config.attribute_value_3[i]
           --属性名字
           local name =  GetNormalizeAttrName(attr)
           local colorVal = "ffffff"
           local format_name = "<color=#%s>%s</color> "
           local format_value = "<color=#%s>%s</color>"
           local value  = string.format(format_value, colorVal,attr_value)
           --添加一条描述
            attrBox:AddDetail(
                string.format(format_name, colorVal, name),
                value
            ):SetCompareValue(attr_value)--设置比较用的值
      end
       return attrBox, panel
end

--圣装属性
function AddHolyEquipAttr(panel)
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()
    local item_type = ConfigUtils.GetItemType(itemInfo.base_id)
    if(item_type<39 or item_type >49)then
        return  nil,panel
    end
    local motifId = HolyEquipModule.GetHolyEquipMotif(itemInfo.base_id)
 
    if(not motifId or  motifId ==  0 )then
        return  nil,panel
    end
    

    local config = LuaConfig_shengzhuang_name[motifId]


    -- 更高级主题的属性条件满足 要去高级主题属性进行加成
    local illumeSuitAttrNum = {}  --点亮套装属性件数
    for k= motifId,#LuaConfig_shengzhuang_name do 
       local suitCount = HolyEquipModule.HolyEquipDressMotifCount(k)
       for _,v in ipairs(LuaConfig_shengzhuang_name[k].suit_min) do 
            if suitCount >= v then
                if k == motifId then
                    table.insert(illumeSuitAttrNum,v)
                elseif k > motifId and table.containValue(illumeSuitAttrNum,v) then
                    table.remove(illumeSuitAttrNum,table.getKeyByValue(illumeSuitAttrNum,v))
                end
            else
               break
            end
       end
    end


    --添加一个属性盒子
    local attrBox = panel:AddAttrBox()
      --标题
    attrBox:AddTitle(string.format( "【%s套装】",config.suit_name))

    local data = HolyEquipModule.GetHolyEquipSuitAttrData(motifId)

    for k, v in ipairs(data) do
        --属性名字
        local colorVal = nil 
        if table.containValue(illumeSuitAttrNum,v.part_min) then
            colorVal = "00ff00"
        else
            colorVal = "cacbcb"
        end
        
        local valueStr = ""
        for index,flag in pairs(v.attribute_flag) do
             local flagStr=""
             local value = nil
             if table.containKey(LuaConfig_attribute,flag) then
                 flagStr = LuaConfig_attribute[flag].show
                 if LuaConfig_attribute[flag].show_type == 1 then
                    value  = (v.attribute_value[index] / 100) .. "%"
                else
                    value  = v.attribute_value[index]
                end
             end

             valueStr = valueStr.. string.format( "<color=#%s>%s+%s</color>\n",colorVal,flagStr,value)
        end

        --添加一条描述
        attrBox:AddDetail(
             string.format("【%s】",v.part_min.."件" ),
             valueStr,ITEM_INFO_WIDTH
         )
    end
    return attrBox, panel
end



--装备套装属性
function AddEquipSuitAttr(panel)
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()
    if( not itemInfo.id or itemInfo.id == 0 or not itemInfo.top_attr_list )then
        return  nil,panel
    end
    local item_type = ConfigUtils.GetItemType(itemInfo.base_id)
    if(item_type<1 or item_type >10)then
        return  nil,panel
    end
    local motifId = 0
    if itemInfo.suit_forge_level and itemInfo.suit_forge_level > 0 then
         motifId = itemInfo.suit_forge_level
    end
    if(motifId ==  0 )then
        return  nil,panel
    end
    local quality = ConfigUtils.GetItemQuality(itemInfo.base_id,"item")
    local level = ConfigUtils.GetItemLevel(itemInfo.base_id)
    local step = EquipControl.GetEquipStep(level)
    local star = #itemInfo.top_attr_list
    local suit_condition = LuaConfig_suit_condition[motifId]
    --不可打造
    if(step < suit_condition.level_min or star < suit_condition.star_min or quality < suit_condition.quality_min )then
     return  nil,panel
    end
	local suit_name = nil
	if LuaConfig_suit_part_type[item_type].type == 1 then
		suit_name = suit_condition.suit_name[table.getKeyByValue(suit_condition.level,step)]
	else
		suit_name = suit_condition.suit_name_2[table.getKeyByValue(suit_condition.level_2,step)]
    end
    -- 更高级主题的属性条件满足 要去高级主题属性进行加成
    local illumeSuitAttrNum = {}  --点亮套装属性件数
    for k= motifId,#LuaConfig_suit_condition do
       local suitCount = EquipModule.GetEquipSuitCount(item_type,k)
       for _,v in ipairs(LuaConfig_suit_part_type[item_type].suit_num) do
            if suitCount >= v then
                if k == motifId then
                    table.insert(illumeSuitAttrNum,v)
                elseif table.containValue(illumeSuitAttrNum,v) then
                    table.remove(illumeSuitAttrNum,table.getKeyByValue(illumeSuitAttrNum,v))
                end
            else
               break
            end
       end
    end

    --添加一个属性盒子
    local attrBox = panel:AddAttrBox()
      --标题
    attrBox:AddTitle(string.format( "【%s】%s (%s/%s)",suit_condition.name,suit_name,EquipModule.GetEquipSuitCount(item_type,motifId),EquipControl.GetEquipSuitTypeCount(item_type)))

    local data = EquipControl.GetEquipSuitAttrData(item_type,motifId)

    for k, v in ipairs(data) do
        --属性名字
        local colorVal = nil

        if table.containValue(illumeSuitAttrNum,v.equip_num) then
            colorVal = "00ff00"
        else
            colorVal = "cacbcb"
        end

        local valueStr = ""
        for index,flag in pairs(v.attribute_flag) do
             local flagStr=""
             local value = nil
             if table.containKey(LuaConfig_attribute,flag) then
                 flagStr = LuaConfig_attribute[flag].show
                 if LuaConfig_attribute[flag].show_type == 1 then
                    value  = (v.attribute_value[index] / 100) .. "%"
                else
                    value  = v.attribute_value[index]
                end
             end

             valueStr = valueStr.. string.format( " <color=#%s>%s+%s</color>\n",colorVal,flagStr,value)
        end

           --添加一条描述
        attrBox:AddDetail(
             string.format("【%s】",v.equip_num.."件" ),
             valueStr,ITEM_INFO_WIDTH
         )
    end
    return attrBox, panel
end


--添加宝石属性盒子
function AddGamAttrBox(panel)
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()

    if(itemInfo.id == 0 or not itemInfo.id)then
        return nil,panel
    end

    local equip = EquipModule.GetEquipByBaseId(itemInfo.base_id)

    if(equip)then
        if(equip.info.id ~= itemInfo.id)then
            return nil,panel
        end

        local isAllLock =  table.all(equip.holes,function(arg) return arg.state == 1 end)
        --当没一个槽开启时不添加盒子
        if(isAllLock)then
            return nil,panel
        end
         --添加一个属性盒子
        local attrBox = panel:AddAttrBox()
        --标题
        attrBox:AddTitle("宝石镶嵌","<color=#eb8b20>【%s】</color>")
        for i, hole in ipairs(equip.holes) do
            if hole.state == 0 then
                local customLayout =  attrBox:AddCustomLayout()
                if hole.item.base_id ~= 0 then
                    --非空槽
                    local name = ConfigUtils.GetItemName("item",hole.item.base_id)
                    local level = ConfigUtils.GetItemLevel(hole.item.base_id)
                    local sprite = customLayout:AddImage()

                    sprite:SetSpriteByPath("UI/Common/Sprite/BSS01_P")
                    sprite:SetNativeSize()

                    local text = customLayout:AddText()
                    local format = "<color=#8484df> %s</color> <color=#8484df>（%s 级）</color>"

                    text:SetText(string.format(format,name, level))
                    text:SetPreferSize(ITEM_INFO_WIDTH)
                else
                    --空槽
                    local sprite = customLayout:AddImage()

                    sprite:SetSpriteByPath("UI/Common/Sprite/BSS02_P")
                    sprite:SetNativeSize()

                    local text = customLayout:AddText()
                    local format = "<color=#59ad6b> %s</color>"

                    text:SetText(string.format(format,"未镶嵌"))
                    text:SetPreferSize(ITEM_INFO_WIDTH)
				end
                customLayout:RefreshSize()
			end
		end
    end
    return attrBox, panel
end

-- 装备前缀（命盘）
function AddPrefixBox(panel)
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()
    if (itemInfo == nil or itemInfo.destiny == nil or #itemInfo.destiny<=0) then
        return
    end
    local destiny = itemInfo.destiny
    --添加一个属性盒子
    local attrBox = panel:AddAttrBox()
    attrBox:AddTitle("命盘", "<color=#eb8b20>【%s】</color>")
    if destiny then
		for idx,prefix in ipairs(destiny) do
            local conf = LuaConfig_skill_high[prefix]
            if(conf)then
                local customLayout =  attrBox:AddCustomLayout()
                local text = customLayout:AddText()
                text:SetText(string.format("<color=#8484df>%s</color>",conf.life_describe))
                text:SetPreferSize(ITEM_INFO_WIDTH)
                customLayout:RefreshSize()
            end
		end
    end
    return attrBox, panel
end

--自动添加按钮
--是用自动添加有问题的话，可以在自己的模块里自定义（自动添加在判断上有点模糊）
function AddButtons(panel)
    if(panel == nil or not panel:CheckInit())then
        return false
    end
    local itemInfo = panel:GetItemInfo()
    if (itemInfo == nil) then
        return false
    end
    local view = UIManager.GetPanel(PanelName.CommonItemInfo)
    if(not view or view:GetActive()==false)then
        return false
    end

    local bag_type = itemInfo.bag_type
    local base_id = itemInfo.base_id
    local item_id = itemInfo.id --唯一id
    local item_type = ConfigUtils.GetItemType(itemInfo.base_id)
    local button_id = ConfigUtils.GetItemButtonId(itemInfo.base_id)
    local quality = ConfigUtils.GetItemQuality(itemInfo.base_id,"item")
    local gotoview = ConfigUtils.GetItemGoToView(itemInfo.base_id)
    local canDecompose = #LuaConfig_item[base_id].sale_flag>0
    local isShowGetBtn = LuaConfig_item[base_id].opuput_display == 1

    --炫耀
    local AddShowOff = function(func)
        --紫色品质才能炫耀
        if(quality>=3)then
            local onShowOff = function()
                view:Hide(true)
                if(func)then
                    func()
                end
                ChatController.SetShowOffInfo(itemInfo)
            end
            view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_SHOWOFF,onShowOff)
        end
    end

    --获取
    local AddGetWay = function()
        if(item_type == 0)then
            local onClick = function()
                data = ItemModule.GetItemByBaseId(base_id)
                if data then
                    GameUtils.ShowPropGetMall(data.base_id)
                else
                    GameUtils.ShowPropGetMall(item_id)
                end
                view:Hide(true)
            end
            view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_GETWAY,onClick)
        end
    end

    --背包里分解
    local AddDecompose = function()
        if(not canDecompose)then
            return
        end
        if item_type == 36 then
            local func = function()
                local panel = UIManager.ShowPanel(PanelName.NaturalHistoryCardPanel)
                if panel then
                    local viewId = ConfigUtils.GetItemViewId(base_id)
                    local config = LuaConfig_natural_card_info[viewId]
                    if not config then return end
                    local key = config.file_id * 100 + config.chapter_id
                    panel:SetInfo(key)
                    panel:OnClickBagBtn()
                end
            end
            view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_SALEUP,func)
        else
            local panel = UIManager.GetPanel(PanelName.BagView)
            if(panel and panel:GetActive() and item_id)then
                local onClick = function()
                    panel:GetSwitchDecompose()
                    DecomposeModule.AddItem(item_id)--数据同步
                    local DecomposePanel = panel:GetDecomposePanel()
                    local boxID = DecomposePanel:GetEmptyItemBoxID(item_id)
                    DecomposePanel:ShowDecItem(boxID,item_id)
                    if ItemModule.GetHightEquipItem(item_id) then
                        ItemModule.RemoveHightEquipItem(item_id)
                    end
                end
                view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_SALEUP,onClick)
            end
        end
    end

    if isShowGetBtn then
        AddGetWay()
    end

    --使用
    if(button_id == 1)then
        local onUseItem = function()
            if ConfigUtils.GetItemLevel(base_id) > HeroProp.Level then
                UITips.Add("等级不足，不可使用",UITips.Center)
                view:Hide(true)
            end

            local haveCount = ItemModule.GetItemCount(base_id)
            -- 如果使用物品的数量只有一个则直接使用
            if haveCount == 1 then
                ItemControl.ItemUseTips(item_id,1)
            elseif haveCount > 1 then
                local useType = ConfigUtils.GetItemBatchUse(base_id)
                if useType == 1 then
                    local panel = UIManager.ShowPanel(PanelName.ItemUse)
                    panel:SetItem(item_id)
                else
                    ItemControl.ItemUseTips(item_id,1)
                end
            end

            --打开使用界面的时候   关闭推荐使用页面
            EventManager.DispatchEvent(EventType.ItemEvent, "PropUse",item_id)
            view:Hide(true)
        end

        --经验丹使用限制
        local CheckIsExpPill = function(id)
            local useBuffId = 0
            for i,v in pairs(LuaConfig_buff) do ---读表获得某个经验丹的buffId
                if v.item_id == id then
                    useBuffId = i
                    break
                end
            end

            local buffList = GameUtils.GetMainPlayer().BuffManager.buffList --人物身上的buff列表

            if useBuffId and useBuffId > 0 then
                local isHadBuff = false
                local useBuffInfo = LuaConfig_buff[useBuffId] --使用经验丹获得的buff的信息
                for i,buff in ipairs(buffList) do
                    local buffInfo = LuaConfig_buff[buff.buff_id] --人物身上的buff的信息
                    if buffInfo.type == useBuffInfo.type then
                        if useBuffId > buff.buff_id then --提示“继续使用将会覆盖当前提升经验效果”
                            CommonMessage.ShowMessage("提示", "继续使用将会覆盖当前提升经验效果!", {"确认","取消"}, {onUseItem})
                        elseif useBuffId < buff.buff_id then   --提示“已有效果更佳的经验丹”
                            UITips.ShowMsg("已有效果更佳的经验丹")
                        else --同一种经验丹直接使用
                            onUseItem()
                        end
                        view:Hide(true)
                        isHadBuff = true
                        break
                    end
                end
                if not isHadBuff then onUseItem() end --如果当前没用使用过同类型的经验丹，直接使用
                return true
            end
            return false
        end

        local onClick = function()
            if not CheckIsExpPill(base_id) then --如果不是经验丹就直接使用
                onUseItem()
            end
        end

        view:AddButton():SetDataByBtnConfig(button_id,onClick)
        AddDecompose()
        return true
    end

    --前往--激活--破阵
    if button_id == 2 or button_id == 4 or button_id == 5 then
        local onClick = function()
            if  not ItemControl.CheckItemIsAbleBySex(itemInfo.base_id) then
                UITips.ShowMsg("性别不对，不能使用")
                return
            end

            if(not  FunctionManager.IsFunctionOpen(gotoview))then
                FunctionManager.ShowFunctionUnOpenMsg(gotoview)
                view:Hide(true)
                return
            end
		    -- 开服基金有一个开放时间段
		    if gotoview == "FoundationPanel" and not FoundationRewardModule.IsShow() then
		    	UITips.Add("活动已结束；敬请期待下次开放",UITips.Center)
		    	--view:Hide(true)
		    	return
		    end
		    -- 如果已经拥有家族则提示
		    if gotoview == "FamilyCreatePanel" and FamilyModule.HaveFamily then
		    	UITips.Add("已经拥有家族，不可创建",UITips.Center)
		    	return
		    end
		    --送花
		    if gotoview == "SendFlowers"  then
		    	FriendModule.infodata =nil
		    	UIManager.ShowPanel(PanelName.SendFlowersPanel)
		    	view:Hide(true)
		    	return
		    end
		    -- 转盘
		    if gotoview == "TurntablePanel"  then
		    	UIManager.ShowPanel(PanelName.Turntable):SetItemID(base_id)
		    	view:Hide(true)
		    	return
            end

            if gotoview == "BredeInfo" then
                if CloakModule.GetActiveCount() <= 0 then
                    UITips.Add("需要激活一件披风",UITips.Center)
                    view:Hide(true)
                    return
                end
            end

            if gotoview == "FamilyDonatePanel3" then
                if not FamilyModule.HaveFamily then
                    UIManager.ShowPanel(PanelName.FamilyListPanel)
                    view:Hide(true)
                    return
                end
            end
            if gotoview == "BossPersonalPanel" then
                UIManager.ShowPanel(PanelName.Boss)
                view:Hide(true)
                return
            end

            if UIManager.IsPanelShow(PanelName.BagView) then
                UIManager.HidePanel(PanelName.BagView)
            end
            local canOpen = FunctionManager.IsFunctionOpen(gotoview)
            if(canOpen)then
                local viewId = ConfigUtils.GetItemViewId(base_id)
                UIManager.ShowPanelByConfig(gotoview,viewId,true)
            else
			    FunctionManager.ShowFunctionUnOpenMsg(gotoview)
            end
            view:Hide(true)
        end
        view:AddButton():SetDataByBtnConfig(button_id,onClick)
        AddDecompose()
        return true
    end
    --穿戴(常规装备)
    if button_id == 3 and bag_type == 1  then
        local equip = EquipModule.GetEquipById(item_id)
        if(equip)then
            if(PowerWarController.toe)then
            --不能卸下
            view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_OUTLAY,function()
                --背包已满，不能卸下装备
                if BagModule.IsBagFull() then
                    UITips.Add("背包已满，请清理",UITips.Center)
                else
                    EquipProtocolBase.cs_equip_take_off(item_type)
                end
                view:Hide(true)
            end):SetSound(312)
            end
            AddShowOff(function()
                if UIManager.IsPanelShow(PanelName.BagView) then
                    UIManager.HidePanel(PanelName.BagView)
                else
                    UIManager.ClosePanel(PanelName.RoleAttributesPanel)
                end
            end)
        else
            local onPutOn = function()
                if ConfigUtils.GetItemLevel(base_id) > HeroProp.Level then
                    UITips.Add("没有达到装备穿戴等级",UITips.Center)
                    view:Hide(true)
                    return
                end

                if ItemModule.GetHightEquipItem(item_id) then
                    ItemModule.RemoveHightEquipItem(item_id)
                end
                EventManager.DispatchEvent(EventType.ItemEvent, "EquipPutOn", item_id)
                EquipProtocolBase.cs_equip_take_on(item_id)
                view:Hide(true)
            end
            view:AddButton():SetDataByBtnConfig(button_id,onPutOn)
            AddShowOff(function()
                if UIManager.IsPanelShow(PanelName.BagView) then
                    UIManager.HidePanel(PanelName.BagView)
                else
                    UIManager.ClosePanel(PanelName.RoleAttributesPanel)
                end
            end)
            AddDecompose()
        end
        return true
    end

    --合成
    if button_id == 6 then
        local onClick = function()
            local viewId = ConfigUtils.GetItemViewId(base_id)
            UIManager.ShowPanelByConfig(gotoview,viewId,true)
            view:Hide(true)
        end
        view:AddButton():SetDataByBtnConfig(button_id,onClick)
    end

    --有问题（低阶宝石可以堆叠，无法根据pb_item_info.id来判断你点的是槽中的还是仓库中的宝石）
    --对应界面单独处理 --这里只处理背包
    --宝石镶嵌
    if button_id == 7 then
        local onClick = function()
            -- EquipMainPanel = UIManager.ShowPanel(PanelName.Equip)
            -- if EquipMainPanel then
            --     EquipMainPanel:SetStonePanel()
            -- end
            UIManager.ShowPanelByConfig("StoneMainPanel",nil,true)
            view:Hide(true)
        end

        --镶嵌
        view:AddButton():SetDataByBtnConfig(button_id,onClick):SetSound(312)
        -- end
        AddGetWay()
        --宝石炫耀 sbc
        AddShowOff(function()
            if UIManager.IsPanelShow(PanelName.BagView) then
                UIManager.HidePanel(PanelName.BagView)
            else
                UIManager.ClosePanel(PanelName.RoleAttributesPanel)
            end
        end)
        -- AddShowOff(function() UIManager.ClosePanel(PanelName.Equip) end)
        return true
	end

    --骑具
    if(button_id == 3 and item_type>=21 and item_type<=24)then
        local equip = MountModule.GetEquipById(item_id)
        local slot = MountModule.GetSlot(item_type)
        if(equip)then
            -- AddShowOff(function() UIManager.ClosePanel(PanelName.Mount) end)

            local func = function() view:Hide(true) MountProtocolBase.cs_mount_equip_take_off(1,item_type) end
            --已强化过的装备无法卸下
            --已萃灵过的装备无法卸下
            if(slot and (slot.level > 0 or #slot.exp >0))then
                func = function() UITips.ShowMsg("已强化或淬灵过的装备无法卸下") end
            end
            view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_OUTLAY,func):SetSound(312)
        else
            local tohecheng = function()
                UIManager.ShowPanelByConfig("SynthesisQiChongEquipPanel")
            end
            --合成
            view:AddButton():SetDataByBtnConfig(6,tohecheng):SetSound(305)
            
            --这个装备不是装备中的装备 有分解按钮,穿戴,炫耀
            --穿戴
            local onPutOn = function()
                local same = MountModule.GetEquipByBaseId(base_id)
                if same then
                    UITips.Add("你已穿戴该装备",UITips.Center)
                    view:Hide(true)
                    return
                end
                MountProtocolBase.cs_mount_equip_take_on(1,item_id)
                view:Hide(true)
            end
            view:AddButton():SetDataByBtnConfig(button_id,onPutOn):SetSound(305)


            --策划说去掉 分解  和 炫耀
            -- AddShowOff(function() UIManager.ClosePanel(PanelName.Mount) end)
            -- --
            -- local onDecompose = function()
            --     view:Hide(true)
            --     SynthesisProtocolBase.cs_divide(item_id,0)
            -- end
            -- view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_SALEUP,onDecompose)
        end
        return true
    end

    --灵仆
    if(button_id == 3 and item_type>=25 and item_type<=28)then
        local equip = MechaModule.GetEquipById(item_id)
        local slot = MechaModule.GetSlot(item_type)
        if(equip)then
            -- AddShowOff(function() UIManager.ClosePanel(PanelName.Wing) end)

            local func = function() view:Hide(true) MountProtocolBase.cs_mount_equip_take_off(2,item_type) end
            --已强化过的装备无法卸下
            --已萃灵过的装备无法卸下
            if(slot and (slot.level > 0 or #slot.exp >0))then
                func = function() UITips.ShowMsg("已强化或淬灵过的装备无法卸下") end
            end
            view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_OUTLAY,func):SetSound(312)
        else
            local tohecheng = function()
                UIManager.ShowPanelByConfig("SynthesisQiChongEquipPanel")
            end
            --合成
            view:AddButton():SetDataByBtnConfig(6,tohecheng):SetSound(305)

            --这个装备不是装备中的装备 有分解按钮,穿戴,炫耀
            --穿戴
            local onPutOn = function()
                local same = MechaModule.GetEquipByBaseId(base_id)
                if same then
                    UITips.Add("你已穿戴该装备",UITips.Center)
                    view:Hide(true)
                    return
                end
                MountProtocolBase.cs_mount_equip_take_on(2,item_id)
                view:Hide(true)
            end
            view:AddButton():SetDataByBtnConfig(button_id,onPutOn):SetSound(305)



            --策划说去掉 分解  和 炫耀
            -- AddShowOff(function() UIManager.ClosePanel(PanelName.Wing) end)
            -- --
            -- local onDecompose = function()
            --     view:Hide(true)
            --     SynthesisProtocolBase.cs_divide(item_id,0)
            -- end
            -- view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_SALEUP,onDecompose)
        end
        return true
    end

    --护符
    if(button_id == 3 and item_type>=31 and item_type<=35)then
        local equip = GuardModule.GetGuardEquipByID(itemInfo.id)
        if(equip)then
            local func = function()
                if not GuardModule.CkeckEquipIsCanPutOn(base_id) then
                    UITips.Add("该装备不适合当前护主",UITips.Center)
                    return
                end

                if equip.guard_level > itemInfo.guard_level then
                    local consume = LuaConfig_gameplay_times[804].cost_value[1]
                    local str = "当前替换装备的强化等级比穿戴装备低，是否消耗<color=#00FF47FF>%d元宝</color>转移强化等级？"
                    str = string.format(str,consume)
                    local fun = function()
                        if CommonCtor.JudgeCurrencyIsEnough(1, consume) then
                            GuardProtocolBase.cs_guard_equip_on(GuardModule.CurSelectID,item_id,1)
                        end
                    end

                    local fun1 = function()
                        GuardProtocolBase.cs_guard_equip_on(GuardModule.CurSelectID,item_id,0)
                    end
                    CommonMessage.ShowMessage("提示", str, {"确定","取消"}, {fun,fun1})
                else
                    GuardProtocolBase.cs_guard_equip_on(GuardModule.CurSelectID,item_id,0)
                end
            end
            view:AddButton():SetData("替换",func,"87280B","UI/Common_W6/Sprite/ty_anniux02_xz")

            local onDecompose = function()
                view:Hide(true)
                SynthesisProtocolBase.cs_divide(item_id,0)
            end
            view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_SALEUP,onDecompose)

            AddShowOff(function() UIManager.ClosePanel(PanelName.GuardPanel) end)
        else
            local index = GuardModule.IsInEquipBar(item_id)
            if index then
                --卸下
                view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_OUTLAY,function() view:Hide(true) GuardProtocolBase.cs_guard_equip_off(GuardModule.CurSelectID,index) end):SetSound(312)
                AddShowOff(function() UIManager.ClosePanel(PanelName.GuardPanel) end)
            else
                --这个装备不是装备中的装备 有分解按钮,穿戴,炫耀
                --穿戴
                local onPutOn = function()
                    if not GuardModule.CkeckEquipIsCanPutOn(base_id) then
                        UITips.Add("改装备不适合当前护主",UITips.Center)
                        return
                    end

                    if GuardModule.GetActivedGuard(GuardModule.CurSelectID) then
                        GuardProtocolBase.cs_guard_equip_on(GuardModule.CurSelectID,item_id,0)
                    else
                        UITips.Add("请先激活该护主",UITips.Center)
                    end
                    view:Hide(true)
                end
                view:AddButton():SetDataByBtnConfig(button_id,onPutOn):SetSound(305)
                --
                local onDecompose = function()
                    view:Hide(true)
                    SynthesisProtocolBase.cs_divide(item_id,0)
                end
                view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_SALEUP,onDecompose)
                --
                AddShowOff(function() UIManager.ClosePanel(PanelName.GuardPanel) end)
            end
        end
        return true
    end
     --天罡
    if(button_id == 3 and item_type==38)then
        local equip = HighestDayModule.GetEquipDataByItemID(item_id)
        if(equip)then
            AddShowOff(function() UIManager.ClosePanel(PanelName.ShanHaiJingMain) UIManager.ClosePanel(PanelName.HighestBagPanel) end)
            --卸下
            view:AddButton():SetDataByFuncBtnType(CommonItemInfoButton.FUNCBTN_OUTLAY,function()
                    view:Hide(true)
                    Highest_dayProtocolBase.cs_highest_day_equip_off(HighestDayModule.Chose_HighestDay_Index,item_id)
                end):SetSound(312)
        else
            --这个装备不是装备中的装备 有分解按钮,穿戴,炫耀
            --穿戴
            local onPutOn = function()
                if not HighestDayModule.CheckQualityMeetByBaseID(base_id) then
                    UITips.Add("该装备不满足槽位品质需求",UITips.Center)
                    return
                end
                Highest_dayProtocolBase.cs_highest_day_equip_on(HighestDayModule.Chose_HighestDay_Index,item_id)

                view:Hide(true)
            end
            view:AddButton():SetDataByBtnConfig(button_id,onPutOn):SetSound(305)
            -- 炫耀
            AddShowOff(function() UIManager.ClosePanel(PanelName.ShanHaiJingMain) UIManager.ClosePanel(PanelName.HighestBagPanel) end)
        end
        return true
    end

    return false
end


--道具描述
function AddDescBox(panel)
    --过滤列表
    --策划要求 装备和宝石类型物品不显示描述
    local filter = {
        1,4
    }
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()
    local detail,attrBox
    if(itemInfo)then
        local desc = LuaConfig_item[itemInfo.base_id].desc
        if(#desc<=0 or table.iany(filter,function(arg) return arg == itemInfo.bag_type end))then
            return nil,panel
        end
        attrBox = panel:AddAttrBox()
        attrBox:AddTitle("道具说明", "<color=#eb8b20>【%s】</color>")
        detail,attrBox = attrBox:AddDetail("","<color=#8484df>"..desc.."</color>",ITEM_INFO_WIDTH)
    end
    return attrBox, panel
end

--获取途径
function AddGetWayDesc(panel)
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()
    local detail,attrBox
    if(itemInfo)then
        local getDesc = ConfigUtils.GetItemGetDesc(itemid)
        if getDesc and getDesc ~= "0" and getDesc ~= "" then
            attrBox = panel:AddAttrBox()
            attrBox:AddTitle("获得途径", "<color=#eb8b20>【%s】</color>")
            detail,attrBox = attrBox:AddDetail("","<color=#8484df>"..getDesc.."</color>",ITEM_INFO_WIDTH)
        end
    end
    return attrBox, panel
end

--显示物品时效
function AddTimeLimitBox(panel)
    if(panel == nil or not panel:CheckInit())then
        return nil,panel
    end
    local itemInfo = panel:GetItemInfo()
    local detail,attrBox
    if(itemInfo and itemInfo.id and itemInfo.deadline and itemInfo.deadline>0)then
        local deadline = itemInfo.deadline
        attrBox = panel:AddAttrBox()
        attrBox:AddTitle("到期时间", "<color=#eb8b20>【%s】</color>")
        local content = os.date("%Y-%m-%d %H:%M:%S",deadline)
        detail,attrBox = attrBox:AddDetail("","<color=#e21313>"..content.."</color>",ITEM_INFO_WIDTH)
    end
    return attrBox, panel
end

--获取标准化的属性名字
function GetNormalizeAttrName(attrType)
    if not LuaConfig_attribute[attrType] then
        print("LuaConfig_attribute 没有这个属性类型",attrType)
        return ""
    end
    local name = LuaConfig_attribute[attrType].show
        if(name)then
            name = string.gsub(name," ","")
            name = string.gsub(name,"基础","")
        else
            name = attrType
        end
    return name
end

--获取正确的值（显示用）
function GetNormalizeValue(flag,value)
    --转化百分值
    if(string.find(flag,"pct"))then
        return ( value / 10000) .. "%"
    end
    return value
end


--获取属性值的品质颜色
function ColorOfAttrValueQuality(value)
    local colorVal
    for i,config in ipairs(LuaConfig_attribute_quality)do
        if(config.value >= value)then
            colorVal = config.color
            break
        end
    end
    return colorVal
end


--两个属性盒子作比较
--比较结果会在box_1中显示
--box_1 = DynamicAttrBox  --只针对其中的DynamicDetail
--both 比较结果也会再box_2中显示
function CompareAttrBox(box_1,box_2,both)
    local _liveQueue_1 = box_1:GetDetails()
    local _liveQueue_2 = box_2:GetDetails()
    if(_liveQueue_1==nil or _liveQueue_2==nil)then
        --print("一方不存在显示中的描述")
        return
    end
    if(#_liveQueue_1~=#_liveQueue_2)then
        --print("两个属性盒子的描述数目不一致无法作比较！")
        return
    end
    if(#_liveQueue_1 == 0 or #_liveQueue_2==0)then
        --print("两个属性盒子的描述数目不一致无法作比较！")
        return
    end
    for i,detail in ipairs(_liveQueue_1)do
        detail:DoCompareByDetail(_liveQueue_2[i])
    end
    if(both)then
        for i,detail in ipairs(_liveQueue_2)do
            detail:DoCompareByDetail(_liveQueue_1[i])
        end
    end
end

