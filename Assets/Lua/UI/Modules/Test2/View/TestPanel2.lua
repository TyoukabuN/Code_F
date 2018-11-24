require "UI/Base/UIPanel"

TestPanel2 = class("TestPanel2",UIPanel)

local this = TestPanel2

function this:ctor(go,...)
    this.base.ctor(self,go,...)
end

function this:Init(...)
    self._button_test = self:GetButton(0)
    self._button_test:SetClickCB(function() self:OnClick() end)

    self._option = DynamicOption.New(self:GetObject(1))
    self._layout = self:GetObject(2)

    local onConstruct = function()
        local obj = self._option:Clone()
        return obj
    end
    local onEnable = function(obj)
        obj:SetAsLastSibling()
        obj:SetParent(self._layout.transform)
        obj:SetActive(true)
    end
    local onDisabled = function(obj)
        obj:SetActive(false)
    end
    self._optionPool = SimpleObjectPool.New(onConstruct,onEnable,onDisabled)
end

function this:AfterInit()
    self._optionPool:Get():SetContent("GET"):GetButton():SetClickCB(function() self:OnGet() end)
    self._optionPool:Get():SetContent("POST"):GetButton():SetClic4kCB(function() self:OnPost() end)
end

function this:OnGet()
    local onReturn = function(req) printc(req.downloadHandler.text) end
    ToLuaUtility.HttpGetRequest("http://192.168.8.213/get.php",onReturn,"","submit","r", "1", "g", "1", "b", "1")
end

function this:OnPost()
    local onReturn = function(req) printc(req.downloadHandler.text) end
    ToLuaUtility.HttpPostRequest("http://192.168.8.213/post.php",onReturn,"","submit","r", "100", "g", "100", "b", "100")
end

-- function this:OnClick()
--     UISystem.ClosePanel(PanelName.Test2)
-- end