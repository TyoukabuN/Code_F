/*
--Copyright(C)
--版本      : 1.0
--作者      : 
--创始日期  : 2018年8月9日11:57:54
--功能描述  : ResourceManager
*/
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Object = UnityEngine.Object;


public class ResourceManager : MonoSingleton<ResourceManager>
{
    private const string ERROR_PATH = "Find not asset:{0}";
    private const string ERROR_INSTANTICATE = "Instantiate error:{0} {1}";

    private Dictionary<string, Object> assetMap = new Dictionary<string, Object>();

    //同步加载
    public static GameObject Load(string path, Type type)
    {
        if (type==null) {
            type = typeof(GameObject);
        }
        GameObject gobj = null;
        Object asset = null; 
        if (!Instance.assetMap.TryGetValue(path,out asset))
        {
#if UNITY_EDITOR
            //Debug.Log(GetPath(path));
            asset = UnityEditor.AssetDatabase.LoadAssetAtPath(GetPath(path), type);
#else
            asset = BundleManager.GetAsset(path, type);
#endif
            Instance.assetMap[path] = asset;
        }
        if (asset==null)
        {
            Debug.LogError(string.Format(ERROR_PATH,GetPath(path)));
        }
        try
        {
            gobj = GameObject.Instantiate(asset as GameObject);
        }
        catch (Exception e)
        {
            Debug.LogError(string.Format(ERROR_INSTANTICATE, e.ToString() , path));
        }
        
        return gobj;
    }

    //异步加载
    public static void LoadAsync(string path, Type type, Action<Object> onLoadComplete)
    {
        if (type == null)
        {
            type = typeof(GameObject);
        }
        Action<AsyncOperation> onComplete = null;
        if (onLoadComplete != null)
        {
            onComplete = delegate (AsyncOperation req)
            {
                AssetBundleRequest request = (req as AssetBundleRequest);
                if (request.asset == null)
                {
                    Debug.LogError("failure to load asset");
                }
                else
                {
                    Object obj = request.asset;
                    onLoadComplete.Invoke(obj);
                }
            };
        }
        BundleManager.GetAssetAsync(path, type,onComplete);
    }

    private static string GetPath(string folderName)
    {
        return "Assets/"+ folderName;
    }

}
