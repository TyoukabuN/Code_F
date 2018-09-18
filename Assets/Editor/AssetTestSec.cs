using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEditor;
using Object = UnityEngine.Object;

public class AssetPathAttribute : Attribute
{
    public string Path = string.Empty;
    public AssetPathAttribute(string path)
    {
        Path = path;
    }
}

public class PatternAttribute : Attribute
{
    public string Pattern = string.Empty;
    public PatternAttribute(string pattern)
    {
        Pattern = pattern;
    }
}
public class AssetTestSec : EditorWindow
{

    [Flags]
    public enum AssetPath
    {
        [AssetPath("Assets/UI/")]
        Prefab = 0,
        [AssetPath("Assets/Lua/")]
        Lua = 1,
        [AssetPath("Assets/Sound/")]
        Sound = 2,
    }
    [Flags]
    public enum FilePattern
    {
        [Pattern("*.prefab")]
        Prefab = 0,
        [Pattern("*.lua")]
        Lua = 1,
        [Pattern("*.mp3")]
        Mp3 = 1,
        [Pattern("*.Ogg")]
        Ogg = 1,
    }

    public static string GetPatternByProperties(FilePattern p)
    {
        Type enumType = p.GetType(); //得到enum的类型
        FieldInfo[] fields = enumType.GetFields(); //获取enum下的所有共有字段
        foreach (var field in fields) //遍历字段
        {
            if (field.Name.Equals(p.ToString())) //判断出与arg相同的字段
            {
                //获取该字段上的Pattern属性
                object[] attributes = field.GetCustomAttributes(typeof(PatternAttribute), true);
                if (attributes.Length > 0)
                {
                    return ((PatternAttribute)attributes[0]).Pattern;
                }
            }
        }
        return string.Empty;
    }
    public static string GetAssetPathByProperties(AssetPath p)
    {
        Type enumType = p.GetType();
        FieldInfo[] fields = enumType.GetFields();
        foreach (var field in fields)
        {
            if (field.Name.Equals(p.ToString())) {
                object[] attributes = field.GetCustomAttributes(typeof(AssetPathAttribute), true);
                if (attributes.Length>0)
                {
                    return ((AssetPathAttribute)attributes[0]).Path;
                }
            }
        }
        return string.Empty;
    }



    //文件扩展名（filename extension）
    public FilePattern Pattern = 0;
    //Asset路径
    public AssetPath Path = 0;
    //输出路径
    public string OutputPath = string.Empty;
    //包名
    private string AssetBundleName = string.Empty;
    //用GUI界面绘制的滑条坐标
    private Vector2 _scrollViewPos = Vector2.zero;
    [MenuItem("Bundle实验/通过添加AssetLabel的打包")]
    static void Open()
    {
        GetWindow<AssetTestSec>(false, "AssetCreaterSec", true);
    }

