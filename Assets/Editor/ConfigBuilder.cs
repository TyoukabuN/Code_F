using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.IO;

public class ConfigBuilder : EditorWindow {

    private static string path = "F:/WorkSpace/Project/tools/excel/xls";
    private static string savePath = "C:/Users/Administrator/Desktop/Config";

    [MenuItem("Tool/ConfigBuilder")]
    public static void Open()
    {
        GetWindow(typeof(ConfigBuilder),false,nameof(ConfigBuilder));
    }
	// Use this for initialization
	void Start () {
		
	}
    void OnGUI()
    {
        EditorGUILayout.BeginHorizontal("HelpBox");
        //EditorGUILayout.LabelField("SavePath:",GUILayout.Width(60));
        savePath = EditorGUILayout.TextField("SavePath:",savePath);
        if (GUILayout.Button("Select", GUILayout.Width(60)))
        {
            savePath = EditorUtility.SaveFolderPanel("SelectSavePath", savePath, savePath);
        }
        EditorGUILayout.EndHorizontal();
        //
        EditorGUILayout.BeginHorizontal("HelpBox");
        path = EditorGUILayout.TextField(path);
        if (GUILayout.Button("Select", GUILayout.Width(60)))
        {
            path = EditorUtility.SaveFolderPanel("SelectConfigPath", path, path);
        }
        if (GUILayout.Button("Build",GUILayout.Width(60)))
        {
            DirectoryInfo dir = new DirectoryInfo(path);
            if (!dir.Exists)
            {
                EditorUtility.DisplayDialog("error", "find not directory", "ok");
                return;
            }
            FileInfo[] fileInfos = dir.GetFiles();
            foreach(FileInfo fileInfo in fileInfos)
            {
                if (!ExcelTool.ExcelToLuaTable(fileInfo.FullName, savePath))
                {
                    continue;
                }
            }
        }
        EditorGUILayout.EndHorizontal();
    }
	// Update is called once per frame
	void Update () {
        Repaint();
    }
}
