--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 张嘉文
--创始日期  : 2018年7月13日16:00:20
--功能描述  : 动态说明（标题加数值）(一个有两个text的DynamicCustomLayout)
--------------------------------------------------------

DynamicDetails = class("DynamicDetails",DynamicCustomLayout)

local prefabPath = "Windows/CommonItemInfo/DynamicDetails"
local this = DynamicDetails

function this:ctor(go,...)
    self._defaultWidth_itemInfo = 286-10
    --fitter = self:GetComponent(typeof(ContentSizeFitter),"Label")
    --go = go or CommonUtils.InstantiateLocalPerfab(prefabPath)
    --self._UISlots = go:GetComponent("UISlots")
    this.super.ctor(self,go,...)
    self:GetText(1):SetActive(false)
    self._rectTrans = self:GetObject(0):GetComponent("RectTransform")
    self._text_label = self:AddText()--self:GetText(1)
    self._labelTrans = self._text_label._transform--self:GetObject(1):GetComponent("RectTransform")
    self._text_content = self:AddText()--self:GetText(2)
    self._contentTrans = self._text_content._transform--self:GetObject(2):GetComponent("RectTransform")
    self._sprite_compare = self:AddImage()
    self._text_compare = self:AddText()
    self._text_compare:SetHorizontalWrapMode(HorizontalWrapMode.Overflow)
    self._sprite_compare:SetSpriteByPath("UI/Common_W6/Sprite/JT05")
    self._sprite_compare:SetNativeSize()
end

--设置字体大小
function this:SetFontSize(val)
    if(self.fontSize == val)then
        return self
    end
    self.fontSize = val
    self._text_label:SetFontSize(val)
    self._text_content:SetFontSize(val)
    self._text_compare:SetFontSize(val)
    return self
end

--初始化
--width = label.width + content.width 如果 label.width + content.width > width , content自动换行(通过增加content.height来实现)
function this:init(label,content,width)
    self._sprite_compare:SetActive(false)
    self._text_compare:SetActive(false)
    self._asLabel = false
    self._label = label
    self._content = content
    self._width = width
    --获取比较用值
    if(type(content)=="number")then
        self._value = content
    end
    --
	self._text_label:SetText(label)
    self._text_content:SetText(content)
    self:CountSizeDeltas()
    return self
end

--手动调整父节点的sizeDelta(为了一帧通过LayoutGroup的排序)
function this:CountSizeDeltas()
    local width = self._width
    self._text_label:SetSizeDelta(self._text_label:GetPreferredWidth(),0)
    self._text_label:SetText(self._label)
    self._text_label:SetSizeDelta(self._text_label:GetPreferredWidth(),self._text_label:GetPreferredHeight())
    --self._text_label:SetPreferSize()--._transform.sizeDelta = Vector2.New(self._text_label:GetPreferredWidth(),0)
    if(width)then
        self._text_content:SetHorizontalWrapMode(HorizontalWrapMode.Wrap)
        self._text_content:SetSizeDelta(width - self._text_label:GetPreferredWidth(),0)
        self._text_content:SetText(self._content)
        self._text_content:SetSizeDelta(width - self._text_label:GetPreferredWidth(),self._text_content:GetPreferredHeight())
    else
        self._text_content:SetHorizontalWrapMode(HorizontalWrapMode.Overflow)
        self._text_content:SetSizeDelta(self._text_content:GetPreferredWidth(),0)
        self._text_content:SetSizeDelta(self._text_content:GetPreferredWidth(),self._text_content:GetPreferredHeight())
    end
    --self:SetSizeDelta(self._text_label:GetPreferredWidth(),self._text_content:GetPreferredHeight())
    self:RefreshSize()
    return self
end

--设置这个Detail的大小
function this:SetSizeDelta(x,y,isAdd)
    if(isAdd)then
        x = self._rectTrans.sizeDelta.x + x
        y = self._rectTrans.sizeDelta.y + y
    end
    self._rectTrans.sizeDelta = Vector2.New(x,y)
end

--作为单个标题初始化（即content=""）
function this:initAsLabel(label,format)
    local orginLabel = label
    if(format)then
        label = string.format(format,label)
    end
    self:init(label,"")
    self._asLabel = true
    self._label = orginLabel
    return self
