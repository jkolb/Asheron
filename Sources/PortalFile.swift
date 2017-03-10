public final class PortalFile {
    private let indexFile: IndexFile
    
    public init(indexFile: IndexFile) {
        self.indexFile = indexFile
    }
    
    public func fetchColors(handle: PortalHandle) throws -> [ARGB8888] {
        precondition(handle.kind == .colors)
        let bytes = ByteStream(buffer: try indexFile.readData(handle: handle.rawValue))
        let rawHandle = bytes.getUInt32()
        precondition(handle.rawValue == rawHandle)
        let count = bytes.getUInt32()
        var colors = [ARGB8888]()
        colors.reserveCapacity(numericCast(count))
        
        for _ in 0..<count {
            let color = ARGB8888(bits: bytes.getUInt32())
            
            colors.append(color)
        }
        
        return colors
    }
    
    public func fetchTexture(handle: PortalHandle) throws -> Texture {
        precondition(handle.kind == .texture)
        let bytes = ByteStream(buffer: try indexFile.readData(handle: handle.rawValue))
        let rawHandle = bytes.getUInt32()
        precondition(handle.rawValue == rawHandle)
        bytes.skip(MemoryLayout<UInt32>.size)
        let width = bytes.getUInt32()
        let height = bytes.getUInt32()
        let format = TextureFormat(rawValue: bytes.getUInt32())!
        let data = ByteBuffer(count: numericCast(bytes.getUInt32()))
        bytes.copyBytes(to: data)
        var colors: [ARGB8888] = []
        
        if format == .D3DFMT_INDEX16 || format == .D3DFMT_P8 {
            colors = try fetchColors(handle: PortalHandle(rawValue: bytes.getUInt32())!)
        }

        return Texture(width: width, height: height, format: format, data: data, colors: colors)
    }
}
