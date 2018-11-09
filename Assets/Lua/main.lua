--Copyright (C)
--版本      : 1.0
--作者      :
--创始日期  : 2018年8月9日11:21:30
--功能描述  :
--------------------------------------------------------

ResourceManager = CS.ResourceManager

--about UnityEngine
UnityEngine = CS.UnityEngine
EventTriggerType = UnityEngine.EventSystems.EventTriggerType
EventTrigger = UnityEngine.EventSystems.EventTrigger
Entry = EventTrigger.Entry
EventTriggerSub = CS.EventTriggerSub
GameObject = UnityEngine.GameObject
Vector2 = UnityEngine.Vector2
Vector3 = UnityEngine.Vector3
Time = UnityEngine.Time
Quaternion = UnityEngine.Quaternion
Debug = UnityEngine.Debug
DG = CS.DG
Tweening = DG.Tweening
DOTween = Tweening.DOTween
Ease = DOTween.Ease
RectTransform = UnityEngine.RectTransform
Camera = UnityEngine.Camera
CanvasRenderer = UnityEngine.CanvasRenderer
CanvasScaler = UnityEngine.UI.CanvasScaler
ScaleMode = CanvasScaler.ScaleMode
ScreenMatchMode = CanvasScaler.ScreenMatchMode
Canvas = UnityEngine.Canvas
LayerMask = UnityEngine.UnityEngine
TimerSystem = CS.TimerSystem

LuaSystem = CS.LuaSystem
EnUpdate = LuaSystem.EnUpdate
DeUpdate = LuaSystem.DeUpdate



require "requireInit"

local function Init()
    UISystem.Init()
end

Init()

