//
//  Quaternion.swift
//  Asheron
//
//  Created by Justin Kolb on 1/16/19.
//

public struct Quaternion : Hashable, CustomStringConvertible {
    public var w: Float
    public var xyz: CVector
    
    public var x: Float {
        get {
            return xyz.x
        }
        
        set {
            xyz.x = newValue
        }
    }
    
    public var y: Float {
        get {
            return xyz.y
        }
        
        set {
            xyz.y = newValue
        }
    }
    
    public var z: Float {
        get {
            return xyz.z
        }
        
        set {
            xyz.z = newValue
        }
    }
    
    public init() {
        self.init(1, CVector())
    }
    
    public init(_ w: Float, _ x: Float, _ y: Float, _ z: Float) {
        self.init(w, CVector(x, y, z))
    }
    
    public init(_ w: Float, _ xyz: CVector) {
        self.w = w
        self.xyz = xyz
    }
    
    public var description: String {
        return "{\(w), \(xyz)}"
    }
}
