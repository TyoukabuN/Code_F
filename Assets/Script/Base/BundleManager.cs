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

        path = GetAssetName(path);
        AssetBundleRequest req = ab.LoadAssetAsync(path, type);
        if (onComplete != null)
        {
            req.completed += onComplete;
        }

        return req;
    }

    public static IEnumerable GetAssetAsyncE(string path, Type type, Action<AsyncOperation> onComplete)
    {
        if (path == string.Empty)
        {
            Debug.LogError("bundle path is null");
            yield return 0;
        }

        AssetBundle ab = null;
        if (!Instance.bundleMap.TryGetValue(path, out ab))
        {
            ab = Instance.LoadAssetBundleByPath(GetPath(path.ToString()));
            if (ab == null)
            {
                Debug.LogError("find not bundle: " + path);
                yield return 0;
            }
            Instance.bundleMap[path] = ab;
        }

        path = GetAssetName(path);
        AssetBundleRequest req = ab.LoadAssetAsync(path, type);
        yield return req;
        if (onComplete != null)
        {
            req.completed += onComplete;
        }

        yield return 0;
    }

    private static string GetAssetName(string path)
    {
        return Path.Combine("Assets", path).ToLower();
    }


    private AssetBundle LoadAssetBundleByPath(string path)
    {
        path = path.Substring(0, path.LastIndexOf('.'));
        path = path.ToLower();

        var ab = AssetBundle.LoadFromFile(path);
        if (ab == null)
        {
            Debug.Log("Failed to load AssetBundle!  " + path);
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
