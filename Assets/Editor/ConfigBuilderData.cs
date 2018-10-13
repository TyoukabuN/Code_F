using UnityEngine;
using UnityEditor;
using System.IO;

public class ConfigBuilderData : ScriptableObject{

    /// <summary>
    /// 配置表路径
    /// </summary>
    public string ConfigPath = string.Empty;

    /// <summary>
    /// 保存路径
    /// </summary>
    public string SavePath = string.Empty;

    private readonly static string dataPath = "Assets/Editor/EditorData/ConfigBuilderData.asset";

    public static ConfigBuilderData instance
    {
        get {
            if (configBuilderData == null)
            {
                configBuilderData = AssetDatabase.LoadAssetAtPath<ConfigBuilderData>(dataPath);
                if (configBuilderData == null)
                {
                    FileInfo fileInfo = new FileInfo(dataPath);
                    if (!fileInfo.Directory.Exists)
                    {
                        fileInfo.Directory.Create();
                    }
                    configBuilderData = new ConfigBuilderData();
                    AssetDatabase.CreateAsset(configBuilderData, dataPath);
                    AssetDatabase.Refresh();
                }
            }
            return configBuilderData;
        }
    }

    private static ConfigBuilderData configBuilderData = null;
}
