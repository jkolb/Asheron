
public protocol DXTReader {
    associatedtype DXTBlockType : DXTBlock
    func read(_ buffer: ByteStream) -> DXTBlockType
}

public struct DXT1Reader : DXTReader {
    public init() {}
    public func read(_ buffer: ByteStream) -> DXT1Block {
        return DXT1Block(colorBlock: DXTColor(bits: buffer.getUInt64()))
    }
}

public struct DXT3Reader : DXTReader {
    public init() {}
    public func read(_ buffer: ByteStream) -> DXT3Block {
        return DXT3Block(alphaBlock: DXT3Alpha(bits: buffer.getUInt64()), colorBlock: DXTColor(bits: buffer.getUInt64()))
    }
}

public struct DXT5Reader : DXTReader {
    public init() {}
    public func read(_ buffer: ByteStream) -> DXT5Block {
        return DXT5Block(alphaBlock: DXT5Alpha(bits: buffer.getUInt64()), colorBlock: DXTColor(bits: buffer.getUInt64()))
    }
}
