using System;
using System.Collections.Generic;
using UnityEngine;

public class CounterSystem : MonoSingleton<CounterSystem>
{

    private Dictionary<object, CounterObject> m_CounterWithArgDic = new Dictionary<object, CounterObject>();
    private MyObjectPool m_CounterPool = new MyObjectPool(new Func<CounterObject>(OnTimerConstruct),
        new Action<CounterObject>(OnTimerDestroy),
        new Action<CounterObject>(OnTimerEnable),
        new Action<CounterObject>(OnTimerDisable)
    );

    public static void Start(object obj,Action<object> onTimerWithArgCallback,float time)
    {
        if (onTimerWithArgCallback == null)
        {
            Debug.LogError("定时回调不能为空");
            return;
        }
        if (Instance.m_CounterWithArgDic.ContainsKey(obj))
        {
            Stop(onTimerWithArgCallback);
        }
        CounterObject counterObject = Instance.m_CounterPool.Get() as CounterObject;
        Instance.m_CounterWithArgDic[obj] = counterObject;

        counterObject.StartCounter(obj,onTimerWithArgCallback, time);
    }

    public static void Stop(object obj)
    {
        if (obj == null)
        {
            Debug.LogError("object不能为空");
            return;
        }
        CounterObject counterObject = null;
        if (!Instance.m_CounterWithArgDic.TryGetValue(obj,out counterObject))
        {
            return;
        }
        counterObject.StopCounter();
        Instance.m_CounterWithArgDic.Remove(obj);
        Instance.m_CounterPool.Remove(counterObject);
        
    }
    public static CounterObject OnTimerConstruct()
    {
        CounterObject counterObject = Instance.gameObject.AddComponent<CounterObject>();
        return counterObject;
    }
    public static void OnTimerDestroy(CounterObject counterObject)
    {
        Destroy(counterObject);
    }
    public static void OnTimerEnable(CounterObject counterObject)
    {
        counterObject.enabled = true;
    }
    public static void OnTimerDisable(CounterObject counterObject)
    {
        Destroy(counterObject);
    }
}
