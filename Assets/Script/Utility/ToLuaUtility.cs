using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using System.Net;
using System;

public class ToLuaUtility {

    /// <summary>
    /// 在世界空间中获取计算矩形的角点。
    /// 每个角落都提供其世界空间价值。返回的4个顶点数组是顺时针方向。它从左下角开始，向左旋转，然后向右旋转，最后向右旋转。注意，例如，左下角是（x，y，z）向量，其中x为左，y为底。
    /// </summary>
    /// <param name="trans"></param>
    /// <returns></returns>
    public static Vector3[] GetWorldCorners(RectTransform trans)
    {
        Vector3[] arr = new Vector3[4];
        trans.GetWorldCorners(arr);
        return arr;
    }

    public static void HttpGetRequest(string url,Action<UnityWebRequest> callback, string data, string command,params string[] args)
    {
        if (!string.IsNullOrEmpty(command)) {
            url = string.Format("{0}/{1}", url, command);
        }

        if (args!=null && args.Length>0) {
            string arg = string.Empty;
            for (int i = 0; i < args.Length; i += 2)
            {
                if (i+1>=args.Length)
                {
                    break;
                }
                string key = WWW.EscapeURL(args[i]);
                string value = WWW.EscapeURL(args[i + 1]);
                arg += string.Format("{0}={1}&", key, value);
            }
            arg = arg.Remove(arg.Length - 1);
            url = string.Format("{0}?{1}",url, arg);
        }
        LuaSystem.Instance.StartCoroutine(HttpCoroutine(url, UnityWebRequest.kHttpVerbGET, data, callback));
    }

    public static void HttpPostRequest(string url, Action<UnityWebRequest> callback, string data, string command, params string[] args)
    {
        //if (!string.IsNullOrEmpty(command))
        //{
        //    url = string.Format("{0}/{1}", url, command);
        //}
        WWWForm form = new WWWForm();
        string arg = string.Empty;
        if (args != null && args.Length > 0)
        {
            for (int i = 0; i < args.Length; i += 2)
            {
                if (i + 1 >= args.Length)
                {
                    break;
                }
                string key = WWW.EscapeURL(args[i]);
                string value = WWW.EscapeURL(args[i + 1]);
                //arg += string.Format("{0}={1}&", key, value);
                form.AddField(key, value);
            }
            //arg = arg.Remove(arg.Length - 1);
            //arg = string.Format("/{0}?{1}", command, arg);
        }
        LuaSystem.Instance.StartCoroutine(HttpCoroutinePost(url, UnityWebRequest.kHttpVerbPOST, form, callback));
    }

    private static IEnumerator HttpCoroutinePost(string url, string method, WWWForm form, Action<UnityWebRequest> callback)
    {
        UnityWebRequest request = UnityWebRequest.Post(url, form);

        //if (onHttpRequest != null)
        //{
        //    onHttpRequest.Invoke(request);
        //}

        yield return request.SendWebRequest();

        //if (onHttpReturn != null)
        //{
        //    onHttpReturn.Invoke(request);
        //}

        if (callback != null)
        {
            callback.Invoke(request);
        }

        request.Dispose();
    }



    private static IEnumerator HttpCoroutine(string url, string method, string data, Action<UnityWebRequest> callback) {
        UnityWebRequest request = null;
        if (method == UnityWebRequest.kHttpVerbPUT)
        {
            request = UnityWebRequest.Put(url, data);
        }
        else if (method == UnityWebRequest.kHttpVerbPOST)
        {
            request = UnityWebRequest.Post(url, data);
        }
        else
        {
            request = UnityWebRequest.Get(url);
        }

        //if (onHttpRequest != null)
        //{
        //    onHttpRequest.Invoke(request);
        //}

        yield return request.SendWebRequest();

        //if (onHttpReturn != null)
        //{
        //    onHttpReturn.Invoke(request);
        //}

        if (callback != null)
        {
            callback.Invoke(request);
        }

        request.Dispose();
    }
}
