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

import Lilliput

extension OrderedByteBuffer {
    public func skip(_ count: Int) {
        let _ = getUInt8(count: count)
    }
    
    public func getBool() -> Bool {
        let value = getUInt32()
        precondition(value == 0 || value == 1)
        return value == 1
    }
    
    public func getString() -> String {
        let count: Int
        let shortCount = getUInt16()
        
        if shortCount == 0xFFFF {
            count = Int(getUInt32())
        }
        else {
            count = Int(shortCount)
        }
        
        var nulTerminatedUTF8 = getUInt8(count: count)
        nulTerminatedUTF8.append(0)
        
        align(4)
        
        return String(cString: nulTerminatedUTF8)
    }
    
    public func getString(count: Int) -> String {
        var nulTerminatedUTF8 = getUInt8(count: count)
        nulTerminatedUTF8.append(0)

        return String(cString: nulTerminatedUTF8)
    }
}
