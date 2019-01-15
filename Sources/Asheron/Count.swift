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

public struct Count : RawRepresentable, Comparable, Hashable, CustomStringConvertible, ExpressibleByIntegerLiteral, Strideable {
    public let rawValue: Int32
    
    public init(rawValue: Int32) {
        precondition(rawValue >= 0)
        self.rawValue = rawValue
    }
    
    public init(integerLiteral value: Int32) {
        self.init(rawValue: value)
    }
    
    public init<T>(_ source: T) where T : BinaryInteger {
        self.init(rawValue: Int32(source))
    }
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public static func ==(a: Count, b: Count) -> Bool {
        return a.rawValue == b.rawValue
    }
    
    public static func <(a: Count, b: Count) -> Bool {
        return a.rawValue < b.rawValue
    }
    
    public static func +(a: Count, b: Count) -> Count {
        return Count(rawValue: a.rawValue + b.rawValue)
    }
    
    public var description: String {
        return rawValue.description
    }
    
    public func distance(to other: Count) -> Int {
        return Int(other.rawValue) - Int(rawValue)
    }
    
    public func advanced(by n: Int) -> Count {
        return Count(rawValue: rawValue + Int32(n))
    }
}

extension Int {
    public init(_ count: Count) {
        self.init(count.rawValue)
    }
}

extension Array {
    public subscript (index: Count) -> Element {
        return self[Int(index)]
    }
}
