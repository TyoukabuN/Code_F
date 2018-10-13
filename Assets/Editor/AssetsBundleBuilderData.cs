using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class AssetsBundleBuilderData : ScriptableObject {

    /// <summary>
    ///  输出路径
    /// </summary>
    public string OutputPath = string.Empty;

    /// <summary>
    /// 保存路径
    /// </summary>
    private readonly static string dataPath = "Assets/Editor/EditorData/AssetsBundleBuilderData.asset";

    public static AssetsBundleBuilderData instance
    {
        get {
            if (_instance == null)
            {
                _instance = AssetDatabase.LoadAssetAtPath<AssetsBundleBuilderData>(dataPath);
                if (_instance == null) {
                    FileInfo fileInfo = new FileInfo(dataPath);
                    if (!fileInfo.Directory.Exists)
                    {
                        fileInfo.Directory.Create();
                    }
                    _instance = new AssetsBundleBuilderData();
                    AssetDatabase.CreateAsset(_instance, dataPath);
                    AssetDatabase.Refresh();
                }
            }
            return _instance;
        }
    }

    private static AssetsBundleBuilderData _instance = null;
}
