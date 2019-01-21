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

public protocol AsheronInputStream : class {
    var bytesRead: Int32 { get }
    func skip(count: Int32) throws
    func readUInt8()  throws -> UInt8
    func readUInt16() throws -> UInt16
    func readUInt32() throws -> UInt32
    func readUInt64() throws -> UInt64
    func readInt8()  throws -> Int8
    func readInt16() throws -> Int16
    func readInt32() throws -> Int32
    func readInt64() throws -> Int64
    func readFloat32() throws -> Float32
    func readFloat64() throws -> Float64
    func read(bytes: UnsafeMutableRawPointer, count: Int32) throws -> Int32
}
