//
//  Vector2.swift
//  Asheron
//
//  Created by Justin Kolb on 1/16/19.
//

public struct Vector2 : Hashable, CustomStringConvertible {
    public var x: Float
    public var y: Float
    
    public init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
    
    public var description: String {
        return "{\(x), \(y)}"
    }
}
