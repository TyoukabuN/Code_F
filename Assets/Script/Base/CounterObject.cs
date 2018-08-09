using System;
using System.Collections.Generic;
using UnityEngine;

public class CounterObject : MonoBehaviour {

    private const string FUNCTION_NAME = "OnCounterInvke";

    public Action<object> onCounterCallback { get; private set; }
    public float time { get; private set; }
    public object arg { get; private set; }

    public void StartCounter(object obj, Action<object> onCounterCallback,float time)
    {
        this.onCounterCallback = onCounterCallback;
        this.time = time;
        this.arg = obj;

        Invoke(FUNCTION_NAME, time);
    }

    public void StopCounter()
    {
        onCounterCallback = null;
        CancelInvoke(FUNCTION_NAME);
        Destroy(this);
    }
    private void OnCounterInvke()
    {
        if (onCounterCallback != null)
        {
            onCounterCallback(arg);
            StopCounter();
        }

    }
}
