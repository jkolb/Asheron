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

public struct LandBlockId : CellId {
    private static let landBlockIndex: UInt16 = 0xFFFF
    public var position: IntVector2<Int> {
        return IntVector2<Int>(_position)
    }
    public var index: UInt16 {
        return LandBlockId.landBlockIndex
    }
    private let _position: IntVector2<UInt8>
    
    public init?(handle: Handle) {
        let x = UInt8((handle.bits & 0xFF000000) >> 24)
        let y = UInt8((handle.bits & 0x00FF0000) >> 16)
        
        if x == 0xFF || y == 0xFF {
            return nil
        }
        
        let index = UInt16(handle.bits & 0x0000FFFF)
        
        if index != LandBlockId.landBlockIndex {
            return nil
        }
        
        self.init(position: IntVector2<UInt8>(x, y))
    }
    
    public init(position: IntVector2<UInt8> = IntVector2<UInt8>()) {
        self._position = position
    }
}
