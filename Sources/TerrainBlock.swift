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

public final class TerrainBlock : CustomStringConvertible {
    public static let size = 9
    public let handle: UInt32
    public let flags: UInt32
    public let index: [UInt16]
    public let height: [UInt8]
    
    public init(handle: UInt32, flags: UInt32, index: [UInt16], height: [UInt8]) {
        self.handle = handle
        self.flags = flags
        self.index = index
        self.height = height
    }
    
    public var description: String {
        var string = "["
        let size = type(of: self).size
        
        for y in 0..<size {
            string += "\t[ "
            
            for x in 0..<size {
                let index = x + (y * size)
                
                string += hex(height[index])
                
                if x < size - 1 {
                    string += ", "
                }
            }
            
            string += " ]\n"
        }

        string += "]"
        
        return string
    }
}
