using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using XLua;

public static class LuaConfig {

    [CSharpCallLua]
    public static List<Type> CSharpCallLualist = new List<Type>
    {
        typeof(UnityEngine.Vector2),
        typeof(UnityEngine.Vector3),
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
        typeof(LightType),
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


        typeof(UnityEngine.UI.Image),
        typeof(UnityEngine.ImageConversion),
        typeof(UnityEngine.UI.Text),
        typeof(UnityEngine.UI.Button),
        typeof(UnityEngine.UI.Button.ButtonClickedEvent),
        typeof(UnityEngine.UI.Toggle),
        typeof(UnityEngine.UI.ToggleGroup),
        typeof(UnityEngine.UI.InputField),
        typeof(UnityEngine.UI.Dropdown),
        typeof(UnityEngine.UI.InputField.OnChangeEvent),
        typeof(UnityEngine.UI.InputField.SubmitEvent),
        typeof(UnityEngine.UI.InputField.LineType),
        typeof(UnityEngine.UI.InputField.CharacterValidation),
        typeof(UnityEngine.UI.InputField.InputType),
        typeof(UnityEngine.UI.InputField.ContentType),
        typeof(UnityEngine.UI.ScrollRect),
        typeof(UnityEngine.UI.GridLayoutGroup),
        typeof(UnityEngine.UI.ScrollRect),
        typeof(UnityEngine.UI.GridLayoutGroup.Constraint),
        typeof(UnityEngine.UI.GridLayoutGroup.Axis),
        typeof(UnityEngine.UI.GridLayoutGroup.Corner),
        typeof(UnityEngine.UI.HorizontalLayoutGroup),
        typeof(UnityEngine.UI.VerticalLayoutGroup),
        typeof(UnityEngine.UI.ContentSizeFitter),
        typeof(UnityEngine.UI.AspectRatioFitter),
        typeof(UnityEngine.UI.Image.Origin360),
        typeof(UnityEngine.UI.Image.Origin180),
        typeof(UnityEngine.UI.Image.Origin90),
        typeof(UnityEngine.UI.Image.OriginVertical),
        typeof(UnityEngine.UI.Image.OriginHorizontal),
        typeof(UnityEngine.UI.Image.FillMethod),
        typeof(UnityEngine.UI.Image.Type),
        typeof(UnityEngine.UI.MaskableGraphic),
        typeof(UnityEngine.UI.MaskableGraphic.CullStateChangedEvent),
        typeof(UnityEngine.UI.Graphic),
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

        typeof(Vector2),
        typeof(Vector3),
        typeof(EventTrigger),
        typeof(EventTrigger.Entry),
        typeof(EventTriggerType),

        //self clase
        typeof(EventTriggerSub),
        typeof(ResourceManager),
        typeof(UISlots),
        typeof(ViewEffect),
    };
}
