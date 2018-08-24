using UnityEngine;
using UnityEngine.UI;
using UnityEditor;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine.Events;

/// <summary>
/// 游戏对象工具
/// </summary>
public sealed class GameObjectTool
{
    private const string FORMAT_PATH = "{0}/{1}";
    private const string FORMAT_LINES = "{0}\n{1}";
    private const string METHOD_PLAY = "Play";
    private const string ASSET_BUTTON_ANIMATOR = "Assets/UI/Animation/Button.controller";
    private const string METHOD_ADD_EVENT = "AddPersistentListener";
    private const string METHOD_PLAY_SOUND = "PlaySound";

    //[MenuItem("GameObject/UI/Add Button Sound", true)]
    //public static bool CheckAddButtonSound()
    //{
    //    if (Selection.activeGameObject == null)
    //    {
    //        return false;
    //    }

    //    return Selection.activeGameObject.GetComponent<Selectable>() != null;
    //}

    //[MenuItem("GameObject/UI/Add Button Sound")]
    //public static void AddButtonSound()
    //{
    //    for (int i = 0; i < Selection.gameObjects.Length; ++i)
    //    {
    //        AddButtonSound(Selection.gameObjects[i]);
    //    }
    //}

    //[MenuItem("GameObject/UI/Add Button Sound And Animation", true)]
    //public static bool CheckAddButtonSoundAndAnimation()
    //{
    //    if (Selection.activeGameObject == null)
    //    {
    //        return false;
    //    }

    //    return Selection.activeGameObject.GetComponent<Selectable>() != null;
    //}

    //[MenuItem("GameObject/UI/Add Button Sound And Animation")]
    //public static void AddButtonSoundAndAnimation()
    //{
    //    for (int i = 0; i < Selection.gameObjects.Length; ++i)
    //    {
    //        AddButtonSound(Selection.gameObjects[i]);
    //        AddButtonAnimation(Selection.gameObjects[i]);
    //    }
    //}

    //private static void AddButtonSound(GameObject gameObject)
    //{
    //    Button button = gameObject.GetComponent<Button>();
    //    if (null != button)
    //    {
    //        AddButtonEvent(gameObject, button.onClick);

    //        return;
    //    }

    //    Toggle toggle = gameObject.GetComponent<Toggle>();
    //    if (null != toggle)
    //    {
    //        AddButtonEvent(gameObject, toggle.onValueChanged);

    //        return;
    //    }
    //}

    //private static void AddButtonEvent(GameObject gameObject, UnityEventBase unityEvent)
    //{
    //    UIButtonSound buttonSound = gameObject.GetComponent<UIButtonSound>();
    //    if (buttonSound == null)
    //    {
    //        buttonSound = gameObject.AddComponent<UIButtonSound>();
    //    }

    //    for (int i = 0; i < unityEvent.GetPersistentEventCount(); ++i)
    //    {
    //        string methodName = unityEvent.GetPersistentMethodName(i);
    //        if (methodName == METHOD_PLAY_SOUND)
    //        {
    //            return;
    //        }
    //    }

    //    MethodInfo[] methodInfos = unityEvent.GetType().GetMethods(BindingFlags.Instance | BindingFlags.NonPublic);
    //    for (int i = 0; i < methodInfos.Length; ++i)
    //    {
    //        MethodInfo methodInfo = methodInfos[i];
    //        if (methodInfo.Name == METHOD_ADD_EVENT)
    //        {
    //            object callback = null;
    //            if (unityEvent is UnityEvent<bool>)
    //            {
    //                callback = new UnityAction<bool>(buttonSound.PlaySound);
    //            }
    //            else
    //            {
    //                callback = new UnityAction(buttonSound.PlaySound);
    //            }

    //            methodInfo.Invoke(unityEvent, new object[] { callback });

    //            break;
    //        }
    //    }
    //}

    private static void AddButtonAnimation(GameObject gameObject)
    {
        Selectable selectable = gameObject.GetComponent<Selectable>();
        selectable.transition = Selectable.Transition.Animation;

        Animator animator = gameObject.GetComponent<Animator>();
        if (animator == null)
        {
            animator = gameObject.AddComponent<Animator>();
        }
        animator.runtimeAnimatorController = AssetDatabase.LoadAssetAtPath<RuntimeAnimatorController>(ASSET_BUTTON_ANIMATOR);
    }

    [MenuItem("GameObject/UI/Copy Root Path", true)]
    public static bool CheckCopyRootPath()
    {
        return Selection.activeGameObject != null;
    }

    [MenuItem("GameObject/UI/Copy Root Path")]
    public static void CopyRootPath()
    {
        GameObject gameObject = Selection.activeGameObject;
        if (gameObject == null)
        {
            return;
        }

        string path = gameObject.name;
        if (gameObject.transform.root != null && gameObject.transform != gameObject.transform.root)
        {
            Transform parent = gameObject.transform;
            while (true)
            {
                parent = parent.parent;
                if (parent == gameObject.transform.root)
                {
                    break;
                }

                path = string.Format(FORMAT_PATH, parent.name, path);
            }
        }
        TextEditor textEditor = new TextEditor();
        textEditor.text = path;
        textEditor.OnFocus();
        textEditor.Copy();
        Debug.Log(path);
    }

