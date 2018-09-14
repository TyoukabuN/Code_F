require "UI/Base/UIView"

UIPanel = class("UIPanel",UIView)

local this = UIPanel

function this:ctor(panelName,go,...)
    self.panelName = panelName
    go = go or self:LoadPanel(panelName)
    this.base.ctor(self,go,...)
    self.viewEffect = self:GetComponent("ViewEffect")
    self.canvas = self:GetComponent(typeof(Canvas))
end

function this:Init(...)
    this.base.Init(self,...)
end

function this:SetCanvasOrderSort(val)
    if(type(val)~="number")then
        return
    end
    self.canvas.sortingOrder = val
end

function this:LoadPanel(panelName)   
    local path = PanelPath[panelName]
    if(not path)then
        Debug.LogError("find not path!")
        return
    end

    local gobj = ResourceManager.Load(path, typeof(GameObject))
    if(not gobj)then
        Debug.LogError("fail to load prefab!")
        return
    end
    gobj.transform:SetParent(UISystem.UIRoot.transform,false)
    gobj.name = string.gsub(gobj.name,"%(Clone%)","")
    
    return gobj
end

function this:Redisplay()
    if self.viewEffect then
		self.viewEffect:Show()
	end
    self:SetActive(true)
end

function this:Hide()
    local func = function()
        self:SetActive(false)
    end

    if self.viewEffect then
		self.viewEffect:Close(func)
	else
		func()
	end
end

function this:Close()
    local func = function()
        self:SetActive(false)
        self:Destroy()
    end

    if self.viewEffect then
		self.viewEffect:Close(func)
	else
		func()
	end
end

function this:Show()
    if self.viewEffect then
		self.viewEffect:Show()
	end
    self:SetActive(true)
end