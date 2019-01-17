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

public final class LandBlock : CustomStringConvertible {
    public struct Topography : CustomStringConvertible {
        private let bits: UInt16
        
        public init(bits: UInt16 = 0) {
            self.bits = bits
        }
        
        public var sceneryListIndex: Int {
            return numericCast((self.bits & 0b11111_0000_00000_00) >> 11)
        }
        
        public var biomeIndex: Int {
            return numericCast((self.bits & 0b00000_0000_11111_00) >> 2)
        }
        
        public var roadIndex: Int {
            return numericCast((self.bits & 0b00000_0000_00000_11) >> 0)
        }
        
        public var description: String {
            return binary(bits)
        }
    }
    public struct LandHeight : CustomStringConvertible {
        private let bits: UInt8
        
        public init(bits: UInt8 = 0) {
            self.bits = bits
        }
        
        public var heightIndex: Int {
            return Int(bits)
        }
        
        public var description: String {
            return "\(bits)"
        }
    }
    public var landBlockId: LandBlockId
    public var hasStructures: Bool
    public var topography: Grid<Topography>
    public var landHeight: Grid<LandHeight>
    
    public init(size: IntVector2<Int>) {
        self.landBlockId = LandBlockId()
        self.hasStructures = false
        self.topography = Grid<Topography>(size: size, initialValue: Topography())
        self.landHeight = Grid<LandHeight>(size: size, initialValue: LandHeight())
    }
    
    public init(landBlockId: LandBlockId, hasStructures: Bool, topography: Grid<Topography>, landHeight: Grid<LandHeight>) {
        precondition(topography.size == landHeight.size)
        self.landBlockId = landBlockId
        self.hasStructures = hasStructures
        self.topography = topography
        self.landHeight = landHeight
    }
    
    public var position: IntVector2<Int> {
        return landBlockId.position
    }
    
    public var size: IntVector2<Int> {
        let overlap = IntVector2<Int>(1, 1)
        return landHeight.size - overlap
    }
    
    public var description: String {
        return "\(landBlockId)"
    }
    
    public func isSplitNESW(position: IntVector2<Int>) -> Bool {
        let worldPosition = landBlockId.position * size + position
        
        return splitNESW(worldPosition: IntVector2<UInt32>(worldPosition))
    }

    private func splitNESW(worldPosition: IntVector2<UInt32>) -> Bool {
        let x = worldPosition.x
        let y = worldPosition.y
        let magic1 = UInt32(0x0CCAC033)
        let magic2 = UInt32(0x421BE3BD)
        let magic3 = UInt32(0x6C1AC587)
        let magic4 = UInt32(0x519B8F25)
        let v = ((x &* y) &* magic1) &- (x &* magic2) &+ ((y &* magic3) &- magic4)
        let w = (v & UInt32(0x80000000))
        let p = w != 0
        return p
    }
    /*
     int FSplitNESW(long x, long y) {
        double v = ((x * y) * 0xCCAC033) - (x * 0x421BE3BD) + ((y * 0x6C1AC587) - 0x519B8F25);
        int w = (unsigned long)v / 2147483648;
        int p = ((w % 2) ? 1 : 0);
        return p;
     }
     bool cLandblock::FSplitNESW(DWORD x, DWORD y) {
        DWORD dw = x * y * 0x0CCAC033 - x * 0x421BE3BD + y * 0x6C1AC587 - 0x519B8F25;
        return (dw & 0x80000000) != 0;
     }
     bool Land::isSplitNESW(int gridX, int gridY) const {
        // credits to Akilla
        uint32_t cell_x = id().x() * 8 + gridX;
        uint32_t cell_y = id().y() * 8 + gridY;
        return prng(cell_x, cell_y, RND_MID_DIAG) >= 0.5;
     }
     // if prng(x, y, RND_MID_DIAG) >= 0.5, the landcell's polygon is split NE/SW
     static const int32_t RND_MID_DIAG       = 0x00000003;
     double prng(uint32_t cell_x, uint32_t cell_y, uint32_t seed) {
        uint32_t ival = 0x6C1AC587 * cell_y - 0x421BE3BD * cell_x - seed * (0x5111BFEF * cell_y * cell_x + 0x70892FB7);
        return static_cast<double>(ival) / static_cast<double>(UINT32_MAX);
     }
     */
}
