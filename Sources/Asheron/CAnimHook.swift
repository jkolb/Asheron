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

public enum CAnimHook {
    case noop(NOOPHook)
    case sound(SoundHook)
    case soundTable(SoundTableHook)
    case attack(AttackHook)
    case animDone(AnimDoneHook)
    case replaceObject(ReplaceObjectHook)
    case ethereal(EtherealHook)
    case transparentPart(TransparentPartHook)
    case luminous(LuminousHook)
    case luminousPart(LuminousPartHook)
    case diffuse(DiffuseHook)
    case diffusePart(DiffusePartHook)
    case scale(ScaleHook)
    case createParticle(CreateParticleHook)
    case destroyParticle(DestroyParticleHook)
    case stopParticle(StopParticleHook)
    case noDraw(NoDrawHook)
    case defaultScript(DefaultScriptHook)
    case defaultScriptPart(DefaultScriptPartHook)
    case callPES(CallPESHook)
    case transparent(TransparentHook)
    case soundTweaked(SoundTweakedHook)
    case setOmega(SetOmegaHook)
    case textureVelocity(TextureVelocityHook)
    case textureVelocityPart(TextureVelocityPartHook)
    case setLight(SetLightHook)
    case createBlockingParticle(CreateBlockingParticleHook)
    
    public enum Direction : Int32 {
        case unknown = -2
        case backward = -1
        case both = 0
        case forward = 1
    }
}
