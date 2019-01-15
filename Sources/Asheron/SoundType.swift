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

public enum SoundType : Int32 {
    case Sound_Invalid = 0
    case Sound_Speak1 = 1
    case Sound_Random = 2
    case Sound_Attack1 = 3
    case Sound_Attack2 = 4
    case Sound_Attack3 = 5
    case Sound_SpecialAttack1 = 6
    case Sound_SpecialAttack2 = 7
    case Sound_SpecialAttack3 = 8
    case Sound_Damage1 = 9
    case Sound_Damage2 = 10
    case Sound_Damage3 = 11
    case Sound_Wound1 = 12
    case Sound_Wound2 = 13
    case Sound_Wound3 = 14
    case Sound_Death1 = 15
    case Sound_Death2 = 16
    case Sound_Death3 = 17
    case Sound_Grunt1 = 18
    case Sound_Grunt2 = 19
    case Sound_Grunt3 = 20
    case Sound_Oh1 = 21
    case Sound_Oh2 = 22
    case Sound_Oh3 = 23
    case Sound_Heave1 = 24
    case Sound_Heave2 = 25
    case Sound_Heave3 = 26
    case Sound_Knockdown1 = 27
    case Sound_Knockdown2 = 28
    case Sound_Knockdown3 = 29
    case Sound_Swoosh1 = 30
    case Sound_Swoosh2 = 31
    case Sound_Swoosh3 = 32
    case Sound_Thump1 = 33
    case Sound_Smash1 = 34
    case Sound_Scratch1 = 35
    case Sound_Spear = 36
    case Sound_Sling = 37
    case Sound_Dagger = 38
    case Sound_ArrowWhiz1 = 39
    case Sound_ArrowWhiz2 = 40
    case Sound_CrossbowPull = 41
    case Sound_CrossbowRelease = 42
    case Sound_BowPull = 43
    case Sound_BowRelease = 44
    case Sound_ThrownWeaponRelease1 = 45
    case Sound_ArrowLand = 46
    case Sound_Collision = 47
    case Sound_HitFlesh1 = 48
    case Sound_HitLeather1 = 49
    case Sound_HitChain1 = 50
    case Sound_HitPlate1 = 51
    case Sound_HitMissile1 = 52
    case Sound_HitMissile2 = 53
    case Sound_HitMissile3 = 54
    case Sound_Footstep1 = 55
    case Sound_Footstep2 = 56
    case Sound_Walk1 = 57
    case Sound_Dance1 = 58
    case Sound_Dance2 = 59
    case Sound_Dance3 = 60
    case Sound_Hidden1 = 61
    case Sound_Hidden2 = 62
    case Sound_Hidden3 = 63
    case Sound_Eat1 = 64
    case Sound_Drink1 = 65
    case Sound_Open = 66
    case Sound_Close = 67
    case Sound_OpenSlam = 68
    case Sound_CloseSlam = 69
    case Sound_Ambient1 = 70
    case Sound_Ambient2 = 71
    case Sound_Ambient3 = 72
    case Sound_Ambient4 = 73
    case Sound_Ambient5 = 74
    case Sound_Ambient6 = 75
    case Sound_Ambient7 = 76
    case Sound_Ambient8 = 77
    case Sound_Waterfall = 78
    case Sound_LogOut = 79
    case Sound_LogIn = 80
    case Sound_LifestoneOn = 81
    case Sound_AttribUp = 82
    case Sound_AttribDown = 83
    case Sound_SkillUp = 84
    case Sound_SkillDown = 85
    case Sound_HealthUp = 86
    case Sound_HealthDown = 87
    case Sound_ShieldUp = 88
    case Sound_ShieldDown = 89
    case Sound_EnchantUp = 90
    case Sound_EnchantDown = 91
    case Sound_VisionUp = 92
    case Sound_VisionDown = 93
    case Sound_Fizzle = 94
    case Sound_Launch = 95
    case Sound_Explode = 96
    case Sound_TransUp = 97
    case Sound_TransDown = 98
    case Sound_BreatheFlaem = 99
    case Sound_BreatheAcid = 100
    case Sound_BreatheFrost = 101
    case Sound_BreatheLightning = 102
    case Sound_Create = 103
    case Sound_Destroy = 104
    case Sound_Lockpicking = 105
    case Sound_UI_EnterPortal = 106
    case Sound_UI_ExitPortal = 107
    case Sound_UI_GeneralQuery = 108
    case Sound_UI_GeneralError = 109
    case Sound_UI_TransientMessage = 110
    case Sound_UI_IconPickUp = 111
    case Sound_UI_IconSuccessfulDrop = 112
    case Sound_UI_IconInvalid_Drop = 113
    case Sound_UI_ButtonPress = 114
    case Sound_UI_GrabSlider = 115
    case Sound_UI_ReleaseSlider = 116
    case Sound_UI_NewTargetSelected = 117
    case Sound_UI_Roar = 118
    case Sound_UI_Bell = 119
    case Sound_UI_Chant1 = 120
    case Sound_UI_Chant2 = 121
    case Sound_UI_DarkWhispers1 = 122
    case Sound_UI_DarkWhispers2 = 123
    case Sound_UI_DarkLaugh = 124
    case Sound_UI_DarkWind = 125
    case Sound_UI_DarkSpeech = 126
    case Sound_UI_Drums = 127
    case Sound_UI_GhostSpeak = 128
    case Sound_UI_Breathing = 129
    case Sound_UI_Howl = 130
    case Sound_UI_LostSouls = 131
    case Sound_UI_Squeal = 132
    case Sound_UI_Thunder1 = 133
    case Sound_UI_Thunder2 = 134
    case Sound_UI_Thunder3 = 135
    case Sound_UI_Thunder4 = 136
    case Sound_UI_Thunder5 = 137
    case Sound_UI_Thunder6 = 138
    case Sound_RaiseTrait = 139
    case Sound_WieldObject = 140
    case Sound_UnwieldObject = 141
    case Sound_ReceiveItem = 142
    case Sound_PickUpItem = 143
    case Sound_DropItem = 144
    case Sound_ResistSpell = 145
    case Sound_PicklockFail = 146
    case Sound_LockSuccess = 147
    case Sound_OpenFailDueToLock = 148
    case Sound_TriggerActivated = 149
    case Sound_SpellExpire = 150
    case Sound_ItemManaDepleted = 151
    case Sound_TriggerActivated1 = 152
    case Sound_TriggerActivated2 = 153
    case Sound_TriggerActivated3 = 154
    case Sound_TriggerActivated4 = 155
    case Sound_TriggerActivated5 = 156
    case Sound_TriggerActivated6 = 157
    case Sound_TriggerActivated7 = 158
    case Sound_TriggerActivated8 = 159
    case Sound_TriggerActivated9 = 160
    case Sound_TriggerActivated10 = 161
    case Sound_TriggerActivated11 = 162
    case Sound_TriggerActivated12 = 163
    case Sound_TriggerActivated13 = 164
    case Sound_TriggerActivated14 = 165
    case Sound_TriggerActivated15 = 166
    case Sound_TriggerActivated16 = 167
    case Sound_TriggerActivated17 = 168
    case Sound_TriggerActivated18 = 169
    case Sound_TriggerActivated19 = 170
    case Sound_TriggerActivated20 = 171
    case Sound_TriggerActivated21 = 172
    case Sound_TriggerActivated22 = 173
    case Sound_TriggerActivated23 = 174
    case Sound_TriggerActivated24 = 175
    case Sound_TriggerActivated25 = 176
    case Sound_TriggerActivated26 = 177
    case Sound_TriggerActivated27 = 178
    case Sound_TriggerActivated28 = 179
    case Sound_TriggerActivated29 = 180
    case Sound_TriggerActivated30 = 181
    case Sound_TriggerActivated31 = 182
    case Sound_TriggerActivated32 = 183
    case Sound_TriggerActivated33 = 184
    case Sound_TriggerActivated34 = 185
    case Sound_TriggerActivated35 = 186
    case Sound_TriggerActivated36 = 187
    case Sound_TriggerActivated37 = 188
    case Sound_TriggerActivated38 = 189
    case Sound_TriggerActivated39 = 190
    case Sound_TriggerActivated40 = 191
    case Sound_TriggerActivated41 = 192
    case Sound_TriggerActivated42 = 193
    case Sound_TriggerActivated43 = 194
    case Sound_TriggerActivated44 = 195
    case Sound_TriggerActivated45 = 196
    case Sound_TriggerActivated46 = 197
    case Sound_TriggerActivated47 = 198
    case Sound_TriggerActivated48 = 199
    case Sound_TriggerActivated49 = 200
    case Sound_TriggerActivated50 = 201
    case Sound_HealthDownVoid = 202
    case Sound_RegenDownVoid = 203
    case Sound_SkillDownVoid = 204
}
