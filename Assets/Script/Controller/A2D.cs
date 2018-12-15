using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class A2D : MonoBehaviour {

    public AC2D[] ac2ds;
    private AC2D curAc2d;
    private string curName = string.Empty;
    private bool lastFlipX = false;

    public bool Play(SpriteRenderer sr,string name)
    {
        if (name.Equals(curName)) {
            return false;
        }
        AC2D obj = null;
        foreach (var ac2d in ac2ds)
        {
            if (ac2d.gameObject.name.Equals(name))
            {
                obj = ac2d;
            }
        }
        if (obj == null || sr == null)
        {
            return false;
        }
        curAc2d = obj;
        curName = name;
        curAc2d.Init();
        sr.sprite = curAc2d.GetCurFrames()[0];

        return true;
    }

    public void Tick(SpriteRenderer sr, float h, float v)
    {
        if (curAc2d)
        {
            curAc2d.Tick(sr, h, v);
            if (curAc2d.DefaultFlipX == false)
            {
                sr.flipX = h != 0 ? !(curAc2d.DefaultFlipX==false && h>0) : lastFlipX;
            }
            else
            {
                sr.flipX = h != 0 ? !(curAc2d.DefaultFlipX==true && h < 0) : lastFlipX;
            }
            lastFlipX = sr.flipX;
        }
    }
}
