using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System.IO;
using System;

public class LuaSystem : MonoSingleton<LuaSystem>
{

    private LuaEnv luaEnv { get; set; }

    public static void Init()
    {
        if (Instance.luaEnv == null)
        {
            Instance.luaEnv = new LuaEnv();
            Instance.luaEnv.AddLoader(LuaLoader);

            LuaTable table_main = Instance.luaEnv.NewTable();
            InheritGlobal(table_main);

            Instance.luaEnv.DoString("require 'Main'", "Main", table_main);
        }
    }

    public static object[] DoString(string chunk, string chunkName = "chunk", LuaTable env = null)
    {
        return Instance.luaEnv.DoString(chunk, chunkName, env);
    }

    public static void InheritGlobal(LuaTable table)
    {
        if (Instance.luaEnv != null)
        {
            LuaTable metaTable = Instance.luaEnv.NewTable();
            metaTable.Set("__index", Instance.luaEnv.Global);
            table.SetMetaTable(metaTable);
            metaTable.Dispose();
        }
    }

    private static byte[] LuaLoader(ref string filepath)
    {
        string path = string.Empty;
#if UNITY_EDITOR
        path = Application.dataPath + "/Lua/" + filepath + ".lua";
#endif
        return File.ReadAllBytes(path);
    }

    public static LuaEnv GetLuaEnv()
    {
        return Instance.luaEnv;
    }

    public static LuaTable NewTable()
    {
        return GetLuaEnv().NewTable();
    }


    private Dictionary<Action<LuaTable>,LuaTable> updates = new Dictionary<Action<LuaTable>, LuaTable>();
    private List<Action<LuaTable>> removeList = new List<Action<LuaTable>>();
    public static void EnUpdate(Action<LuaTable> func,LuaTable hInstance)
    {
        if (!Instance.updates.ContainsKey(func)) {
            Instance.updates.Add(func, hInstance);
        }
    }

    public static void DeUpdate(Action<LuaTable> func, LuaTable hInstance)
    {
        if (!Instance.updates.ContainsKey(func))
        {
            return;
        }

        Instance.removeList.Add(func);
    }
    private void Update()
    {
        foreach (var func in Instance.removeList)
        {
            Instance.updates.Remove(func);
        }

        Instance.removeList.Clear();

        if (Instance.updates.Count==0) {
            return;
        }

        var keys = Instance.updates.Keys;
        foreach (var pair in Instance.updates)
        {
            pair.Key.Invoke(pair.Value);
        }
    }

    private void OnDestroy()
    {
        //if (Instance.luaEnv != null)
        //{
        //    Instance.luaEnv.Dispose();
        //}
    }
}
