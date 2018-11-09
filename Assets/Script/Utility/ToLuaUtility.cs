using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToLuaUtility {

    /// <summary>
    /// 在世界空间中获取计算矩形的角点。
    /// 每个角落都提供其世界空间价值。返回的4个顶点数组是顺时针方向。它从左下角开始，向左旋转，然后向右旋转，最后向右旋转。注意，例如，左下角是（x，y，z）向量，其中x为左，y为底。
    /// </summary>
    /// <param name="trans"></param>
    /// <returns></returns>
    public static Vector3[] GetWorldCorners(RectTransform trans)
    {
        Vector3[] arr = new Vector3[4];
        trans.GetWorldCorners(arr);
        return arr;
    }
}
