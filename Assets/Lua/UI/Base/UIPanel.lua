require "UI/Base/UIView"

UIPanel = class("UIPanel",UIView)

local this = UIPanel

function this:ctor(panelName,go,...)
    self.panelName = panelName
    go = go or self:LoadPanel(panelName)
    this.base.ctor(self,go,...)
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