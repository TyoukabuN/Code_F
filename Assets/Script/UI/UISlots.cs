using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UISlots : MonoBehaviour {

    public GameObject[] Objects;

    public GameObject GetObject(int index)
    {
        if (index < Objects.Length)
            return Objects[index];
        return null;
    }
}
