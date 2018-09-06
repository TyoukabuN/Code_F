-- local test1 = TestClass.New()
-- EventSystem.Broadcast(EventType.Test,"广播事件测试")

local path = "UI/Panel/TestPanel.prefab"
local goj = ResourceManager.Load(path, typeof(GameObject))
local panel = TestPanel.New(goj)
local root = GameObject.Find("Root")
if(root)then
    panel:SetParent(root.transform)
end