using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[SerializeField]

public class CircleLayout : LayoutGroup
{

    /// <summary>
    ///  半径
    /// </summary>
    public float Radius;

    /// <summary>
    /// 半径偏移 用于绘制一些特殊效果
    /// </summary>
    public float RadiusOffset;

    //
    [SerializeField]
    private float _angleOffest = 0;

    /// <summary>
    /// 角度偏移用于旋转
    /// </summary>
    public float AngleOffest
    {
        get
        {
            return _angleOffest;
        }
        //限制旋转偏移为正值
        set
        {
            if (value > 360)
            {
                value -= 360;
            }
            if (value < 0)
            {
                value += 360;
            }

            value = Mathf.Clamp(value, AngleOffsetLimit.x, AngleOffsetLimit.y);
            _angleOffest = value;
        }
    }

    /// <summary>
    /// 角度偏移限制
    /// </summary>
    public Vector2 AngleOffsetLimit = new Vector2(0, 360);

    /// <summary>
    /// 局部半径缩放用于绘制椭圆
    /// </summary>
    public Vector2 RadiusScale = Vector2.one;

    /// <summary>
    /// child的角度间隔
    /// </summary>
    [Range(0, 360)]
    public float AnglePadding;

    /// <summary>
    /// 自动调整child的角度间隔
    /// </summary>
    public bool FocusChildAngle = false;

    [NonSerialized]
    public bool FocusOffset = false;

    public override void CalculateLayoutInputVertical()
    {
        if ((FocusChildAngle || FocusOffset) && rectChildren.Count > 0)
        {
            if (rectChildren.Count == 1)
            {

            }
            else
            {
                double length = 0;
                for (var i = 0; i < rectChildren.Count; i++)
                {
                    var rectTrans = rectChildren[i];
                    length += rectTrans.sizeDelta.y;
                }

                if (FocusChildAngle)
                {
                    AnglePadding = 360 / ((float)length / rectChildren[0].sizeDelta.y);
                }
            }
        }

        Sort();
    }

    public void Sort()
    {
        double length = 0;
        for (var i = 0; i < rectChildren.Count; i++)
        {
            var rectTrans = rectChildren[i];
            length += rectTrans.sizeDelta.y;
        }

        float RadiusPlus = 0;
        for (var i = 0; i < rectChildren.Count; i++)
        {
            RadiusPlus = Radius + RadiusOffset * i;
            var rectTrans = rectChildren[i];
            float angle = 0;
            if (FocusChildAngle)
            {
                float anglePer = 360 / ((float)length / rectChildren[0].sizeDelta.y);
                angle = i * anglePer;
            }
            else
            {
                angle = i * AnglePadding;
            }

            angle += AngleOffest;
            float x = Mathf.Cos(angle * Mathf.Deg2Rad) * RadiusPlus * RadiusScale.x;
            float y = Mathf.Sin(angle * Mathf.Deg2Rad) * RadiusPlus * RadiusScale.y;
            rectTrans.anchoredPosition = new Vector2(x, y);
        }

        float mindis;
        Debug.Log(CurrentCheckIndex(ShowCurrentSelect, out mindis) + "  " + mindis);
    }

    public float limit(float value)
    {
        if (value > 360)
        {
            value -= 360;
        }
        if (value < 0)
        {
            value += 360;
        }
        return value;
    }

    public bool ShowCurrentSelect = false;
    /// <summary>
    /// 检查角度
    /// </summary>
    [Range(0,360)]
    public float CheckAngle = 180;

    public int CurrentCheckIndex(bool displayEffect,out float min)
    {
        min = 361;
        int index = 0;
        try
        {
            for (int i = 0; i < rectChildren.Count; i++)
            {
                
                var rectGo = transform.GetChild(i).gameObject;
                CanvasGroup canvasGroup = null;
                if (displayEffect)
                {
                    canvasGroup = rectGo.GetComponent<CanvasGroup>();
                    if (canvasGroup == null)
                    {
                        canvasGroup = rectGo.AddComponent<CanvasGroup>();
                    }

                    canvasGroup.alpha = 0.3f;
                }
                else
                {
                    canvasGroup = rectGo.GetComponent<CanvasGroup>();
                    if (canvasGroup)
                    {
                        canvasGroup.alpha = 1f;
                    }
                }
                float angle = limit(i * AnglePadding + AngleOffest);
                float abs = Mathf.Abs(CheckAngle - angle);
                if (abs < min)
                {
                    min = abs;
                    index = i;
                }
            }
            if (displayEffect && transform.GetChild(index))
            {
                transform.GetChild(index).gameObject.GetComponent<CanvasGroup>().alpha = 1f;
            }
        }
        catch (Exception e)
        {

        }
        return index;
    }

    public override void SetLayoutHorizontal()
    {
    }

    public override void SetLayoutVertical()
    {
    }

#if UNITY_EDITOR
    protected override void OnValidate()
    {
        CalculateLayoutInputVertical();
    }
#endif
}
