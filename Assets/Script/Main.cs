using System.Collections;
using System.Collections.Generic;
using System.IO;
using System;
using UnityEngine;
using UnityEngine.EventSystems;
#if UNITY_EDITOR
    using UnityEditor;
#endif
using XLua;

public class Main : MonoBehaviour
{
    void Awake()
    {
        LuaSystem.Init();
    }

    void OnGUI()
    {
        var style = new GUIStyle
        {
            fixedWidth = 100,
            fixedHeight = 100,
            normal = { textColor = Color.yellow },
            fontSize = 36,
        };
        float width = 100;
        float height = 100;
        float posX = 0;
        float posY = 0;//Screen.height - height;
        Rect rect = new Rect(posX, posY, width, height);
        //          test for resourseManager
        //if (GUI.Button(rect, "Load"))
        //{
        //    //同步加载
        //    //string path = @"UI/Panel/SlotMachine.prefab";
        //    //var goj = ResourceManager.Load(path, typeof(GameObject));
        //    //string path = "slotmachine";
        //    //var asset = BundleManager.GetAsset(path, typeof(GameObject));
        //    //var goj = GameObject.Instantiate(asset as GameObject);

        //    //异步
        //    string path = "UI/Panel/slotmachine";
        //    ResourceManager.LoadAsync(path, typeof(GameObject),(UnityEngine.Object obj)=> { GameObject.Instantiate(obj as GameObject); });
        //}
        if (GUI.Button(new Rect(rect.x, posY, width, height),"OP"))//+rect.width
        {
            string filePath = "HoTFixTest";
            LuaSystem.DoString(LuaLoader(filePath));
        }
    }

    public static string LuaLoader(string filepath)
    {
        string path = string.Empty;
#if UNITY_EDITOR
        path = Application.dataPath + "/Lua/" + filepath + ".lua";
#endif
        return File.ReadAllText(path);
    }

    public static void ClearConsole()
    {
        var logEntries = System.Type.GetType("UnityEditorInternal.LogEntries,UnityEditor.dll");
        var clearMethod = logEntries.GetMethod("Clear", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public);
        clearMethod.Invoke(null, null);
    }
}
