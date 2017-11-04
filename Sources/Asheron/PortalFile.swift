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

public final class PortalFile {
    private let indexFile: IndexFile
    private let parser: PortalParser
    
    public init(indexFile: IndexFile) {
        self.indexFile = indexFile
        self.parser = PortalParser()
    }
    
    public func fetchColorTable(handle: ColorTableHandle) throws -> ColorTable {
        let buffer = try indexFile.readData(handle: handle.rawValue)
        
        return parser.parseColorTable(handle: handle, buffer: buffer)
    }
    
    public func fetchTextureList(handle: TextureListHandle) throws -> TextureList {
        let buffer = try indexFile.readData(handle: handle.rawValue)
        
        return parser.parseTextureList(handle: handle, buffer: buffer)
    }
    
    public func fetchTextureData(handle: TextureDataHandle) throws -> TextureData {
        let buffer = try indexFile.readData(handle: handle.rawValue)
        
        return parser.parseTextureData(handle: handle, buffer: buffer)
    }
    
    public func fetchWorldRegion(handle: WorldRegionHandle) throws -> WorldRegion {
        let buffer = try indexFile.readData(handle: handle.rawValue)
        
        return parser.parseWorldRegion(handle: handle, buffer: buffer)
    }
    
    public func fetchMaterial(handle: MaterialHandle) throws -> Material {
        let buffer = try indexFile.readData(handle: handle.rawValue)
        
        return parser.parseMaterial(handle: handle, buffer: buffer)
    }
}
