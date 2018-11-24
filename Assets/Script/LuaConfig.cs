using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.EventSystems;
using UnityEngine.Networking;
using UnityEngine.UI;
using XLua;

public static class LuaConfig
{

    [CSharpCallLua]
    public static List<Type> CSharpCallLualist = new List<Type>
    {
        typeof(UnityEngine.Vector2),
        typeof(UnityEngine.Vector3),
        typeof(System.Action<UnityEngine.Object>),
        typeof(System.Action<XLua.LuaTable>),
        typeof(System.Action<UnityWebRequest>),
        typeof(UnityEngine.Events.UnityAction),
        typeof(UnityEngine.Events.UnityAction<bool>),
        typeof(UnityEngine.Events.UnityAction<string>),
        typeof(UnityEngine.Events.UnityAction<UnityEngine.Vector2>),
        typeof(UnityEngine.Events.UnityAction<UnityEngine.EventSystems.PointerEventData>),
        typeof(UnityEngine.Events.UnityAction<UnityEngine.EventSystems.BaseEventData>),
    };

    [LuaCallCSharp]
    public static List<Type> LuaCallCSharpList = new List<Type>
    {
        typeof(Behaviour),
        typeof(MonoBehaviour),
        typeof(GameObject),
        typeof(TrackedReference),
        typeof(Application),
        typeof(Physics),
        typeof(Collider),
        typeof(Time),
        typeof(Texture),
        typeof(Texture2D),
        typeof(Shader),
        typeof(Renderer),
        typeof(WWW),
        typeof(Screen),
        typeof(CameraClearFlags),
        typeof(AudioClip),
        typeof(AssetBundle),
        typeof(ParticleSystem),
        typeof(AsyncOperation),//.SetBaseType(typeof(System.Object),
        //typeof(LightType),
        typeof(SleepTimeout),
        typeof(Animator),
        typeof(Input),
        typeof(KeyCode),
        typeof(SkinnedMeshRenderer),
        typeof(Space),
        typeof(TextAnchor),

        typeof(MeshRenderer),

        typeof(BoxCollider),
        typeof(MeshCollider),
        typeof(SphereCollider),
        typeof(CharacterController),
        typeof(CapsuleCollider),

        typeof(Animation),
        typeof(AnimationClip),//.SetBaseType(typeof(UnityEngine.Object),
        typeof(AnimationState),
        typeof(AnimationBlendMode),
        typeof(AnimationPlayMode),
        typeof(QueueMode),
        typeof(PlayMode),
        typeof(WrapMode),
        typeof(NetworkReachability),

        typeof(QualitySettings),
        typeof(RenderSettings),
        typeof(BlendWeights),
        typeof(RenderTexture),
        typeof(RuntimePlatform),
        typeof(AnimatorStateInfo),
        typeof(TextAsset),
        typeof(PlayerPrefs),
        typeof(UnityEngine.Rendering.ShadowCastingMode),//.SetNameSpace("UnityEngine.Rendering"),
        typeof(NavMeshPath),
        typeof(NavMeshObstacle),
        typeof(ObstacleAvoidanceType),
        typeof(AudioListener),
        typeof(SystemInfo),
        typeof(Resolution),
        typeof(Debug),


        typeof(Image),
        typeof(ImageConversion),
        typeof(Text),
        typeof(Button),
        typeof(Button.ButtonClickedEvent),
        typeof(Toggle),
        typeof(ToggleGroup),
        typeof(InputField),
        typeof(Dropdown),
        typeof(InputField.OnChangeEvent),
        typeof(InputField.SubmitEvent),
        typeof(InputField.LineType),
        typeof(InputField.CharacterValidation),
        typeof(InputField.InputType),
        typeof(InputField.ContentType),
        typeof(GridLayoutGroup),
        typeof(ScrollRect),
        typeof(GridLayoutGroup.Constraint),
        typeof(GridLayoutGroup.Axis),
        typeof(GridLayoutGroup.Corner),
        typeof(HorizontalLayoutGroup),
        typeof(VerticalLayoutGroup),
        typeof(ContentSizeFitter),
        typeof(AspectRatioFitter),
        typeof(Image.Origin360),
        typeof(Image.Origin180),
        typeof(Image.Origin90),
        typeof(Image.OriginVertical),
        typeof(Image.OriginHorizontal),
        typeof(Image.FillMethod),
        typeof(Image.Type),
        typeof(MaskableGraphic),
        typeof(MaskableGraphic.CullStateChangedEvent),
        typeof(Graphic),
        typeof(Transform),
        typeof(RectTransform),
        typeof(Canvas),
        typeof(UnityEngine.CanvasRenderer),
        typeof(CanvasScaler.ScaleMode),
        typeof(CanvasScaler.ScreenMatchMode),
        typeof(CanvasScaler),
        typeof(UnityEngine.UI.Selectable),
        typeof(UnityEngine.UI.Selectable.Transition),
        typeof(UnityEngine.Events.UnityEventBase),
        typeof(UnityEngine.Events.UnityEvent),
        typeof(UnityEngine.Events.UnityEvent<string>),
        typeof(UnityEngine.EventSystems.UIBehaviour),


        typeof(DG.Tweening.Tween),
        typeof(DG.Tweening.Tweener),
        typeof(DG.Tweening.DOTween),
        typeof(DG.Tweening.TweenExtensions),
        typeof(DG.Tweening.ShortcutExtensions),
        //typeof(DG.Tweening.ShortcutExtensions43),
        typeof(DG.Tweening.ShortcutExtensions46),
        typeof(DG.Tweening.ShortcutExtensions50),
        typeof(DG.Tweening.TweenSettingsExtensions),
        typeof(DG.Tweening.Ease),
        typeof(DG.Tweening.LoopType),
        typeof(DG.Tweening.RotateMode),

        typeof(Camera),
        typeof(Vector2),
        typeof(Vector3),
        typeof(Quaternion),
        typeof(EventTrigger),
        typeof(EventTrigger.Entry),
        typeof(EventTriggerType),
        typeof(LayerMask),

        //self class
        typeof(EventTriggerSub),
        typeof(ResourceManager),
        typeof(TimerSystem),
        typeof(UISlots),
        typeof(ViewEffect),
        typeof(ToLuaUtility),
        typeof(LuaSystem),
    };

