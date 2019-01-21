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

public final class HighresFile {
    private let btreeDataSource: BTreeDataSourceV2
    
    public init(btreeDataSource: BTreeDataSourceV2) {
        self.btreeDataSource = btreeDataSource
    }
    
    public func fetchImgTex(portalId: PortalId<ImgTex>) throws -> ImgTex {
        return try ImgTexInputStream(stream: fetch(portalId: portalId)).readImgTex(portalId: portalId)
    }

    private func fetch<T: PortalObject>(portalId: PortalId<T>) throws -> AsheronInputStream {
        return try btreeDataSource.readData(handle: portalId.handle)
    }
    
    public func allPortalIds<T: PortalObject>() throws -> [PortalId<T>] {
        let rawHandles = try btreeDataSource.handles(matching: { ($0.bits & 0xFF000000) == T.kind.rawValue })
        
        return rawHandles.map({ PortalId<T>(handle: $0)! })
    }
}
