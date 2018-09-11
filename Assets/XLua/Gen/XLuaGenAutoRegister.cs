#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using System;
using System.Collections.Generic;
using System.Reflection;


namespace XLua.CSObjectWrap
{
    public class XLua_Gen_Initer_Register__
	{
        
        
        static void wrapInit0(LuaEnv luaenv, ObjectTranslator translator)
        {
        
            translator.DelayWrapLoader(typeof(UnityEngine.Behaviour), UnityEngineBehaviourWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.MonoBehaviour), UnityEngineMonoBehaviourWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.GameObject), UnityEngineGameObjectWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.TrackedReference), UnityEngineTrackedReferenceWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Application), UnityEngineApplicationWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Physics), UnityEnginePhysicsWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Collider), UnityEngineColliderWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Time), UnityEngineTimeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Texture), UnityEngineTextureWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Texture2D), UnityEngineTexture2DWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Shader), UnityEngineShaderWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Renderer), UnityEngineRendererWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.WWW), UnityEngineWWWWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Screen), UnityEngineScreenWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.CameraClearFlags), UnityEngineCameraClearFlagsWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.AudioClip), UnityEngineAudioClipWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.AssetBundle), UnityEngineAssetBundleWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.ParticleSystem), UnityEngineParticleSystemWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.AsyncOperation), UnityEngineAsyncOperationWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.LightType), UnityEngineLightTypeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.SleepTimeout), UnityEngineSleepTimeoutWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Animator), UnityEngineAnimatorWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Input), UnityEngineInputWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.KeyCode), UnityEngineKeyCodeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.SkinnedMeshRenderer), UnityEngineSkinnedMeshRendererWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Space), UnityEngineSpaceWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.TextAnchor), UnityEngineTextAnchorWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.MeshRenderer), UnityEngineMeshRendererWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.BoxCollider), UnityEngineBoxColliderWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.MeshCollider), UnityEngineMeshColliderWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.SphereCollider), UnityEngineSphereColliderWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.CharacterController), UnityEngineCharacterControllerWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.CapsuleCollider), UnityEngineCapsuleColliderWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Animation), UnityEngineAnimationWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.AnimationClip), UnityEngineAnimationClipWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.AnimationState), UnityEngineAnimationStateWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.AnimationBlendMode), UnityEngineAnimationBlendModeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.AnimationPlayMode), UnityEngineAnimationPlayModeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.QueueMode), UnityEngineQueueModeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.PlayMode), UnityEnginePlayModeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.WrapMode), UnityEngineWrapModeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.NetworkReachability), UnityEngineNetworkReachabilityWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.QualitySettings), UnityEngineQualitySettingsWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.RenderSettings), UnityEngineRenderSettingsWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.BlendWeights), UnityEngineBlendWeightsWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.RenderTexture), UnityEngineRenderTextureWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.RuntimePlatform), UnityEngineRuntimePlatformWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.AnimatorStateInfo), UnityEngineAnimatorStateInfoWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.TextAsset), UnityEngineTextAssetWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.PlayerPrefs), UnityEnginePlayerPrefsWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Rendering.ShadowCastingMode), UnityEngineRenderingShadowCastingModeWrap.__Register);
        
        }
        
        static void wrapInit1(LuaEnv luaenv, ObjectTranslator translator)
        {
        
            translator.DelayWrapLoader(typeof(UnityEngine.AI.NavMeshPath), UnityEngineAINavMeshPathWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.AI.NavMeshObstacle), UnityEngineAINavMeshObstacleWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.AI.ObstacleAvoidanceType), UnityEngineAIObstacleAvoidanceTypeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.AudioListener), UnityEngineAudioListenerWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.SystemInfo), UnityEngineSystemInfoWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Resolution), UnityEngineResolutionWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Debug), UnityEngineDebugWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Image), UnityEngineUIImageWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.ImageConversion), UnityEngineImageConversionWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Text), UnityEngineUITextWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Button), UnityEngineUIButtonWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Button.ButtonClickedEvent), UnityEngineUIButtonButtonClickedEventWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Toggle), UnityEngineUIToggleWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.ToggleGroup), UnityEngineUIToggleGroupWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.InputField), UnityEngineUIInputFieldWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Dropdown), UnityEngineUIDropdownWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.InputField.OnChangeEvent), UnityEngineUIInputFieldOnChangeEventWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.InputField.SubmitEvent), UnityEngineUIInputFieldSubmitEventWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.InputField.LineType), UnityEngineUIInputFieldLineTypeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.InputField.CharacterValidation), UnityEngineUIInputFieldCharacterValidationWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.InputField.InputType), UnityEngineUIInputFieldInputTypeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.InputField.ContentType), UnityEngineUIInputFieldContentTypeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.ScrollRect), UnityEngineUIScrollRectWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.GridLayoutGroup), UnityEngineUIGridLayoutGroupWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.GridLayoutGroup.Constraint), UnityEngineUIGridLayoutGroupConstraintWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.GridLayoutGroup.Axis), UnityEngineUIGridLayoutGroupAxisWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.GridLayoutGroup.Corner), UnityEngineUIGridLayoutGroupCornerWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.HorizontalLayoutGroup), UnityEngineUIHorizontalLayoutGroupWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.VerticalLayoutGroup), UnityEngineUIVerticalLayoutGroupWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.ContentSizeFitter), UnityEngineUIContentSizeFitterWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.AspectRatioFitter), UnityEngineUIAspectRatioFitterWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Image.Origin360), UnityEngineUIImageOrigin360Wrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Image.Origin180), UnityEngineUIImageOrigin180Wrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Image.Origin90), UnityEngineUIImageOrigin90Wrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Image.OriginVertical), UnityEngineUIImageOriginVerticalWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Image.OriginHorizontal), UnityEngineUIImageOriginHorizontalWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Image.FillMethod), UnityEngineUIImageFillMethodWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Image.Type), UnityEngineUIImageTypeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.MaskableGraphic), UnityEngineUIMaskableGraphicWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.MaskableGraphic.CullStateChangedEvent), UnityEngineUIMaskableGraphicCullStateChangedEventWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Graphic), UnityEngineUIGraphicWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Selectable), UnityEngineUISelectableWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.UI.Selectable.Transition), UnityEngineUISelectableTransitionWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Events.UnityEventBase), UnityEngineEventsUnityEventBaseWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Events.UnityEvent), UnityEngineEventsUnityEventWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Events.UnityEvent<string>), UnityEngineEventsUnityEvent_1_SystemString_Wrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.EventSystems.UIBehaviour), UnityEngineEventSystemsUIBehaviourWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(DG.Tweening.Tween), DGTweeningTweenWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(DG.Tweening.Tweener), DGTweeningTweenerWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(DG.Tweening.DOTween), DGTweeningDOTweenWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(DG.Tweening.TweenExtensions), DGTweeningTweenExtensionsWrap.__Register);
        
        }
        
        static void wrapInit2(LuaEnv luaenv, ObjectTranslator translator)
        {
        
            translator.DelayWrapLoader(typeof(DG.Tweening.ShortcutExtensions), DGTweeningShortcutExtensionsWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(DG.Tweening.ShortcutExtensions46), DGTweeningShortcutExtensions46Wrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(DG.Tweening.ShortcutExtensions50), DGTweeningShortcutExtensions50Wrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(DG.Tweening.TweenSettingsExtensions), DGTweeningTweenSettingsExtensionsWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(DG.Tweening.Ease), DGTweeningEaseWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(DG.Tweening.LoopType), DGTweeningLoopTypeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(DG.Tweening.RotateMode), DGTweeningRotateModeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Vector2), UnityEngineVector2Wrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Vector3), UnityEngineVector3Wrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.EventSystems.EventTrigger), UnityEngineEventSystemsEventTriggerWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.EventSystems.EventTrigger.Entry), UnityEngineEventSystemsEventTriggerEntryWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.EventSystems.EventTriggerType), UnityEngineEventSystemsEventTriggerTypeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(EventTriggerSub), EventTriggerSubWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(ResourceManager), ResourceManagerWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UISlots), UISlotsWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(ViewEffect), ViewEffectWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(LuaBehaviour), LuaBehaviourWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(XLuaTest.Pedding), XLuaTestPeddingWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(XLuaTest.MyStruct), XLuaTestMyStructWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(XLuaTest.MyEnum), XLuaTestMyEnumWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(XLuaTest.NoGc), XLuaTestNoGcWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.WaitForSeconds), UnityEngineWaitForSecondsWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(BaseTest), BaseTestWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(Foo1Parent), Foo1ParentWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(Foo2Parent), Foo2ParentWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(Foo1Child), Foo1ChildWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(Foo2Child), Foo2ChildWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(Foo), FooWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(FooExtension), FooExtensionWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(object), SystemObjectWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Object), UnityEngineObjectWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Vector4), UnityEngineVector4Wrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Quaternion), UnityEngineQuaternionWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Color), UnityEngineColorWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Ray), UnityEngineRayWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Bounds), UnityEngineBoundsWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Ray2D), UnityEngineRay2DWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Component), UnityEngineComponentWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Transform), UnityEngineTransformWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Resources), UnityEngineResourcesWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Keyframe), UnityEngineKeyframeWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.AnimationCurve), UnityEngineAnimationCurveWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Light), UnityEngineLightWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(UnityEngine.Mathf), UnityEngineMathfWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(System.Collections.Generic.List<int>), SystemCollectionsGenericList_1_SystemInt32_Wrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(Tutorial.BaseClass), TutorialBaseClassWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(Tutorial.TestEnum), TutorialTestEnumWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(Tutorial.DrivenClass), TutorialDrivenClassWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(Tutorial.DrivenClass.TestEnumInner), TutorialDrivenClassTestEnumInnerWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(Tutorial.ICalc), TutorialICalcWrap.__Register);
        
        
            translator.DelayWrapLoader(typeof(Tutorial.DrivenClassExtensions), TutorialDrivenClassExtensionsWrap.__Register);
        
        }
        
        
        
        
        
        static void Init(LuaEnv luaenv, ObjectTranslator translator)
        {
            
            wrapInit0(luaenv, translator);
            
            wrapInit1(luaenv, translator);
            
            wrapInit2(luaenv, translator);
            
            
            translator.AddInterfaceBridgeCreator(typeof(InvokeLua.ICalc), InvokeLuaICalcBridge.__Create);
            
            translator.AddInterfaceBridgeCreator(typeof(XLuaTest.IExchanger), XLuaTestIExchangerBridge.__Create);
            
            translator.AddInterfaceBridgeCreator(typeof(System.Collections.IEnumerator), SystemCollectionsIEnumeratorBridge.__Create);
            
            translator.AddInterfaceBridgeCreator(typeof(CSCallLua.ItfD), CSCallLuaItfDBridge.__Create);
            
        }
        
	    static XLua_Gen_Initer_Register__()
        {
		    XLua.LuaEnv.AddIniter(Init);
		}
		
		
	}
	
}
namespace XLua
{
	public partial class ObjectTranslator
	{
		static XLua.CSObjectWrap.XLua_Gen_Initer_Register__ s_gen_reg_dumb_obj = new XLua.CSObjectWrap.XLua_Gen_Initer_Register__();
		static XLua.CSObjectWrap.XLua_Gen_Initer_Register__ gen_reg_dumb_obj {get{return s_gen_reg_dumb_obj;}}
	}
	
	internal partial class InternalGlobals
    {
	    
	    static InternalGlobals()
		{
		    extensionMethodMap = new Dictionary<Type, IEnumerable<MethodInfo>>()
			{
			    
			};
			
			genTryArrayGetPtr = StaticLuaCallbacks.__tryArrayGet;
            genTryArraySetPtr = StaticLuaCallbacks.__tryArraySet;
		}
	}
}
