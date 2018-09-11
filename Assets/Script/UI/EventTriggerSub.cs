using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using Entry = UnityEngine.EventSystems.EventTrigger.Entry;

public class EventTriggerSub : MonoBehaviour,IPointerEnterHandler,IPointerExitHandler,IPointerDownHandler, IPointerUpHandler, IPointerClickHandler
{
    public List<Entry> triggers = new List<Entry>();

    public void OnPointerClick(PointerEventData eventData)
    {
        InvokeTrigger(EventTriggerType.PointerClick, eventData);
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        InvokeTrigger(EventTriggerType.PointerDown, eventData);
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        InvokeTrigger(EventTriggerType.PointerEnter, eventData);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        InvokeTrigger(EventTriggerType.PointerExit, eventData);
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        InvokeTrigger(EventTriggerType.PointerUp, eventData);
    }
    private void InvokeTrigger(EventTriggerType eventID, PointerEventData eventData)
    {
        foreach (var entry in triggers)
        {
            if (entry.eventID == eventID)
            {
                if (entry.callback != null)
                {
                    entry.callback.Invoke(eventData);
                }
                break;
            }
        }
    }
}
