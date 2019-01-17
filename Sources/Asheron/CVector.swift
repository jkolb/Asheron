//
//  CVector.swift
//  Asheron
//
//  Created by Justin Kolb on 1/16/19.
//

public struct CVector : Hashable, CustomStringConvertible {
    public var x: Float
    public var y: Float
    public var z: Float
    
    public init() {
        self.init(0.0, 0.0, 0.0)
    }
    
    public init(_ x: Float, _ y: Float, _ z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public var description: String {
        return "{\(x), \(y), \(z)}"
    }
}
