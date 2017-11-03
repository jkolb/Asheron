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

public struct GridPosition : Hashable, CustomStringConvertible {
    public let x: UInt32
    public let y: UInt32
    
    public init(position: CellPosition, x: Int, y: Int) {
        precondition(x >= 0 && x < 8)
        precondition(y >= 0 && y < 8)
        self.x = UInt32(Int(position.x) * 8 + x)
        self.y = UInt32(Int(position.y) * 8 + y)
    }

    public var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
    
    public var description: String {
        return "(\(x), \(y))"
    }

    public static func ==(a: GridPosition, b: GridPosition) -> Bool {
        return a.x == b.x && a.y == b.y
    }
}