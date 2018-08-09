using System;
using System.Collections.Generic;
using UnityEngine;

public class TimerObject : MonoBehaviour
{

    private const string FUNCTION_NAME = "OnTimerInvke";

    public Action onTimerCallback { get; private set; }
    public Action<object> onTimerWithArgCallback { get; private set; }
    public float time { get; private set; }
    public float repeatRate { get; private set; }
    public object arg { get; private set; }

    public void StartTimer(Action onTimerCallback, float time, float repeatRate = 0)
    {
        this.onTimerWithArgCallback = null;
        this.onTimerCallback = onTimerCallback;
        this.time = time;
        this.repeatRate = repeatRate;

        if (repeatRate > 0)
        {
            InvokeRepeating(FUNCTION_NAME, time, repeatRate);
        }
        else
        {
            Invoke(FUNCTION_NAME, time);
        }
    }
    public void StartTimer(Action<object> onTimerWithArgCallback, float time, float repeatRate ,object arg)
    {
        this.onTimerCallback = null;
        this.onTimerWithArgCallback = onTimerWithArgCallback;
        this.time = time;
        this.repeatRate = repeatRate;
        this.arg = arg;

        if (repeatRate > 0)
        {
            InvokeRepeating(FUNCTION_NAME, time, repeatRate);
        }
        else
        {
            Invoke(FUNCTION_NAME, time);
        }
    }
    public void StopTimer()
    {
        onTimerCallback = null;
        CancelInvoke(FUNCTION_NAME);
    }
    private void OnTimerInvke()
    {
        if (onTimerCallback != null)
        {
            onTimerCallback.Invoke();
            if (repeatRate <= 0)
            {
                TimerSystem.Stop(onTimerCallback);
            }
        }
        else
        {
            onTimerWithArgCallback(arg);
            if (repeatRate <= 0)
            {
                TimerSystem.Stop(onTimerCallback);
            }
        }
    }
}
