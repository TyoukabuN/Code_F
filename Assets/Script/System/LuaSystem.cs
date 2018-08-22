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
            Instance.luaEnv.Global.Get<LuaFunction>("Init").Call();
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

    private void OnDestroy()
    {
        if (Instance.luaEnv != null)
        {
            Instance.luaEnv.Dispose();
        }
    }
}
