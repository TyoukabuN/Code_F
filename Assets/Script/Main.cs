using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//luaLoad Test
using XLua;
using System.IO;
using System;

public class Main : MonoBehaviour
{
    void Awake()
    {
        LuaSystem.Init();
    }
    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnGUI()
    {
        var style = new GUIStyle
        {
            normal = { textColor = new Color(0, 0, 0, 1) },
            fontSize = 22
        };
        float width = 200;
        float height = 30;
        float posX = 0;
        float posY = Screen.height - height;
        Rect rect = new Rect(posX, posY, width, height);
        if (GUI.Button(rect, "Load"))
        {
            //同步加载
            //string path = @"UI/Panel/SlotMachine.prefab";
            //var goj = ResourceManager.Load(path, typeof(GameObject));

            //string path = "slotmachine";
            //var asset = BundleManager.GetAsset(path, typeof(GameObject));
            //var goj = GameObject.Instantiate(asset as GameObject);

            //异步
            string path = "UI/Panel/slotmachine";
            ResourceManager.LoadAsyc(path, typeof(GameObject),(UnityEngine.Object obj)=> { GameObject.Instantiate(obj as GameObject); });


        }

    }
}
