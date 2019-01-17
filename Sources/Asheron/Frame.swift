//
//  Frame.swift
//  Asheron
//
//  Created by Justin Kolb on 1/16/19.
//

public struct Frame : Hashable {
    public var origin: CVector
    public var quaternion: Quaternion
    
    public init(origin: CVector, quaternion: Quaternion) {
        self.origin = origin
        self.quaternion = quaternion
    }
}
