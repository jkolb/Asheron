/*
The MIT License (MIT)

Copyright (c) 2020 Justin Kolb

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

public class DataStream {
    public var data: Data
    public var nextIndex: Int {
        willSet {
            precondition(newValue >= data.startIndex)
            precondition(newValue <= data.endIndex)
        }
    }
    public var position: Int {
        get {
            return nextIndex - data.startIndex
        }
        set {
            nextIndex = newValue + data.startIndex
        }
    }
    public var remainingCount: Int {
        return data.endIndex - nextIndex
    }
    
    public convenience init(count: Int) {
        self.init(data: Data(count: count))
    }
    
    public init(data: Data) {
        self.data = data
        self.nextIndex = data.startIndex
    }
    
    @inlinable public func getUInt8() -> UInt8 {
        return get()
    }
    
    @inlinable public func getUInt16() -> UInt16 {
        return get()
    }
    
    @inlinable public func getUInt32() -> UInt32 {
        return get()
    }
    
    @inlinable public func getUInt64() -> UInt64 {
        return get()
    }
    
    @inlinable public func get<T : FixedWidthInteger>() -> T {
        var value: T = 0
        withUnsafeMutableBytes(of: &value) {
            let _ = getData(count: MemoryLayout<T>.size).copyBytes(to: $0)
        }
        return value
    }

    @inlinable public func getRemainingData() -> Data {
        return getData(count: remainingCount)
    }

    @inlinable public func getData(count: Int) -> Data {
        let begin = nextIndex
        let end = begin + count
        nextIndex = end
        return data[begin..<end]
    }
    
    @inlinable public func putUInt8(_ value: UInt8) {
        put(value)
    }
    
    @inlinable public func putUInt16(_ value: UInt16) {
        put(value)
    }
    
    @inlinable public func putUInt32(_ value: UInt32) {
        put(value)
    }
    
    @inlinable public func putUInt64(_ value: UInt64) {
        put(value)
    }
    
    @inlinable public func put<T : FixedWidthInteger>(_ value: T) {
        var value = value
        withUnsafeBytes(of: &value) {
            putData(Data($0))
        }
    }
    
    @inlinable public func putRemainingData(_ value: DataStream) {
        putRemainingData(value.getRemainingData())
    }
    
    @inlinable public func putRemainingData(_ value: Data) {
        putData(value, count: min(remainingCount, value.count))
    }

    @inlinable public func putData(_ value: Data) {
        putData(value, count: value.count)
    }
    
    @inlinable public func putData(_ value: Data, count: Int) {
        precondition(count <= value.count)
        let begin = nextIndex
        let end = begin + count
        nextIndex = end
        data[begin..<end] = value.prefix(count)
    }
    
    @inlinable public func align(to size: Int = MemoryLayout<UInt32>.size) {
        let skipBytes = size - (position % size)
        
        if skipBytes < size {
            position += skipBytes
        }
    }
}
