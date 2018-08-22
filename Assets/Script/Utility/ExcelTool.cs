using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using XLua;
using ICSharpCode;
using System.Data;
using System.IO;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using NPOI.HSSF.UserModel;
using UnityEditor;
using UnityEngine;
public static class ExcelTool
{
    private static readonly string EXT_EXCEL_2003 = ".xls";
    private static readonly string EXT_EXCEL_2007 = ".xlsx";
    private static readonly string FIND_NOT_PATH = "路径不存在：{0}";
    private static readonly string ERROR_EXT = "不可解析的文件格式：{0}";
    private static readonly string FIND_NOT_SHEET = "文件中没有工作表：{0}";

    private static readonly char SPLIT = '/';
    private static readonly int KEY_ROW = 2;
    private static readonly int TYPE_ROW = 1;
    private static readonly int START_ROW = 4;
    private static readonly int START_COL = 2;

    private static readonly Dictionary<string, Func<string, string>> Type2Func = new Dictionary<string, Func<string, string>>()
    {
        {"int32",ToField},
        {"int64",ToField},
        {"int",ToField},
        {"float",ToField},
        {"str",ToString},
        {"string",ToString},
        {"list_int",ToIntList},
    };
    private static string ToField(string value)
    {
        return value;
    }

    private static string ToIntList(string value)
    {
        string[] values = value.Split(SPLIT);
        string str = "{";
        for (int i = 0; i < values.Length; i++)
        {
            if (i>0)
            {
                str = str + ",";
            }
            str = str + values[i];
        }
        str = str + "}";
        return str;
    }
    private static string ToString(string value)
    {
        return string.Format("\"{0}\"", value);
    }

    private static void ToInt32(LuaTable table, string key, string value)
    {
        table.Set<string, Int32>(key, Int32.Parse(value));
    }
    private static void ToInt64(LuaTable table, string key, string value)
    {
        table.Set<string, Int64>(key, Int64.Parse(value));
    }

    private static void ToFloat(LuaTable table, string key, string value)
    {
        table.Set<string, float>(key, float.Parse(value));
    }

    private static void ToIntList(LuaTable table, string key, string value)
    {
        //table.Set<string, string>(key, value);
    }


    public static bool ExcelToLuaTable(string filePath)
    {
        EditorUtility.DisplayProgressBar("ExcelToLuaTable", filePath, 0);
        FileInfo fileInfo = new FileInfo(filePath);
        if (!fileInfo.Exists)
        {
            Debug.LogError(string.Format(FIND_NOT_PATH, filePath));
            return false;
        }
        FileStream file = null;
        try
        {
            file = File.OpenRead(filePath);
        }
        catch (Exception e)
        {
            Debug.LogError("文件可能被占用,无法写入: " + Path.GetFileName(filePath));
        }
        if (file == null)
        {
            EditorUtility.ClearProgressBar();
            return false;
        }
        IWorkbook workbook = null;
        Debug.Log(fileInfo.FullName);
        string ext = Path.GetExtension(fileInfo.FullName).ToLower();

        if (ext == EXT_EXCEL_2003)
        {
            workbook = new HSSFWorkbook(file);
        }
        else if (ext == EXT_EXCEL_2007)
        {
            workbook = new XSSFWorkbook(file);
        }
        else
        {
            Debug.LogError(string.Format(ERROR_EXT, ext));
            EditorUtility.ClearProgressBar();
            return false;
        }
        if (workbook.NumberOfSheets <= 0)
        {
            Debug.LogError(string.Format(FIND_NOT_SHEET, filePath));
        }
        for (int index = 0; index < workbook.NumberOfSheets; index++)
        {
            string strTable = string.Empty;
            ISheet sheet = workbook.GetSheetAt(index);
            if (sheet.FirstRowNum > KEY_ROW)
            {
                continue;
            }

            //tableName
            string key_name = sheet.GetRow(KEY_ROW).GetCell(0).StringCellValue;
            strTable = string.Format("LuaConfig_{0} = {{\n", key_name);

            //type
            Dictionary<int, string> dicTypes = new Dictionary<int, string>();
            IRow row_types = sheet.GetRow(TYPE_ROW);
            if (row_types == null)
            {
                continue;
            }
            for (int i = row_types.FirstCellNum; i < row_types.LastCellNum; i++)
            {
                ICell cell = row_types.GetCell(i);
                if (cell == null)
                {
                    continue;
                }
                dicTypes[i] = cell.StringCellValue;
            }

            //key
            Dictionary<int, string> dicKeys = new Dictionary<int, string>();
            IRow row_keys = sheet.GetRow(KEY_ROW);
            if (row_keys == null)
            {
                continue;
            }
            for (int i = 2; i < row_keys.LastCellNum; i++)
            {
                ICell cell = row_keys.GetCell(i);
                if (cell == null)
                {
                    continue;
                }
                dicKeys[i] = cell.StringCellValue;
            }

            //value
            for (int i = 4; i < sheet.LastRowNum; i++)
            {
                IRow row_data = sheet.GetRow(i);
                string strOneRow = string.Empty;
                for (int j = row_data.FirstCellNum; j < row_data.LastCellNum; j++)
                {
                    if (j != row_data.FirstCellNum)
                    {
                        strOneRow = strOneRow + ",";
                    }
                    string value = string.Empty;
                    string key;
                    if (!dicKeys.TryGetValue(j, out key))
                    {
                        continue;
                    }
                    string type;
                    if (!dicTypes.TryGetValue(j, out type))
                    {
                        continue;
                    }
                    Func<string, string> func;
                    if (!Type2Func.TryGetValue(type, out func))
                    {
                        func = (string arg) => { return string.Format("\"{0}\"", arg); };
                    }
                    ICell cell = row_data.GetCell(j);
                    //只处理数字和字符串
                    if (cell.CellType != CellType.NUMERIC && cell.CellType != CellType.STRING)
                    {
                        continue;
                    };
                    cell.SetCellType(CellType.STRING);
                    value = func.Invoke(cell.StringCellValue);
                    if (key == "id")
                    {
                        strOneRow = string.Format("\t[{0}] = {{", value);
                    }
                    strOneRow = strOneRow + string.Format("{0}={1}", key, value);

                }
                if (!strOneRow.Equals(string.Empty))
                {
                    strOneRow = strOneRow + "},\n";
                    strTable = strTable + strOneRow;
                }
            }
            strTable = strTable + "}";
            //write
            FileInfo luaConfig = new FileInfo(@"C:/Users/Administrator/Desktop/LuaConfig_" + key_name + ".lua");
            //Debug.Log(luaConfig.FullName);
            if (luaConfig.Exists == false)
            {
                luaConfig.Create();
            }

            try
            {
                File.WriteAllText(luaConfig.FullName, strTable, Encoding.UTF8);
            }
            catch (Exception e)
            {
                Debug.LogError("文件肯能被占用,无法写入！");
            }
            EditorUtility.DisplayProgressBar("ExcelToLuaTable", filePath, index + 1 / row_types.LastCellNum);
        }
        EditorUtility.ClearProgressBar();
        return true;
    }


    public static bool ExcelToJson()
    {
        return true;
    }
}
