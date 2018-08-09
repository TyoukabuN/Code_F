using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 单例模式*
/// </summary>
/// <typeparam name="T"></typeparam>
public abstract class Singleton<T> where T: new() //new()约束了
{
    public static readonly T Instance = new T();
}
