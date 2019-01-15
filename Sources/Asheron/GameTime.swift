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

public struct GameTime {
    public var zeroTimeOfYear: Float64
    public var zeroYear: UInt32
    public var dayLength: Float32
    public var daysPerYear: UInt32
    public var yearSpec: String // ?? PString
    public var timesOfDay: [TimeOfDay] // ??
    public var daysOfTheWeek: [WeekDay] // ??
    public var seasons: [Season] // ??
    
    public init() {
        self.init(zeroTimeOfYear: 0.0, zeroYear: 0, dayLength: 0.0, daysPerYear: 0, yearSpec: "", timesOfDay: [], daysOfTheWeek: [], seasons: [])
    }
    
    public init(
        zeroTimeOfYear: Float64,
        zeroYear: UInt32,
        dayLength: Float32,
        daysPerYear: UInt32,
        yearSpec: String,
        timesOfDay: [TimeOfDay],
        daysOfTheWeek: [WeekDay],
        seasons: [Season]
        )
    {
        self.zeroTimeOfYear = zeroTimeOfYear
        self.zeroYear = zeroYear
        self.dayLength = dayLength
        self.daysPerYear = daysPerYear
        self.yearSpec = yearSpec
        self.timesOfDay = timesOfDay
        self.daysOfTheWeek = daysOfTheWeek
        self.seasons = seasons
    }
//    public var yearLength: Float64 = day_length * days_per_year
//    public var presentTimeOfDay: Float32
//    public var timeOfDayBegin: Float64
//    public var timeOfNextEvent: Float64
    // more
}
