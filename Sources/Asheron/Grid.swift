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

public struct Grid<T> {
    public let size: IntVector2<Int>
    private var values: [T]
    
    public init(rows: Int, columns: Int, initialValue: T) {
        self.init(size: IntVector2<Int>(columns, rows), initialValue: initialValue)
    }
    
    public init(size: IntVector2<Int>, initialValue: T) {
        self.size = size
        self.values = [T](repeating: initialValue, count: size.rows * size.columns)
    }
    
    public init(rows: Int, columns: Int, columnMajorValues: [T]) {
        self.init(size: IntVector2<Int>(columns, rows), columnMajorValues: columnMajorValues)
    }
    
    public var rows: Int {
        return size.rows
    }
    
    public var columns: Int {
        return size.columns
    }
    
    public init(size: IntVector2<Int>, columnMajorValues: [T]) {
        precondition(size.rows * size.columns == columnMajorValues.count)
        self.size = size
        self.values = columnMajorValues
    }
    
    public subscript<V: FixedWidthInteger> (position: IntVector2<V>) -> T {
        get {
            return values[index(position)];
        }
        set {
            values[index(position)] = newValue
        }
    }
    
    private func index<V: FixedWidthInteger>(_ position: IntVector2<V>) -> Int {
        // Column Major Order
        precondition(position.row < size.rows)
        precondition(position.column < size.columns)
        return (Int(position.column) * size.rows) + Int(position.row)
    }
}
