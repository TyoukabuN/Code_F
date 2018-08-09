using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Video;

public class DownLoadAudio : MonoSingleton<DownLoadAudio>
{
    public Image MoiveImage;

    private WWW currentWww = null;

    private Dictionary<Type, AssetBundle> m_Dictionary = new Dictionary<Type, AssetBundle>();

    public MovieTexture wwwAudio = null;

    void Start()
    {
        foreach (var image in FindObjectsOfType<Image>())
        {
            if (image.gameObject.tag == "MoiveImage")
            {
                MoiveImage = image;
            }
        }

        
    }
    void OnGUI()
    {
        if (currentWww != null)
        {
            var style = new GUIStyle
            {
                normal = { textColor = new Color(0.1f, 0.7f, 0, 1) },
                fontSize = 32
            };
            float width = 70;
            float height = 40;
            float posX = Screen.width * 0.5f - width;
            float posY = Screen.height / 2.0f - height;
            Rect rect = new Rect(posX, posY, width, height);
            GUI.Label(rect, currentWww.progress * 100 + "%", style);
        }

        //wwwAudio.Play();
        //
    }

    void Update()
    {
        if (wwwAudio != null && !wwwAudio.isPlaying)
        {
            wwwAudio.Play();
            Debug.Log(wwwAudio.isPlaying);
        }
    }

    #region WWW
    public IEnumerator OpenAudioByWWW(string url)
    {
        AssetBundle ab = null;

            yield return StartCoroutine(LoadAssetBundleByWWW(url));
            currentWww = null;
        
    }

    public IEnumerator LoadAssetBundleByWWW(string url)
    {
        //WWW www = WWW.LoadFromCacheOrDownload(@"file://" + url,1);
        WWW www = new WWW(@"file://" + url);
        currentWww = www;
        yield return www;
        if (!string.IsNullOrEmpty(www.error))
        {
            Debug.Log(www.error);
        }
        else
        {
            //D:\UnityPro5.6.0f3\Try\Assets\StreamingAssets\sou
            //string s = url.Remove(0, url.LastIndexOf('\\'));
            //wwwAudio = www.assetBundle.LoadAsset<MovieTexture>(s);
            //wwwAudio = new MovieTexture();
            wwwAudio = www.GetMovieTexture();
            AudioSource audioSource = MoiveImage.GetComponent<AudioSource>();
            //audioSource.clip = www.GetAudioClipCompressed();
            audioSource.Play();
            if (wwwAudio == null)
            {
                Debug.Log("Failed to load AssetBundle!");
            }
            else
            {
                Debug.LogError("视频加载成功！！");
               // MoiveImage.texture = wwwAudio;
                MoiveImage.material.mainTexture = wwwAudio;
                wwwAudio.Play();
              }   
        }
    }
    #endregion


    public static void AddAssetBundle(Type type, AssetBundle ab)
    {
        if (type == null)
        {
            Debug.LogError("你的包的类型是什么啊？空的？");
        }
        else
        {
            Instance.m_Dictionary[type] = ab;
        }

    }

    private string GetPath(string folderName)
    {
        return Application.dataPath + folderName;
    }
    private string GetStreamPath(string folderName)
    {
        return Application.streamingAssetsPath + folderName;
    }
}
