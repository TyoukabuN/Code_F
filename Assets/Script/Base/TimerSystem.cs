using System;
using System.Collections.Generic;
using UnityEngine;

public class TimerSystem : MonoSingleton<TimerSystem>
{

    private Dictionary<Action, TimerObject> m_TimerDic = new Dictionary<Action, TimerObject>();

    private Dictionary<Action<object>, TimerObject> m_TimerWithArgDic = new Dictionary<Action<object>, TimerObject>();

    private MyObjectPool m_TimerPool = new MyObjectPool(new Func<TimerObject>(OnTimerConstruct),
        new Action<TimerObject>(OnTimerDestroy),
        new Action<TimerObject>(OnTimerEnable),
        new Action<TimerObject>(OnTimerDisable)
    );

    public static void Start(Action onTImerCallback, float time, float repeatRate = 0)
    {
        if (onTImerCallback == null)
        {
            Debug.LogError("定时回调不能为空");
            return;
        }
        if (Instance.m_TimerDic.ContainsKey(onTImerCallback))
        {
            Stop(onTImerCallback);
        }
        TimerObject timerObject = Instance.m_TimerPool.Get() as TimerObject;
        Instance.m_TimerDic[onTImerCallback] = timerObject;

        timerObject.StartTimer(onTImerCallback,time,repeatRate);
    }
    public static void StartWithArg(Action<object> onTimerWithArgCallback, float time, float repeatRate,object arg)
    {
        if (onTimerWithArgCallback == null)
        {
            Debug.LogError("定时回调不能为空");
            return;
        }
        if (Instance.m_TimerWithArgDic.ContainsKey(onTimerWithArgCallback))
        {
            Debug.Log("之前有");
            StopWithArg(onTimerWithArgCallback);
        }
        TimerObject timerObject = Instance.m_TimerPool.Get() as TimerObject;
        Instance.m_TimerWithArgDic[onTimerWithArgCallback] = timerObject;

        timerObject.StartTimer(onTimerWithArgCallback, time, repeatRate, arg);
    }
    public static void Stop(Action onTImerCallback)
    {
        if (onTImerCallback == null)
        {
            Debug.LogError("定时回调不能为空");
            return;
        }
        TimerObject timerObject = null;
        if (!Instance.m_TimerDic.TryGetValue(onTImerCallback,out timerObject))
        {
            return;
        }
        timerObject.StopTimer();
        Instance.m_TimerDic.Remove(onTImerCallback);
        Instance.m_TimerPool.Remove(timerObject);
    }
    public static void StopWithArg(Action<object> onTimerWithArgCallback)
    {
        if (onTimerWithArgCallback == null)
        {
            Debug.LogError("定时回调不能为空");
            return;
        }
        TimerObject timerObject = null;
        if (!Instance.m_TimerWithArgDic.TryGetValue(onTimerWithArgCallback, out timerObject))
        {
            return;
        }
        timerObject.StopTimer();
        Instance.m_TimerWithArgDic.Remove(onTimerWithArgCallback);
        Instance.m_TimerPool.Remove(timerObject);
    }
    public static void Clear()
    {
        Instance.m_TimerDic.Clear();
        Instance.m_TimerWithArgDic.Clear();
        Instance.m_TimerPool.Clear();
    }

    public static TimerObject OnTimerConstruct()
    {
        TimerObject timerObject = Instance.gameObject.AddComponent<TimerObject>();
        return timerObject;
    }
    public static void OnTimerDestroy(TimerObject timerObject)
    {
        Destroy(timerObject);
    }
    public static void OnTimerEnable(TimerObject timerObject)
    {
        timerObject.enabled = true;
    }
    public static void OnTimerDisable(TimerObject timerObject)
    {
        timerObject.enabled = false;
    }


}
