using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpriteShadow : MonoBehaviour {

    public SpriteRenderer sr;
    public float lifeTime;
    private float counter = 0;
    private bool _switch = false;
    
	
	// Update is called once per frame
	private void Update () {
        if (!_switch)
        {
            return;
        }
        counter += Time.deltaTime;
        sr.color = new Color(sr.color.r, sr.color.g, sr.color.b, 1 - (counter / lifeTime));
        if (counter>=lifeTime) {
            Destroy(this.gameObject);
        }
	}


    public void SetData(SpriteRenderer sr, float lifeTime)
    {
        this.sr = sr;
        this.lifeTime = lifeTime;
        this._switch = true;
    }
}
