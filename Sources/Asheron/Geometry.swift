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

public struct Vector2 : Packable, CustomStringConvertible {
    public var x: Float32
    public var y: Float32
    
    public var description: String {
        return "{\(x), \(y)}"
    }
    
    public init(from dataStream: DataStream) {
        self.x = Float32(from: dataStream)
        self.y = Float32(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        x.encode(to: dataStream)
        y.encode(to: dataStream)
    }
}

public struct Vector3 : Packable, CustomStringConvertible {
    public var x: Float32
    public var y: Float32
    public var z: Float32
    
    public var description: String {
        return "{\(x), \(y) \(z)}"
    }
    
    public init(x: Float32, y: Float32, z: Float32) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(from dataStream: DataStream) {
        self.x = Float32(from: dataStream)
        self.y = Float32(from: dataStream)
        self.z = Float32(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        x.encode(to: dataStream)
        y.encode(to: dataStream)
        z.encode(to: dataStream)
    }
}

public struct Quaternion : Packable, CustomStringConvertible {
    public var w: Float32
    public var x: Float32
    public var y: Float32
    public var z: Float32
    
    public var description: String {
        return "{\(w) {\(x), \(y) \(z)}}"
    }
    
    public init(from dataStream: DataStream) {
        self.w = Float32(from: dataStream)
        self.x = Float32(from: dataStream)
        self.y = Float32(from: dataStream)
        self.z = Float32(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        w.encode(to: dataStream)
        x.encode(to: dataStream)
        y.encode(to: dataStream)
        z.encode(to: dataStream)
    }
}

public struct Plane : Packable, CustomStringConvertible {
    public let normal: Vector3
    public let distance: Float32
    
    public var description: String {
        return "{\(normal), \(distance)}"
    }
    
    public init(from dataStream: DataStream) {
        self.normal = Vector3(from: dataStream)
        self.distance = Float32(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        normal.encode(to: dataStream)
        distance.encode(to: dataStream)
    }
}

public struct Sphere : Packable, CustomStringConvertible {
    public let center: Vector3
    public let radius: Float32
    
    public var description: String {
        return "{\(center), \(radius)}"
    }
    
    public init(from dataStream: DataStream) {
        self.center = Vector3(from: dataStream)
        self.radius = Float32(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        center.encode(to: dataStream)
        radius.encode(to: dataStream)
    }
}

public struct Frame : Packable {
    public var origin: Vector3
    public var quaternion: Quaternion
    
    public init(from dataStream: DataStream) {
        self.origin = Vector3(from: dataStream)
        self.quaternion = Quaternion(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        origin.encode(to: dataStream)
        quaternion.encode(to: dataStream)
    }
}

public struct CylSphere : Packable {
    public var lowPt: Vector3
    public var height: Float32
    public var radius: Float32
    
    public init(from dataStream: DataStream) {
        self.lowPt = Vector3(from: dataStream)
        self.height = Float32(from: dataStream)
        self.radius = Float32(from: dataStream)
    }
    
    @inlinable public func encode(to dataStream: DataStream) {
        lowPt.encode(to: dataStream)
        height.encode(to: dataStream)
        radius.encode(to: dataStream)
    }
}
