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

public struct CellPosition : Equatable, Hashable, CustomStringConvertible, RawRepresentable {
    public let row: UInt8
    public let col: UInt8
    
    public init?(rawValue: UInt32) {
        let row = UInt8((rawValue & 0xFF000000) >> 24)
        let col = UInt8((rawValue & 0x00FF0000) >> 16)
        
        self.init(row: row, col: col)
    }
    
    public init(row: UInt8, col: UInt8) {
        self.row = row
        self.col = col
    }

    public init(row: Int, col: Int) {
        self.init(row: UInt8(row), col: UInt8(col))
    }

    public var rawValue: UInt32 {
        return UInt32(row) << 24 | UInt32(col) << 16
    }
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public var description: String {
        return "(\(row), \(col))"
    }
}