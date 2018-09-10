UISystem = class("UISystem")

local common_panel_list = {
}

local panel_queue = {}

local common_panel_queue = {}

local isCommonPanel = function(panelName)
    return table.any(common_panel_list,function(arg) return arg == panelName end)
end

UISystem.UIRoot = GameObject.Find("Root")

PanelName = {
    Test = "TestPanel",
    Test2 = "TestPanel2",
}
PanelPath = {
    TestPanel = "UI/Panel/TestPanel.prefab",
    TestPanel2 = "UI/Panel/TestPanel2.prefab",
}

UISystem.ToString = function()
    local temp = {}
    for i,conf in ipairs(panel_queue)do
        table.insert( temp,conf.panelName)
    end
    print("当前面板队列长度：",#temp)
    print("当前面板队列：",table.unpack(temp))
end

UISystem.OpenPanel = function(panelName,closeOther,parent_hInstance)
    if(not closeOther)then
        closeOther = false
    end
    local panelConfig,index = UISystem.GetPanel(panelName)
    local hInstance

    if(panelConfig)then
        local curConf = UISystem.GetCurrentPanel()
        -- if(panelConfig == curConf)then
        --     hInstance = panelConfig.hInstance
        -- elseif(not isCommonPanel(panelName))then
        --     if(panelConfig:IsCloser(curConf.panelName))then
        --         return
        --     else
        --         hInstance = panelConfig.hInstance
        --     end
        -- else
        --     ---@TODO
        -- end
        hInstance = panelConfig.hInstance
        table.remove(panel_queue,index)
    else
        hInstance = globalClass[panelName]
        if(not hInstance)then
            Debug.LogError("find not lua class!")
            return
        end

        hInstance = hInstance.New(panelName)
        if(not hInstance or not hInstance._gameObject)then
            hInstance = nil
            return
        end

        panelConfig = UIPanelConfig.New(panelName,hInstance,parent_hInstance)
    end

    if(not isCommonPanel(panelName))then
        table.insert(panel_queue,panelConfig)
    else
        table.insert(common_panel_queue,panelConfig) 
    end
    
    if(closeOther)then
        for i = 1,#panel_queue-1 do
            panel_queue[i]:AddCloser(panelConfig)
        end
    end

    hInstance:Show()

    return hInstance
end

UISystem.ClosePanel = function(panelName)
    local confs = table.ifinds(panel_queue,function(arg) return arg.panelName == panelName end)
    if(#confs==0)then
        return
    end

    local current = UISystem.GetCurrentPanel()
    if(current and current.panelName == panelName)then
        local conf = table.remove(panel_queue,#panel_queue)
        conf.hInstance:Close()
        conf.hInstance:Destroy()
        confs[#confs] = nil
    end

    for i,conf in ipairs(panel_queue)do
        conf:Redisplay(panelName)
    end
    
    --table.iaction(panel_queue,function(arg) if(arg)then arg:Close() end end)
end


UISystem.GetPanel =function(panelName)
    local panelConfig,index = table.ifind(panel_queue,function(arg) return arg.panelName == panelName end)
    return panelConfig,index
end

UISystem.GetCurrentPanel = function()
    return panel_queue[#panel_queue]
end


--面板信息
UIPanelConfig = class("UIPanelConfig")
function UIPanelConfig:ctor(panelName,hInstance,parent_hInstance)
    self.panelName = panelName
    self.hInstance = hInstance
    self.parent_hInstance = parent_hInstance
    self.conf_closer = {}
end

function UIPanelConfig:AddCloser(conf)
    if(conf.panelName == self.panelName)then
        return
    end

    local had = table.iany(self.conf_closer,function(arg) return arg.panelName == conf.panelName end)
    if(not had)then
        table.insert(self.conf_closer,conf)
    end
    self.hInstance:Hide()
end

function UIPanelConfig:Redisplay(panelName)
    if(#self.conf_closer<=0)then
        return
    end
    -- local last_conf = self.conf_closer[#self.conf_closer]
    -- if(last_conf.panelName == panelName)then
    --     table.remove(self.conf_closer,#self.conf_closer)
    -- end
    local conf,index = table.ifind(self.conf_closer,function(arg) return arg.panelName == panelName end)
    if(conf)then
        table.remove(self.conf_closer,index)
    end
    if(#self.conf_closer<=0)then
        self.hInstance:Redisplay()
    end
end

function UIPanelConfig:IsCloser(panelName)
    return table.iany(self.conf_closer,function(arg) return arg.panelName == panelName end)
end