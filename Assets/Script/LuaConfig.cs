using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using XLua;

public class LuaConfig : MonoBehaviour {

    [LuaCallCSharp]
    public static new List<Type> luaCallCSharpList = new List<Type>
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
    };
}
