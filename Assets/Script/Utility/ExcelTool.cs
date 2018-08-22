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
    private static readonly string EXT_ERROR = "不可解析的文件格式：{0}";
    private static readonly string FIND_NOT_SHEET = "文件中没有工作表：{0}";
    private static readonly char SPILT = '/';
    private static readonly Dictionary<string, Action> Type2Func = new Dictionary<string, Action>();
    public static bool ExcelToLuaTable(string filePath)
    {
        FileInfo fileInfo = new FileInfo(filePath);
        
        //DirectoryInfo dir = new DirectoryInfo(filePath);
        if (!fileInfo.Exists)
        {
            Debug.LogError(string.Format(FIND_NOT_PATH, filePath));
            return false;
        }
        using (var file = File.OpenRead(filePath))
        {
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
                Debug.LogError(string.Format(EXT_ERROR, ext));
                return false;
            }
            if (workbook.NumberOfSheets <= 0)
            {
                Debug.LogError(string.Format(FIND_NOT_SHEET, filePath));
            }
            //
            ISheet sheet = workbook.GetSheetAt(0);
            Debug.Log(sheet.GetRow(2).GetCell(0));
            //for (int index = 0; index < workbook.NumberOfSheets; index++)
            //{
                //int rowCount = sheet.LastRowNum;
                //for (int i_row = 0; i_row < rowCount; i_row++)
                //{
                //    IRow row = sheet.GetRow(i_row);
                //    int colCount = row.LastCellNum;
                //}
            //}
        }
        return true;
    }

    public static bool ExcelToJson()
    {
        return true;
    }
}
