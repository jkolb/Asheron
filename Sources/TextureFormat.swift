public enum TextureFormat : UInt32 {
    /* DirectX standard formats */
    case D3DFMT_R8G8B8   = 20   // RGB888
    case D3DFMT_A8R8G8B8 = 21   // ARGB888
    case D3DFMT_R5G6B5   = 23   // RGB565
    case D3DFMT_A4R4G4B4 = 26   // ARGB4444
    case D3DFMT_P8       = 41   // 8-bit index
    case D3DFMT_DXT1     = 0x31545844 // MAKEFOURCC('D', 'X', 'T', '1')
    case D3DFMT_DXT3     = 0x33545844 // MAKEFOURCC('D', 'X', 'T', '3')
    case D3DFMT_DXT5     = 0x35545844 // MAKEFOURCC('D', 'X', 'T', '5')
    case D3DFMT_INDEX16  = 101  // 16-bit index
    /* Custom formats */
    case CUSTOM_B8R8G8   = 0xF3 // BGR888
    case CUSTOM_I8       = 0xF4 // Intensity (I, I, I, I)
}
