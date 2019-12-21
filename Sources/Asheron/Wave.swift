/*
The MIT License (MIT)

Copyright (c) 2020 Justin Kolb

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

import Foundation

public final class Wave : Identifiable {
    public enum FormatCode : UInt16, Packable {
        case pcm = 0x0001 // PCM
        case mp3 = 0x0055 // ISO/MPEG Layer3 Format
        
        public var fileExtension: String {
            switch self {
            case .pcm: return "wav"
            case .mp3: return "mp3"
            }
        }
    }
    public var id: Identifier
    // WAVEFORMATEX
    public var cksize: UInt32
    public var wFormatTag: FormatCode
    public var nChannels: UInt16
    public var nSamplesPerSec: UInt32
    public var nAvgBytesPerSec: UInt32
    public var nBlockAlign: UInt16
    public var wBitsPerSample: UInt16
    public var cbSize: UInt16
    // MPEGLAYER3WAVEFORMAT
    public var wID: UInt16
    public var fdwFlags: UInt32
    public var nBlockSize: UInt16
    public var nFramesPerBlock: UInt16
    public var nCodecDelay: UInt16
    // Both
    public var sampleData: Data

    public init(from dataStream: DataStream, id: Identifier) {
        let diskId = Identifier(from: dataStream)
        precondition(diskId == id)
        self.id = id
        let cksize = UInt32(from: dataStream)
        precondition(cksize == 18 || cksize == 30)
        let dataSize: Int = numericCast(UInt32(from: dataStream))

        self.cksize = cksize
        self.wFormatTag = FormatCode(from: dataStream)
        self.nChannels = UInt16(from: dataStream)
        self.nSamplesPerSec = UInt32(from: dataStream)
        self.nAvgBytesPerSec = UInt32(from: dataStream)
        self.nBlockAlign = UInt16(from: dataStream)
        self.wBitsPerSample = UInt16(from: dataStream)
        let cbSize = UInt16(from: dataStream)
        precondition(cbSize == 0 || cbSize == 12)
        self.cbSize = cbSize
        
        if wFormatTag == .mp3 {
            self.wID = UInt16(from: dataStream)
            self.fdwFlags = UInt32(from: dataStream)
            self.nBlockSize = UInt16(from: dataStream)
            self.nFramesPerBlock = UInt16(from: dataStream)
            self.nCodecDelay = UInt16(from: dataStream)
        }
        else {
            self.wID = 0
            self.fdwFlags = 0
            self.nBlockSize = 0
            self.nFramesPerBlock = 0
            self.nCodecDelay = 0
        }

        self.sampleData = Data(from: dataStream, count: dataSize)
        precondition(dataStream.remainingCount == 0)
    }
    
    public func makeFileData() -> Data {
        let fileLength = sampleData.count + 20 + Int(cksize)
        let dataStream = DataStream(count: fileLength)
        FourCC("RIFF").encode(to: dataStream)
        UInt32(fileLength).encode(to: dataStream)
        FourCC("WAVE").encode(to: dataStream)
        FourCC("fmt ").encode(to: dataStream)
        cksize.encode(to: dataStream)
        wFormatTag.encode(to: dataStream)
        nChannels.encode(to: dataStream)
        nSamplesPerSec.encode(to: dataStream)
        nAvgBytesPerSec.encode(to: dataStream)
        nBlockAlign.encode(to: dataStream)
        wBitsPerSample.encode(to: dataStream)
        cbSize.encode(to: dataStream)
        if wFormatTag == .mp3 {
            wID.encode(to: dataStream)
            fdwFlags.encode(to: dataStream)
            nBlockSize.encode(to: dataStream)
            nFramesPerBlock.encode(to: dataStream)
            nCodecDelay.encode(to: dataStream)
        }
        FourCC("data").encode(to: dataStream)
        UInt32(sampleData.count).encode(to: dataStream)
        sampleData.encode(to: dataStream)
        precondition(dataStream.remainingCount == 0)
        return dataStream.data
    }
}
