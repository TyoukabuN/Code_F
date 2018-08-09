using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
[AttributeUsage(AttributeTargets.Class)]
public class MyAttribute : Attribute
{
    //public string Name = string.Empty;
    int Id;

    public MyAttribute(int id)
    {
        this.Id = id;
    }

    public int GetId()
    {
        return Id;
    }
}
[AttributeUsage(AttributeTargets.Class)]
public class BulletAttribute : Attribute
{
    public string Name;

    public BulletAttribute(string name)
    {
        Name = name;
    }
}
[System.AttributeUsage(System.AttributeTargets.Field | System.AttributeTargets.Enum)]
public class PatternAttribute : Attribute
{
    public PatternAttribute(string pattern)
    {
        Pattern = pattern;
    }
    public string Pattern { get; private set; }

}
[System.AttributeUsage(System.AttributeTargets.Field | System.AttributeTargets.Enum)]
public class AssetPathAttribute : Attribute
{
    public AssetPathAttribute(string path)
    {
        Path = path;
    }
    public string Path { get; private set; }

}




