using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;

using UnityEngine.Windows;
using Directory = System.IO.Directory;

public class AssetTest : EditorWindow
{
    public string Select = string.Empty;

    public string CustomFileSavePath = string.Empty;

    public string FilterSelect = string.Empty;

    public string AssetBundleName = string.Empty;

    public string OutputPath = string.Empty;

    private Vector2 _scrollViewPos = Vector2.zero;
	void Start () {
		
	}
    [MenuItem("Bundle实验/打包窗口")]
    static void Init()
    {
        EditorWindow.GetWindow<AssetTest>(false, "AssetCreater", true);//创建窗口
    }
    private void OnGUI()
    {
        _scrollViewPos = GUILayout.BeginScrollView(_scrollViewPos,false,true);
        //选择内容过滤器
        var ass = Selection.GetFiltered(typeof(object), SelectionMode.DeepAssets);
        // 包的内容(path)
        List<string> assetNames = new List<string>();
        //选中obj在assets下的路径
        string path = string.Empty;
        foreach (var gojp in ass)
        {
            //显示用
            string p = AssetDatabase.GetAssetPath(gojp);
            path = path.Insert(path.Length, p + "\n");
            //数据处理用
            assetNames.Add(p);
        }
        GUIStyle style = new GUIStyle { normal = { textColor = Color.yellow } };

        GUILayout.Label("Application.dataPath: ");
        GUILayout.Label(Application.dataPath, style);

        string noAssetPath = Application.dataPath.Substring(0, Application.dataPath.LastIndexOf('/'));
        GUILayout.Label("Application.dataPath(noAssetPath): ");
        GUILayout.Label(noAssetPath, style);

        string persistentDataPath = Application.persistentDataPath;
        GUILayout.Label("Application.persistentDataPath: ");
        GUILayout.Label(persistentDataPath, style);

        string streamingAssetsPath = Application.streamingAssetsPath;
        GUILayout.Label("Application.streamingAssetsPath: ");
        GUILayout.Label(streamingAssetsPath, style);

        string temporaryCachePath = Application.temporaryCachePath;
        GUILayout.Label("Application.temporaryCachePath: ");
        GUILayout.Label(temporaryCachePath, style);
        
        //PathTest();

        //打包操作
        GUILayout.Space(20);

        GUILayout.Label("AssetBundleName(包名):");
        AssetBundleName = EditorGUILayout.TextField("AssetBundleName:", AssetBundleName);
        GUILayout.Label("SelectedFilePath(打包内容):");
        EditorGUILayout.TextArea(path);

        EditorGUILayout.BeginHorizontal();
        GUILayout.Label("OutPutPath(输出路径)null会帮你创建的:");
        OutputPath = EditorGUILayout.TextField(OutputPath);
        if (GUILayout.Button("Select"))
        {
            OutputPath =EditorUtility.SaveFolderPanel("你包TM的保存路径", OutputPath, string.Empty);
        }
        EditorGUILayout.EndHorizontal();

        GUILayout.BeginHorizontal();

        GUILayout.EndHorizontal();
        if (GUILayout.Button("Build"))
        {
            AssetBundleBuild[] assetBundle = new AssetBundleBuild[1];
            Debug.Log(AssetBundleName);
            assetBundle[0].assetBundleName = AssetBundleName;
            assetBundle[0].assetNames = assetNames.ToArray();
            Debug.Log(assetNames[0]);
            //assetBundle[0].assetBundleVariant
            if (string.IsNullOrEmpty(OutputPath))
            {
                OutputPath = streamingAssetsPath;
            }
            if (!Directory.Exists(OutputPath))
            {
                Directory.CreateDirectory(OutputPath);
            }
            BuildPipeline.BuildAssetBundles(OutputPath, assetBundle, BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows64);
        }
        GUILayout.EndScrollView();
    }

    private void OnSelectionChange()
    {
#if UNITY_EDITOR
        //选择更新(窗口关注)
        //FocusWindowIfItsOpen<AssetTest>();Bug:会无限聚焦这个窗口
        
#endif
        var s = Selection.GetFiltered(typeof (object), SelectionMode.DeepAssets);
        if (s.Length > 0)
        {
            AssetBundleName = Selection.GetFiltered(typeof(object), SelectionMode.DeepAssets)[0].name;
        }
        
    }

    private void OnInspectorUpdate()
    {
        //窗口刷新
        Repaint();
    }


    private void PathTest()
    {
        //路径测试
        Select = string.Empty;
        FilterSelect = string.Empty;
        foreach (var goj in Selection.gameObjects)
        {
            Select = Select.Insert(Select.Length, goj.name + ",");

        }
        var selects = Selection.GetFiltered(typeof(object), SelectionMode.DeepAssets);
        foreach (var gojf in selects)
        {
            FilterSelect = FilterSelect.Insert(FilterSelect.Length, gojf.name + "\n");
        }
        GUILayout.Label("不过滤选择:");
        EditorGUILayout.TextField(Select);

        GUILayout.Label("过滤选择:");
        EditorGUILayout.LabelField(FilterSelect, GUILayout.MaxHeight(300));
    }
    //统一打包见AssetTestSec
}
