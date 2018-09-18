require "UI/Base/UIView"

UIPanel = class("UIPanel",UIView)

local this = UIPanel

function this:ctor(panelName,isAsync)
    self.panelName = panelName
    self.isAsync = isAsync
    
    if(isAsync)then
        self:LoadPanel(panelName,isAsync)
        return
    end
    go = go or self:LoadPanel(panelName)
    this.base.ctor(self,go)
end

function this:Init(...)
    this.base.Init(self,...)
    self.viewEffect = self:GetComponent("ViewEffect")
    self.canvas = self:GetComponent(typeof(Canvas))
    
    self.canvasScaler = self:GetComponent(typeof(CanvasScaler)) or self:AddComponent(typeof(CanvasScaler))
    self.canvasScaler.uiScaleMode = ScaleMode.ScaleWithScreenSize
    self.canvasScaler.referenceResolution = UISystem.GetResolution()
    self.canvasScaler.screenMatchMode = ScreenMatchMode.Expand
    self.canvasScaler.referencePixelsPerUnit = 100
end

function this:SetCanvasOrderSort(val)
    if(type(val)~="number")then
        return
    end
    self.canvas.sortingOrder = val
end

function this:LoadPanel(panelName,isAsync)   
    local path = PanelPath[panelName]
    if(not path)then
        Debug.LogError("find not path!")
        return
    end
    
    local afterLoad = function(obj)
        if(not obj)then
            Debug.LogError("fail to load prefab!")
            return
        end
        obj.transform:SetParent(UISystem.UIRoot.transform,false)
        obj.name = string.gsub(obj.name,"%(Clone%)","")
        this.base.ctor(self,obj)
        return obj
    end
    
    if(isAsync)then
        ResourceManager.LoadAsync(path, typeof(GameObject),afterLoad)
        return
    end
    local gobj = ResourceManager.Load(path, typeof(GameObject))
    return afterLoad(gobj)
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

function this:Open()
    if self.viewEffect then
		self.viewEffect:Open()
	end
    self:SetActive(true)
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

