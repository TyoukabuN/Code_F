using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public abstract class MonoSingleton<T> : MonoBehaviour where T : MonoSingleton<T>, new()
{
    private static T _instance;

    public static T Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = FindObjectOfType<T>() ?? new GameObject(typeof(T).Name).AddComponent<T>();
                _instance.transform.hideFlags = HideFlags.NotEditable;
            }
            return _instance;
        }
    }

    private void Awake()
    {
        _instance = _instance ?? this as T;

        if (this != _instance)
        {
            Destroy(gameObject);
        }
    }
}


/*
         //外部接口
    public static T Instance   //若继承mono单例的脚本没挂在场景中，需要创建
    {
        get
        {
            if (_instance==null)
            {
                _instance = FindObjectOfType<T>();
                if (_instance==null)
                {
                    GameObject gobj = new GameObject();
                    _instance = gobj.AddComponent<T>();
                    Debug.Log(string.Format("{0} OnMonoSingleCreate!!", _instance.GetType()));
                }
            }
            return _instance;
        }
    }
    protected static T _instance;

    protected void Awake()
    {
        //若当前实例为空
        if (_instance == null)
        {
            //继承monosingle的脚本已经挂载在场景中的游戏物体上，都需要这么做
            //(在_instance不是private的情况下,Instance又没有被调用过的情况下_instance的直接使用是错误的)
            _instance = this as T;
            gameObject.name = this.GetType().Name;
            DontDestroyOnLoad(transform.gameObject);    //场景切换不删除
        }
        else
        {
            if (this!=_instance)
            {
                Debug.Log("already had "+ _instance.GetType() + " singleton");
                Destroy(this.gameObject);
            }
        }
    }
     */

