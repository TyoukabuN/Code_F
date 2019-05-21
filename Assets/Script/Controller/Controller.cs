using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody2D))]
[RequireComponent(typeof(BoxCollider2D))]
public class Controller : MonoBehaviour {

    public float moveSpeed = 1;
    protected Rigidbody2D rigid2d;

    protected SpriteRenderer sr;
    protected BoxCollider2D col2d;

    //public AC2D[] AC2Ds;

    public A2D A2d;
    public bool movement = true;
    public float horizontalForce = 1;
    public float jumpForce = 0;

    protected ContactFilter2D groundFilter;
    protected ContactFilter2D topFilter;
    protected ContactFilter2D wallFilter;

    public float minNormalAngle =60;
    public float maxNormalAngle = 120;

    public float minNormalAngle_Top = 240;
    public float maxNormalAngle_Top = 300;

    public float minNormalAngle_Wall = 80;
    public float maxNormalAngle_Wall = 200;

    // Use this for initialization
    protected void Awake() {
        sr = GetComponent<SpriteRenderer>();

        rigid2d = GetComponent<Rigidbody2D>();
        rigid2d.interpolation = RigidbodyInterpolation2D.Extrapolate;

        col2d = GetComponent<BoxCollider2D>() ?? gameObject.AddComponent<BoxCollider2D>();

        groundFilter = new ContactFilter2D();
        groundFilter.SetNormalAngle(minNormalAngle, maxNormalAngle);

        topFilter = new ContactFilter2D();
        topFilter.SetNormalAngle(minNormalAngle_Top, maxNormalAngle_Top);

        wallFilter = new ContactFilter2D();
    }
	void Start () {
    }

    void Update () {
		
	}

    protected void FixedUpdate()
    {

    }
}