    [MenuItem("Assets/Copy Files Name")]
    public static void CopyFilesName()
    {
        List<Object> objects = new List<Object>(Selection.objects);
        objects.Sort((obj1, obj2) =>
        {
            return obj1.name.CompareTo(obj2.name);
        });

        string text = string.Empty;
        for (int i = 0; i < objects.Count; ++i)
        {
            Object obj = objects[i];
            text = i == 0 ? obj.name : string.Format(FORMAT_LINES, text, obj.name);
        }

        TextEditor textEditor = new TextEditor();
        textEditor.text = text;
        textEditor.OnFocus();
        textEditor.Copy();
        Debug.Log(text);
    }
    [MenuItem("Assets/Copy The Role AnimationClipsInfo form Animator", true)]
    public static bool CheckCopyRoleAnimationClipsInfo()
    {
        return Selection.activeObject is GameObject;
    }


    //[MenuItem("Assets/Copy The Role AnimationClipsInfo form Animator")]
    //public static void CopyRoleAnimationClipsInfo()
    //{
    //    var ass = Selection.GetFiltered(typeof(object), SelectionMode.TopLevel);
    //    string text = string.Empty;
    //    foreach (var asset in ass)
    //    {
    //        string path = AssetDatabase.GetAssetPath(asset).Replace("Assets/", string.Empty).ToLower().Replace(".prefab", ".bundle");
    //        GameObject gameObject = asset as GameObject;
    //        Animator animator = gameObject.GetComponent<Animator>();
    //        //获取配置头
    //        var roleData = Framework.DataSystem.GetData("Fashion", "Resource", path);
    //        var configPre = roleData.Get("AnimaConfigPre");
    //        //获取动画配置
    //        if (animator != null)
    //        {
    //            var clipList = animator.runtimeAnimatorController.animationClips;
    //            foreach (var clip in clipList)
    //            {
    //                if (clip.name != null)
    //                {
    //                    var name = Framework.DataSystem.GetData("Action", "Name", clip.name.ToLower());
    //                    int id = int.Parse(name.Get("TemplateId").ToString());
    //                    int actionId = id + int.Parse(configPre.ToString());
    //                    string temp = string.Format("{0}{1}{2}{3}{4}{5}", actionId, "\t", clip.name, "\t", clip.length, "\n");
    //                    text = text.Insert(text.Length, temp);
    //                }
    //            }
    //        }
    //    }
    //    text = text.Substring(0, text.LastIndexOf("\n"));
    //    TextEditor textEditor = new TextEditor();
    //    textEditor.text = text;
    //    textEditor.OnFocus();
    //    textEditor.Copy();
    //    Debug.Log(text);
    //}

    [MenuItem("Assets/Copy The AnimationClipsInfo form Animator", true)]
    public static bool CheckCopyAnimationClipsInfo()
    {
        return Selection.activeObject is GameObject;
    }

    [MenuItem("Assets/Copy The AnimationClipsInfo form Animator")]
    public static void CopyAnimationClipsInfo()
    {
        var ass = Selection.GetFiltered(typeof(object), SelectionMode.TopLevel);
        string text = string.Empty;
        foreach (var asset in ass)
        {
            GameObject gameObject = asset as GameObject;
            Animator animator = gameObject.GetComponent<Animator>();
            //获取动画配置
            if (animator != null)
            {
                var clipList = animator.runtimeAnimatorController.animationClips;
                if (clipList[0] != null)
                {
                    if (clipList[0].name != null)
                    {
                        string temp = string.Format("{0}{1}{2}{3}", clipList[0].name, "\t", clipList[0].length, "\n");
                        text = text.Insert(text.Length, temp);
                    }
                }
            }
        }
        text = text.Substring(0, text.LastIndexOf("\n"));
        TextEditor textEditor = new TextEditor();
        textEditor.text = text;
        textEditor.OnFocus();
        textEditor.Copy();
        Debug.Log(text);
    }

    [MenuItem("Assets/Copy The AudioClip Length", true)]
    public static bool CheckCopyAudioClipLength()
    {
        return Selection.activeObject is AudioClip;
    }
    [MenuItem("Assets/Copy The AudioClip Length")]
    public static void CopyAudioClipLength()
    {
        var ass = Selection.GetFiltered(typeof(object), SelectionMode.TopLevel);
        var clip = ass[0] as AudioClip;
        string text = clip.length.ToString();
        TextEditor textEditor = new TextEditor();
        textEditor.text = text;
        textEditor.OnFocus();
        textEditor.Copy();
        Debug.Log(text);
    }

    [MenuItem("Assets/Copy The RoomChat AudioClip Length", true)]
    public static bool CheckCopyRoomChatAudioClipLength()
    {
        return Selection.activeObject is AudioClip;
    }

    //[MenuItem("Assets/Copy The RoomChat AudioClip Length")]
    //public static void CopyRoomChatAudioClipLength()
    //{
    //    var ass = Selection.GetFiltered(typeof(object), SelectionMode.TopLevel);
    //    string text = string.Empty;
    //    var datas = Framework.DataSystem.GetAllDatas("Chat");
    //    foreach (var data in datas)
    //    {
    //        string length1 = "";
    //        string length2 = "";
    //        foreach (var asset in ass)
    //        {
    //            AudioClip clip = asset as AudioClip;
    //            if (string.Equals(clip.name, data.Get("ManSound").ToString()))
    //            {
    //                length1 = clip.length.ToString();
    //            }
    //            if (string.Equals(clip.name, data.Get("WomanSound").ToString()))
    //            {
    //                length2 = clip.length.ToString();
    //            }
    //        }
    //        string temp = string.Format("{0}{1}{2}{3}", length1, "\t", length2, "\n");
    //        text = text.Insert(text.Length, temp);
    //    }
    //    text = text.Substring(0, text.LastIndexOf("\n"));
    //    TextEditor textEditor = new TextEditor();
    //    textEditor.text = text;
    //    textEditor.OnFocus();
    //    textEditor.Copy();
    //    Debug.Log(text);
    //}
}

