public final class IndexFileManager {
    public func open(path: String) throws -> IndexFile {
        let binaryFile = try BinaryFile(path: path)
        let headerBytes = ByteBufferStream(buffer: ByteBuffer(count: 1024))
        try binaryFile.readBytes(headerBytes.buffer, at: 0)
        headerBytes.skipBytes(324)
        let blockSize = headerBytes.getUInt32()
        headerBytes.skipBytes(24)
        let rootNodeOffset = headerBytes.getUInt32()
        let blockFile = BlockFile(binaryFile: binaryFile, blockSize: blockSize)
        let indexFile = IndexFile(blockFile: blockFile, rootNodeOffset: rootNodeOffset)
        return indexFile
    }
}
