////////////////////////////////////////////////////////
//Copyright(C)
//版本      : 1.0
//作者      : zjw
//创始日期  : 2019年4月3日20:34:06
//功能描述  : ScrollCircle
////////////////////////////////////////////////////////


using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using System;


public class ScrollCircle : UIBehaviour, IBeginDragHandler, IEndDragHandler, IDragHandler ,IPointerClickHandler,IPointerEnterHandler
{
    public CircleLayout layout;
    public Vector2 velocity;
    public Camera camera;
    public void OnBeginDrag(PointerEventData eventData)
    {
        Debug.Log("OnBeginDrag  " + eventData.clickTime.ToString());
        velocity = Vector2.one;
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        Debug.Log("OnEndDrag  " + eventData.clickTime.ToString());
        velocity = eventData.delta;
    }

    public float GetDirectValue(Vector2 vector)
    {
        float value = vector.x;
        if (Mathf.Abs(vector.y) > Mathf.Abs(vector.x))
        {
            value = -vector.y;
        }
        return value;
    }
    public void OnDrag(PointerEventData eventData)
    {
        //float value = GetDirectValue(eventData.delta);
        float value = 0;
        //获取 控件中心坐标 到 当前鼠标当前坐标的 的向量 （法线）
        Vector2 normal = Vector2.zero;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(GetComponent<RectTransform>(), eventData.position, camera, out normal);
        normal.Normalize();

        float dot = Vector2Dot(normal, eventData.delta.normalized);
        //根据旋性判断正方向
        if (dot < 0)
        {
            value = Mathf.Sqrt(eventData.delta.sqrMagnitude) * -1;
        }
        else
        {
            value = Mathf.Sqrt(eventData.delta.sqrMagnitude);
        }
        //调用圆形布局重新排列（旋转）
        layout.AngleOffest += (value / Mathf.PI);
        layout.Sort();
    }

    //二维向量叉乘（获取旋转关系）
    public float Vector2Dot(Vector2 vec1, Vector2 vec2)
    {
        return (vec1.x * vec2.y) - (vec1.y * vec2.x);
    }

	void Update () {
		
	}

    public void OnPointerClick(PointerEventData eventData)
    {
        Debug.Log("OnPointerClick  " + eventData.clickTime.ToString());
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        Debug.Log("OnPointerEnter  " + eventData.clickTime.ToString());
    }

}
