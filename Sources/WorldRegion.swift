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

public final class WorldRegion : PortalObject {
    public static let kind = PortalKind.worldRegion
    public let handle: WorldRegionHandle
    public let number: UInt32 // 1 = client_cell_1
    public let version: UInt32 // 3
    public let name: String // "Dereth"
    public let cellRowCount: UInt32 // 255 (0-254)
    public let cellColCount: UInt32 // 255 (0-254)
    public let cellGridSize: Float // 24.0
    public let heightsPerCell: UInt32 // 8 (8 * 24.0 = 192.0)
    public let overlapPerCell: UInt32 // 1
    public let unknown1: Float // 200.0
    public let unknown2: Float // 1000.0
    public let unknown3: Float // 5.0
    public let landHeights: [Float] // 256
    public let unknown4: UInt32 // 0
    public let unknown5: Float // 5.37890625
    public let unknown6: UInt32 // 10
    public let unknown7: Float // 7620.0
    public let daysPerYear: UInt32 // 360
    public let yearUnitName: String // "P.Y."

    public init(
        handle: WorldRegionHandle,
        number: UInt32,
        version: UInt32,
        name: String,
        cellRowCount: UInt32,
        cellColCount: UInt32,
        cellGridSize: Float,
        heightsPerCell: UInt32,
        overlapPerCell: UInt32,
        unknown1: Float,
        unknown2: Float,
        unknown3: Float,
        landHeights: [Float],
        unknown4: UInt32,
        unknown5: Float,
        unknown6: UInt32,
        unknown7: Float,
        daysPerYear: UInt32,
        yearUnitName: String
    )
    {
        self.handle = handle
        self.number = number
        self.version = version
        self.name = name
        self.cellRowCount = cellRowCount
        self.cellColCount = cellColCount
        self.cellGridSize = cellGridSize
        self.heightsPerCell = heightsPerCell
        self.overlapPerCell = overlapPerCell
        self.unknown1 = unknown1
        self.unknown2 = unknown2
        self.unknown3 = unknown3
        self.landHeights = landHeights
        self.unknown4 = unknown4
        self.unknown5 = unknown5
        self.unknown6 = unknown6
        self.unknown7 = unknown7
        self.daysPerYear = daysPerYear
        self.yearUnitName = yearUnitName
    }
}