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

public final class LandBlock : CustomStringConvertible {
    public struct Topography : CustomStringConvertible {
        private let bits: UInt16

        public init(bits: UInt16) {
            self.bits = bits
        }
        
        public var sceneryIndex: UInt8 {
            return UInt8((self.bits & 0b11111_0000_00000_00) >> 11)
        }
        
        public var terrainIndex: UInt8 {
            return UInt8((self.bits & 0b00000_0000_11111_00) >> 2)
        }
        
        public var roadIndex: UInt8 {
            return UInt8((self.bits & 0b00000_0000_00000_11) >> 0)
        }
        
        public var description: String {
            return binary(bits)
        }
    }
    
    public static let size = 9
    public let handle: LandBlockHandle
    public let hasStructures: Bool
    private let topography: [Topography]
    private let heightIndex: [UInt8]
    
    public init(handle: LandBlockHandle, hasStructures: Bool, topography: [Topography], heightIndex: [UInt8]) {
        self.handle = handle
        self.hasStructures = hasStructures
        self.topography = topography
        self.heightIndex = heightIndex
    }
    
    public var position: CellPosition {
        return handle.position
    }
    
    public var description: String {
        return "\(handle)"
    }
    
    public func getTopography(x: Int, y: Int) ->Topography {
        return topography[y + (x * type(of: self).size)]
    }
    
    public func getHeightIndex(x: Int, y: Int) -> UInt8 {
        return heightIndex[y + (x * type(of: self).size)]
    }

    public func isSplitNESW(x: Int, y: Int) -> Bool {
        let grid = GridPosition(position: position, x: x, y: y)
        // https://github.com/deregtd/AC2D/blob/master/Landblocks.cpp
        // This makes the square shape near Singularity Caul have uniform tessellation
        let magic1 = UInt32(0x0CCAC033)
        let magic2 = UInt32(0x421BE3BD)
        let magic3 = UInt32(0x6C1AC587)
        let magic4 = UInt32(0x519B8F25)
        let result = ((grid.x &* grid.y) &* magic1) &- (grid.x &* magic2) &+ (grid.y &* magic3) &- magic4
        return ((result &* UInt32(0x80000000)) != UInt32(0))
    }
}
