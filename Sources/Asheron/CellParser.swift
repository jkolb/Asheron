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

public final class CellParser {
    public func parseLandBlock(size: IntVector2<Int>, handle: LandBlockId, inputStream: AsheronInputStream) -> LandBlock {
        fatalError("Not implemented")
//        let bytes = OrderedByteBuffer<LittleEndian>(buffer: buffer)
//        let rawHandle = bytes.getUInt32()
//        precondition(handle.rawValue == rawHandle)
//        let rawHasStructures = bytes.getUInt32()
//        precondition(rawHasStructures == 0 || rawHasStructures == 1)
//        let hasStructures = (rawHasStructures == 1)
//        let count = Int(size.rows) * Int(size.cols)
//        let topography = Grid<LandBlock.Topography>(size: size, columnMajorValues: bytes.getUInt16(count: count).map({ LandBlock.Topography(bits: $0) }))
//        let heightIndex = Grid<UInt8>(size: size, columnMajorValues: bytes.getUInt8(count: count))
//        bytes.skip(1)
//        precondition(!bytes.hasRemaining)
//        return LandBlock(handle: handle, hasStructures: hasStructures, topography: topography, heightIndex: heightIndex)
    }
}
