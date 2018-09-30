using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.IO;

public class ConfigBuilder : EditorWindow
{

    //some default value
    private static string configPath = string.Empty;//"F:/WorkSpace/Project/tools/excel/xls";
    private static string savePath = string.Empty;//"C:/Users/Administrator/Desktop/Config";

    private static readonly int BUTTON_WIDTH = 45;

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
            configBuilderData = ConfigBuilderData.instance;
        }
        if (configPath != configBuilderData.ConfigPath) {
            configPath = configBuilderData.ConfigPath;
            savePath = configBuilderData.SavePath;
        }
    }

    void OnGUI()
    {
        CheckData();

        //
        EditorGUILayout.BeginHorizontal("HelpBox");

        EditorGUILayout.LabelField("ConfigPath:", GUILayout.Width(120));
        EditorGUILayout.LabelField(configPath);


        if (GUILayout.Button("NPOI", GUILayout.Width(BUTTON_WIDTH)))
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
                if (!ExcelTool.ExcelToLuaTableNPOT(fileInfo.FullName, savePath + ""))
                {
                    continue;
                }
            }
        }

        if (GUILayout.Button("Kiang", GUILayout.Width(BUTTON_WIDTH)))
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
                if (!ExcelTool.ExcelToLuaTableNPOTKiang(fileInfo.FullName, savePath + ""))
                {
                    continue;
                }
            }
        }

        if (GUILayout.Button("Select", GUILayout.Width(BUTTON_WIDTH)))
        {
            string path = EditorUtility.SaveFolderPanel("SelectConfigPath", configPath, string.Empty);
            if (!path.Equals(string.Empty))
            {
                configPath = configBuilderData.ConfigPath = path;
                SaveConfigData();
            }
        }
        if(GUILayout.Button("Open",GUILayout.Width(BUTTON_WIDTH)))
        {
            System.Diagnostics.Process.Start("explorer.exe", configPath.Replace("/", "\\"));
        }
        //if (GUILayout.Button("EPPlus", GUILayout.Width(BUTTON_WIDTH)))
        //{
        //    DirectoryInfo dir = new DirectoryInfo(configPath);
        //    if (!dir.Exists)
        //    {
        //        EditorUtility.DisplayDialog("error", "find not directory", "ok");
        //        return;
        //    }

        //    FileInfo[] fileInfos = dir.GetFiles();
        //    foreach (FileInfo fileInfo in fileInfos)
        //    {
        //        if (!ExcelTool.ExcelToLuaTableEPPlus(fileInfo.FullName, savePath+ "/EPPlus"))
        //        {
        //            continue;
        //        }
        //    }
        //}

        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal("HelpBox");
        EditorGUILayout.LabelField("SavePath:",GUILayout.Width(120));
        EditorGUILayout.LabelField(savePath);
        if (GUILayout.Button("Select", GUILayout.Width(BUTTON_WIDTH)))
        {
            string path = EditorUtility.SaveFolderPanel("SelectSavePath", savePath, string.Empty);
            if (!path.Equals(string.Empty))
            {
                savePath = configBuilderData.SavePath = path;
                SaveConfigData();
            }
        }
        if (GUILayout.Button("Open", GUILayout.Width(BUTTON_WIDTH)))
        {
            System.Diagnostics.Process.Start("explorer.exe", savePath.Replace("/","\\"));
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