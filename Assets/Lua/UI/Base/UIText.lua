--------------------------------------------------------
--Copyright (C)
--版本      : 1.0
--作者      : 
--创始日期  : 2017年4月28日11:44:42
--功能描述  : UI文本类
--------------------------------------------------------
require "UI/Base/UIBase"

UIText = class("UIText", UIBase)

local this = UIText

UIText.DEFAULT_HIDEAMOUNT = 1

function this:ctor(obj)
	UIText.base.ctor(self, obj)
	self._text = self:GetComponent("Text")
	self._outline = self:GetComponent("Outline")
	self._shadow = self:GetComponent("Shadow")
	self.text = nil
	self._amount = -1
end

function this:SetText(text)
	if self._text then
		self._text.text = text
	end
	self.text = text
end

--2018年7月25日17:51:23 zjw
--设置文本大小
function this:SetFontSize(value)
	if self._text then
		self._text.fontSize = value
	end
	return self
end

--文本对齐方式
function this:SetAlignment(alignment)
	if self._text then
		self._text.alignment = alignment
	end
end

--- 物品数量显示接口
function this:SetItemAmount(amount)
	if self._amount == amount then
		return
	end
	
	self._amount = amount
	if amount >= 100000 then
		local yi=100000000
		if amount > yi then
			local jiy=amount/yi
			jiy=jiy-jiy%1
			local jiw=amount-jiy*yi
			local wstr=""
			if jiw>=100000 then
				wstr=string.format("%d万", jiw/10000)
			end
			self:SetText(string.format("%d亿%s", jiy,wstr))
		else
			self:SetText(string.format("%d万", amount/10000))
		end
	else
		self:SetText(tostring(amount))
	end
	self:CheckHide()
end

function this:SetMinVisibleItemAmount(amount)
	self._minVisibleAmount = amount
	self:CheckHide()
end

function this:CheckHide()
	if self._amount and self._minVisibleAmount then
		self:SetActive(self._amount > self._minVisibleAmount)
	end
end

function this:GetText()
	if self._text then
		return self._text.text
	end
end

function this:SetColor(color)
	if self._text then
		self._text.color = color
	end
end

--as 255,255,255 
--2018年7月25日17:46:31 zjw
function this:SetColorByDec(R,G,B)
	self:SetColor(Color.New(R/255,G/255,B/255))
	return self
end

function this:GetTextComponent()
	return self._text
end

function this:SetOutLineColor(color)
	if self._outline then
		self._outline.effectColor = color
	end
end

function this:Destroy()
	self._text = nil
	UIText.base.Destroy(self)
end

--@2018年7月13日16:59:15 zjw 
-- mode
-- HorizontalWrapMode.Wrap,
-- HorizontalWrapMode.Overflow
function this:SetHorizontalWrapMode(mode)
	if(self._text)then
		self._text.horizontalOverflow = mode
	end
end

-- VerticalWrapMode.Truncate,
-- VerticalWrapMode.Overflow
function this:SetVerticalWrapMode(mode)
	if(self._text)then
		self._text.verticalOverflow = mode
	end
end
--@

--@2018年7月16日14:42:40 zjw
--获取字体完美宽度
function this:GetPreferredWidth()
	if(self._text)then
		return self._text.preferredWidth
	end
end

--获取字体完美高度
function this:GetPreferredHeight()
	if(self._text)then
		return self._text.preferredHeight
	end
end

--设置完美大小
function this:SetPreferSize(max_x,max_y)
	if(max_x)then
		self:SetSizeDelta(max_x)
	end
	if(max_y)then
		self:SetSizeDelta(nil,max_y)
	end
	self:ReCalculateLayoutInput()
	local prefer_x = self:GetPreferredWidth()
	local prefer_y = self:GetPreferredHeight()
	if(max_x)then
		if(prefer_x>max_x)then
			prefer_x = max_x
		end
	end
	if(max_y)then
		if(prefer_y>max_y)then
			prefer_y = max_y
		end
	end
	self:SetSizeDelta(prefer_x,prefer_y)
	return self
end
--@

--重新计算布局输入 2018年8月14日11:23:37 zjw
function this:ReCalculateLayoutInput()
	if(self._text)then
		self._text:CalculateLayoutInputHorizontal()
		self._text:CalculateLayoutInputVertical()
	end
	return self
end



