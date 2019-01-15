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

// 0x0001269d
public struct RegionMisc {
    public var version: UInt32
    public var gameMap: PortalId<ImgTex>
    public var autotestMap: PortalId<ImgTex>
    public var autotestMapSize: UInt32
    public var clearCell: UInt32 // handle?
    public var clearMonster: UInt32 // handle?
    
    public init(
        version: UInt32,
        gameMap: PortalId<ImgTex>,
        autotestMap: PortalId<ImgTex>,
        autotestMapSize: UInt32,
        clearCell: UInt32,
        clearMonster: UInt32
        )
    {
        self.version = version
        self.gameMap = gameMap
        self.autotestMap = autotestMap
        self.autotestMapSize = autotestMapSize
        self.clearCell = clearCell
        self.clearMonster = clearMonster
    }
}
