UIBase = class("UIBase")

local this = UIBase

function this:ctor(go,...)
    self._transform = go.transform
	self._gameObject = go
end

function this:SetActive(enabled)
	if(not self._gameObject)then
		return
	end
	if(self._gameObject.activeSelf == enabled)then
		return
	end
	self._gameObject:SetActive(enabled)
end

function this:Clone()
	local go = GameObject.Instantiate(self._gameObject)
	return self.class.New(go)
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

function this:AddComponent(type)
	if(self._gameObject==nil)then
		return
	end
	local comp = self._gameObject:AddComponent(type)
	return comp
end

function this:OpenPanel(panelType,closeOther)
	UISystem.OpenPanel(panelTpye,closeOther,self)
end

--2018年7月26日12:06:11 zjw
function this:SetAnchoredPosition(x,y)
	x = x or self:GetAnchoredPosition().x
	y = y or self:GetAnchoredPosition().y
	self._transform.anchoredPosition = Vector2(x,y)
	return self
end

function this:GetAnchoredPosition()
	return self._transform.anchoredPosition
end

function this:Destroy()
	if(self._gameObject)then
		GameObject.Destroy(self._gameObject)
	end
end

function this:Close()
	if(self._gameObject)then
		self._gameObject:SetActive(false)
	end
end

--[[
	--@horizontalType:水平的位置类型 --1 left d2 center 3 rigth
	--@verticalType：垂直的位置类型	--1 buttom 2 center 3 top
]]
function this:SetAnchor(horizontalType,verticalType,alsoPivot)
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

function this:SetPivot(x,y)
	self._transform.pivot = Vector2(x,y)
end

function this:SetSizeDelta(x,y)
	x = x or self._transform.sizeDelta.x
	y = y or self._transform.sizeDelta.y
	self._transform.sizeDelta = Vector2(x,y)
	return self
end

function this:GetSizeDelta()
	return self._transform.sizeDelta
end

function this:GetComponent(stype)
	return self._transform:GetComponent(stype)
end

function this:SetSiblingIndex(idx)
	self._transform:SetSiblingIndex(idx)
end

function this:SetAsLastSibling()
	self._transform:SetAsLastSibling()
end

function this:SetAsFirstSibling()
	self._transform:SetAsFirstSibling()
end

function this:Destroy()
    if(self.onDestroy)then
        self:onDestroy()
    end
	if self._gameObject ~= nil then
		GameObject.Destroy(self._gameObject)
    end
end

--------------------------------生成组件------------------------------------------
function this:GetObject(index)
	if self._UISlots then
		return self._UISlots:GetObject(index)
	end
end

function this:GetButton(index)
	local go = self:GetObject(index)
	if go then
		return UIButton.New(go)
	end
end

function this:GetText(index)
	local go = self:GetObject(index)
	if go then
		return UIText.New(go)
	end
end

function this:GetSprite(index)
	local go = self:GetObject(index)
	if go then
		return UISprite.New(go)
	end
end

function this:GetToggle(index)
	local go = self:GetObject(index)
	if go then
		return UIToggle.New(go)
	end
end

function this:GetScrollBar(index)
	local go = self:GetObject(index)
	if go then
		return go:GetComponent("Scrollbar")
	end
end

function this:GetCanvasGroup(index)
	local go = self:GetObject(index)
	if go then
		return go:GetComponent("CanvasGroup")
	end
end

function this:GetGrid(index)
	local go = self:GetObject(index)
	if go then
		return UIGrid.New(go)
	end
end

function this:GetSlider(index)
	local go = self:GetObject(index)
	if go then
		return go:GetComponent("Slider")
	end
end

function this:GetInputField(index)
	local go = self:GetObject(index)
	if go then
		return go:GetComponent("InputField")
	end
end

function this:GetBox(index)
	local go = self:GetObject(index)
	if go then
		return UIBox.New(go)
	end
end
