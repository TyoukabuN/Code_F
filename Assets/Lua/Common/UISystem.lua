UISystem = class("UISystem")

local common_panel_list = {}

local panel_queue = {}

local common_panel_queue = {}

local isCommonPanel = function(panelName)
    return table.iany(common_panel_list,function(arg) return arg == panelName end)
end

UISystem.UIRoot = GameObject.Find("Root")

PanelName = {
    Test = "TestPanel",
}
PanelPath = {
    TestPanel = "UI/Panel/TestPanel.prefab",
}

UISystem.OpenPanel = function(panelName,parent_hInstance)
    local panelConfig = UISystem.GetPanel(panelName)

    if(panelConfig)then
        if(panelConfig == UISystem.GetCurrentPanel)then
            return panelConfig.hInstance
        elseif(isCommonPanel(panelName))then
            --@TODO
        else

        end
    else
        local hInstance = globalClass[panelName]
        if(not hInstance)then
            Debug.LogError("find not lua class!")
            return
        end

        hInstance = hInstance.New(panelName)
        if(not hInstance or not hInstance._gameObject)then
            hInstance = nil
            return
        end

        local panelConfig = UIPanelConfig.New(panelName,hInstance,parent_hInstance)

        if(not isCommonPanel(panelName))then
            table.insert(panel_queue,panelConfig)
            panelConfig.index = #panel_queue
        else
            table.insert(common_panel_queue,panelConfig) 
            panelConfig.index = #common_panel_queue
        end

        hInstance:Show()

        return hInstance
    end
end

UISystem.ClosePanel = function(panelName)
    local confs = table.ifinds(panel_queue,function(arg) return arg.panelName == panelName end)
    if(#confs==0)then
        return
    end

    local current = UISystem.GetCurrentPanel()
    if(current and current.panelName == panelName)then
        local conf = table.remove(panel_queue,#panel_queue)
        conf.hInstance:Destroy()
        confs[#confs] = nil
    end
    
    table.iaction(panel_queue,function(arg) if(arg)then arg:Close() end end)
end


UISystem.GetPanel =function(panelName)
    local panelConfig = table.ifind(panel_queue,function(arg) return arg.panelName == panelName end)
    return panelConfig
end

UISystem.GetCurrentPanel = function()
    return panel_queue[#panel_queue]
end

UIPanelConfig = class("UIPanelConfig")
function UIPanelConfig:ctor(panelName,hInstance,parent_hInsatnce)
    self.panelName = panelName
    self.hInstance = hInstance
    self.parent_hInsatnce = parent_hInsatnce
end