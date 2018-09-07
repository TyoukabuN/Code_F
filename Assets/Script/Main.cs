using System.Collections;
using System.Collections.Generic;
using System.IO;
using System;
using UnityEngine;
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
    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

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
        //    ResourceManager.LoadAsyc(path, typeof(GameObject),(UnityEngine.Object obj)=> { GameObject.Instantiate(obj as GameObject); });
        //}
        if (GUI.Button(new Rect(rect.x, posY, width, height),"OP", style))//+rect.width
        {
            string filePath = "HoTFixTest";
            LuaSystem.DoString(LuaLoader(filePath));
        }
        //if (GUI.Button(new Rect(rect.x + rect.width*2, posY, width, height), "Excel"))
        //{
        //    string filePath = @"F:/WorkSpace/Project/tools/excel/xls/M-秘境夺宝.xlsx";
        //    //ExcelTool.ExcelToLuaTable(filePath, "C:/Users/Administrator/Desktop");
        //}
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
