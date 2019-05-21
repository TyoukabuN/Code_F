--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 张嘉文
--创始日期  : 2018年7月13日17:46:19
--功能描述  : 通用物品信息面板
--------------------------------------------------------
require "Manager/Base/UIView"
CommonItemInfoPanel = class("CommonItemInfoPanel", UIView)

local prefabPath = "Windows/CommonItemInfo/CommonItemInfoPanel"
local this = CommonItemInfoPanel

function this:ctor(go, ...)
    go = go or CommonUtils.InstantiateLocalPerfab(prefabPath)
    this.super.ctor(self, go, ...)
end

function this:Init(...)
    self._text_itemName = self:GetText(0)
    self._commonItenIcon = self:GetObject(1)
    self._text_level_label = self:GetText(2)
    self._text_level_value = self:GetText(3)
    self._text_part_label = self:GetText(4)
    self._text_part_value = self:GetText(5)
    self._text_sellEnabled = self:GetText(6)
    self._sprite_wear = self:GetSprite(7)
    self._sprite_frame = self:GetSprite(8)
    self._layout_box = self:GetObject(9)
    self._layout = self._layout_box:GetComponent("VerticalLayoutGroup")
    self._fitter = self._layout_box:GetComponent(typeof(ContentSizeFitter))
    self._sprite_itemBg = self:GetSprite(10)
    self._sprite_frame_cj = self:GetSprite(11)
    self._text_level_value:SetActive(false)
    self._text_part_value:SetActive(false)

    --2019年4月13日11:23:52 zjw 加个滑动功能
    self.layoutElement =self._gameObject:GetComponent("LayoutElement")
    self.layout_attrboxs = self:GetLayout(12)  --属性独立出来
    self.layout_attr = self:GetLayout(13)
    self.scrollRect = self:GetObject(14)

    --盒子池
    local onConstruct = function()
        return DynamicAttrBox.New()
    end
    local onEnable = function(obj)
        obj:SetActive(true)
        self.layout_attr:AddChild(obj,2)
        obj:SetAsLastSibling()
        self:BoxLineSet()
    end
    local onDisable = function(obj)
        obj:SetActive(false)
        obj:Clear()
    end
    self._objPool_box = SimpleObjectPool.New(onConstruct, onEnable, onDisable)
    --
    self:Clear()

    self._default_label_level = "等级："
    self._default_label_part = "部位："
end

--重新计算rect.size
function this:CalculateLayoutInput()
    table.iaction(self._objPool_box:GetLives(),function(arg) arg:CalculateLayoutInput() end)

    self.layout_attr:CalculateLayoutInput()
    self.layout_attrboxs:CalculateLayoutInput()
    self._layout:CalculateLayoutInputHorizontal()
    self._layout:CalculateLayoutInputVertical()
    self._fitter:SetLayoutHorizontal()
    self._fitter:SetLayoutVertical()
end

function this:Show()
    -- self:Clear()
end

--清理生池
function this:Clear()
    self._hadInit = false
    self._objPool_box:Clear()
    return self
end
 --

--[[
    @desc: 设置数据（初始化）
    author:{zjw}
    time:2018-07-16 15:00:20
    --@data:    数据
	--@itemInfoGetter:  获取pb_item_info的方法 默认自己是pb_item_info格式
	--@levelContentGetter:  获取标题内容的方法 （等级,阶数,）   默认等级
	--@partContentGetter:   获取部位内容的方法 （部位,x阶宝石） 默认部位
    @return:
]] function this:SetData(data,itemInfoGetter,levelContentGetter,partContentGetter)
    self._hadInit = true --是否初始化完成
    self._data = data
    self._itemInfoGetter = itemInfoGetter or function(arg) return arg end
    --标题内容的方法
    self._levelContentGetter = levelContentGetter
    --部位内容的方法
    self._partContentGetter = partContentGetter

    --self._levelLabel = levelLabel or self._default_label_level
    self:RefreshPanel()
    return self
end

--检查是否初始化
function this:CheckInit()
    if (not self._hadInit) then
        print("没有执行过面板的SetData方法！（<color=#yellow>未初始化</color>）")
        return false
    end
    return true
end

--获取原始数据
function this:GetData()
    if (self:CheckInit()) then
        return self._data
    end
end

--获取物品信息获取器
function this:GetItemInfoGetter()
    if (self:CheckInit()) then
        return self._itemInfoGetter
    end
end

--获取物品信息
--pb_item_info
function this:GetItemInfo()
    if (self:CheckInit()) then
        return self._itemInfoGetter(self._data)
    end
end

--获取原始数据
function this:GetOriginData()
     return self._data
end

--设置穿戴中
function this:SetWear(enabled)
    self._sprite_wear:SetActive(enabled)
    return self
end

--等级标题 （品阶）
function this:SetLevelLabel(level)
    level = level or ConfigUtils.GetItemLevel(self:GetItemInfo().base_id)
    if(not self._levelContentGetter)then
        local bag_type = self:GetItemInfo().bag_type
        self._levelContentGetter = function(arg) return "等级：" .. tostring(arg) end
        if(bag_type == 11 or bag_type == 12 or bag_type == 13)then
            self._levelContentGetter = function(arg) return "阶数：" .. tostring(arg) end
        end
    end
    self._text_level_label:SetText(self._levelContentGetter(level))
    self._text_level_label:SetPreferSize(200)
    return self
end

