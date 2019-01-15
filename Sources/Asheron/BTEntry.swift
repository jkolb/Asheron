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

public protocol BTEntry {
    var handle: Handle { get set }
    var offset: Offset { get set }
    var length: Length { get set }
}

public struct BTEntryV1 : BTEntry {
    public var handle: Handle
    public var offset: Offset
    public var length: Length

    public init(handle: Handle, offset: Offset, length: Length) {
        self.handle = handle
        self.offset = offset
        self.length = length
    }
}

public struct BTEntryV2 : BTEntry {
    public var comp_resv_ver: UInt32 // 1_111111111111111_1111111111111111
    public var handle: Handle
    public var offset: Offset
    public var length: Length
    public var date: UInt32
    public var iter: UInt32

    public init(comp_resv_ver: UInt32, handle: Handle, offset: Offset, length: Length, date: UInt32, iter: UInt32) {
        self.comp_resv_ver = comp_resv_ver
        self.handle = handle
        self.offset = offset
        self.length = length
        self.date = date
        self.iter = iter
    }
}
