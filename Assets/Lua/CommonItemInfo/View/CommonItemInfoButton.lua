--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 张嘉文
--创始日期  : 2018年7月16日15:35:36
--功能描述  : 通用物品信息面板按钮
--------------------------------------------------------
require "Manager/Base/UIView"
CommonItemInfoButton = class("CommonItemInfoButton", UIView)

local prefabPath = "Windows/CommonItemInfo/CommonItemInfoButton"
local this = CommonItemInfoButton

function this:ctor(go, ...)
    go = go or CommonUtils.InstantiateLocalPerfab(prefabPath)
    this.super.ctor(self, go, ...)
end

CommonItemInfoButton.FUNCBTN_OUTLAY  = 1
CommonItemInfoButton.FUNCBTN_GETWAY  = 2
CommonItemInfoButton.FUNCBTN_SHOWOFF = 3
CommonItemInfoButton.FUNCBTN_SALEUP  = 4


CommonItemInfoButton.FUNCTYPE2TEXT = {
	--[CommonItemInfoButton.FUNCBTN_TAKEOFF] = "脱下",
	[CommonItemInfoButton.FUNCBTN_GETWAY]  = "获取",
	[CommonItemInfoButton.FUNCBTN_SHOWOFF] = "炫耀",
	[CommonItemInfoButton.FUNCBTN_SALEUP]  = "分解",
	[CommonItemInfoButton.FUNCBTN_OUTLAY]  = "卸下",
}

CommonItemInfoButton.FUNCTYPE2SPRPATH = {
	--[CommonItemInfoButton.FUNCBTN_TAKEOFF] = "UI/Common_W6/Sprite/ty_anniux02_xz",
	[CommonItemInfoButton.FUNCBTN_GETWAY]  = "UI/Common_W6/Sprite/ty_anniux02_zc.png",
	[CommonItemInfoButton.FUNCBTN_SHOWOFF] = "UI/Common_W6/Sprite/ty_anniux02_zc.png",
	[CommonItemInfoButton.FUNCBTN_SALEUP]  = "UI/Common_W6/Sprite/ty_anniux02_zc.png",
	[CommonItemInfoButton.FUNCBTN_OUTLAY]  = "UI/Common_W6/Sprite/ty_anniux02_xz",
}

CommonItemInfoButton.FUNCTYPE2TXTCOLOR = {
	--[CommonItemInfoButton.FUNCBTN_TAKEOFF] = "905D2B",
	[CommonItemInfoButton.FUNCBTN_GETWAY]  = "00234f",--004151FF
	[CommonItemInfoButton.FUNCBTN_SHOWOFF] = "00234f",
	[CommonItemInfoButton.FUNCBTN_SALEUP]  = "00234f",
	[CommonItemInfoButton.FUNCBTN_OUTLAY]  = "8c3910",
}

function this:Init()
    self._text_label = self:GetText(0)
    self._sprite_bg = self:GetSprite(1)
    self._btn_self = self:GetButton(1)
    self._btn_self:SetClickCB(self,self.OnClick)
end

--设置数据
function this:SetData(label,callback,color,bgPath)
    color = color or "00234f"
    bgPath = bgPath or "UI/Common_W6/Sprite/ty_anniux02_zc.png"
    self._label = label
    self._callback = callback
    self._text_label:SetText(string.format("<color=#%s>%s</color>",color,self._label))
    self:SetBgSprite(bgPath)
    return self
end

--用ItemInfoView里的配置初始化
--CommonItemInfoButton.FUNCBTN
function this:SetDataByFuncBtnType(type,callback)
    self:SetData(CommonItemInfoButton.FUNCTYPE2TEXT[type],callback,CommonItemInfoButton.FUNCTYPE2TXTCOLOR[type],CommonItemInfoButton.FUNCTYPE2SPRPATH[type])
    return self
end

--用按钮配来设置数据
--LuaConfig_button
function this:SetDataByBtnConfig(configId,callback)
    local config = LuaConfig_button[configId]
    if(config==nil)then
        print("没有找到配置")
        return self
    end
    self._label = config.name
    self._text_label:SetText(string.format("<color=#%s>%s</color>",config.color,self._label))
    self:SetBgSprite(config.icon)
    self._callback = callback
    return self
end

--获取按钮标题
function GetLabel()
    return  self._label
end

--设置背景精灵
function this:SetBgSprite(path)
    self._sprite_bg:SetSpriteByPath(path)
end

--点击
function this:OnClick()
    local view = UIManager.GetPanel(PanelName.CommonItemInfo)
    if(view and view:GetActive())then
        view:Hide(true)
    end
    if(self._callback==nil)then
        print("没有设置按钮回调")
        return
    end
    self._callback()
end

--
function this:SetSound(soundId)
    self._btn_self:SetSound(soundId)
    return self
end

--
function this:GetButton(index)
    if(index)then
        return this.super.GetButton(self,index)
    end
    return self._btn_self
end