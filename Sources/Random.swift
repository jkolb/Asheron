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

public struct Random {
    public enum Seed : UInt32 {
        case cellDiagonal = 0x00000003
    }

    private let seed: Seed

    public init(seed: Seed) {
        self.seed = seed
    }

    public func generate(for position: CellPosition) -> Double {
        let magic1: UInt32 = 0x6C1AC587
        let magic2: UInt32 = 0x421BE3BD
        let magic3: UInt32 = 0x5111BFEF
        let magic4: UInt32 = 0x70892FB7
        let row = UInt32(position.row)
        let col = UInt32(position.col)
        let numerator = Double(magic1 &* col &- magic2 &* row &- seed.rawValue &* (magic3 &* col &* row &+ magic4))
        let denominator = Double(UInt32.max)

        return numerator / denominator
    }
}
