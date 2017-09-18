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

public struct LandBlockHandle : CellHandle {
    private static let landBlockIndex: UInt16 = 0xFFFF
    public let position: CellPosition
    public var index: UInt16 {
        return LandBlockHandle.landBlockIndex
    }
    
    public init?(rawValue: UInt32) {
        let position = CellPosition(rawValue: rawValue)!

        if position.x == 0xFF || position.y == 0xFF {
            return nil
        }

        let index = UInt16(rawValue & 0x0000FFFF)
        
        if index != LandBlockHandle.landBlockIndex {
            return nil
        }

        self.init(position: position)
    }
    
    public init(x: Int, y: Int) {
        self.init(position: CellPosition(x: x, y: y))
    }

    public init(position: CellPosition) {
        precondition(position.x != 0xFF)
        precondition(position.y != 0xFF)
        self.position = position
    }
}
