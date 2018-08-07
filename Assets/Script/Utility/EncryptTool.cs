using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace Tyou
{
    //加密工具
    public static class EncryptTool
    {
        //加密文件
        public static void EncryptFile(string path)
        {
            EncryptFile(path, path);
        }

        public static void EncryptFile(string path, string tarPath)
        {
            byte[] buffer = Encrypt(File.ReadAllBytes(path));
            File.WriteAllBytes(tarPath, buffer);
        }

        //加密
        public static byte[] Encrypt(byte[] buffer)
        {
            int length_buffer = buffer.Length;
            string key = GetKey();
            for (int index = 0; index < length_buffer; ++index)
            {
                int index_2 = index % key.Length;
                buffer[index] = (byte)((uint)buffer[index] ^ (uint)key[index_2]);
            }
            byte[] buffer_encrypt;
            using (MemoryStream memoryStream = new MemoryStream())
            {
                using (BinaryWriter binaryWriter = new BinaryWriter(memoryStream))
                {
                    binaryWriter.Write(buffer);
                    binaryWriter.Close();
                }
                buffer_encrypt = memoryStream.GetBuffer();
            }
            return buffer_encrypt;
        }

        //解密
        public static byte[] Decrypt(byte[] buffer)
        {
            byte[] buffer_decryet;
            using (MemoryStream memoryStream = new MemoryStream(buffer))
            {
                using (BinaryReader binaryReader = new BinaryReader(memoryStream))
                {
                    buffer_decryet = binaryReader.ReadBytes((int)memoryStream.Length);
                    string key = GetKey();
                    binaryReader.BaseStream.Seek(0L, SeekOrigin.Begin);
                    for (int index = 0; index < buffer_decryet.Length; ++index)
                    {
                        int index_2 = index % key.Length;
                        buffer_decryet[index] = (byte)((uint)buffer[index] ^ (uint)key[index_2]);
                    }
                }
            }
            return buffer_decryet;
        }
        //密钥
        private static string GetKey()
        {
            return "G*&(*Y*)YYH(YH&(";
        }
    }
}
