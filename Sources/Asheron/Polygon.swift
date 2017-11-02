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

public struct Polygon : CustomStringConvertible {
	public enum Name : UInt8 {
		case triangle = 3
		case rectangle = 4
		case pentagon = 5
		case hexagon = 6
		case heptagon = 7
		case octagon = 8
		//case nonagon = 9
		//case decagon = 10
	}

	public struct TexCoords : OptionSet {
		public static let none    = TexCoords(rawValue: 0)
		public static let front   = TexCoords(rawValue: 1 << 0)
		public static let back    = TexCoords(rawValue: 1 << 1)
		public static let noFront = TexCoords(rawValue: 1 << 2)
		public static let noBack  = TexCoords(rawValue: 1 << 3)

		public let rawValue: UInt8

		public init(rawValue: UInt8) {
			self.rawValue = rawValue
		}
	}

	public enum Faces : UInt16 {
		case single = 0
		case repeated = 1
		case double = 2
	}

	public var index: UInt16 = 0
	public var name: Name = .triangle
	public var sides: Int { return Int(name.rawValue) }
	public var texCoords: TexCoords = .none
	public var faces: Faces = .single
	public var unknown: UInt16 = 0
	public var frontMaterialIndex: UInt16 = 0
	public var backMaterialIndex: UInt16 = 0
	public var vertexIndex: [UInt16] = []
	public var frontTexCoordIndex: [UInt8] = []
	public var backTexCoordIndex: [UInt8] = []

	public init() {}

	public var description: String {
		return "\(index): \(name) texCoords: \(texCoords) faces: \(faces) front: \(frontMaterialIndex):\(frontTexCoordIndex.count) back: \(backMaterialIndex):\(backTexCoordIndex.count) unknown: \(unknown)"
	}
}
