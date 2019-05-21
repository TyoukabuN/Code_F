--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 张嘉文
--创始日期  : 2018年7月13日17:27:00
--功能描述  : 通用物品信息视图
--------------------------------------------------------
CommonItemInfoView = class("CommonItemInfoView", UIPanel)

CommonItemInfoView.PanelGroup = UILayer.InfoPanel
local this = CommonItemInfoView



function this:ctor(panelName, ...)
    this.super.ctor(self, panelName, ...)
end

function this:Init(...)
    self._layout_panel = UIView.New(self:GetObject(0))
    self._btn_close = self:GetButton(1)
    self._layout_button = self:GetObject(2)
    self._obj_owm = self:GetObject(3)
    self._layout = self:GetObject(0):GetComponent("HorizontalLayoutGroup")
    self._fitter = self:GetObject(0):GetComponent(typeof(ContentSizeFitter))
    self._btn_close:SetClickCB(self,function()
        self:Hide(true)
        -- UIManager.ClosePanel(PanelName.CommonItemInfo)
    end)
    --容器
    self:Clear()
    --
    self:InitPanelObjPool()
    self:InitBtnObjPool()
end

function this:InitPanelObjPool()
    --
    local onConstruct = function(...)
        return CommonItemInfoPanel.New(...)
    end
    local onEnable = function(obj)
        obj:SetActive(true)
        obj:SetParent(self._layout_panel._transform)
        obj:SetAsFirstSibling()
        obj.view = self
        self._layout_button.transform:SetAsLastSibling()
    end
    local onDisable = function(obj)
        obj:SetActive(false)
        obj:Clear()
    end
    self._objPool_panel = SimpleObjectPool.New(onConstruct, onEnable, onDisable)
end

function this:InitBtnObjPool()
    --
    local onConstruct = function()
        return CommonItemInfoButton.New()
    end
    local onEnable = function(obj)
        obj:SetActive(true)
        obj:SetParent(self._layout_button.transform)
        obj:SetAsLastSibling()
        obj.view = self
    end
    local onDisable = function(obj)
        --obj:SetSound(45000)
        obj:SetActive(false)
    end
    self._objPool_btn = SimpleObjectPool.New(onConstruct, onEnable, onDisable)
end

--获取指定按钮（不填predicate返回全部）
function this:GetButtons(predicate)
    predicate = predicate or function(arg) return true end
    local lives =self._objPool_btn:GetLives()
    local temp = table.ifinds(lives,predicate)
    return temp
end

--移除一个按钮
function this:RemoveButton(button)
     self._objPool_btn:Remove(button)
end

--移除特定的按钮
function this:RemoveButtons(predicate)
    local temp = self:GetButtons(predicate)
    for i,v in ipairs()do
        self:RemoveButton(v)
    end
end

function this:Close()
    self._btn_close:SetActive(false)
    self:Clear()
    self.super.Close(self)
end

--调这个隐藏
function this:Hide(isManual)
    -- this.super.Hide(self,isManual)
    self:Close()
end

function this:Show(bCloseOther)
    this.super.Show(self)
    self._btn_close:SetActive(true)
    self:Clear()
    self:BeCenter()
    self:SetAsLastSibling()
end

--清理生池
function this:Clear()
    self._layout_button:SetActive(false)
    if(self._objPool_panel)then
        self._objPool_panel:Clear()
    end
    if(self._objPool_btn)then
        self._objPool_btn:Clear()
    end
end

--
function this:AddItemInfoPanel()
    local panel = self._objPool_panel:Add()
    return panel, self
end

--添加一个按钮
--CommonItemInfoButton
function this:AddButton()
    self._layout_button:SetActive(true)
    local button = self._objPool_btn:Add()
    return button, self
end

--获取屏幕size
function this:GetScreenSize()
    if(not this._screenSize)then
        this._screenSize = self._obj_owm.transform.rect.size
    end
    return this._screenSize
end

--自动调整位置的
-- 1.道具tips显示规则改为：显示在图标上方
-- 2.位置判断：道具图标位于黄线以下时，tips显示在图标的下方，黄线以上为300像素的高度
-- 3.左右边缘处理：当图标位于屏幕最左边或最右边时，上下规则不变，tips左右不可超出屏幕外
-- 4.以上规则，不包含背包中道具tips
function this:AutoPosition(trans)
    table.iaction(self._objPool_panel:GetLives(),function(arg) return arg:CalculateLayoutInput() end)
    --重新计算rect
    self._layout:CalculateLayoutInputHorizontal()
    self._layout:CalculateLayoutInputVertical()
    self._fitter:SetLayoutHorizontal()
    self._fitter:SetLayoutVertical()

	local pos = trans.position
	pos = Vector3.New(pos.x,pos.y,pos.z)
	local corners = Util.GetWorldCorners(trans)
	local syh =(corners[1].y-corners[0].y)/2   --固定在icon的顶部
    local sxh =(corners[2].x-corners[1].x)/2   --固定在icon的顶部
    pos.y = pos.y--+ syh

    self._layout_panel:SetAnchor(0,0,false)
    --图标在屏幕60%以下的 固定在图标上方
    local viewPortPos3dOrign = UIManager.UICamera:WorldToViewportPoint(pos)

    local type = 1 --1上 2下
    if(viewPortPos3dOrign.y<0.6)then
        self._layout_panel:SetPivot(0,0)
        pos.y = pos.y + syh
    else
        self._layout_panel:SetPivot(0,1)
        pos.y = pos.y - syh
        type = 2
    end

    local viewPortPos3d = UIManager.UICamera:WorldToViewportPoint(pos)

    local size = self:GetScreenSize()
    local widthL = self._layout_panel._transform.rect.size.x/2
    local height = self._layout_panel._transform.rect.size.y

    --坐标最终值
    local Xf = size.x*viewPortPos3d.x - widthL
    local Yf = size.y*viewPortPos3d.y

    --防止上下越界
    local YoverU = size.y*viewPortPos3d.y + height -  size.y
    local YoverD = size.y*viewPortPos3d.y - height
    local Yover = false
    if(type == 1 and YoverU>0)then
        Yf,Yover = Yf - YoverU,true
    end
    if(type == 2 and YoverD<0)then
        Yf,Yover = Yf + math.abs(YoverD),true
    end

    --若发生了上下越界，作防item被手指遮住的偏移
    if(Yover)then
        sxh = math.abs(viewPortPos3d.y - viewPortPos3dOrign.y) * size.x /2
        if(Xf/size.x<=0.5)then
            Xf = Xf - 0 + (widthL + sxh)
        else
            Xf = Xf - 0 -  (widthL + sxh)
        end
    else
        --若没发生，则作一般的防止左右越界
        local XoverR = size.x*viewPortPos3d.x + widthL - size.x
        local XoverL = size.x*viewPortPos3d.x - widthL
        if(XoverR>0)then
            Xf = Xf + (-1 * XoverR)
        end
        if(XoverL<0)then
            Xf =  Xf + math.abs(XoverL)
        end
    end

    self._layout_panel:SetAnchoredPosition(Xf ,Yf)
end

--固定在中间
function this:BeCenter()
    self._layout_panel:SetAnchor(0.5,0.5,true)
    self._layout_panel:SetAnchoredPosition(0,0)
end