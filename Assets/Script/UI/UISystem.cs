using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

[RequireComponent(typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster))]
[RequireComponent(typeof(UnityEngine.EventSystems.EventSystem), typeof(StandaloneInputModule))]
public class UISystem : MonoSingleton<UISystem>
{
    public static Canvas canvas { get; private set; }
    public static CanvasScaler canvasScaler { get; private set; }
    public static GraphicRaycaster graphicRaycaster { get; private set; }
    public static UnityEngine.EventSystems.EventSystem eventSystem { get; private set; }
    //type - prefab
    private Dictionary<Type, GameObject> m_PrefabDic = new Dictionary<Type, GameObject>();
    //type - uipanel
    private Dictionary<Type, UIPanel> m_UIPanelDic = new Dictionary<Type, UIPanel>();

    private static List<UIPanel> m_PanelList = new List<UIPanel>();

    private void Awake()
    {
        canvas = gameObject.GetComponent<Canvas>();
        canvasScaler = gameObject.GetComponent<CanvasScaler>();
        graphicRaycaster = gameObject.GetComponent<GraphicRaycaster>();
        eventSystem = gameObject.GetComponent<UnityEngine.EventSystems.EventSystem>();
    }

    private void Update()
    {
        if (m_PanelList!=null)
        {
            for (int i = 1; i < m_PanelList.Count; i++)
            {
                UIPanel panel = m_PanelList[i];
                if (!panel.enabled)
                {
                    continue;
                }
                panel.OnUpdate();
            }
        }
    }

    public static void Open(Type type)
    {
        UIPanel uiPanel = null;
        if (!Instance.m_UIPanelDic.TryGetValue(type, out uiPanel))
        {
            GameObject uiPanelPrefab = Instance.GetPrefab(type);
            if (uiPanelPrefab != null)
            {
                GameObject gameObject = Instantiate(uiPanelPrefab);
                Instance.m_UIPanelDic[type] = uiPanel;
                gameObject.transform.SetParent(Instance.gameObject.transform, false);
                uiPanel = Activator.CreateInstance(type) as UIPanel;
                uiPanel.Init(uiPanelPrefab.name, gameObject);
                uiPanel.enabled = true;
                m_PanelList.Add(uiPanel);
            }
        }
        uiPanel.gameObject.SetActive(true);
        //return uiPanel;
    }

    public static void Close(Type type, bool destroy = false)
    {
        UIPanel uiPanel = null;
        if (Instance.m_UIPanelDic.TryGetValue(type, out uiPanel))
        {
            uiPanel.gameObject.SetActive(false);
            if (destroy)
            {
                Instance.m_UIPanelDic[type] = null;
                Instance.m_UIPanelDic.Remove(type);
                Destroy(uiPanel.gameObject);
                m_PanelList.Remove(uiPanel);
            }
        }
    }

    private GameObject GetPrefab(Type type)
    {
        GameObject uiPrefab = null;
        if (!Instance.m_PrefabDic.TryGetValue(type, out uiPrefab))
        {
            //var assetBundleRequest = BundleSystetm.GetAsset(type);
            //uiPrefab = assetBundleRequest.asset as GameObject;
            //if (uiPrefab != null)
            //{
            //    Instance.m_PrefabDic[type] = uiPrefab;
            //}
        }

        return uiPrefab;
    }

    public void Open(Type type, string url)
    {
        UIPanel uiPanel = null;
        if (!Instance.m_UIPanelDic.TryGetValue(type, out uiPanel))
        {
            //StartCoroutine(BundleSystetm.Instance.GetAssetByWWW(type, url, Open));

            //GameObject uiPanelPrefab = Instance.GetPrefab(type);
            //if (uiPanelPrefab != null)
            //{
            //    uiPanel = Instantiate(uiPanelPrefab);
            //    Instance.m_UIPanelDic[type] = uiPanel;
            //    uiPanel.transform.SetParent(Instance.gameObject.transform);
            //}
        }
        //uiPanel.gameObject.SetActive(true);
    }
}
