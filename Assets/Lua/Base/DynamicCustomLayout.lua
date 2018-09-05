--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 张嘉文
--创始日期  : 2018年8月13日15:57:57
--功能描述  : 动态自定义图文布局
--------------------------------------------------------
DynamicCustomLayout = class("DynamicCustomLayout",UISprite)
local prefabPath = "Windows/CommonItemInfo/DynamicCustomLayout"
local this = DynamicCustomLayout
function this:ctor(go,...)
    go = go or CommonUtils.NewGameObject(prefabPath)
    this.super.ctor(self,go,...)
    self._transform = go.transform
    self._gameObject = go.gameObject
    self._UISlots = go:GetComponent("UISlots")
    self._textPrefab = self:GetText(1)
    self._textPrefab:SetActive(false)
    --init pools
    self:InitImagePool()
    self:InitTextPool()
    --containers
    self.lastElement = nil
    self._elements = {}
end

--添加一个精灵
function this:AddImage()
    return self._objPool_image:Add()
end

--添加一个文本
function this:AddText()
    return self._objPool_text:Add()
end

--初始化精灵池
function this:InitImagePool()
    local onConstruct = function()
        local obj = GameObject.New("Icon")
        obj:AddComponent(typeof(UnityEngine.RectTransform))
        obj:AddComponent(typeof(UnityEngine.UI.Image))
        obj = UISprite.New(obj)
        return obj
    end
    local onEnabled = function(obj)
        self:AddElement(obj)
        obj:SetActive(true)
    end
    local onDisabled = function(obj)
        obj:SetParent(self._transform)
        obj:SetActive(false)
    end
    self._objPool_image = SimpleObjectPool.New(onConstruct,onEnabled,onDisabled)
end

--初始化文本池
function this:InitTextPool()
    local onConstruct = function()
        --local obj = GameObject.New("Text")
        -- obj:AddComponent(typeof(UnityEngine.RectTransform))
        -- obj:AddComponent(typeof(UnityEngine.UI.Text))
        local obj = self._textPrefab:Clone()
        obj:SetPreferSize()
        return obj
    end
    local onEnabled = function(obj)
        self:AddElement(obj)
        obj:SetActive(true)
    end
    local onDisabled = function(obj)
        obj:SetParent(self._transform)
        obj:SetActive(false)
    end
    self._objPool_text = SimpleObjectPool.New(onConstruct,onEnabled,onDisabled)
end

--添加一个元素
function this:AddElement(obj)
    obj:SetParent(self._transform)
    if(#self._elements==0)then
        obj._gameObject.name = "first"
        obj:SetAnchor(1,3,true)
        obj:SetAnchoredPosition(0,0)
    else
        obj:SetParent(self._elements[#self._elements]._transform)
        obj:SetAnchor(3,3)
        obj:SetPivot(0,1)
        obj:SetAnchoredPosition(0,0)
    end
    table.insert(self._elements,obj)
end

function this:GetElements()
    return self._elements
end

--刷新本体大小
function this:RefreshSize()
    local total_width = 0
    local max_height = 0
    for i,obj in ipairs(self:GetElements()) do
        local width = 0
        local height = 0
        if(obj and obj:GetActive())then
            if(obj.__cname == "UISprite")then
                width = obj:GetSizeDelta().x
                height = obj:GetSizeDelta().y
            elseif(obj.__cname == "UIText")then
                obj:ReCalculateLayoutInput()
                width = obj:GetPreferredWidth()
                height = obj:GetPreferredHeight()
            end
            width = obj:GetSizeDelta().x
            height = obj:GetSizeDelta().y
            if(height>max_height)then
                max_height = height
            end
            total_width = total_width + width
        end
    end
    self:SetSizeDelta(total_width,max_height)
end

--清理
function this:Clear()
    self._elements = {}
    if(self._objPool_image)then
        self._objPool_image:Clear()
    end
    if(self._objPool_text)then
        self._objPool_text:Clear()
    end
end