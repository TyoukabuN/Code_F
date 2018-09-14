UISystem = class("UISystem")

local common_panel_list = {
}

PanelName = {
    Test = "TestPanel",
    Test2 = "TestPanel2",
}
PanelPath = {
    TestPanel = "UI/Panel/TestPanel.prefab",
    TestPanel2 = "UI/Panel/TestPanel2.prefab",
}

local panel_queue = {}



local IsCommonPanel = function(panelName)
    return table.any(common_panel_list,function(arg) return arg == panelName end)
end

local AddToQueue = function(panelConfig)
    if(not IsCommonPanel(panelConfig.panelName))then
        table.insert(panel_queue,panelConfig)
    else
        table.insert(common_panel_queue,panelConfig) 
    end
end

local RemoveFormQueue = function(panelConfig)
    local queue
    if(not IsCommonPanel(panelConfig.panelName))then
        queue = panel_queue
    else
        queue = common_panel_queue
    end
    local conf,index = table.ifind(queue,function(arg) return arg.panelName == panelConfig.panelName end)
    if(index)then
        table.remove(queue,index)
    end
end

UILayer = {
    Base = "Layer_Base",
    Dialog = "Layer_Dialog",
}

UILayerSort = {
    UILayer.Base,
    UILayer.Dialog
}

UILayerUnit = 1000
UIPanelUnit = 100

--初始化
UISystem.Init = function()
    local addLayerObj = function(name,parentTrans)
        local gobj = GameObject(name)
        --root:AddComponent(typeof(RectTransform))
        gobj:AddComponent(typeof(CanvasRenderer))
        gobj.layer = 5--LayerMask:GetMask({"UI"})
        gobj.transform:SetParent(parentTrans,false)
        return gobj
    end
    
    local root = GameObject.Find("Root")
    if(not root)then
        root = addLayerObj("Root")
    end

    for i,name in ipairs(UILayerSort)do
        local layout = root.transform:Find(name)
        if(not layout)then
            layout = addLayerObj(name,root.transform)
        end
    end
    
    UISystem.UIRoot = root
end

--输出队列
UISystem.ToString = function()
    local temp = {}
    for i,conf in ipairs(panel_queue)do
        table.insert( temp,conf.panelName)
    end
    print("当前面板队列长度：",#temp)
    print("当前面板队列：",table.unpack(temp))
end

--打开面板
UISystem.OpenPanel = function(panelName,closeOther,parent_hInstance)
    if(not closeOther)then
        closeOther = false
    end
    local panelConfig,index = UISystem.GetPanel(panelName)
    local hInstance
    local isCommonPanel = IsCommonPanel(panelName)

    if(panelConfig)then
        local curConf = UISystem.GetCurrentPanel()
        hInstance = panelConfig.hInstance
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

        AddToQueue(panelConfig)
    end
    
    if(closeOther and not isCommonPanel)then
        for i = 1,#panel_queue-1 do
            panel_queue[i]:AddCloser(panelConfig)
        end
    end

    hInstance:Show()

    return hInstance
end

--关闭面板
UISystem.ClosePanel = function(panelName)
    local confs = table.ifinds(panel_queue,function(arg) return arg.panelName == panelName end)
    if(#confs==0)then
        return
    end

    local current = UISystem.GetCurrentPanel()
    if(current and current.panelName == panelName)then
        local conf = table.remove(panel_queue,#panel_queue)
        conf.hInstance:Close()
        --confs[#confs] = nil

        for i,conf in ipairs(panel_queue)do
            conf:Redisplay(panelName)
        end
    else
        local conf = UISystem.GetPanel(panelName)
        if(conf)then
            RemoveFormQueue(conf)
            conf.hInstance:Close()
        end
    end

    UISystem.ToString()
    --table.iaction(panel_queue,function(arg) if(arg)then arg:Close() end end)
end


UISystem.GetPanel =function(panelName)
    local panelConfig,index = table.ifind(panel_queue,function(arg) return arg.panelName == panelName end)
    return panelConfig,index
end

UISystem.GetCurrentPanel = function()
    return panel_queue[#panel_queue]
end


--面板配置
UIPanelConfig = class("UIPanelConfig")
function UIPanelConfig:ctor(panelName,hInstance,parent_hInstance)
    self.panelName = panelName
    self.hInstance = hInstance
    self.parent_hInstance = parent_hInstance
    self.conf_closer = {}  --关闭者需要优化
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
    printc("Redisplay")
    self.hInstance:Redisplay()

    -- if(#self.conf_closer<=0)then
    --     return
    -- end

    -- local conf,index = table.ifind(self.conf_closer,function(arg) return arg.panelName == panelName end)
    -- if(conf)then
    --     table.remove(self.conf_closer,index)
    -- end

    -- if(#self.conf_closer<=0)then
    --     self.hInstance:Redisplay()
    -- end
end

function UIPanelConfig:IsCloser(panelName)
    return table.iany(self.conf_closer,function(arg) return arg.panelName == panelName end)
end