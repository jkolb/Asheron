/*
 The MIT License (MIT)
 
 Copyright (c) 2018 Justin Kolb
 
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

import Swiftish

public struct SkyObject {
    public var objectName: String = "" // Not in file
    public var beginTime: Float
    public var endTime: Float
    public var beginAngle: Float
    public var endAngle: Float
    public var texVelocity: Vector3<Float>
    public var defaultGFXObject: Handle
    public var defaultPesObject: Handle
    public var properties: UInt32

    public init(
        beginTime: Float,
        endTime: Float,
        beginAngle: Float,
        endAngle: Float,
        texVelocity: Vector3<Float>,
        defaultGFXObject: Handle,
        defaultPesObject: Handle,
        properties: UInt32
        )
    {
        self.beginTime = beginTime
        self.endTime = endTime
        self.beginAngle = beginAngle
        self.endAngle = endAngle
        self.texVelocity = texVelocity
        self.defaultGFXObject = defaultGFXObject
        self.defaultPesObject = defaultPesObject
        self.properties = properties
    }
}
