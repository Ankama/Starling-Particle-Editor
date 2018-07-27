/**
 *	Copyright (c) 2013 Devon O. Wolfgang
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to deal
 *	in the Software without restriction, including without limitation the rights
 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *	copies of the Software, and to permit persons to whom the Software is
 *	furnished to do so, subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *	THE SOFTWARE.
 */

package com.onebyonedesign.particleeditor 
{
	import flash.display.Sprite;

	/**
	 * Because the SoulWire SimpleGUI works by modifying the properties of a display object, 
	 * this class was created to contain all modifiable properties.
     * SimpleGUI is attached to this and its changes are sent to SettingsListener objects
	 * @author Devon O.
	 */
	public final class SettingsModel extends Sprite
	{
        private var mListeners:Vector.<SettingsListener>;

        public static const DEFAULT_DURATION:Number = 2.0;
        public static const DEFAULT_SHOT:Number = 1.0;

        private var _infinite:Boolean;
        private var _shot:Number;
        private var _displayShot:Boolean;
        private var _duration:Number;
        private var _xPos:Number;
        private var _yPos:Number;
		private var _xPosVar:Number;
		private var _yPosVar:Number;
		private var _maxParts:Number;
		private var _lifeSpan:Number;
		private var _lifeSpanVar:Number;
		private var _startSize:Number;
		private var _startSizeVar:Number;
		private var _finishSize:Number;
		private var _finishSizeVar:Number;
		private var _emitAngle:Number;
		private var _emitAngleVar:Number;
		
		private var _stRot:Number;
		private var _stRotVar:Number;
		private var _endRot:Number;
		private var _endRotVar:Number;
		
		private var _speed:Number;
		private var _speedVar:Number;
		private var _gravX:Number;
		private var _gravY:Number;
		private var _tanAcc:Number;
		private var _tanAccVar:Number;
		private var _radialAcc:Number;
		private var _radialAccVar:Number;
		
		private var _emitterType:int;
		
		private var _maxRadius:Number;
		private var _maxRadiusVar:Number;
		private var _minRadius:Number;
        private var _minRadiusVar:Number;
		private var _degPerSec:Number;
		private var _degPerSecVar:Number;
		
		private var _sr:Number;
		private var _sg:Number;
		private var _sb:Number;
		private var _sa:Number;

		private var _fr:Number;
		private var _fg:Number;
		private var _fb:Number;
		private var _fa:Number;
		
		private var _svr:Number;
		private var _svg:Number;
		private var _svb:Number;
		private var _sva:Number;
		
		private var _fvr:Number;
		private var _fvg:Number;
		private var _fvb:Number;
		private var _fva:Number;
		
		private var _srcBlend:uint;
		private var _dstBlend:uint;
        
        private var _xml:XML;
		
		public function SettingsModel(xml:XML) 
		{
            mListeners = new Vector.<SettingsListener>();
            this.xml = xml;
        }

        public function set xml(xml:XML):void
        {
            _xml = xml;
            _duration = xml.duration.@value;
            if(_duration == -1)
            {
                _infinite = true;
                _duration = DEFAULT_DURATION;
            }
            else
                _infinite = false;
            _displayShot = true;
            _shot = DEFAULT_SHOT;
            _maxParts = _xml.maxParticles.@value;
            _lifeSpan = _xml.particleLifeSpan.@value;
            _lifeSpanVar = _xml.particleLifespanVariance.@value;
            _startSize = _xml.startParticleSize.@value;
            _startSizeVar = _xml.startParticleSizeVariance.@value;
            _finishSize = _xml.finishParticleSize.@value;
            _finishSizeVar = _xml.FinishParticleSizeVariance.@value;
            _emitAngle = _xml.angle.@value;
            _emitAngleVar = _xml.angleVariance.@value;
            _stRot = _xml.rotationStart.@value;
            _stRotVar = _xml.rotationStartVariance.@value;
            _endRot = _xml.rotationEnd.@value;
            _endRotVar = _xml.rotationEndVariance.@value;
            _xPos = _xml.sourcePosition.@x;
            _yPos = _xml.sourcePosition.@y;
            _xPosVar = _xml.sourcePositionVariance.@x;
            _yPosVar = _xml.sourcePositionVariance.@y;
            _speed = _xml.speed.@value;
            _speedVar = _xml.speedVariance.@value;
            _gravX = _xml.gravity.@x;
            _gravY = _xml.gravity.@y;
            _tanAcc = _xml.tangentialAcceleration.@value;
            _tanAccVar = _xml.tangentialAccelVariance.@value;
            _radialAcc = _xml.radialAcceleration.@value;
            _radialAccVar = _xml.radialAccelVariance.@value;
            _maxRadius = _xml.maxRadius.@value;
            _maxRadiusVar = _xml.maxRadiusVariance.@value;
            _minRadius = _xml.minRadius.@value;
            _minRadiusVar = _xml.minRadiusVariance.@value;
            _degPerSec = _xml.rotatePerSecond.@value;
            _degPerSecVar = _xml.rotatePerSecondVariance.@value;
            _sr = _xml.startColor.@red;
            _sg = _xml.startColor.@green;
            _sb = _xml.startColor.@blue;
            _sa = _xml.startColor.@alpha;
            _fr = _xml.finishColor.@red;
            _fg = _xml.finishColor.@green;
            _fb = _xml.finishColor.@blue;
            _fa = _xml.finishColor.@alpha;
            _svr = _xml.startColorVariance.@red;
            _svg = _xml.startColorVariance.@green;
            _svb = _xml.startColorVariance.@blue;
            _sva = _xml.startColorVariance.@alpha;
            _fvr = _xml.finishColorVariance.@red;
            _fvg = _xml.finishColorVariance.@green;
            _fvb = _xml.finishColorVariance.@blue;
            _fva = _xml.finishColorVariance.@alpha;
            _srcBlend = _xml.blendFuncSource.@value;
            _dstBlend = _xml.blendFuncDestination.@value;
            _emitterType = _xml.emitterType.@value;
        }
        
        public function get xml():XML
        {
            return _xml;
        }
        
        public function addListener(listener:SettingsListener):void
        {
            mListeners.push(listener);
        }

        public function get infinite():Boolean
        {
            return _infinite;
        }

        public function set infinite(value:Boolean):void
        {
            _infinite = value;
            _xml.duration.@value = _infinite ? "-1.0" : _duration;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateDuration(_infinite, _duration);});
        }

        public function get duration():Number
        {
            return _duration;
        }

        public function set duration(value:Number):void
        {
            _duration = value;
            _xml.duration.@value = _infinite ? "-1.0" : _duration;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateDuration(_infinite, _duration);});
        }

        public function get shot():Number
        {
            return _shot;
        }

        public function set shot(value:Number):void
        {
            _shot = value;
        }

        public function get displayShot():Boolean
        {
            return _displayShot;
        }

        public function set displayShot(value:Boolean):void
        {
            _displayShot = value;
        }

        public function get xPos():Number
        {
            return _xPos;
        }

        public function set xPos(value:Number):void
        {
            _xPos = value;
            _xml.sourcePosition.@x = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateXPos(value);});
        }

        public function get yPos():Number
        {
            return _yPos;
        }

        public function set yPos(value:Number):void
        {
            _yPos = value;
            _xml.sourcePosition.@y = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateYPos(value);});
        }
        
        public function get xPosVar():Number 
        {
            return _xPosVar;
        }
        
        public function set xPosVar(value:Number):void 
        {
            _xPosVar = value;
            _xml.sourcePositionVariance.@x = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateXPosVariance(value);});
        }
        
        public function get yPosVar():Number 
        {
            return _yPosVar;
        }
        
        public function set yPosVar(value:Number):void 
        {
            _yPosVar = value;
            _xml.sourcePositionVariance.@y = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateYPosVariance(value);});
        }
        
        public function get maxParts():Number 
        {
            return _maxParts;
        }
        
        public function set maxParts(value:Number):void 
        {
            _maxParts = value;
            _xml.maxParticles.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateMaxParticles(value);});
        }
        
        public function get lifeSpan():Number 
        {
            return _lifeSpan;
        }
        
        public function set lifeSpan(value:Number):void 
        {
            if (isNaN(value))
                value = 0.0;
                
            _lifeSpan = value;
            _xml.particleLifeSpan.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateLifeSpan(value);});
        }
        
        public function get lifeSpanVar():Number 
        {
            return _lifeSpanVar;
        }
        
        public function set lifeSpanVar(value:Number):void 
        {
            if (isNaN(value))
                value = 0.0;
                
            _lifeSpanVar = value;
            _xml.particleLifespanVariance.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateLifeSpanVariance(value);});
        }
        
        public function get startSize():Number 
        {
            return _startSize;
        }
        
        public function set startSize(value:Number):void 
        {
            _startSize = value;
            _xml.startParticleSize.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateStartSize(value);});
        }
        
        public function get startSizeVar():Number 
        {
            return _startSizeVar;
        }
        
        public function set startSizeVar(value:Number):void 
        {
            _startSizeVar = value;
            _xml.startParticleSizeVariance.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateStartSizeVariance(value);});
        }
        
        public function get finishSize():Number 
        {
            return _finishSize;
        }
        
        public function set finishSize(value:Number):void 
        {
            _finishSize = value;
            _xml.finishParticleSize.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateFinishSize(value);});
        }
        
        public function get finishSizeVar():Number 
        {
            return _finishSizeVar;
        }
        
        public function set finishSizeVar(value:Number):void 
        {
            if (isNaN(value))
                value = 0.0;
                
            _finishSizeVar = value;
            _xml.FinishParticleSizeVariance.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateFinishSizeVariance(value);});
        }
        
        public function get emitAngle():Number 
        {
            return _emitAngle;
        }
        
        public function set emitAngle(value:Number):void 
        {
            _emitAngle = value;
            _xml.angle.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateEmitAngle(value);});
        }
        
        public function get emitAngleVar():Number 
        {
            return _emitAngleVar;
        }
        
        public function set emitAngleVar(value:Number):void 
        {
            _emitAngleVar = value;
            _xml.angleVariance.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateEmitAngleVariance(value);});
        }
        
        public function get stRot():Number 
        {
            return _stRot;
        }
        
        public function set stRot(value:Number):void 
        {
            _stRot = value;
            _xml.rotationStart.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateStartRotation(value);});
        }
        
        public function get stRotVar():Number 
        {
            return _stRotVar;
        }
        
        public function set stRotVar(value:Number):void 
        {
            _stRotVar = value;
            _xml.rotationStartVariance.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateStartRotationVariance(value);});
        }
        
        public function get endRot():Number 
        {
            return _endRot;
        }
        
        public function set endRot(value:Number):void 
        {
            _endRot = value;
            _xml.rotationEnd.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateEndRotation(value);});
        }
        
        public function get endRotVar():Number 
        {
            return _endRotVar;
        }
        
        public function set endRotVar(value:Number):void 
        {
            _endRotVar = value;
            _xml.rotationEndVariance.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateEndRotationVariance(value);});
        }
        
        public function get speed():Number 
        {
            return _speed;
        }
        
        public function set speed(value:Number):void 
        {
            _speed = value;
            _xml.speed.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateSpeed(value);});
        }
        
        public function get speedVar():Number 
        {
            return _speedVar;
        }
        
        public function set speedVar(value:Number):void 
        {
            _speedVar = value;
            _xml.speedVariance.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateSpeedVariance(value);});
        }
        
        public function get gravX():Number 
        {
            return _gravX;
        }
        
        public function set gravX(value:Number):void 
        {
            _gravX = value;
            _xml.gravity.@x = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateGravityX(value);});
        }
        
        public function get gravY():Number 
        {
            return _gravY;
        }
        
        public function set gravY(value:Number):void 
        {
            _gravY = value;
            _xml.gravity.@y = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateGravityY(value);});
        }
        
        public function get tanAcc():Number 
        {
            return _tanAcc;
        }
        
        public function set tanAcc(value:Number):void 
        {
            _tanAcc = value;
            _xml.tangentialAcceleration.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateTanAcceleration(value);});
        }
        
        public function get tanAccVar():Number 
        {
            return _tanAccVar;
        }
        
        public function set tanAccVar(value:Number):void 
        {
            _tanAccVar = value;
            _xml.tangentialAccelVariance.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateTanAccelerationVariance(value);});
        }
        
        public function get radialAcc():Number 
        {
            return _radialAcc;
        }
        
        public function set radialAcc(value:Number):void 
        {
            _radialAcc = value;
            _xml.radialAcceleration.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateRadialAcceleration(value);});
        }
        
        public function get radialAccVar():Number 
        {
            return _radialAccVar;
        }
        
        public function set radialAccVar(value:Number):void 
        {
            _radialAccVar = value;
            _xml.radialAccelVariance.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateRadialAccelerationVariance(value);});
        }
        
        public function get emitterType():int 
        {
            return _emitterType;
        }
        
        public function set emitterType(value:int):void 
        {
            _emitterType = value;
            _xml.emitterType.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateEmitterType(value);});
        }
        
        public function get maxRadius():Number 
        {
            return _maxRadius;
        }
        
        public function set maxRadius(value:Number):void 
        {
            _maxRadius = value;
            _xml.maxRadius.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateMaxRadius(value);});
        }
        
        public function get maxRadiusVar():Number 
        {
            return _maxRadiusVar;
        }
        
        public function set maxRadiusVar(value:Number):void 
        {
            _maxRadiusVar = value;
            _xml.maxRadiusVariance.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateMaxRadiusVariance(value);});
        }
        
        public function get minRadius():Number 
        {
            return _minRadius;
        }
        
        public function set minRadius(value:Number):void 
        {
            _minRadius = value;
            _xml.minRadius.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateMinRadius(value);});
        }
        
        public function get minRadiusVar():Number
        {
            return _minRadiusVar;
        }
        
        public function set minRadiusVar(value:Number):void
        {
            if (isNaN(value))
                value = 0.0;
                
            _minRadiusVar = value;
            _xml.minRadiusVariance.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateMinRadiusVariance(value);});
        }
        
        public function get degPerSec():Number 
        {
            return _degPerSec;
        }
        
        public function set degPerSec(value:Number):void 
        {
            _degPerSec = value;
            _xml.rotatePerSecond.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateDegreesPerSecond(value);});
        }
        
        public function get degPerSecVar():Number 
        {
            return _degPerSecVar;
        }
        
        public function set degPerSecVar(value:Number):void 
        {
            _degPerSecVar = value;
            _xml.rotatePerSecondVariance.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateDegreesPerSecondVariance(value);});
        }
        
        public function get sr():Number 
        {
            return _sr;
        }
        
        public function set sr(value:Number):void 
        {
            _sr = value;
            _xml.startColor.@red = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateStartRed(value);});
        }
        
        public function get sg():Number 
        {
            return _sg;
        }
        
        public function set sg(value:Number):void 
        {
            _sg = value;
            _xml.startColor.@green = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateStartGreen(value);});
        }
        
        public function get sb():Number 
        {
            return _sb;
        }
        
        public function set sb(value:Number):void 
        {
            _sb = value;
            _xml.startColor.@blue = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateStartBlue(value);});
        }
        
        public function get sa():Number 
        {
            return _sa;
        }
        
        public function set sa(value:Number):void 
        {
            _sa = value;
            _xml.startColor.@alpha = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateStartAlpha(value);});
        }
        
        public function get fr():Number 
        {
            return _fr;
        }
        
        public function set fr(value:Number):void 
        {
            _fr = value;
            _xml.finishColor.@red = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateFinishRed(value);});
        }
        
        public function get fg():Number 
        {
            return _fg;
        }
        
        public function set fg(value:Number):void 
        {
            _fg = value;
            _xml.finishColor.@green = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateFinishGreen(value);});
        }
        
        public function get fb():Number 
        {
            return _fb;
        }
        
        public function set fb(value:Number):void 
        {
            _fb = value;
            _xml.finishColor.@blue = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateFinishBlue(value);});
        }
        
        public function get fa():Number 
        {
            return _fa;
        }
        
        public function set fa(value:Number):void 
        {
            _fa = value;
            _xml.finishColor.@alpha = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateFinishAlpha(value);});
        }
        
        public function get svr():Number 
        {
            return _svr;
        }
        
        public function set svr(value:Number):void 
        {
            _svr = value;
            _xml.startColorVariance.@red = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateStartRedVariance(value);});
        }
        
        public function get svg():Number 
        {
            return _svg;
        }
        
        public function set svg(value:Number):void 
        {
            _svg = value;
            _xml.startColorVariance.@green = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateStartGreenVariance(value);});
        }
        
        public function get svb():Number 
        {
            return _svb;
        }
        
        public function set svb(value:Number):void 
        {
            _svb = value;
            _xml.startColorVariance.@blue = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateStartBlueVariance(value);});
        }
        
        public function get sva():Number 
        {
            return _sva;
        }
        
        public function set sva(value:Number):void 
        {
            _sva = value;
            _xml.startColorVariance.@alpha = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateStartAlphaVariance(value);});
        }
        
        public function get fvr():Number 
        {
            return _fvr;
        }
        
        public function set fvr(value:Number):void 
        {
            _fvr = value;
            _xml.finishColorVariance.@red = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateFinishRedVariance(value);});
        }
        
        public function get fvg():Number 
        {
            return _fvg;
        }
        
        public function set fvg(value:Number):void 
        {
            _fvg = value;
            _xml.finishColorVariance.@green = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateFinishGreenVariance(value);});
        }
        
        public function get fvb():Number 
        {
            return _fvb;
        }
        
        public function set fvb(value:Number):void 
        {
            _fvb = value;
            _xml.finishColorVariance.@blue = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateFinishBlueVariance(value);});
        }
        
        public function get fva():Number 
        {
            return _fva;
        }
        
        public function set fva(value:Number):void 
        {
            _fva = value;
            _xml.finishColorVariance.@alpha = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateFinishAlphaVariance(value);});
        }
        
        public function get srcBlend():uint 
        {
            return _srcBlend;
        }
        
        public function set srcBlend(value:uint):void 
        {
            _srcBlend = value;
            _xml.blendFuncSource.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateSourceBlend(value);});
        }
        
        public function get dstBlend():uint 
        {
            return _dstBlend;
        }
        
        public function set dstBlend(value:uint):void 
        {
            _dstBlend = value;
            _xml.blendFuncDestination.@value = value;
            dispatchUpdate(function(listener:SettingsListener):void{listener.updateDestinationBlend(value);});
        }

        private function dispatchUpdate(func:Function):void
        {
            for each(var listener:SettingsListener in mListeners)
            {
                func(listener);
                listener.update();
            }
        }

        /** Randomize all particle settings */
        public function randomize():void
        {
            infinite = Math.random() > 0.5;
            if(!infinite)
            {
                duration = randRange(10, 0, 2);
                shot = randRange(duration, 0, 2);
            }
            emitterType = randRange(1, 0, 0);
            maxParts = randRange(1000, 1, 2);
            lifeSpan = randRange(10, 0, 2);
            lifeSpanVar = randRange(10, 0, 2);
            startSize = randRange(70, 0, 2);
            startSizeVar = randRange(70, 0, 2);
            finishSize = randRange(70, 0, 2);
            finishSizeVar = randRange(70, 0, 2);
            emitAngle = randRange(360, 0, 2);
            emitAngleVar = randRange(360, 0, 2);
            stRot = randRange(360, 0, 2);
            stRotVar = randRange(360, 0, 2);
            endRot = randRange(360, 0, 2);
            endRotVar = randRange(360, 0, 2);
            xPosVar = randRange(1000, 0, 2);
            yPosVar = randRange(1000, 0, 2);
            speed = randRange(500, 0, 2);
            speedVar = randRange(500, 0, 2);
            gravX = randRange(500, -500, 2);
            gravY = randRange(500, -500, 2);
            tanAcc = randRange(500, -500, 2);
            tanAccVar = randRange(500, 0, 2);
            radialAcc = randRange(500, -500, 2);
            radialAccVar = randRange(500, 0, 2);
            maxRadius = randRange(500, 0, 2);
            maxRadiusVar = randRange(500, 0, 2);
            minRadius = randRange(500, 0, 2);
            minRadiusVar = randRange(500, 0, 2);
            degPerSec = randRange(360, -360, 2);
            degPerSecVar = randRange(360, 0, 2);
            sr = randRange(1, 0, 2);
            sg = randRange(1, 0, 2);
            sb = randRange(1, 0, 2);
            sa = randRange(1, 0, 2);
            fr = randRange(1, 0, 2);
            fg = randRange(1, 0, 2);
            fb = randRange(1, 0, 2);
            fa = randRange(1, 0, 2);
            svr = randRange(1, 0, 2);
            svg = randRange(1, 0, 2);
            svb = randRange(1, 0, 2);
            sva = randRange(1, 0, 2);
            fvr = randRange(1, 0, 2);
            fvg = randRange(1, 0, 2);
            fvb = randRange(1, 0, 2);
            fva = randRange(1, 0, 2);
        }

        /** Create a random number between min and max with decimals decimal places */
        private function randRange(max:Number, min:Number = 0, decimals:int = 0):Number {
            if (min > max) return NaN;
            var rand:Number = Math.random() * (max - min) + min;
            var d:Number = Math.pow(10, decimals);
            return ~~((d * rand) + 0.5) / d;
        }
	}

}