    private void OnGUI()
    {
        DrawBuildWindow();
    }
    //绘制建造窗口
    private void DrawBuildWindow()
    {
        EditorGUILayout.BeginVertical();
        _scrollViewPos = GUILayout.BeginScrollView(_scrollViewPos, false, true);
        //过滤后的Asset
        var assets = Selection.GetFiltered<Object>(SelectionMode.DeepAssets);
        //可能需要build成Bundle的Asset路径展示
        string paths = string.Empty;
        //它们的name列表
        List<string> assetPathList = new List<string>();

        foreach (var asset in assets)
        {
            //显示用
            string p = AssetDatabase.GetAssetPath(asset);
            paths = paths.Insert(paths.Length, p + "\n");
            //打包数据处理用
            assetPathList.Add(p);
        }
        //GUILayout.Label("AssetBundleName(包名):");
        //AssetBundleName = EditorGUILayout.TextField("AssetBundleName:", AssetBundleName);
        //GUILayout.Label("SelectedFilePath(打包内容):");
        //EditorGUILayout.TextArea(paths);//展示过滤选择后Asset

        //EditorGUILayout.BeginHorizontal();
        //GUILayout.Label("OutPutPath(输出路径)null会帮你创建的:");
        //OutputPath = EditorGUILayout.TextField(OutputPath);
        //if (GUILayout.Button("Select"))
        //{
        //    OutputPath = EditorUtility.SaveFolderPanel("你包TM的保存路径", OutputPath, string.Empty);
        //}
        //EditorGUILayout.EndHorizontal();

        //GUILayout.BeginHorizontal();

        //GUILayout.EndHorizontal();
        //if (GUILayout.Button("Build(通过代码自动设置AssetLabels)"))
        //{
        //    foreach (string path in assetPathList)
        //    {
        //        AssetImporter assetImporter = AssetImporter.GetAtPath(path);
        //        assetImporter.assetBundleName = AssetBundleName;
        //        assetImporter.assetBundleVariant = string.Empty;
        //    }
        //    //assetBundle[0].assetBundleVariant
        //    if (string.IsNullOrEmpty(OutputPath))
        //    {
        //        OutputPath = Application.streamingAssetsPath;
        //    }
        //    if (!Directory.Exists(OutputPath))
        //    {
        //        Directory.CreateDirectory(OutputPath);
        //    }
        //    BuildPipeline.BuildAssetBundles(OutputPath, BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows64);
        //}


        GUILayout.Space(30);
        //GUI.color = Color.green;
        //GUILayout.Label("-----(全程自动只需要设置,文件类型和Asset目录)-----");
        //GUI.color = Color.white;
        //GUILayout.Label("AssetBundle名:", GUILayout.MinWidth(80));
        //AssetBundleName =  GUILayout.TextField(AssetBundleName, GUILayout.MinWidth(200));
        EditorGUILayout.BeginHorizontal();
        GUILayout.Label("Asset路径:", GUILayout.MinWidth(60));
        GUILayout.TextField(GetAssetPathByProperties(Path), GUILayout.MinWidth(200));
        Path = (AssetPath)EditorGUILayout.EnumPopup(Path, GUILayout.MinWidth(50));
        EditorGUILayout.EndHorizontal();
        EditorGUILayout.BeginHorizontal();
        GUILayout.Label("Asset类型:", GUILayout.MinWidth(60));
        GUILayout.TextField(GetPatternByProperties(Pattern), GUILayout.MinWidth(200));
        Pattern = (FilePattern)EditorGUILayout.EnumPopup(Pattern, GUILayout.MinWidth(50));

        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        OutputPath = EditorGUILayout.TextField(OutputPath);
        if (GUILayout.Button("输出路径"))
        {
            OutputPath = EditorUtility.SaveFolderPanel("AssetBundle输出路径", OutputPath, string.Empty);
        }
        EditorGUILayout.EndHorizontal();
        if (GUILayout.Button("Build"))
        {
            //计算路径
            string dataPath = Application.dataPath.Substring(0, Application.dataPath.LastIndexOf('/') + 1);
            //创建路径信息
            DirectoryInfo directoryInof = new DirectoryInfo(dataPath + GetAssetPathByProperties(Path));
            //获取路径下的所有文件
            FileInfo[] fileInfos = directoryInof.GetFiles(GetPatternByProperties(Pattern), SearchOption.AllDirectories);
            //添加AssetBundleName
            foreach (var fileInfo in fileInfos)
            {
                int startIndex = fileInfo.FullName.LastIndexOf(@"Assets", StringComparison.Ordinal);
                string assetPath = fileInfo.FullName.Substring(startIndex, fileInfo.FullName.Length - startIndex);
                AssetImporter assetImporter = AssetImporter.GetAtPath(assetPath);

                int indexf = assetPath.IndexOf("Assets") + 7;
                string abName = assetPath.Substring(indexf, assetPath.LastIndexOf('.')- indexf);
                Debug.Log("ABName:  " + abName);
                assetImporter.assetBundleName = abName;
                assetImporter.assetBundleVariant = string.Empty;
            }
            if (string.IsNullOrEmpty(OutputPath))
            {
                OutputPath = Application.streamingAssetsPath;
            }
            if (!Directory.Exists(OutputPath))
            {
                Directory.CreateDirectory(OutputPath);
            }
            Debug.Log(OutputPath);
            BuildPipeline.BuildAssetBundles(OutputPath, BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows64);
            EditorApplication.RepaintProjectWindow();
        }
        if (GUILayout.Button("BuildNormal"))
        {
            BuildPipeline.BuildAssetBundles(OutputPath, BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows64);
        }

        if (GUILayout.Button("Load"))
        {
            string path = Application.dataPath + "/AssetsBundle/" + "ui/panel/loadingpanel";
            AssetBundle.UnloadAllAssetBundles(true);
            AssetBundle ab = AssetBundle.LoadFromFile(path);
            if (ab)
            {
                foreach (string name in ab.GetAllAssetNames())
                {
                    var gobj = ab.LoadAsset(name) as GameObject;
                    GameObject.Instantiate<GameObject>(gobj);
                }
            }
            //ab.Unload(true);
        }
        GUILayout.EndScrollView();
    }
    private void OnSelectionChange()
    {
        var s = Selection.GetFiltered<Object>(SelectionMode.DeepAssets);
        if (s.Length > 0)
        {
            AssetBundleName = s[0].name;
        }
    }
    private void OnInspectorUpdate()
    {
        Repaint();//窗口刷新
    }
}

