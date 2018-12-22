using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StatusController {

    public Dictionary<string, Status> StatusMap = new Dictionary<string, Status>();
    public Status lastStatus;
    public Status curStatus;
    public string CurStatusName = string.Empty;
    private float counter = 0;

    public void Add(string name,Status status)
    {
        if (Get(name)!=null)
        {
            return;
        }

        StatusMap.Add(name, status);
    }

    public void Remove(string name)
    {
        if (Get(name)==null)
        {
            return;
        }

        StatusMap.Remove(name);
    }

    public Status Get(string name)
    {
        Status status = null;
        StatusMap.TryGetValue(name, out status);
        return status;
    }

    public void Enter(string name)
    {
        Status status = Get(name);
        if (status == null)
        {
            return;
        }

        if (curStatus!=null)
        {
            if (!curStatus.OnCondition(name)) {
                return;
            }
            curStatus.OnExit();
        }
        CurStatusName = name;
        lastStatus = curStatus;
        curStatus = status;
        counter = 0;
        curStatus.OnEnter(name);
    }

    public void Update()
    {
        if (curStatus!=null)
        {
            counter += Time.deltaTime;
            curStatus.OnUpdate();
            if (curStatus.AutoExit==true && counter>=curStatus.ExitTime) {
                curStatus.onAutoExit.Invoke();
            }
        }
    }
}
