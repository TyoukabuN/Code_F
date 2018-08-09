using System;
using System.Collections.Generic;
using UnityEngine;

public sealed class MyObjectPool
{
    //private const string LOG_NULL = "Construct callback is null.";
    //public ushort constructStep = 10;

    //private Delegate m_OnConstruct;

    //private Delegate m_OnDestroy;

    //private Delegate m_OnEnabled;

    //private Delegate m_OnDisabled;

    //private List<object> m_EnabledList = new List<object>();

    //private Queue<object> m_DisabledPool = new Queue<object>();

    //public MyObjectPool(Delegate onContruct, Delegate onDestroy = null, Delegate onEnabled = null, Delegate onDisabled = null)
    //{
    //    if (onContruct == null)
    //    {
    //        Debug.LogError(LOG_NULL);
    //    }

    //    m_OnConstruct = onContruct;
    //    m_OnDestroy = onDestroy;
    //    m_OnEnabled = onEnabled;
    //    m_OnDisabled = onDisabled;
    //}

    //public object Add()
    //{
    //    for (int i = 0; i < constructStep - 1; ++i)
    //    {
    //        object obj = m_OnConstruct.DynamicInvoke(); //在构造步长个
    //        m_DisabledPool.Enqueue(obj);//放进队列
    //    }
    //    return m_OnConstruct.DynamicInvoke();//另外在构造一个
    //}
    //public object Get()
    //{
    //    object obj = m_DisabledPool.Count == 0 ? Add() : m_DisabledPool.Dequeue();
    //    m_EnabledList.Add(obj);
    //    if (m_OnEnabled != null)
    //    {
    //        m_OnEnabled.DynamicInvoke(obj);
    //    }
    //    return obj;
    //}

    //public void Remove(object obj)
    //{
    //    m_EnabledList.Remove(obj);
    //    m_DisabledPool.Enqueue(obj);
    //    if (m_OnDisabled != null)
    //    {
    //        m_OnDisabled.DynamicInvoke(obj);
    //    }
    //}

    //public void Clear()
    //{
    //    if (m_OnDisabled != null)
    //    {
    //        for (int i = 0; i < m_EnabledList.Count; ++i)
    //        {
    //            m_OnDestroy.DynamicInvoke(m_EnabledList[i]);
    //        }
    //        while (0 < m_DisabledPool.Count)
    //        {
    //            m_OnDestroy.DynamicInvoke(m_DisabledPool.Dequeue());
    //        }
    //    }
    //    m_EnabledList.Clear();
    //    m_DisabledPool.Clear();
    //}
    public  int constructStep = 1;

    private Delegate onConstruct;
    private Delegate onDestroy;
    private Delegate onEnabled;
    private Delegate onDisabled;
    

    private List<object> enabledList = new List<object>();
    private Queue<object>  disableList = new Queue<object>();

    public MyObjectPool(Delegate onConstruct,Delegate onDestroy,Delegate onEnabled,Delegate onDisabled)
    {
        if (onConstruct == null)
        {
            Debug.Log("构造函数不能为空");
            return;
        }
        this.onConstruct = onConstruct;
        this.onDestroy = onDestroy;
        this.onEnabled = onEnabled;
        this.onDisabled = onDisabled;
    }

    public object Add()
    {
        for (int i = 0; i < constructStep; i++)
        {
            disableList.Enqueue(onConstruct.DynamicInvoke());
        }
        return onConstruct.DynamicInvoke();
    }

    public object Get()
    {
        object obj = disableList.Count == 0 ? Add() : disableList.Dequeue();
        enabledList.Add(obj);
        if (onEnabled != null)
        {
            onEnabled.DynamicInvoke(obj);
        }
        return obj;
    }

    public void Remove(object obj)
    {
        enabledList.Remove(obj);
        disableList.Enqueue(obj);
        if (onDisabled != null)
        {
            onDisabled.DynamicInvoke(obj);
        }
    }

    public void Clear()
    {
        if (onDestroy != null)
        {
            var list = enabledList.ToArray();
            foreach (var obj in list)
            {
                onDestroy.DynamicInvoke(obj);
            }
            while (disableList.Count > 0)
            {
                onDestroy.DynamicInvoke(disableList.Dequeue());
            }
        }
        enabledList.Clear();
        disableList.Clear();
    }
}
