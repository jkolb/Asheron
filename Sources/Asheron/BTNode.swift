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

public struct BTNode<Entry : BTEntry> {
    public static var entryCount: Int32 { return 61 }
    public static var nextNodeCount: Int32 { return entryCount + 1 }
    
    public var nextNode: [Int32]
    public var numEntries: Int32
    public var entry: [Entry]
    
    public init(nextNode: [Int32], numEntries: Int32, entry: [Entry]) {
        precondition(Int32(nextNode.count) == BTNode<Entry>.nextNodeCount)
        precondition(Int32(entry.count) == BTNode<Entry>.entryCount)
        precondition(numEntries <= BTNode<Entry>.entryCount)
        self.nextNode = nextNode
        self.numEntries = numEntries
        self.entry = entry
    }
    
    @_transparent
    public var isLeaf: Bool {
        return nextNode[0] == 0
    }
}
