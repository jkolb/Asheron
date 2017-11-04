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

extension ByteStream {
    public func getPolygon() -> Polygon {
        var polygon = Polygon()
        polygon.index = getUInt16()
        polygon.name = Polygon.Name(rawValue: getUInt8())!
        polygon.texCoords = Polygon.TexCoords(rawValue: getUInt8())
        polygon.faces = Polygon.Faces(rawValue: getUInt16())!
        polygon.unknown = getUInt16()
        polygon.frontMaterialIndex = getUInt16()
        polygon.backMaterialIndex = getUInt16()
        polygon.vertexIndex = getUInt16(count: polygon.sides)
        
        if polygon.texCoords.contains([.front]) {
            polygon.frontTexCoordIndex = getUInt8(count: polygon.sides)
        }
        
        if polygon.texCoords.contains([.back]) {
            polygon.backTexCoordIndex = getUInt8(count: polygon.sides)
        }
        
        align(4)
        
        return polygon
    }
    
    public func getPolygon(count: Int) -> [Polygon] {
        var values = [Polygon]()
        values.reserveCapacity(count)
        
        for _ in 0..<count {
            values.append(getPolygon())
        }
        
        return values
    }
}
