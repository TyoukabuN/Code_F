using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using XLua;
using ICSharpCode;
using System.IO;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using NPOI.HSSF.UserModel;

using OfficeOpenXml;
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
    private static readonly char SPLIT_2 = ',';
    private static readonly int KEY_ROW = 2;
    private static readonly int TYPE_ROW = 1;
    private static readonly int START_ROW = 4;
    private static readonly int START_COL = 2;

    private static readonly Dictionary<string, Func<string, string>> Type2Func = new Dictionary<string, Func<string, string>>()
    {
        {"int32",ToNum},
        {"int64",ToNum},
        {"int",ToNum},
        {"float",ToNum},
        {"str",ToString},
        {"string",ToString},
        {"list_int",ToList},
        {"list_str",ToStrList},
    };

    private static string ToNum(string value)
    {
        if (value.Equals(string.Empty))
        {
            value = "0";
        }
        return value;
    }
    private static string ToField(string value)
    {
        return value;
    }

    private static string ToList(string value)
    {
        string[] values = value.Split(SPLIT);
        if (values.Length == 1)
        {
            values = value.Split(SPLIT_2);
        }
        string str = "{";
        for (int i = 0; i < values.Length; i++)
        {
            if (string.IsNullOrEmpty(values[i]))
            {
                continue;
            }
            if (i > 0)
            {
                str = str + ",";
            }
            str = str + values[i];
        }
        str = str + "}";
        str.Replace(",}", "}");
        return str;
    }

    private static string ToStrList(string value)
    {
        string[] values = value.Split(SPLIT);
        if (values.Length == 1)
        {
            values = value.Split(SPLIT_2);
        }
        string str = "{";
        for (int i = 0; i < values.Length; i++)
        {
            if (string.IsNullOrEmpty(values[i]))
            {
                continue;
            }
            if (i > 0)
            {
                str = str + ",";
            }
            str = str + ToString(values[i]);
        }
        str = str + "}";
        str.Replace(",}", "}");
        return str;
    }
    private static string ToString(string value)
    {
        value = value.Replace(@"\", @"\\");
        return string.Format("\"{0}\"", value);
    }
    private class data
    {
        public string key;
        public string wholeRow;
    }
    public static bool ExcelToLuaTableNPOT(string filePath, string savePath)
    {
        EditorUtility.DisplayProgressBar("ExcelToLuaTable", filePath, 0);
        FileInfo fileInfo = new FileInfo(filePath);
        if (!fileInfo.Exists)
        {
            Debug.LogError(string.Format(FIND_NOT_PATH, filePath));
            EditorUtility.ClearProgressBar();
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
            file.Dispose();
            return false;
        }
        if (workbook.NumberOfSheets <= 0)
        {
            Debug.LogError(string.Format(FIND_NOT_SHEET, filePath));
        }
        for (int index = 0; index < workbook.NumberOfSheets; index++)
        {
            EditorUtility.DisplayProgressBar("ExcelToLuaTable", filePath, index + 1 / workbook.NumberOfSheets);
            string strTable = string.Empty;
            var tableMap = new List<ExcelTool.data>();
            ISheet sheet = workbook.GetSheetAt(index);
            if (sheet.FirstRowNum > KEY_ROW)
            {
                continue;
            }

            //tableName
            string key_name = string.Empty;
            try
            {
                IRow row = sheet.GetRow(KEY_ROW);
                ICell cell = row.GetCell(0);
                if (cell.CellType == CellType.ERROR || cell.CellType == CellType.BLANK || cell.CellType == CellType.Unknown)
                {
                    continue;
                }
                cell.SetCellType(CellType.STRING);
                key_name = cell.StringCellValue;
            }
            catch (Exception e)
            {
                EditorUtility.ClearProgressBar();
                continue;
            }
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
                string value = cell.StringCellValue;
                if (string.IsNullOrEmpty(value))
                {
                    continue;
                }
                dicTypes[i] = value;
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

                string value = cell.StringCellValue;
                if (string.IsNullOrEmpty(value))
                {
                    continue;
                }

                dicKeys[i] = value;
            }
            if (dicKeys.Count <= 0)
            {
                continue;
            }

            //value
            for (int i = 4; i < sheet.LastRowNum; i++)
            {
                IRow row_data = sheet.GetRow(i);
                if (row_data == null)
                {
                    continue;
                }
                if (row_data.FirstCellNum > 2)
                {
                    continue;
                }
                string mainKey = string.Empty;
                string strOneRow = string.Empty;
                for (int j = 2; j < row_data.LastCellNum; j++)
                {
                    bool isFirstCell = j == 2;
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

                    string[] types = type.Split('|');
                    type = types[0];
                    string conditions = string.Empty;
                    if (types.Length > 1)
                    {
                        conditions = types[1];
                    }
                    if (key_name.Equals("art") && key.Equals("nav"))
                    {
                        string s = string.Empty;
                    }
                    Func<string, string> func;
                    if (!Type2Func.TryGetValue(type, out func))
                    {
                        func = Type2Func["str"];
                    }
                    ICell cell = row_data.GetCell(j);
                    if (cell == null)
                    {
                        continue;
                    }
                    //只处理数字和字符串
                    if (cell.CellType == CellType.NUMERIC)
                    {
                        value = func.Invoke(cell.NumericCellValue.ToString());
                    }
                    else if (cell.CellType == CellType.STRING)
                    {
                        value = func.Invoke(cell.StringCellValue);
                    }
                    else if (cell.CellType == CellType.BLANK)
                    {
                        value = func.Invoke(string.Empty);
                        if (isFirstCell)
                        {
                            strOneRow = string.Empty;
                            break;
                        }
                    }
                    else
                    {
                        continue;
                    }

                    value = value.Replace("\r\n", "");
                    //处理条件
                    if (!string.IsNullOrEmpty(conditions))
                    {
                        if (conditions.Equals("half"))
                        {
                            value = value.Replace("\r\n", "");
                            value = value.Replace("\n", "");
                        }
                    }
                    //
                    if (j != row_data.FirstCellNum)
                    {
                        strOneRow = strOneRow + ",";
                    }

                    if (isFirstCell)
                    {
                        mainKey = value;
                        //strOneRow = strOneRow + "{{";
                    }

                    strOneRow = strOneRow + string.Format("{0}={1}", key, value);

                }
                if (!strOneRow.Equals(string.Empty))
                {
                    //strOneRow = strOneRow + "}";
                    tableMap.Add(new data() { key = mainKey, wholeRow = strOneRow });
                    //strTable = strTable + strOneRow;
                }
            }
            int count = tableMap.Count;
            int idx = 0;
            while (idx < count - 1)
            {
                if (idx > 0)
                {
                    strTable += ",\n";
                }
                strTable = strTable + string.Format("[{0}] = {{ {1} }}", tableMap[idx].key, tableMap[idx].wholeRow);
                idx++;
            }
            //foreach (var d in tableMap)
            //{
            //    strTable = strTable + string.Format("[{0}] = {{ {1} }}", d.key, d.wholeRow);
            //}
            strTable = strTable + "}";
            //write
            FileInfo luaConfig = new FileInfo(savePath + "/LuaConfig_" + key_name + ".lua");
            //Debug.Log(luaConfig.FullName);
            if (!luaConfig.Directory.Exists)
            {
                luaConfig.Directory.Create();

            }
            if (!luaConfig.Exists)
            {
                luaConfig.Create().Dispose();
            }
            try
            {
                File.WriteAllText(luaConfig.FullName, strTable, Encoding.UTF8);
            }
            catch (Exception e)
            {
                Debug.LogError(string.Format("文件可能被占用,无法写入！<color=yellow>{0}</color>,{1}", key_name, filePath));
                EditorUtility.ClearProgressBar();
                file.Dispose();
                return false;
            }
            //Debug.Log(string.Format("finish: <color=yellow>{0}</color>,{1},{2}", key_name, sheet.SheetName, filePath));
            EditorUtility.DisplayProgressBar("ExcelToLuaTable", filePath, index + 1 / row_types.LastCellNum);
        }
        EditorUtility.ClearProgressBar();
        file.Dispose();
        return true;
    }



    public static bool ExcelToLuaTableNPOTKiang(string filePath, string savePath)
    {
        EditorUtility.DisplayProgressBar("ExcelToLuaTable", filePath, 0);
        FileInfo fileInfo = new FileInfo(filePath);
        if (!fileInfo.Exists)
        {
            Debug.LogError(string.Format(FIND_NOT_PATH, filePath));
            EditorUtility.ClearProgressBar();
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
            file.Dispose();
            return false;
        }
        if (workbook.NumberOfSheets <= 0)
        {
            Debug.LogError(string.Format(FIND_NOT_SHEET, filePath));
        }
        for (int index = 0; index < workbook.NumberOfSheets; index++)
        {
            EditorUtility.DisplayProgressBar("ExcelToLuaTable", filePath, index + 1 / workbook.NumberOfSheets);
            string strTable = string.Empty;
            var tableMap = new List<ExcelTool.data>();
            ISheet sheet = workbook.GetSheetAt(index);
            if (sheet.FirstRowNum > KEY_ROW)
            {
                continue;
            }

            //tableName
            string key_name = string.Empty;
            try
            {
                IRow row = sheet.GetRow(KEY_ROW);
                ICell cell = row.GetCell(0);
                if (cell.CellType == CellType.ERROR || cell.CellType == CellType.BLANK || cell.CellType == CellType.Unknown)
                {
                    continue;
                }
                cell.SetCellType(CellType.STRING);
                key_name = cell.StringCellValue;
            }
            catch (Exception e)
            {
                EditorUtility.ClearProgressBar();
                continue;
            }
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
                string value = cell.StringCellValue;
                if (string.IsNullOrEmpty(value))
                {
                    continue;
                }
                dicTypes[i] = value;
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

                string value = cell.StringCellValue;
                if (string.IsNullOrEmpty(value))
                {
                    continue;
                }

                dicKeys[i] = value;
            }
            if (dicKeys.Count <= 0)
            {
                continue;
            }

            //value
            for (int i = 4; i < sheet.LastRowNum; i++)
            {
                IRow row_data = sheet.GetRow(i);
                if (row_data == null)
                {
                    continue;
                }
                if (row_data.FirstCellNum > 2)
                {
                    continue;
                }
                string mainKey = string.Empty;
                string strOneRow = string.Empty;
                for (int j = 2; j < row_data.LastCellNum; j++)
                {
                    bool isFirstCell = j == 2;
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

                    string[] types = type.Split('|');
                    type = types[0];
                    string conditions = string.Empty;
                    if (types.Length > 1)
                    {
                        conditions = types[1];
                    }
                    if (key_name.Equals("art") && key.Equals("nav"))
                    {
                        string s = string.Empty;
                    }
                    Func<string, string> func;
                    if (!Type2Func.TryGetValue(type, out func))
                    {
                        func = Type2Func["str"];
                    }
                    ICell cell = row_data.GetCell(j);
                    if (cell == null)
                    {
                        continue;
                    }
                    //只处理数字和字符串
                    if (cell.CellType == CellType.NUMERIC)
                    {
                        value = func.Invoke(cell.NumericCellValue.ToString());
                    }
                    else if (cell.CellType == CellType.STRING)
                    {
                        value = func.Invoke(cell.StringCellValue);
                    }
                    else if (cell.CellType == CellType.BLANK)
                    {
                        value = func.Invoke(string.Empty);
                        if (isFirstCell)
                        {
                            strOneRow = string.Empty;
                            break;
                        }
                    }
                    else
                    {
                        continue;
                    }

                    value = value.Replace("\r\n", "");
                    //处理条件
                    if (!string.IsNullOrEmpty(conditions))
                    {
                        if (conditions.Equals("half"))
                        {
                            value = value.Replace("\r\n", "");
                            value = value.Replace("\n", "");
                        }
                    }
                    //
                    if (j != row_data.FirstCellNum)
                    {
                        strOneRow = strOneRow + ",";
                    }

                    if (isFirstCell)
                    {
                        mainKey = value;
                        //strOneRow = strOneRow + "{{";
                    }

                    strOneRow = strOneRow + string.Format("{0}={1}", key, value);

                }
                if (!strOneRow.Equals(string.Empty))
                {
                    //strOneRow = strOneRow + "}";
                    tableMap.Add(new data() { key = mainKey, wholeRow = strOneRow });
                    //strTable = strTable + strOneRow;
                }
            }
            bool mix = false;

            for (int idx = 0; idx < tableMap.Count;idx++)
            {
                Debug.Log(idx);
                if (idx > 0 && !mix)
                {
                    strTable += ",\n";
                }
                var cur = tableMap[idx];
                data next = null;
                if (idx + 1 < tableMap.Count)
                {
                    next = tableMap[idx + 1];
                }

                string content = string.Format("[{0}] = {{ {1} }}", cur.key, cur.wholeRow);
                if (mix)
                {
                    content = string.Format("\n\t{{ {0} }} \n\t}}", cur.wholeRow);
                    mix = false;
                }
                else
                {
                    if (next != null && cur.key == next.key)
                    {
                        mix = true;
                        content = string.Format("[{0}] = {{ \n\t{{ {1} }},", cur.key, cur.wholeRow);
                    }
                }
                strTable = strTable + content;
            }
            //foreach (var d in tableMap)
            //{
            //    strTable = strTable + string.Format("[{0}] = {{ {1} }}", d.key, d.wholeRow);
            //}
            strTable = strTable + "\n}";
            //write
            FileInfo luaConfig = new FileInfo(savePath + "/LuaConfig_" + key_name + ".lua");
            //Debug.Log(luaConfig.FullName);
            if (!luaConfig.Directory.Exists)
            {
                luaConfig.Directory.Create();

            }
            if (!luaConfig.Exists)
            {
                luaConfig.Create().Dispose();
            }
            try
            {
                File.WriteAllText(luaConfig.FullName, strTable, Encoding.UTF8);
            }
            catch (Exception e)
            {
                Debug.LogError(string.Format("文件可能被占用,无法写入！<color=yellow>{0}</color>,{1}", key_name, filePath));
                EditorUtility.ClearProgressBar();
                file.Dispose();
                return false;
            }
            //Debug.Log(string.Format("finish: <color=yellow>{0}</color>,{1},{2}", key_name, sheet.SheetName, filePath));
            EditorUtility.DisplayProgressBar("ExcelToLuaTable", filePath, index + 1 / row_types.LastCellNum);
        }
        EditorUtility.ClearProgressBar();
        file.Dispose();
        return true;
    }

    public static bool ExcelToLuaTableEPPlus(string filePath, string savePath)
    {
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
            return false;
        }

        ExcelPackage excelPackage = new ExcelPackage(fileInfo);
        ExcelWorkbook workbook = excelPackage.Workbook;
        Action clearFunc = () =>
        {
            workbook.Dispose();
            excelPackage.Dispose();
            file.Dispose();
        };
        if (workbook == null)
        {
            clearFunc.Invoke();
            return false;
        }

        if (workbook.Worksheets.Count <= 0)
        {
            Debug.LogError(string.Format(FIND_NOT_SHEET, filePath));
            return false;
        }
        for (int index = 1; index < workbook.Worksheets.Count; index++)
        {
            string strTable = string.Empty;
            ExcelWorksheet sheet = workbook.Worksheets[index];

            int maxColumnNum = sheet.Dimension.End.Column;//最大列
            int minColumnNum = sheet.Dimension.Start.Column;//最小列

            int maxRowNum = sheet.Dimension.End.Row;//最小行
            int minRowNum = sheet.Dimension.Start.Row;//最大行

            //tableName
            string key_name = string.Empty;
            try
            {

                ExcelRow row = sheet.Row(KEY_ROW + 1);
                ExcelRangeBase cell = sheet.Cells[KEY_ROW + 1, 1];
                key_name = cell.GetValue<string>();//cell.StringCellValue;
            }
            catch (Exception e)
            {
                continue;
            }
            if (key_name == null)
            {
                continue;
            }
            strTable = string.Format("LuaConfig_{0} = {{\n", key_name);

            //type
            Dictionary<int, string> dicTypes = new Dictionary<int, string>();

            for (int i = 3; i < maxColumnNum; i++)
            {
                ExcelRangeBase cell = sheet.Cells[TYPE_ROW + 1, i];
                if (cell == null)
                {
                    continue;
                }
                string value = cell.GetValue<string>();
                if (value == null)
                {
                    break;
                }
                dicTypes[i] = value;
            }

            //key
            Dictionary<int, string> dicKeys = new Dictionary<int, string>();
            for (int i = 3; i < maxColumnNum; i++)
            {
                ExcelRangeBase cell = sheet.Cells[KEY_ROW + 1, i];
                if (cell == null)
                {
                    continue;
                }
                string value = cell.GetValue<string>();
                if (value == null)
                {
                    break;
                }
                dicKeys[i] = value;
            }

            //value
            for (int i = 5; i < maxRowNum; i++)
            {
                string strOneRow = string.Empty;
                for (int j = 3; j < maxColumnNum; j++)
                {
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

                    string[] types = type.Split('|');
                    type = types[0];
                    string conditions = string.Empty;
                    if (types.Length > 1)
                    {
                        conditions = types[1];
                    }

                    if (key_name.Equals("art") && key.Equals("nav"))
                    {
                        string s = string.Empty;
                    }
                    Func<string, string> func;
                    if (!Type2Func.TryGetValue(type, out func))
                    {
                        func = Type2Func["str"];
                    }
                    ExcelRangeBase cell = sheet.Cells[i, j];
                    if (cell == null)
                    {
                        continue;
                    }
                    value = cell.GetValue<string>();

                    if (value == null)
                    {
                        if (key == "id")
                        {
                            break;
                        }
                        value = func.Invoke(string.Empty);
                    }
                    else
                    {
                        value = func.Invoke(value);
                    }
                    value = value.Replace("\r\n", "");
                    //处理条件
                    if (!string.IsNullOrEmpty(conditions))
                    {
                        if (conditions.Equals("half"))
                        {
                            value = value.Replace("\r\n", "");
                            value = value.Replace("\n", "");
                        }
                    }
                    //
                    if (j != 3)
                    {
                        strOneRow = strOneRow + ",";
                    }

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
            FileInfo luaConfig = new FileInfo(savePath + "/LuaConfig_" + key_name + ".lua");
            //Debug.Log(luaConfig.FullName);
            if (luaConfig.Exists == false)
            {
                luaConfig.Create().Dispose();
            }
            try
            {
                File.WriteAllText(luaConfig.FullName, strTable, Encoding.UTF8);
            }
            catch (Exception e)
            {
                Debug.LogError(string.Format("文件可能被占用,无法写入！<color=yellow>{0}</color>,{1}", key_name, luaConfig.FullName));
                Debug.Log(e.ToString());
                clearFunc.Invoke();
                return false;
            }
            //Debug.Log(string.Format("finish: <color=yellow>{0}</color>,{1},{2}", key_name, sheet.SheetName, filePath));
            //EditorUtility.DisplayProgressBar("ExcelToLuaTable", filePath, index + 1 / workbook.Worksheets.Count);
        }
        clearFunc.Invoke();
        return true;
    }


    public static bool ExcelToJson()
    {
        return true;
    }
}
