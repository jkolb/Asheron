//
//  CSphere.swift
//  Asheron
//
//  Created by Justin Kolb on 1/16/19.
//

public struct CSphere : Hashable, CustomStringConvertible {
    public let center: CVector
    public let radius: Float
    
    public init(center: CVector, radius: Float) {
        precondition(radius >= 0)
        self.center = center
        self.radius = radius
    }
    
    public var description: String {
        return "{\(center), \(radius)}"
    }
}