    //黑名单
    [BlackList]
    public static List<List<string>> BlackList = new List<List<string>>()  {
                new List<string>(){"System.Xml.XmlNodeList", "ItemOf"},
                new List<string>(){"UnityEngine.WWW", "movie"},
    #if UNITY_WEBGL
                new List<string>(){"UnityEngine.WWW", "threadPriority"},
    #endif
                new List<string>(){"UnityEngine.Security", "GetChainOfTrustValue"},
                new List<string>(){"UnityEngine.CanvasRenderer", "onRequestRebuild"},
                new List<string>(){"UnityEngine.Light", "areaSize"},
                new List<string>(){"UnityEngine.Light", "lightmapBakeType"},
                new List<string>(){"UnityEngine.WWW", "MovieTexture"},
                new List<string>(){"UnityEngine.WWW", "GetMovieTexture"},
                new List<string>(){"UnityEngine.AnimatorOverrideController", "PerformOverrideClipListCleanup"},
    #if !UNITY_WEBPLAYER
                new List<string>(){"UnityEngine.Application", "ExternalEval"},
    #endif
                new List<string>(){"UnityEngine.GameObject", "networkView"}, //4.6.2 not support
                new List<string>(){"UnityEngine.Component", "networkView"},  //4.6.2 not support
                new List<string>(){"System.IO.FileInfo", "GetAccessControl", "System.Security.AccessControl.AccessControlSections"},
                new List<string>(){"System.IO.FileInfo", "SetAccessControl", "System.Security.AccessControl.FileSecurity"},
                new List<string>(){"System.IO.DirectoryInfo", "GetAccessControl", "System.Security.AccessControl.AccessControlSections"},
                new List<string>(){"System.IO.DirectoryInfo", "SetAccessControl", "System.Security.AccessControl.DirectorySecurity"},
                new List<string>(){"System.IO.DirectoryInfo", "CreateSubdirectory", "System.String", "System.Security.AccessControl.DirectorySecurity"},
                new List<string>(){"System.IO.DirectoryInfo", "Create", "System.Security.AccessControl.DirectorySecurity"},
                new List<string>(){"UnityEngine.MonoBehaviour", "runInEditMode"},

                new List<string>(){"UnityEngine.QualitySettings", "streamingMipmapsRenderersPerFrame"},
                new List<string>(){"UnityEngine.Texture", "imageContentsHash"},
                new List<string>(){"UnityEngine.MonoBehaviour", "runInEditMode" },
                new List<string>(){"UnityEngine.Texture2D", "alphaIsTransparency" },
                new List<string>(){"UnityEngine.Input", "IsJoystickPreconfigured", "System.String" },
                new List<string>(){"UnityEngine.UI.Graphic", "OnRebuildRequested" },
                new List<string>(){"UnityEngine.UI.Text", "OnRebuildRequested" },
            };
}
