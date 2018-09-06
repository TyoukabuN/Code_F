UIBase = class("UIBase")

local this = UIBase

function this:ctor(go,...)
    self._transform = go.transform
	self._gameObject = go
end

function this:SetParent(trans)
    if(self._transform)then
		self._transform:SetParent(trans,false)
		self._transform.localScale = Vector3.one
		self._transform.localPosition = Vector3.zero
    else
        Debug.LogError("self.transform is null")
    end
end

--2018年7月26日12:06:11 zjw
function UIBase:SetAnchoredPosition(x,y)
	self._transform.anchoredPosition = Vector2(x,y)
	return self
end


--[[
	--@horizontalType:水平的位置类型 --1 left 2 center 3 rigth
	--@verticalType：垂直的位置类型	--1 buttom 2 center 3 top
]]
function UIBase:SetAnchor(horizontalType,verticalType,alsoPivot)
	if(alsoPivot==nil)then
		alsoPivot = true
	end
	local config = {
		[1] = 0,
		[2] = 0.5,
		[3] = 1,
	}
	self._transform.anchorMax = Vector2(config[horizontalType],config[verticalType])
	self._transform.anchorMin = Vector2(config[horizontalType],config[verticalType])
	if(alsoPivot)then
		self:SetPivot(config[horizontalType],config[verticalType])
	end
end

function UIBase:SetPivot(x,y)
	self._transform.pivot = Vector2(x,y)
end

function UIBase:SetSizeDelta(x,y)
	x = x or self._transform.sizeDelta.x
	y = y or self._transform.sizeDelta.y
	self._transform.sizeDelta = Vector2(x,y)
	return self
end

function UIBase:GetSizeDelta()
	return self._transform.sizeDelta
end

function UIBase:GetComponent(stype)
	return self._transform:GetComponent(stype)
end

function UIBase:SetSiblingIndex(idx)
	self._transform:SetSiblingIndex(idx)
end

function UIBase:SetAsLastSibling()
	self._transform:SetAsLastSibling()
end

function UIBase:SetAsFirstSibling()
	self._transform:SetAsFirstSibling()
end

function UIBase:Destroy()
    if(self.onDestroy)then
        self:onDestroy()
    end
	if self._gameObject ~= nil then
		GameObject.Destroy(self._gameObject)
    end
end

--------------------------------生成组件------------------------------------------
function UIBase:GetObject(index)
	if self._UISlots then
		return self._UISlots:GetObject(index)
	end
end

function UIBase:GetButton(index)
	local go = self:GetObject(index)
	if go then
		return UIButton.New(go)
	end
end

function UIBase:GetText(index)
	local go = self:GetObject(index)
	if go then
		return UIText.New(go)
	end
end

function UIBase:GetSprite(index)
	local go = self:GetObject(index)
	if go then
		return UISprite.New(go)
	end
end

function UIBase:GetToggle(index)
	local go = self:GetObject(index)
	if go then
		return UIToggle.New(go)
	end
end

function UIBase:GetScrollBar(index)
	local go = self:GetObject(index)
	if go then
		return go:GetComponent("Scrollbar")
	end
end

function UIBase:GetCanvasGroup(index)
	local go = self:GetObject(index)
	if go then
		return go:GetComponent("CanvasGroup")
	end
end

function UIBase:GetGrid(index)
	local go = self:GetObject(index)
	if go then
		return UIGrid.New(go)
	end
end

function UIBase:GetSlider(index)
	local go = self:GetObject(index)
	if go then
		return go:GetComponent("Slider")
	end
end

function UIBase:GetInputField(index)
	local go = self:GetObject(index)
	if go then
		return go:GetComponent("InputField")
	end
end

function UIBase:GetBox(index)
	local go = self:GetObject(index)
	if go then
		return UIBox.New(go)
	end
end
