public final class BlockFile {
    private let binaryFile: BinaryFile
    private let block: ByteBufferStream
    
    public init(binaryFile: BinaryFile, blockSize: UInt32) {
        self.binaryFile = binaryFile
        self.block = ByteBufferStream(buffer: ByteBuffer(count: numericCast(blockSize)))
    }

    public func readBlocks(_ blocks: ByteBuffer, at offset: UInt32) throws {
        let data = ByteBufferStream(buffer: blocks)
        var offset = offset
        
        while offset > 0 {
            try binaryFile.readBytes(block.buffer, at: numericCast(offset))

            offset = block.getUInt32()
            data.copyBytes(from: block)
            
            block.reset()
        }
        
        precondition(data.remaining == 0)
    }
}
