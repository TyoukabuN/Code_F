using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
using System.Text;
using System.IO;

public class EditorTool {

    //自动生成require文件
    [MenuItem("Tool/自动生成require文件")]
    public static void RequireAllLuaFile()
    {
        List<string> ExceptList = new List<string>{
            "requireInit.lua",
            "main.lua",
            "HotFixTest.lua",
        };

        if (EditorApplication.isCompiling) {
            EditorUtility.DisplayDialog("警告", "编译中请稍后再试...", "确定");
            return;
        }

        string dataPath = Application.dataPath + "/Lua";
        DirectoryInfo dir = new DirectoryInfo(dataPath);
        string content = string.Empty;
        if (dir.Exists) {
            FileInfo[] files = dir.GetFiles("*.lua", SearchOption.AllDirectories);
            foreach (FileInfo fileInfo in files)
            {
                if (ExceptList.Contains(fileInfo.Name)) {
                    continue;
                }
                //F:\\Code_F\\trunk\\Assets\\Lua\\class.lua"读进来的路径样式，复制下来\\货变成\
                //string fileName = fileInfo.FullName.Replace("\\\","/");
                int length = fileInfo.FullName.Length;
                int index = fileInfo.FullName.IndexOf(@"Lua\");
                string path = fileInfo.FullName.Substring(index + 4);
                path = path.Replace(@"\",@"/");
                path = path.Replace(".lua", "");
                string str = string.Format("require \"{0}\"", path);
                content = content + str + "\n";
            }
        }

        FileInfo requireInit = new FileInfo(dataPath + "/requireInit.lua");
        if (requireInit.Exists == false) {
            requireInit.Create();
        }

        try
        {
            File.WriteAllText(requireInit.FullName, content, new UTF8Encoding(false));
        }
        catch (Exception e)
        {
            Debug.LogError(string.Format("文件可能被占用,无法写入！ {0}",requireInit.FullName));
        }
    }
}
