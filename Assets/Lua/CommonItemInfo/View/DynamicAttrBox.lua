--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 张嘉文
--创始日期  : 2018年7月13日17:58:16
--功能描述  : 动态属性盒子（for CommonItemInfoPanel）
--------------------------------------------------------

DynamicAttrBox = class("DynamicAttrBox", UIView)

local prefabPath = "Windows/CommonItemInfo/DynamicAttrBox"
local this = DynamicAttrBox

function this:ctor(go, ...)
    go = go or CommonUtils.InstantiateLocalPerfab(prefabPath)
    this.super.ctor(self, go, ...)
    self._layout_detail = self:GetObject(0)
    self._layout = self._layout_detail:GetComponent("VerticalLayoutGroup")
    self._fitter = self._layout_detail:GetComponent(typeof(ContentSizeFitter))
    self._sprite_line = self:GetSprite(1)
    --

    self:InitDetailPool()
    self:InitCustomLayoutPool()
end

--重新计算rect.size
function this:CalculateLayoutInput()
    self._layout:CalculateLayoutInputHorizontal()
    self._layout:CalculateLayoutInputVertical()
    self._fitter:SetLayoutHorizontal()
    self._fitter:SetLayoutVertical()
end


--描述池
function this:InitDetailPool()
    local onConstruct = function()
        return DynamicDetails.New()
    end
    local onEnable = function(obj)
        obj:SetActive(true)
        obj:SetParent(self._layout_detail.transform)
        obj:SetAsLastSibling()
        self._sprite_line:SetAsLastSibling()
    end
    local onDisable = function(obj)
        obj:SetActive(false)
    end
    self._objPool_detail = SimpleObjectPool.New(onConstruct, onEnable, onDisable)
end

--自定义图文布局池
function this:InitCustomLayoutPool()
     local onConstruct = function()
        return DynamicCustomLayout.New()
    end
    local onEnable = function(obj)
        obj:SetActive(true)
        obj:SetParent(self._layout_detail.transform)
        obj:SetAsLastSibling()
        self._sprite_line:SetAsLastSibling()
    end
    local onDisable = function(obj)
        obj:Clear()
        obj:SetActive(false)
    end
    self._objPool_customLayout = SimpleObjectPool.New(onConstruct, onEnable, onDisable)
end

function this:Init(...)
    self:Clear()
end

--清理生池
function this:Clear()
    if(self._objPool_detail)then
        self._objPool_detail:Clear()
    end
    if(self._objPool_customLayout)then
        self._objPool_customLayout:Clear()
    end
end

--添加一个标题
function this:AddTitle(label, format)
    local detail = self._objPool_detail:Add():SetFontSize(20)
    detail:initAsLabel(label, format)
    return detail, self
end

--添加一个描述
function this:AddDetail(label, content, width)
    local detail = self._objPool_detail:Add():SetFontSize(20)
    detail:init(label, content, width)
    return detail, self
end

--添加一个自定义图文布局
function this:AddCustomLayout()
    local customLayout = self._objPool_customLayout:Add()
    return customLayout, self
end

--分割线的显示
function this:SetLineEnabled(enabled)
    self._sprite_line:SetActive(enabled)
    if(enabled)then
        self._sprite_line:SetAsLastSibling()
    end
end

--获取所有显示中的描述
function this:GetDetails()
    return self._objPool_detail._liveQueue
end