--部位文本
function this:SetPartLabel()
    if(not self._partContentGetter)then
        local bag_type = self:GetItemInfo().bag_type
        self._partContentGetter = function()
                local content = ConfigUtils.GetItemPositionText(self:GetItemInfo().base_id)
                if(content)then
                    return "部位：" .. content
                end
                return nil
            end
        if(bag_type == 4)then
            self._partContentGetter = function()
                local content = LuaConfig_item[self:GetItemInfo().base_id].desc
                return content
            end
        end
    end

    local postext = self._partContentGetter()
    self._text_part_label:SetActive(postext ~= nil)
    if(postext)then
        self._text_part_label:SetText(postext)
    end
end

--刷新面板 设置一些物品的基本属性
function this:RefreshPanel()
    local itemInfo = self._itemInfoGetter(self._data)
    local itemType = "item"
    local base_id = itemInfo.base_id
    --数据
    local name = ConfigUtils.GetItemName(itemType, base_id)
    local quality = ConfigUtils.GetItemQuality(base_id, itemType)
    local level = ConfigUtils.GetItemLevel(base_id)
    local business = ConfigUtils.GetItemBusiness(base_id)
    --log @@local switch : OvercomeModule.debugSwitch
    printc(name,base_id)
    --图标
    if (self._itemIcon == nil) then
        self._itemIcon = ItemIcon.New(itemType, base_id, self._commonItenIcon)
        self._itemIcon.button:SetClickDownCB(self, function()end)
	    self._itemIcon.button:SetClickUpCB(self,function()end)
	    self._itemIcon.button:SetClickCB(self,function()end)
    end
    self._itemIcon:SetIcon(itemType, base_id)
    self._itemIcon:SetCount(0)
    self._itemIcon:SetAngle()
    self._itemIcon:SetShard()
    self._itemIcon:SetActive(true)
    self._itemIcon:SetDeadlineIcon()
    self._itemIcon:SetStarLv(itemInfo)

    --名称
    self:SetName()
    --等级
    self:SetLevelLabel(level)
    --部位
    self:SetPartLabel()
    --交易可能
    --itemInfo.bind_type == 0 绑定 1不绑定
    --business = 0 不可交易 1 可以
    if itemInfo.bind_type == 1 and business == 1 then 
        self._text_sellEnabled:SetText("<color=#59ad6b>可交易</color>")
    else
        self._text_sellEnabled:SetText("<color=#e65131>不可交易</color>")
    end
    --有些策划认为 0 是绿色品质
    if(quality == 0)then
        quality = 1
    end
    self._sprite_itemBg:SetSpriteByPath(string.format("UI/Common_W6/Sprite/PJDS0%s_P",quality))
    --品质
    -- self._sprite_frame:SetItemQualityColor(quality)
    self._sprite_frame:SetActive(false)--quality>5
    --不要了
    self._sprite_frame_cj:SetActive(false)--quality>5
    return self
end

--关于物品名字的设置（就是前缀什么的）
function this:SetName()
    local itemInfo = self:GetItemInfo()

    local name =  EquipControl.GetEquipName(itemInfo.base_id)
    local quality = ConfigUtils.GetItemQuality(itemInfo.base_id, "item")
    self._text_itemName:SetText(name)

    if (itemInfo == nil) then
        --print("物品无前缀")
        return
    end

    local equip = EquipModule.GetEquipByBaseId(itemInfo.base_id)
    if (equip and itemInfo.id == equip.info.id) then
        --2019年4月19日15:17:13 zjw 策划说去掉元神
        -- if equip.original_spirit_lv and equip.original_spirit_lv > 0 and quality >= 4 then
        --     local origin = self._text_itemName._text.text
        --     self._text_itemName:SetText("元神" .. "·" .. origin)
        -- end
    end

    --传世
    -- if(itemInfo.id and ConfigUtils.IsEquip(itemInfo.base_id) and itemInfo.prefix==true)then
    --     local origin = self._text_itemName._text.text
    --     self._text_itemName:SetText("传世" .. "·" .. origin)
    -- end

    self._text_itemName:SetItemQuality(quality)
end

--限制面板的长度
--超过长度使用滑动
function this:SizeCheck()
    self:CalculateLayoutInput()

    self.scrollRect:SetActive(false)

    if(self._transform.rect.size.y > self.view:GetScreenSize().y * 0.7)then
        self.layoutElement.preferredHeight = self.view:GetScreenSize().y * 0.7
        self.layoutElement.minHeight = self.view:GetScreenSize().y * 0.7
        self.scrollRect:SetActive(true)
        self.layout_attr:SetAnchoredPosition(nil,0)
    end
end

--增加标题内容
function this:AddTitleText(text,ispre)
    local origin = self._text_itemName._text.text
    if(ispre)then
        self._text_itemName:SetText(text .. origin)
        return
    end
    self._text_itemName:SetText(origin .. text)
end

--添加一个属性盒子
function this:AddAttrBox()
    local attrBox = self._objPool_box:Add()

    return attrBox, self
end

--box分割线的显示
function this:BoxLineSet()
    if (self._objPool_box._liveQueue and #self._objPool_box._liveQueue > 0) then
        for i = 1, #self._objPool_box._liveQueue do
            local box = self._objPool_box._liveQueue[i]
            box:SetLineEnabled(i ~= #self._objPool_box._liveQueue)
        end
    end
end

--
function this:GetBoxs()
    return self._objPool_box._liveQueue
end
