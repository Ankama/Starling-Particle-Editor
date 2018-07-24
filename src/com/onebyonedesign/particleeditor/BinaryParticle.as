package com.onebyonedesign.particleeditor
{
    import com.adobe.images.PNGEncoder;
import com.onebyonedesign.particleeditor.ParticleView;

import flash.display.Bitmap;

    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
import flash.system.ImageDecodingPolicy;
import flash.system.LoaderContext;
import flash.utils.ByteArray;

import starling.core.Starling;

public class BinaryParticle
    {
        private var m_settings : SettingsModel;
        private var m_texture : BitmapData;

        public function get isValid() : Boolean
        {
            return m_texture != null;
        }

        public function set texture(value:BitmapData) : void
        {
            m_texture = value;
        }

        public function BinaryParticle(settings:SettingsModel)
        {
            m_settings = settings;
        }

        public function loadFromByteArray(src:ByteArray) : void
        {
            src.position = 0;
            var version:uint = src.readByte();
            if(version == 1)
            {
                var textureSize:int = src.readUnsignedInt();
                var textureBytes:ByteArray = new ByteArray();
                src.readBytes(textureBytes,0, textureSize);
                var imgLoader:Loader = new Loader();
                imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
                imgLoader.loadBytes(textureBytes);
                m_settings.maxParts = src.readFloat();
                m_settings.lifeSpan = src.readFloat();
                m_settings.lifeSpanVar = src.readFloat();
                m_settings.startSize = src.readFloat();
                m_settings.startSizeVar = src.readFloat();
                m_settings.finishSize = src.readFloat();
                m_settings.finishSizeVar = src.readFloat();
                m_settings.emitAngle = src.readFloat();
                m_settings.emitAngleVar = src.readFloat();
                m_settings.stRot = src.readFloat();
                m_settings.stRotVar = src.readFloat();
                m_settings.endRot = src.readFloat();
                m_settings.endRotVar = src.readFloat();
                m_settings.xPos = src.readFloat();
                m_settings.yPos = src.readFloat();
                m_settings.xPosVar = src.readFloat();
                m_settings.yPosVar = src.readFloat();
                m_settings.speed = src.readFloat();
                m_settings.speedVar = src.readFloat();
                m_settings.gravX = src.readFloat();
                m_settings.gravY = src.readFloat();
                m_settings.tanAcc = src.readFloat();
                m_settings.tanAccVar = src.readFloat();
                m_settings.radialAcc = src.readFloat();
                m_settings.radialAccVar = src.readFloat();
                m_settings.maxRadius = src.readFloat();
                m_settings.maxRadiusVar = src.readFloat();
                m_settings.minRadius = src.readFloat();
                m_settings.minRadiusVar = src.readFloat();
                m_settings.degPerSec = src.readFloat();
                m_settings.degPerSecVar = src.readFloat();
                m_settings.sr = src.readFloat();
                m_settings.sg = src.readFloat();
                m_settings.sb = src.readFloat();
                m_settings.sa = src.readFloat();
                m_settings.fr = src.readFloat();
                m_settings.fg = src.readFloat();
                m_settings.fb = src.readFloat();
                m_settings.fa = src.readFloat();
                m_settings.svr = src.readFloat();
                m_settings.svg = src.readFloat();
                m_settings.svb = src.readFloat();
                m_settings.sva = src.readFloat();
                m_settings.fvr = src.readFloat();
                m_settings.fvg = src.readFloat();
                m_settings.fvb = src.readFloat();
                m_settings.fva = src.readFloat();
                m_settings.srcBlend = src.readShort();
                m_settings.dstBlend = src.readShort();
                m_settings.emitterType = src.readByte();
            }
        }


        private function onImageLoaded(event:Event) : void
        {
            event.currentTarget.removeEventListener(Event.COMPLETE, onImageLoaded);
            var loader:Loader = (event.currentTarget as LoaderInfo).loader;
            m_texture = (loader.content as Bitmap).bitmapData;

            ParticleView.CUSTOM_DATA.dispose();
            ParticleView.CUSTOM_DATA = m_texture;
            ParticleView(Starling.current.root).particleData = ParticleView.CUSTOM_DATA;
        }

        public function toByteArray() : ByteArray
        {
            if(!isValid)
                return null;

            var result:ByteArray = new ByteArray();
            result.writeByte(1);
            var textureBytes:ByteArray = PNGEncoder.encode(m_texture);
            textureBytes.position = 0;
            result.writeUnsignedInt(textureBytes.length);
            result.writeBytes(textureBytes, 0, textureBytes.length);
            result.writeFloat(m_settings.maxParts);
            result.writeFloat(m_settings.lifeSpan);
            result.writeFloat(m_settings.lifeSpanVar);
            result.writeFloat(m_settings.startSize);
            result.writeFloat(m_settings.startSizeVar);
            result.writeFloat(m_settings.finishSize);
            result.writeFloat(m_settings.finishSizeVar);
            result.writeFloat(m_settings.emitAngle);
            result.writeFloat(m_settings.emitAngleVar);
            result.writeFloat(m_settings.stRot);
            result.writeFloat(m_settings.stRotVar);
            result.writeFloat(m_settings.endRot);
            result.writeFloat(m_settings.endRotVar);
            result.writeFloat(m_settings.xPos);
            result.writeFloat(m_settings.yPos);
            result.writeFloat(m_settings.xPosVar);
            result.writeFloat(m_settings.yPosVar);
            result.writeFloat(m_settings.speed);
            result.writeFloat(m_settings.speedVar);
            result.writeFloat(m_settings.gravX);
            result.writeFloat(m_settings.gravY);
            result.writeFloat(m_settings.tanAcc);
            result.writeFloat(m_settings.tanAccVar);
            result.writeFloat(m_settings.radialAcc);
            result.writeFloat(m_settings.radialAccVar);
            result.writeFloat(m_settings.maxRadius);
            result.writeFloat(m_settings.maxRadiusVar);
            result.writeFloat(m_settings.minRadius);
            result.writeFloat(m_settings.minRadiusVar);
            result.writeFloat(m_settings.degPerSec);
            result.writeFloat(m_settings.degPerSecVar);
            result.writeFloat(m_settings.sr);
            result.writeFloat(m_settings.sg);
            result.writeFloat(m_settings.sb);
            result.writeFloat(m_settings.sa);
            result.writeFloat(m_settings.fr);
            result.writeFloat(m_settings.fg);
            result.writeFloat(m_settings.fb);
            result.writeFloat(m_settings.fa);
            result.writeFloat(m_settings.svr);
            result.writeFloat(m_settings.svg);
            result.writeFloat(m_settings.svb);
            result.writeFloat(m_settings.sva);
            result.writeFloat(m_settings.fvr);
            result.writeFloat(m_settings.fvg);
            result.writeFloat(m_settings.fvb);
            result.writeFloat(m_settings.fva);
            result.writeShort(m_settings.srcBlend);
            result.writeShort(m_settings.dstBlend);
            result.writeByte(m_settings.emitterType);

            return result;
        }
    }
}
