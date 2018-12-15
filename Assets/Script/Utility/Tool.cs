using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class Tool {

    public static float Map(float val, float min_1, float max_1, float min_2, float max_2)
    {
        float value = (val - min_1) / (max_1 - min_1) * (max_2 - min_2);
        value = value + min_1;
        return value;
    }
}
