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
    //assets same with prefab
    private Dictionary<string, Object> prefabMap = new Dictionary<string, Object>();

    //同步加载
    public static Object Load(string path, Type type)
    {
        if (type==null) {
            type = typeof(GameObject);
        }

        Object prefab = null; 
        if (!Instance.prefabMap.TryGetValue(path,out prefab))
        {
#if UNITY_EDITOR && !A_TEST
            prefab = UnityEditor.AssetDatabase.LoadAssetAtPath(GetPath(path), type);
#else
            prefab = BundleManager.GetAsset(path, type);
#endif
            if (prefab != null)
            {
                Instance.prefabMap[path] = prefab;
            }
        }

        if (prefab==null)
        {
            Debug.LogError(string.Format(ERROR_PATH,GetPath(path)));
        }
        
        return prefab;
    }

    //异步加载
    public static void LoadAsync(string path, Type type, Action<Object> onLoadComplete)
    {
        if (type == null)
        {
            type = typeof(GameObject);
        }
        Action<AsyncOperation> onComplete = null;

        Object prefab;
        if (!Instance.prefabMap.TryGetValue(path,out prefab))
        {
            Debug.Log("<color=red>find not prefabTemp</color>");
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
                        Instance.prefabMap[path] = obj;

                        onLoadComplete.Invoke(obj);
                    }
                };
            }
            BundleManager.GetAssetAsync(path, type, onComplete);
            return;
        }
        Debug.Log("<color=yellow>find prefabTemp</color>");
        onLoadComplete.Invoke(prefab);
    }

    private static string GetPath(string folderName)
    {
        return "Assets/"+ folderName;
    }

}
