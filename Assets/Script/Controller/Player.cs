﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class Player : Controller {

    // Use this for initialization
    public StatusController statusController;
    private float lastDir = 1;
    private const float ADDTION_NONE = 0.0F;
    private const float ADDTION_RUN = 1.0F;
    private const float ADDTION_DASH = 2.5F;
    private const int DIR_LEFT = -1;
    private const int DIR_RIGHT = 1;
    private SpriteShadow sshadow;

    private void SetShadow(bool enabled)
    {
        if (sshadow)
        { sshadow.Switch = enabled; }
    }
    protected new void Awake()
    {
        base.Awake();
        sshadow = GetComponent<SpriteShadow>();
        SetShadow(false);
        //移动方法
        Func<float,bool> move = (addtion) =>
        {
            float h = Input.GetAxisRaw("Horizontal");
            bool someDir = true;
            if (h != 0)
            {
                transform.Translate(addtion * Vector3.right * h * moveSpeed * Time.fixedDeltaTime, Space.World);
                someDir = (h>0 && lastDir>0)||(h < 0 && lastDir < 0);
                //print(someDir);
                lastDir = h;
                return !someDir;
            };
            return false;
        };

        Action<int, float> translate = (int dir, float addtion) =>
        {
            transform.Translate(addtion * Vector3.right * dir * moveSpeed * Time.fixedDeltaTime, Space.World);
        };

        statusController = new StatusController();
        //站立
        Status Idle = new Status();
        Idle.onUpdate = () => {
            float h = Input.GetAxisRaw("Horizontal");

            if (Input.GetKey(KeyCode.K))
            {
                statusController.Enter("Jump");
                return;
            }
            if (Input.GetKeyDown(KeyCode.L))
            {
                statusController.Enter("Dash");
                return;
            }
            if (h != 0)
            {
                statusController.Enter("Run");
                return;
            }
            A2d.Play(sr, "Idle");
        };
        //跑
        Status Run = new Status();
        Run.onUpdate = () => {
            if (Input.GetKey(KeyCode.K))
            {
                statusController.Enter("Jump");
                return;
            }
            if (Input.GetKeyDown(KeyCode.L))
            {
                statusController.Enter("Dash");
                return;
            }
            float h = Input.GetAxisRaw("Horizontal");
            if (h != 0)
            {
                move.Invoke(ADDTION_RUN);
                A2d.Play(sr, "Run");
            }
            else
            {
                statusController.Enter("Idle");
            }
        };
        //跳跃
        Status Jump = new Status();
        Jump.onUpdate = () =>
        {
            move.Invoke(ADDTION_RUN);

            if (Input.GetKey(KeyCode.K))
            {
                rigid2d.gravityScale = 0;
                rigid2d.velocity = Vector2.zero;
                transform.Translate(Vector3.up * jumpForce * Time.fixedDeltaTime, Space.World);
                A2d.Play(sr, "Jump");
                return;
            }

            groundFilter.SetNormalAngle(minNormalAngle, maxNormalAngle);
            Collider2D[] contactPoints_g = new Collider2D[8];
            if (rigid2d.GetContacts(groundFilter, contactPoints_g) > 0)
            {
                rigid2d.gravityScale = 1;
                statusController.Enter("Idle");
                return;
            }

            statusController.Enter("Drop");
        };
        //下落
        Status Drop = new Status();
        Drop.onUpdate = () =>
        {
            move.Invoke(ADDTION_RUN);
            rigid2d.gravityScale = 1;

            groundFilter.SetNormalAngle(minNormalAngle, maxNormalAngle);
            Collider2D[] contactPoints_g = new Collider2D[8];
            if (rigid2d.GetContacts(groundFilter, contactPoints_g) > 0)
            {
                statusController.Enter("Idle");
                return;
            }
            A2d.Play(sr, "Drop");
        };
        //冲刺
        Status Dash = new Status();
        Dash.SetAutoExit(0.25f);
        Dash.onExit = () =>
        {
            SetShadow(false);
            statusController.Enter("Idle");
        };
        Dash.onUpdate = () =>
        {
            SetShadow(true);
            var cdir = move.Invoke(ADDTION_NONE);
            //translate(lastDir > 0 ? DIR_RIGHT : DIR_LEFT, ADDTION_DASH);
            if (cdir)
            {
                statusController.Enter("Idle");
                return;
            }

            //A2d.Play(sr, "Dash");
        };

        statusController.Add("Drop", Drop);
        statusController.Add("Jump", Jump);
        statusController.Add("Idle", Idle);
        statusController.Add("Run", Run);
        statusController.Add("Dash", Dash);

        statusController.Enter("Idle");
    }
	void Start () {
		
	}

	protected void Update () {
	}

    protected new void FixedUpdate()
    {
        float h = Input.GetAxisRaw("Horizontal");
        float v = Input.GetAxisRaw("Vertical");
        //if (movement)
        //{
        //    transform.Translate(Vector3.right * h * moveSpeed * Time.fixedDeltaTime, Space.World);
        //}

        //if (Input.GetKey(KeyCode.K))
        //{
        //    rigid2d.gravityScale = 0;
        //    rigid2d.velocity = Vector2.zero;
        //    transform.Translate(Vector3.up * jumpForce * Time.fixedDeltaTime, Space.World);
        //}
        //else
        //{
        //    rigid2d.gravityScale = 1;
        //}

        //topFilter.SetNormalAngle(minNormalAngle_Top, maxNormalAngle_Top);
        //Collider2D[] contactPoints_t = new Collider2D[8];

        //groundFilter.SetNormalAngle(minNormalAngle, maxNormalAngle);
        //Collider2D[] contactPoints_g = new Collider2D[8];
        //if (rigid2d.GetContacts(groundFilter, contactPoints_g) > 0)
        //{
        //    if (h != 0)
        //    {
        //        A2d.Play(sr, "Run");
        //    }
        //    else if (h == 0)
        //    {
        //        A2d.Play(sr, "Idle");
        //    }
        //}
        //else
        //{
        //    if (rigid2d.velocity.y < 0)
        //    {
        //        A2d.Play(sr, "Drop");
        //    }
        //    else if (Input.GetKey(KeyCode.K))
        //    {
        //        A2d.Play(sr, "Jump");
        //    }
        //}
        statusController.Update();
        A2d.Tick(sr, h, v);
    }
}
;