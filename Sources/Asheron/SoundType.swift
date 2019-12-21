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

public enum SoundType : Int32, Packable {
    case invalid = 0
    case speak1 = 1
    case random = 2
    case attack1 = 3
    case attack2 = 4
    case attack3 = 5
    case specialAttack1 = 6
    case specialAttack2 = 7
    case specialAttack3 = 8
    case damage1 = 9
    case damage2 = 10
    case damage3 = 11
    case wound1 = 12
    case wound2 = 13
    case wound3 = 14
    case death1 = 15
    case death2 = 16
    case death3 = 17
    case grunt1 = 18
    case grunt2 = 19
    case grunt3 = 20
    case oh1 = 21
    case oh2 = 22
    case oh3 = 23
    case heave1 = 24
    case heave2 = 25
    case heave3 = 26
    case knockdown1 = 27
    case knockdown2 = 28
    case knockdown3 = 29
    case swoosh1 = 30
    case swoosh2 = 31
    case swoosh3 = 32
    case thump1 = 33
    case smash1 = 34
    case scratch1 = 35
    case spear = 36
    case sling = 37
    case dagger = 38
    case arrowWhiz1 = 39
    case arrowWhiz2 = 40
    case crossbowPull = 41
    case crossbowRelease = 42
    case bowPull = 43
    case bowRelease = 44
    case thrownWeaponRelease1 = 45
    case arrowLand = 46
    case collision = 47
    case hitFlesh1 = 48
    case hitLeather1 = 49
    case hitChain1 = 50
    case hitPlate1 = 51
    case hitMissile1 = 52
    case hitMissile2 = 53
    case hitMissile3 = 54
    case footstep1 = 55
    case footstep2 = 56
    case walk1 = 57
    case dance1 = 58
    case dance2 = 59
    case dance3 = 60
    case hidden1 = 61
    case hidden2 = 62
    case hidden3 = 63
    case eat1 = 64
    case drink1 = 65
    case open = 66
    case close = 67
    case openSlam = 68
    case closeSlam = 69
    case ambient1 = 70
    case ambient2 = 71
    case ambient3 = 72
    case ambient4 = 73
    case ambient5 = 74
    case ambient6 = 75
    case ambient7 = 76
    case ambient8 = 77
    case waterfall = 78
    case logOut = 79
    case logIn = 80
    case lifestoneOn = 81
    case attribUp = 82
    case attribDown = 83
    case skillUp = 84
    case skillDown = 85
    case healthUp = 86
    case healthDown = 87
    case shieldUp = 88
    case shieldDown = 89
    case enchantUp = 90
    case enchantDown = 91
    case visionUp = 92
    case visionDown = 93
    case fizzle = 94
    case launch = 95
    case explode = 96
    case transUp = 97
    case transDown = 98
    case breatheFlame = 99
    case breatheAcid = 100
    case breatheFrost = 101
    case breatheLightning = 102
    case create = 103
    case destroy = 104
    case lockpicking = 105
    case enterPortal = 106
    case exitPortal = 107
    case generalQuery = 108
    case generalError = 109
    case transientMessage = 110
    case iconPickUp = 111
    case iconSuccessfulDrop = 112
    case iconInvalidDrop = 113
    case buttonPress = 114
    case grabSlider = 115
    case releaseSlider = 116
    case newTargetSelected = 117
    case roar = 118
    case bell = 119
    case chant1 = 120
    case chant2 = 121
    case darkWhispers1 = 122
    case darkWhispers2 = 123
    case darkLaugh = 124
    case darkWind = 125
    case darkSpeech = 126
    case drums = 127
    case ghostSpeak = 128
    case breathing = 129
    case howl = 130
    case lostSouls = 131
    case squeal = 132
    case thunder1 = 133
    case thunder2 = 134
    case thunder3 = 135
    case thunder4 = 136
    case thunder5 = 137
    case thunder6 = 138
    case raiseTrait = 139
    case wieldObject = 140
    case unwieldObject = 141
    case receiveItem = 142
    case pickUpItem = 143
    case dropItem = 144
    case resistSpell = 145
    case picklockFail = 146
    case lockSuccess = 147
    case openFailDueToLock = 148
    case triggerActivated = 149
    case spellExpire = 150
    case itemManaDepleted = 151
    case triggerActivated1 = 152
    case triggerActivated2 = 153
    case triggerActivated3 = 154
    case triggerActivated4 = 155
    case triggerActivated5 = 156
    case triggerActivated6 = 157
    case triggerActivated7 = 158
    case triggerActivated8 = 159
    case triggerActivated9 = 160
    case triggerActivated10 = 161
    case triggerActivated11 = 162
    case triggerActivated12 = 163
    case triggerActivated13 = 164
    case triggerActivated14 = 165
    case triggerActivated15 = 166
    case triggerActivated16 = 167
    case triggerActivated17 = 168
    case triggerActivated18 = 169
    case triggerActivated19 = 170
    case triggerActivated20 = 171
    case triggerActivated21 = 172
    case triggerActivated22 = 173
    case triggerActivated23 = 174
    case triggerActivated24 = 175
    case triggerActivated25 = 176
    case triggerActivated26 = 177
    case triggerActivated27 = 178
    case triggerActivated28 = 179
    case triggerActivated29 = 180
    case triggerActivated30 = 181
    case triggerActivated31 = 182
    case triggerActivated32 = 183
    case triggerActivated33 = 184
    case triggerActivated34 = 185
    case triggerActivated35 = 186
    case triggerActivated36 = 187
    case triggerActivated37 = 188
    case triggerActivated38 = 189
    case triggerActivated39 = 190
    case triggerActivated40 = 191
    case triggerActivated41 = 192
    case triggerActivated42 = 193
    case triggerActivated43 = 194
    case triggerActivated44 = 195
    case triggerActivated45 = 196
    case triggerActivated46 = 197
    case triggerActivated47 = 198
    case triggerActivated48 = 199
    case triggerActivated49 = 200
    case triggerActivated50 = 201
    case healthDownVoid = 202
    case regenDownVoid = 203
    case skillDownVoid = 204
}
