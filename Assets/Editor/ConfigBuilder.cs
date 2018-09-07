using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.IO;

public class ConfigBuilder : EditorWindow
{

    //some default value
    private static string configPath = "F:/WorkSpace/Project/tools/excel/xls";
    private static string savePath = "C:/Users/Administrator/Desktop/Config";

    [MenuItem("Tool/ConfigBuilder")]
    public static void Open()
    {
        GetWindow(typeof(ConfigBuilder), false, "ConfigBuilder");
    }

    private ConfigBuilderData configBuilderData = null;

    private void CheckData()
    {
        if (configBuilderData == null)
        {
            string dataPath = Application.dataPath + "/Editor/EditorData/ConfigBuilderData.asset";

            configBuilderData = AssetDatabase.LoadAssetAtPath<ConfigBuilderData>(dataPath);
            if (configBuilderData == null)
            {
                DirectoryInfo dir = new DirectoryInfo(dataPath.Substring(0, dataPath.LastIndexOf('/')));
                if (!dir.Exists)
                {
                    dir.Create();
                }

                configBuilderData = CreateInstance<ConfigBuilderData>();
                configBuilderData.SavePath = savePath;
                configBuilderData.ConfigPath = configPath;

                var path1 = dataPath.Substring(dataPath.LastIndexOf("Assets"));
                AssetDatabase.CreateAsset(configBuilderData, path1);
                AssetDatabase.Refresh();
            }

            configPath = configBuilderData.ConfigPath;
            savePath = configBuilderData.SavePath;
        }
    }

    void OnGUI()
    {
        CheckData();

        //
        EditorGUILayout.BeginHorizontal("HelpBox");

        configPath = EditorGUILayout.TextField(configPath);
        if (GUILayout.Button("Select", GUILayout.Width(60)))
        {
            string path = EditorUtility.SaveFolderPanel("SelectConfigPath", configPath, string.Empty);
            if (!path.Equals(string.Empty))
            {
                configPath = configBuilderData.ConfigPath = path;
                SaveConfigData();
            }
        }

        if (GUILayout.Button("NPOI", GUILayout.Width(60)))
        {
            DirectoryInfo dir = new DirectoryInfo(configPath);
            if (!dir.Exists)
            {
                EditorUtility.DisplayDialog("error", "find not directory", "ok");
                return;
            }

            FileInfo[] fileInfos = dir.GetFiles();
            foreach (FileInfo fileInfo in fileInfos)
            {
                if (!ExcelTool.ExcelToLuaTableNPOT(fileInfo.FullName, savePath + "/NPOI"))
                {
                    continue;
                }
            }
        }

        if (GUILayout.Button("EPPlus", GUILayout.Width(60)))
        {
            DirectoryInfo dir = new DirectoryInfo(configPath);
            if (!dir.Exists)
            {
                EditorUtility.DisplayDialog("error", "find not directory", "ok");
                return;
            }

            FileInfo[] fileInfos = dir.GetFiles();
            foreach (FileInfo fileInfo in fileInfos)
            {
                if (!ExcelTool.ExcelToLuaTableEPPlus(fileInfo.FullName, savePath+ "/EPPlus"))
                {
                    continue;
                }
            }
        }

        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal("HelpBox");

        savePath = EditorGUILayout.TextField("SavePath:", savePath);
        if (GUILayout.Button("Select", GUILayout.Width(60)))
        {
            string path = EditorUtility.SaveFolderPanel("SelectSavePath", savePath, string.Empty);
            if (!path.Equals(string.Empty))
            {
                savePath = configBuilderData.SavePath = path;
                SaveConfigData();
            }
        }

        EditorGUILayout.EndHorizontal();
    }
    private void SaveConfigData()
    {
        if (configBuilderData)
        {
            EditorUtility.SetDirty(configBuilderData);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
        }
    }
    void Update()
    {
        Repaint();
    }
}