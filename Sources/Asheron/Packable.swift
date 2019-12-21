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

public protocol Packable {
    init(from dataStream: DataStream)
    func encode(to dataStream: DataStream)
}

public protocol CountPackable {
    init(from dataStream: DataStream, count: Int)
}

public struct FourCC : RawRepresentable, Packable {
    public let rawValue: String
    
    public init(_ code: String) {
        self.init(rawValue: code)!
    }
    
    public init?(rawValue: String) {
        precondition(rawValue.count == 4)
        self.rawValue = rawValue
    }
    
    public init(from dataStream: DataStream) {
        let bytes = [UInt8](from: dataStream, count: 4)
        self.init(rawValue: String(bytes: bytes, encoding: .utf8)!)!
    }
    
    public func encode(to dataStream: DataStream) {
        for byte in rawValue.utf8 {
            byte.encode(to: dataStream)
        }
    }
}

extension Bool : Packable {
    @inlinable public init(from dataStream: DataStream) {
        self.init(dataStream.getUInt32() != 0)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        dataStream.putUInt32(self ? 1 : 0)
    }
}

extension Int8 : Packable {
    @inlinable public init(from dataStream: DataStream) {
        self.init(bitPattern: dataStream.getUInt8())
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        UInt8(bitPattern: self).encode(to: dataStream)
    }
}

extension Int16 : Packable {
    @inlinable public init(from dataStream: DataStream) {
        self.init(bitPattern: dataStream.getUInt16())
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        UInt16(bitPattern: self).encode(to: dataStream)
    }
}

extension Int32 : Packable {
    @inlinable public init(from dataStream: DataStream) {
        self.init(bitPattern: dataStream.getUInt32())
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        UInt32(bitPattern: self).encode(to: dataStream)
    }
}

extension Int : Packable {
    @inlinable public init(from dataStream: DataStream) {
        let byte0 = dataStream.getUInt8()
        
        if byte0 & 0b1_0000000 == 0b0_0000000 {
            let b0 = UInt32(byte0)
            
            self = Int(Int32(bitPattern: b0))
            return
        }

        let byte1 = dataStream.getUInt8()

        if byte0 & 0b01_000000 == 0b00_000000 {
            let b0 = UInt32(byte0 & 0b0_1111111) << 8
            let b1 = UInt32(byte1)
            
            self = Int(Int32(bitPattern: b0 | b1))
            return
        }
        
        let short = dataStream.getUInt16()
        
        let hi0 = UInt32(byte0 & 0b00_111111) << 8
        let hi1 = UInt32(byte1)
        let hi = UInt32(hi0 | hi1) << 16
        let lo = UInt32(short)
        
        self = Int(Int32(bitPattern: hi | lo))
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

extension UInt8 : Packable {
    @inlinable public init(from dataStream: DataStream) {
        self.init(littleEndian: dataStream.getUInt8())
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        dataStream.putUInt8(littleEndian)
    }
}

extension UInt16 : Packable {
    @inlinable public init(from dataStream: DataStream) {
        self.init(littleEndian: dataStream.getUInt16())
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        dataStream.putUInt16(littleEndian)
    }
}

extension UInt32 : Packable {
    @inlinable public init(from dataStream: DataStream) {
        self.init(littleEndian: dataStream.getUInt32())
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        dataStream.putUInt32(littleEndian)
    }
}

extension UInt64 : Packable {
    @inlinable public init(from dataStream: DataStream) {
        self.init(littleEndian: dataStream.getUInt64())
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        dataStream.putUInt64(littleEndian)
    }
}

extension Float32 : Packable {
    @inlinable public init(from dataStream: DataStream) {
        self.init(bitPattern: dataStream.getUInt32())
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        bitPattern.encode(to: dataStream)
    }
}

extension Float64 : Packable {
    @inlinable public init(from dataStream: DataStream) {
        self.init(bitPattern: dataStream.getUInt64())
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        bitPattern.encode(to: dataStream)
    }
}

extension String : Packable {
    @inlinable public init(from dataStream: DataStream) {
        let length: Int
        let length16 = dataStream.getUInt16()
        
        if length16 == 0xFFFF {
            let length32 = dataStream.getUInt32()
            
            length = numericCast(length32)
        }
        else {
            length = numericCast(length16)
        }
        
        let bytes = [UInt8](from: dataStream, count: length)
        let string = String(bytes: bytes, encoding: .utf8)!
        
        dataStream.align()
        
        self = string
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        fatalError("Not implemented")
    }
}

extension Array where Element : Packable {
    @inlinable public init(from dataStream: DataStream) {
        let count = Int32(from: dataStream)
        self.init(from: dataStream, count: numericCast(count))
    }
    
    @inlinable public init(uncompress dataStream: DataStream) {
        let count = Int(from: dataStream)
        self.init(from: dataStream, count: count)
    }
    
    @inlinable public init(from dataStream: DataStream, count: Int) {
        var array = [Element]()
        array.reserveCapacity(count)
        
        for _ in 0..<count {
            let element = Element(from: dataStream)
            array.append(element)
        }
        
        self = array
    }
}

extension Dictionary where Key : Packable, Value : Packable {
    @inlinable public init(from dataStream: DataStream) {
        let count: Int = numericCast(Int32(from: dataStream))
        self.init(from: dataStream, count: count)
    }
    
    @inlinable public init(from dataStream: DataStream, count: Int) {
        var dictionary = [Key:Value](minimumCapacity: count)
        
        for _ in 0..<count {
            let key = Key(from: dataStream)
            let value = Value(from: dataStream)
            
            dictionary[key] = value
        }
        
        self = dictionary
    }
}

extension Dictionary where Key : Packable, Value : CountPackable {
    @inlinable public init(from dataStream: DataStream, valueCount: Int) {
        let count: Int = numericCast(Int32(from: dataStream))
        self.init(from: dataStream, count: count, valueCount: valueCount)
    }
    
    @inlinable public init(from dataStream: DataStream, count: Int, valueCount: Int) {
        var dictionary = [Key:Value](minimumCapacity: count)
        
        for _ in 0..<count {
            let key = Key(from: dataStream)
            let value = Value(from: dataStream, count: valueCount)
            
            dictionary[key] = value
        }
        
        self = dictionary
    }
}

extension RawRepresentable where RawValue : Packable {
    @inlinable public init(from dataStream: DataStream) {
        self.init(rawValue: RawValue(from: dataStream))!
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        rawValue.encode(to: dataStream)
    }
}

extension Data : Packable, CountPackable {
    public init(from dataStream: DataStream) {
        self.init(dataStream.getRemainingData())
    }
    
    public func encode(to dataStream: DataStream) {
        dataStream.putData(self)
    }

    public init(from dataStream: DataStream, count: Int) {
        self.init(dataStream.getData(count: count))
    }
}
