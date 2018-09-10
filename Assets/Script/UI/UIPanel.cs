using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;
using System;

public abstract class UIPanel {
    public string bundleName;

    public GameObject gameObject;

    public RectTransform transform { get { return gameObject.transform as RectTransform; } }

    public bool enabled {
        set {
            if (value == true) {
                OnEnabled();
            } else
            {
                OnDisabled();
            }
            gameObject.SetActive(enabled);
        }
        get {
            return gameObject.activeSelf;
        }
    }
    public void Init(string bundleName, GameObject gameObject)
    {
        this.bundleName = bundleName;
        this.gameObject = gameObject;

        OnInit();
    }
    public virtual void OnInit()
    {

    }
    public virtual void OnEnabled()
    {

    }
    public virtual void OnDisabled()
    {

    }

    public virtual void OnUpdate()
    {

    }
    public Component GetComponent(Type type,string childName = null)
    {
        Transform transform = string.IsNullOrEmpty(childName) ? this.transform : this.transform.Find(childName);
        if (transform == null)
        {
            Debug.LogError("transform == null");
        }
        Component comp = transform.GetComponent(type);
        if (comp==null) {
            Debug.LogError("comp == null");
        }
        return comp;
    }

    public Component[] GetComponentsInChildren(Type type, string childName = null)
    {
        Transform transform = string.IsNullOrEmpty(childName) ? this.transform : this.transform.Find(childName);
        Component[] comps = transform.GetComponentsInChildren(type, true);
        if (comps == null)
        {
            Debug.LogError("comp == null");
        }
        return comps;
    }
}
