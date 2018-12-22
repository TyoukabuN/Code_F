using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AC2D : MonoBehaviour {

    [SerializeField]
    public Sprite[] PreFrames;
    [SerializeField]
    public Sprite[] Frames;

    private Sprite[] curFrames;
    public float FrameRate
    {
        get { return 1 / FramePreSecond; }
        set { FrameRate = value; }
    }
    public float FramePreSecond = 12;
    public bool DefaultFlipX = false;
    public bool DefaultFlipY = false;

    [SerializeField]
    private int frameIndex = 0;
    private int frameCount = 0;
    private float counter = 0;

    public bool PingPong = false;

    public bool finishPre = false;
    // Use this for initialization
    void Start () {
    }
    public void Init()
    {
        frameIndex = 0;
        finishPre = true;
        curFrames = Frames;
        if (PreFrames!=null && PreFrames.Length > 0) {
            finishPre = false;
            curFrames = PreFrames;
        }
    }
    
    public Sprite[] GetCurFrames()
    {
        return curFrames;
    }
    public void Tick(SpriteRenderer sr,float h, float v)
    {
        counter += Time.deltaTime;

        if (counter >= FrameRate)
        {
            counter = 0;
            

            if (!PingPong)
            {
                frameIndex++;

                if (frameIndex > curFrames.Length - 1) {
                    frameIndex = 0;

                    if (!finishPre)
                    {
                        finishPre = true;
                        curFrames = Frames;
                    }
                }
            }
            else if(finishPre)
            {
                frameIndex = GetPingPongVal(frameCount);
            }

            sr.sprite = curFrames[frameIndex];

            frameCount += 1;
        }
    }

    private int GetPingPongVal(int i)
    {
        int index = i / (Frames.Length-1);
        index += 1;

        int val = i % (Frames.Length-1);

        if (index % 2 == 0)
        {
            val = (Frames.Length-1) - val;
        }

        return val;
    }
}