end

--@string获取相关的
function this:GetLabel()
    return self._label
end
function this:GetContent()
    return self._content
end
--@

--@获取UI对象相关--
function this:GetLabelText()
    return self._text_label
end
function this:GetContentText()
    return self._text_content
end
--获取比较值的UIText对象
function this:GetCompareText()
    return self._text_compare
end
--@

--@比较相关--
--设置比较用值
function this:SetCompareValue(value)
    self._value = value
    return self
end

--获取比较用值
function this:GetCompareValue(value)
    return self._value
end

--用detail比较
function this:DoCompareByDetail(Detail)
    if(self._asLabel or Detail._asLabel)then
        print("无法对纯标题作比较")
        return self
    end
    if(self:GetLabel()~=Detail:GetLabel())then
        print("描述的内容不一致无法比较")
        return self
    end
    self:DoCompare(Detail:GetCompareValue())
    return self
end


--用值比较
function this:DoCompare(value)
    if(type(value) == "string")then
        print("描述为字符串无法作比较！")
        return self
    end

    if(self._value== nil)then
        print("没有可以用作比较的值！")
        return self
    end

    local ownValue = self._value
    if ownValue > value then
        self._text_compare:SetText(string.format("<color=#59AD6B>%d</color>",(ownValue - value)))
    elseif ownValue < value then
        self._text_compare:SetText(string.format("<color=#F80000>%d</color>",(value - ownValue)))
    end

    self:CompareSpriteSwitch(ownValue~=value)
    self:SetCompareSprite(ownValue > value)

    if(ownValue == value)then
        self:CompareSpriteSwitch(false)
    end

    return self
end

--比较图标开关
function this:CompareSpriteSwitch(enabled,imageEnable)
    if(imageEnable==nil)then
        imageEnable = enabled
    end
    self._sprite_compare:SetActive(enabled)
    self._text_compare:SetActive(enabled)
    self._sprite_compare:GetImage().enabled = imageEnable
    return self
end

--比较用的升降图标
function this:SetCompareSprite(isBigThanElse)
    self:CompareSpriteSwitch(true)
    if(isBigThanElse)then
        self._sprite_compare:SetSpriteByPath("UI/Common/Sprite/JT_P02")--UI/Common_W6/Sprite/JT05
        self._sprite_compare:SetNativeSize()
        return
    end
    self._sprite_compare:SetSpriteByPath("UI/Common/Sprite/JT_P03")
    self._sprite_compare:SetNativeSize()
    return self
end
--@




--一个有mask动画的detail
DynanicMaskDetail =  class("DynanicMaskDetail",DynamicDetails)
function DynanicMaskDetail:ctor(go,...)
    DynanicMaskDetail.super.ctor(self,go,...)
    self._gameObject:AddComponent(typeof(UnityEngine.UI.Mask)).showMaskGraphic = false
    local image = self._gameObject:AddComponent(typeof(UnityEngine.UI.Image))
    image.type = Image.Type.Filled
    image.fillMethod = Image.FillMethod.Vertical
    image.fillOrigin = 1
    self._image_mask = image
    self._sprite_mask = UISprite.New(self._gameObject)
    self._sprite_mask:SetSpriteByPath("UI/SkillPanel/Sprite/Panel_K_P")
end

function DynanicMaskDetail:DoMaskAnim(startVal,endVal,complete)
    complete = complete or function()end
    if(self._tweener_mask)then
        self._tweener_mask:Kill(true)
        self._tweener_mask = nil
    end
    self:SetMaskFillAmount(startVal)
    self._tweener_mask = DoTweenToLua.SimpleDigitalChange(
        startVal,
        endVal,
        0.3,
        function(val)
            self:SetMaskFillAmount(val/100)
        end
    ):OnComplete(function() self:SetMaskFillAmount(endVal/100)  complete() end)
    return self._tweener_mask
end

function DynanicMaskDetail:SetMaskFillAmount(val)
    self._image_mask.fillAmount = val
end

function DynanicMaskDetail:Dispose()
    if(self._tweener_mask)then
        self._tweener_mask:Kill(true)
        self._tweener_mask = nil
    end
end