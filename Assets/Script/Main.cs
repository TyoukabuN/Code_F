using System.Collections;
using System.Collections.Generic;
using System.IO;
using DG.Tweening;
using System;
using UnityEngine;
using UnityEngine.Networking;
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
        TimeSpan timeSpa1n = DateTime.Today.ToUniversalTime() - new DateTime(1970, 1, 1);
        //错误日志
        Application.logMessageReceived += (string condition, string stackTrace, LogType type) =>
        {
            if (type.Equals(LogType.Exception) || type.Equals(LogType.Error)) {

                TimeSpan timeSpan = DateTime.UtcNow - new DateTime(1970, 1, 1,0,0,0);
                
                string timeStamp = ((int)timeSpan.TotalSeconds).ToString();

                string hostName = System.Net.Dns.GetHostName();
                string userName = System.Environment.UserName;
                string machineName = System.Environment.MachineName;

                ToLuaUtility.HttpPostRequest("http://192.168.8.213/errlog.php",
                    (UnityWebRequest req) => { Debug.Log(req.downloadHandler.text); }, "", "submit", 
                    "logType", type.ToString(), 
                    "condition", condition, 
                    "stackTrace", stackTrace,
                    "timeStamp", timeStamp,
                    "hostName", hostName,
                    "userName", userName,
                    "machineName", machineName
                    );
            }
        };
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

            //ToLuaUtility.HttpPostRequest("http://192.168.8.213/errlog.php",
            //        (UnityWebRequest req) => { Debug.Log(req.downloadHandler.text); }, "", "submit", "logType", ((int)LogType.Error).ToString(), "condition", "condition", "stackTrace", "stackTrace");
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
