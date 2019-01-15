/*
 The MIT License (MIT)
 
 Copyright (c) 2018 Justin Kolb
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
/*
 0x4cc3 : Length = 1170, Leaf = 0x1203 LF_FIELDLIST
 list[0] = LF_ENUMERATE, public, value = 0, name = 'PFID_UNKNOWN'
 list[1] = LF_ENUMERATE, public, value = 20, name = 'PFID_R8G8B8'
 list[2] = LF_ENUMERATE, public, value = 21, name = 'PFID_A8R8G8B8'
 list[3] = LF_ENUMERATE, public, value = 22, name = 'PFID_X8R8G8B8'
 list[4] = LF_ENUMERATE, public, value = 23, name = 'PFID_R5G6B5'
 list[5] = LF_ENUMERATE, public, value = 24, name = 'PFID_X1R5G5B5'
 list[6] = LF_ENUMERATE, public, value = 25, name = 'PFID_A1R5G5B5'
 list[7] = LF_ENUMERATE, public, value = 26, name = 'PFID_A4R4G4B4'
 list[8] = LF_ENUMERATE, public, value = 27, name = 'PFID_R3G3B2'
 list[9] = LF_ENUMERATE, public, value = 28, name = 'PFID_A8'
 list[10] = LF_ENUMERATE, public, value = 29, name = 'PFID_A8R3G3B2'
 list[11] = LF_ENUMERATE, public, value = 30, name = 'PFID_X4R4G4B4'
 list[12] = LF_ENUMERATE, public, value = 31, name = 'PFID_A2B10G10R10'
 list[13] = LF_ENUMERATE, public, value = 32, name = 'PFID_A8B8G8R8'
 list[14] = LF_ENUMERATE, public, value = 33, name = 'PFID_X8B8G8R8'
 list[15] = LF_ENUMERATE, public, value = 35, name = 'PFID_A2R10G10B10'
 list[16] = LF_ENUMERATE, public, value = 40, name = 'PFID_A8P8'
 list[17] = LF_ENUMERATE, public, value = 41, name = 'PFID_P8'
 list[18] = LF_ENUMERATE, public, value = 50, name = 'PFID_L8'
 list[19] = LF_ENUMERATE, public, value = 51, name = 'PFID_A8L8'
 list[20] = LF_ENUMERATE, public, value = 52, name = 'PFID_A4L4'
 list[21] = LF_ENUMERATE, public, value = 60, name = 'PFID_V8U8'
 list[22] = LF_ENUMERATE, public, value = 61, name = 'PFID_L6V5U5'
 list[23] = LF_ENUMERATE, public, value = 62, name = 'PFID_X8L8V8U8'
 list[24] = LF_ENUMERATE, public, value = 63, name = 'PFID_Q8W8V8U8'
 list[25] = LF_ENUMERATE, public, value = 64, name = 'PFID_V16U16'
 list[26] = LF_ENUMERATE, public, value = 67, name = 'PFID_A2W10V10U10'
 list[27] = LF_ENUMERATE, public, value = (LF_ULONG) 1498831189, name = 'PFID_UYVY'
 list[28] = LF_ENUMERATE, public, value = (LF_ULONG) 1195525970, name = 'PFID_R8G8_B8G8'
 list[29] = LF_ENUMERATE, public, value = (LF_ULONG) 844715353, name = 'PFID_YUY2'
 list[30] = LF_ENUMERATE, public, value = (LF_ULONG) 1111970375, name = 'PFID_G8R8_G8B8'
 list[31] = LF_ENUMERATE, public, value = (LF_ULONG) 827611204, name = 'PFID_DXT1'
 list[32] = LF_ENUMERATE, public, value = (LF_ULONG) 844388420, name = 'PFID_DXT2'
 list[33] = LF_ENUMERATE, public, value = (LF_ULONG) 861165636, name = 'PFID_DXT3'
 list[34] = LF_ENUMERATE, public, value = (LF_ULONG) 877942852, name = 'PFID_DXT4'
 list[35] = LF_ENUMERATE, public, value = (LF_ULONG) 894720068, name = 'PFID_DXT5'
 list[36] = LF_ENUMERATE, public, value = 70, name = 'PFID_D16_LOCKABLE'
 list[37] = LF_ENUMERATE, public, value = 71, name = 'PFID_D32'
 list[38] = LF_ENUMERATE, public, value = 73, name = 'PFID_D15S1'
 list[39] = LF_ENUMERATE, public, value = 75, name = 'PFID_D24S8'
 list[40] = LF_ENUMERATE, public, value = 77, name = 'PFID_D24X8'
 list[41] = LF_ENUMERATE, public, value = 79, name = 'PFID_D24X4S4'
 list[42] = LF_ENUMERATE, public, value = 80, name = 'PFID_D16'
 list[43] = LF_ENUMERATE, public, value = 100, name = 'PFID_VERTEXDATA'
 list[44] = LF_ENUMERATE, public, value = 101, name = 'PFID_INDEX16'
 list[45] = LF_ENUMERATE, public, value = 102, name = 'PFID_INDEX32'
 list[46] = LF_ENUMERATE, public, value = 240, name = 'PFID_CUSTOM_R8G8B8A8'
 list[47] = LF_ENUMERATE, public, value = 241, name = 'PFID_CUSTOM_A8B8G8R8'
 list[48] = LF_ENUMERATE, public, value = 242, name = 'PFID_CUSTOM_B8G8R8'
 list[49] = LF_ENUMERATE, public, value = 243, name = 'PFID_CUSTOM_LSCAPE_R8G8B8'
 list[50] = LF_ENUMERATE, public, value = 244, name = 'PFID_CUSTOM_LSCAPE_ALPHA'
 list[51] = LF_ENUMERATE, public, value = 500, name = 'PFID_CUSTOM_RAW_JPEG'
 list[52] = LF_ENUMERATE, public, value = 240, name = 'PFID_CUSTOM_FIRST'
 list[53] = LF_ENUMERATE, public, value = 500, name = 'PFID_CUSTOM_LAST'
 list[54] = LF_ENUMERATE, public, value = (LF_ULONG) 2147483647, name = 'PFID_INVALID'
 
 0x4cc4 : Length = 30, Leaf = 0x1507 LF_ENUM
 # members = 55,  type = T_INT4(0074) field list type 0x4cc3
 enum name = PixelFormatID, UDT(0x00004cc4)
 */
