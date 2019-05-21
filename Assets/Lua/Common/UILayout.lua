--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 张嘉文
--创始日期  : 2018年11月14日15:58:40
--功能描述  :lua uilayout
--------------------------------------------------------
UILayout = class("UILayout",UIBase)
local this = UILayout

function this:ctor(go,...)
	self._gameObject = go
    self._transform = go.transform
    self._isHorizontal = false
    self:Init(...)
end

function this:Init()
    self.layout = self._gameObject:GetComponent("VerticalLayoutGroup")
    self._isHorizontal = false
    if(not self.layout)then
        self._isHorizontal = true
        self.layout = self._gameObject:GetComponent("HorizontalLayoutGroup")
    end
    if(not self.layout)then
        self.layout = self._gameObject:GetComponent("GridLayoutGroup")
    end

    self.fitter = self._gameObject:GetComponent(typeof(ContentSizeFitter))

    self.transform = self._transform
    self.gameObject = self._gameObject

    self.sub = {}
end

function this:CalculateLayoutInput()
    table.iaction(self.sub,function(arg) arg:CalculateLayoutInput() end)

    if(self.layout)then
        self.layout:CalculateLayoutInputHorizontal()
        self.layout:CalculateLayoutInputVertical()
    end

    if(self.fitter)then
        self.fitter:SetLayoutHorizontal()
        self.fitter:SetLayoutVertical()
    end
end

-- public enum TextAnchor
--- {
---     UpperLeft = 0,
---     UpperCenter = 1,
---     UpperRight = 2,
---     MiddleLeft = 3,
---     MiddleCenter = 4,
---     MiddleRight = 5,
---     LowerLeft = 6,
---     LowerCenter = 7,
---     LowerRight = 8
--- }
---设置item的对齐方式
function this:SetChildAlignment(textAnchor)
    if(self.layout)then
        self.layout.childAlignment = textAnchor
    end
end

--1 first  2 last
function this:AddChild(obj,sortType)
    local trans = obj.transform or obj._transform
    trans:SetParent(self.transform,false)
    if(sortType == 1)then
        trans:SetAsFirstSibling()
    end
    if(sortType == 2)then
        trans:SetAsLastSibling()
    end

    --如果没布局就默认为 放在中心
    if(not self.layout )then
        trans.anchoredPosition  = Vector2(0,0)
    end
end

function this:AddSubLayout(obj)
    if(not obj.__cname or not obj.__cname=="UILayout")then
        return
    end

    if(table.iany(self.sub,function(arg) return obj == arg end))then
        return
    end

    table.insert(self.sub,obj)
end

--
function this:ResetPos()
    if(self.layout)then
        self.layout.gameObject.transform.anchoredPosition = Vector2.zero
    end
end

--
function this:GetLayoutComp()
    return self.layout
end