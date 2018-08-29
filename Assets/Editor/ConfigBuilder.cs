using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.IO;

public class ConfigBuilder : EditorWindow
{

    //some default value
    private static string path = "F:/WorkSpace/Project/tools/excel/xls";
    private static string savePath = "C:/Users/Administrator/Desktop/Config";

    [MenuItem("Tool/ConfigBuilder")]
    public static void Open()
    {
        GetWindow(typeof(ConfigBuilder), false, nameof(ConfigBuilder));
    }

    private ConfigBuilderData configBuilderData = null;

    void OnEnable()
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
                configBuilderData.ConfigPath = path;
                var path1 = dataPath.Substring(dataPath.LastIndexOf("Assets"));
                AssetDatabase.CreateAsset(configBuilderData, path1);
                AssetDatabase.Refresh();
            }
        }
    }
    void Start()
    {
    }
    void OnGUI()
    {
        EditorGUILayout.BeginHorizontal("HelpBox");
        //EditorGUILayout.LabelField("SavePath:",GUILayout.Width(60));
        savePath = EditorGUILayout.TextField("SavePath:", savePath);
        if (GUILayout.Button("Select", GUILayout.Width(60)))
        {
            savePath = EditorUtility.SaveFolderPanel("SelectSavePath", savePath, savePath);
            if (!savePath.Equals(string.Empty))
            {
                configBuilderData.SavePath = savePath;
                EditorUtility.SetDirty(configBuilderData);
                AssetDatabase.SaveAssets();
            }
        }
        EditorGUILayout.EndHorizontal();
        //
        EditorGUILayout.BeginHorizontal("HelpBox");
        path = EditorGUILayout.TextField(path);
        if (GUILayout.Button("Select", GUILayout.Width(60)))
        {
            path = EditorUtility.SaveFolderPanel("SelectConfigPath", path, path);
            if (!path.Equals(string.Empty))
            {
                configBuilderData.ConfigPath = path;
                EditorUtility.SetDirty(configBuilderData);
                AssetDatabase.SaveAssets();
            }
        }
        if (GUILayout.Button("Build", GUILayout.Width(60)))
        {
            EditorApplication.update = () => {
                DirectoryInfo dir = new DirectoryInfo(path);
                if (!dir.Exists)
                {
                    EditorUtility.DisplayDialog("error", "find not directory", "ok");
                    return;
                }
                FileInfo[] fileInfos = dir.GetFiles();
                foreach (FileInfo fileInfo in fileInfos)
                {
                    if (!ExcelTool.ExcelToLuaTable(fileInfo.FullName, savePath))
                    {
                        continue;
                    }
                }
                EditorApplication.update = null;
            };
        }
        EditorGUILayout.EndHorizontal();
    }
    // Update is called once per frame
    void Update()
    {
        Repaint();
    }
}
