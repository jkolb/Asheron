/*
 The MIT License (MIT)
 
 Copyright (c) 2017 Justin Kolb
 
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

public enum TextureFormat : UInt32 {
    /* DirectX standard formats */
    case D3DFMT_R8G8B8   = 20         // RGB888
    case D3DFMT_A8R8G8B8 = 21         // ARGB888
    case D3DFMT_R5G6B5   = 23         // RGB565
    case D3DFMT_A4R4G4B4 = 26         // ARGB4444
    case D3DFMT_A8       = 28         // 8-bit alpha only
    case D3DFMT_P8       = 41         // 8-bit index
    case D3DFMT_DXT1     = 0x31545844 // MAKEFOURCC('D', 'X', 'T', '1')
    case D3DFMT_DXT3     = 0x33545844 // MAKEFOURCC('D', 'X', 'T', '3')
    case D3DFMT_DXT5     = 0x35545844 // MAKEFOURCC('D', 'X', 'T', '5')
    case D3DFMT_INDEX16  = 101        // 16-bit index
    /* Custom formats */
    case CUSTOM_B8R8G8   = 0xF3       // BGR888
    case CUSTOM_I8       = 0xF4       // Intensity (I, I, I, I)
    case CUSTOM_JFIF     = 0x01F4     // JFIF (https://en.wikipedia.org/wiki/JPEG_File_Interchange_Format)
}
