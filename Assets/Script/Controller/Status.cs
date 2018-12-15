using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Status {
    public Action onEnter;
    public Action onUpdate;
    public Action onExit;
    public Func<string, bool> onCondition;
    public Action onDestroy;
    public bool AutoExit = false;
    public float ExitTime = 0;
    public StatusController statusController;

    public void OnEnter(string name)
    {
        if (onEnter == null)
        {
            return;
        }

        onEnter.Invoke();
    }
    public void OnUpdate() {
        if (onUpdate == null)
        {
            return;
        }

        onUpdate.Invoke();
    }

    public void OnExit()
    {
        if (onExit == null)
        {
            return;
        }

        onExit.Invoke();
    }

    public bool OnCondition(string name)
    {
        if (onCondition!=null) {
            return onCondition.Invoke(name);
        }

        return true;
    }

    public void OnDestroy()
    {
        if (onDestroy == null)
        {
            return;
        }

        onDestroy.Invoke();
    }

    public void SetAutoExit(float exitTime)
    {
        AutoExit = true;
        ExitTime = exitTime;
    }
}
