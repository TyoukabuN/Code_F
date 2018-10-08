using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEngine.Networking;
using Object = UnityEngine.Object;


public class BundleManager : MonoSingleton<BundleManager>
{
    private Dictionary<string, AssetBundle> bundleMap = new Dictionary<string, AssetBundle>();

    private List<AssetBundleCreateRequest> abReqtList = new List<AssetBundleCreateRequest>();

    public static Object GetAsset(string path, Type type)
    {
        if (path == string.Empty)
        {
            Debug.LogError("bundle path is null");
            return null;
        }
        Object asset = null;
        AssetBundle ab = null;
        if (!Instance.bundleMap.TryGetValue(path, out ab))
        {
            ab = Instance.LoadAssetBundleByPath(GetPath(path.ToString()));
            if (ab == null)
            {
                Debug.LogError("find not bundle: " + path);
                return null;
            }
            Instance.bundleMap[path] = ab;
        }
        asset = ab.LoadAsset(GetAssetName(path), type);
        if (asset == null)
        {
            Debug.LogError("find not asset: " + path);
        }
        return asset;
    }

    public static AssetBundleRequest GetAssetAsync(string path, Type type, Action<AsyncOperation> onComplete)
    {
        if (path == string.Empty)
        {
            Debug.LogError("bundle path is null");
            return null;
        }
        AssetBundle ab = null;
        if (!Instance.bundleMap.TryGetValue(path, out ab))
        {
            ab = Instance.LoadAssetBundleByPath(GetPath(path.ToString()));
            if (ab == null)
            {
                Debug.LogError("find not bundle: " + path);
                return null;
            }
            Instance.bundleMap[path] = ab;
        }
        string[] names = ab.GetAllAssetNames();
        foreach (string name in names)
        {
            Debug.Log(name);
        }
        path = GetAssetName(path);
        Debug.Log("AssetName:  " + path);
        AssetBundleRequest req = ab.LoadAssetAsync(path, type);
        if (onComplete!=null)
        {
            req.completed += onComplete;
        }
        return req;
    }

    private static string GetAssetName(string path)
    {
        return Path.Combine("Assets", path).ToLower();
    }
    //private void OnUpdate()
    //{
    //    CheckAssetRequestPrograss();
    //}

    //private void CheckAssetRequestPrograss()
    //{
    //    if (abReqtList.Count <= 0)
    //    {
    //        return;
    //    }
    //    List<AssetBundleCreateRequest> finishList = new List<AssetBundleCreateRequest>();
    //    foreach (var req in abReqtList)
    //    {
    //        if (req.isDone)
    //        {
    //            finishList.Add(req);
    //        }
    //    }
    //    foreach (var req in finishList)
    //    {
    //        abReqtList.Remove(req);
    //    }
    //}

    private AssetBundle LoadAssetBundleByPath(string path)
    {
        path = path.Substring(path.IndexOf("Assets"));
        path = path.Substring(0, path.LastIndexOf('.'));
        //path = path + ".bundle";
        Debug.Log(path);
        var ab = AssetBundle.LoadFromFile(path);
        if (ab == null)
        {
            Debug.Log("Failed to load AssetBundle!");
            return null;
        }
        return ab;
    }

    private static string GetPath(string folderName)
    {
        //string path = Path.Combine(Application.dataPath, "AssetsBundle", folderName);
        //path.Replace("/", "\\");
        //Debug.Log(Application.streamingAssetsPath);
        return Application.dataPath + "/AssetsBundle/" + folderName;
    }
    private string GetStreamPath(string folderName)
    {
        return Application.streamingAssetsPath + folderName;
    }
}
