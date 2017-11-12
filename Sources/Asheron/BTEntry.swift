/*
 The MIT License (MIT)
 
 Copyright (c) 2017 Justin Kolb
 
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

import Lilliput

public protocol BTEntry : Packable {
    static var empty: Self { get }
    var handle: UInt32 { get set }
    var offset: UInt32 { get set }
    var length: UInt32 { get set }
}

public struct BTEntryV1 : BTEntry {
    public let packSize = MemoryLayout<UInt32>.size * 3
    public var handle: UInt32 = 0
    public var offset: UInt32 = 0
    public var length: UInt32 = 0
    
    public static var empty: BTEntryV1 {
        return BTEntryV1()
    }
    
    public func pack<Order>(to buffer: OrderedByteBuffer<Order>) {
        buffer.putUInt32(handle)
        buffer.putUInt32(offset)
        buffer.putUInt32(length)
    }
    
    public mutating func unpack<Order>(from buffer: OrderedByteBuffer<Order>) {
        handle = buffer.getUInt32()
        offset = buffer.getUInt32()
        length = buffer.getUInt32()
    }
}

public struct BTEntryV2 : BTEntry {
    public let packSize = MemoryLayout<UInt32>.size * 6
    public var comp_resv_ver: UInt32 = 0 // 1_111111111111111_1111111111111111
    public var entry: BTEntryV1 = BTEntryV1()
    public var date: UInt32 = 0
    public var iter: UInt32 = 0
    public var handle: UInt32 {
        get {
            return entry.handle
        }
        set {
            entry.handle = newValue
        }
    }
    public var offset: UInt32 {
        get {
            return entry.offset
        }
        set {
            entry.offset = newValue
        }
    }
    public var length: UInt32 {
        get {
            return entry.length
        }
        set {
            entry.length = newValue
        }
    }
    
    public static var empty: BTEntryV2 {
        return BTEntryV2()
    }

    public func pack<Order>(to buffer: OrderedByteBuffer<Order>) {
        buffer.putUInt32(comp_resv_ver)
        entry.pack(to: buffer)
        buffer.putUInt32(date)
        buffer.putUInt32(iter)
    }
    
    public mutating func unpack<Order>(from buffer: OrderedByteBuffer<Order>) {
        comp_resv_ver = buffer.getUInt32()
        entry.unpack(from: buffer)
        date = buffer.getUInt32()
        iter = buffer.getUInt32()
    }
}
