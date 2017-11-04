/*
 The MIT License (MIT)
 
 Copyright (c) 2017 Justin Kolb
 
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

public struct CellPosition : Hashable, CustomStringConvertible, RawRepresentable {
    public let x: UInt8
    public let y: UInt8
    
    public init?(rawValue: UInt32) {
        let x = UInt8((rawValue & 0xFF000000) >> 24)
        let y = UInt8((rawValue & 0x00FF0000) >> 16)
        
        self.init(x: x, y: y)
    }
    
    public init(x: UInt8, y: UInt8) {
        self.x = x
        self.y = y
    }
    
    public init(x: Int, y: Int) {
        self.init(x: UInt8(x), y: UInt8(y))
    }
    
    public var rawValue: UInt32 {
        return UInt32(x) << 24 | UInt32(y) << 16
    }
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public var description: String {
        return "(\(x), \(y))"
    }
}
