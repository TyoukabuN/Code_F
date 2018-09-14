﻿using System;
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
        typeof(RectTransform),
        typeof(Canvas),
        typeof(CanvasRenderer),
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
        typeof(LayerMask),

        //self clase
        typeof(EventTriggerSub),
        typeof(ResourceManager),
        typeof(UISlots),
        typeof(ViewEffect),
    };
}
