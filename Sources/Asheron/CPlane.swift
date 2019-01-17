//
//  CSphere.swift
//  Asheron
//
//  Created by Justin Kolb on 1/16/19.
//

public struct CPlane : Hashable, CustomStringConvertible {
    public let normal: CVector
    public let distance: Float
    
    public init(normal: CVector, distance: Float) {
        self.normal = normal
        self.distance = distance
    }
    
    public var description: String {
        return "{\(normal), \(distance)}"
    }
}
