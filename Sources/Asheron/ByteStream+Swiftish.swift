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

import Swiftish

extension ByteStream {
	public func getVector2() -> Vector2<Float> {
		let x = getFloat32()
		let y = getFloat32()
		return Vector2<Float>(x, y)
	}

	public func getVector2(count: Int) -> [Vector2<Float>] {
		var values = [Vector2<Float>]()
		values.reserveCapacity(count)

		for _ in 0..<count {
			values.append(getVector2())
		}

		return values
	}

	public func getVector3() -> Vector3<Float> {
		let x = getFloat32()
		let y = getFloat32()
		let z = getFloat32()
		return Vector3<Float>(x, y, z)
	}

	public func getQuaternion() -> Quaternion<Float> {
		let w = getFloat32()
		let x = getFloat32()
		let y = getFloat32()
		let z = getFloat32()
		return Quaternion<Float>(w, x, y, z)
	}
}
