public struct Texture {
    public var width: UInt32
    public var height: UInt32
    public var format: TextureFormat
    public var data: ByteBuffer
    public var colors: [ARGB8888]
    
    public init(width: UInt32, height: UInt32, format: TextureFormat, data: ByteBuffer, colors: [ARGB8888]) {
        self.width = width
        self.height = height
        self.format = format
        self.data = data
        self.colors = colors
    }
}
