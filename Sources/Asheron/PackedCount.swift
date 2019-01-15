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

public struct PackedCount {
    public var value: Int32
    
    public init(_ value: Int32) {
        precondition(value >= 0)
        self.value = value
    }
    
//    @_transparent
//    public var packSize: Int {
//        if value <= 0b0_1111111 {
//            return 1
//        }
//        else {
//            return 2
//        }
//    }
//
//    public func pack(to stream: ByteOutputStream) {
//        if value <= 0b0_1111111 {
//            let b0 = UInt8(value)
//
//            stream.pack(b0)
//        }
//        else {
//            let b0 = UInt8((value & 0b0_1111111_00000000) >> 8)
//            let b1 = UInt8((value & 0b0_0000000_11111111) >> 0)
//
//            stream.pack(b0)
//            stream.pack(b1)
//        }
//    }
//
//    public static func unpack(from stream: ByteInputStream) -> PackedCount {
//        let byte0: UInt8 = stream.unpack()
//
//        if byte0 & 0b1_0000000 == 0b0_0000000 {
//            let b0 = byte0
//
//            return PackedCount(numericCast(b0))
//        }
//        else {
//            let byte1: UInt8 = stream.unpack()
//
//            let b0 = UInt16(byte0 & 0b0_1111111) << 8
//            let b1 = UInt16(byte1)
//
//            return PackedCount(numericCast(b0 | b1))
//        }
//    }
}
