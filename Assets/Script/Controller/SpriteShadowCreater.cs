using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpriteShadowCreater : MonoBehaviour {

    public SpriteRenderer sr;
    public bool Switch = true;
    private float counter = 0.0f;
    public float interval = 0.05f;
    public float lifeTime = 0.3f;
    // Use this for initialization
    void Awake()
    {
        sr = GetComponent<SpriteRenderer>();
        
    }
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        if (sr ==null || !Switch)
        {
            return;
        }

        counter += Time.deltaTime;

        if (counter>interval)
        {
            counter = 0;
            var obj = new GameObject("s");
            var spriterenderer = obj.AddComponent<SpriteRenderer>();
            spriterenderer.sprite = sr.sprite;
            spriterenderer.flipX = sr.flipX;
            spriterenderer.color = new Color(1, 0.47f, 0.4f);
            obj.transform.position = transform.position;

            var ss = obj.AddComponent<SpriteShadow>();
            ss.SetData(spriterenderer, lifeTime);
        }
	}
}
