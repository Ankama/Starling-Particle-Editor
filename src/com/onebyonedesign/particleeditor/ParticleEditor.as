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
    import com.bit101.components.Component;
    import com.bit101.components.Label;
    import com.bit101.components.ProgressBar;
    import com.bit101.components.Window;

    import flash.desktop.NativeApplication;

    import flash.display.DisplayObject;

    import flash.display.DisplayObjectContainer;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.net.SharedObject;
    import flash.utils.ByteArray;

    import uk.co.soulwire.gui.SimpleGUI;
	
	/**
	 * Save, load, and modify particle properties
	 * @author Devon O.
	 */
	public class ParticleEditor
	{
		/** file reference to download particle */
		private var downloader:FileReference = new FileReference();
		
		/** UI */
		private var mGUI:SimpleGUI;

        /** Settings */
        private var mSettings:SettingsModel;
        
        /** Particle View */
        private var mParticleView:ParticleView;
        
        /** texture editor */
		private var mTexEditor:TextureEditor;
		
		/** background editor */
		private var mBGEditor:BackgroundEditor;
		
        /** Blend Mode values */
		private var mBlendArray:Array = 
		[
			{label:"Zero", data:0x00 },
			{label:"One", data:0x01 },
			{label:"Src", data:0x300 },
			{label:"One - Src", data:0x301 },
			{label:"Src Alpha", data:0x302 },
			{label:"One - Src Alpha", data:0x303 },
			{label:"Dst Alpha", data:0x304 },
			{label:"One - Dst Alpha", data:0x305 },
			{label:"Dst Color", data:0x306 },
			{label:"One - Dst Color", data:0x307}
		];

        private var mGravityGroup:Sprite;
        private var mRadialGroup:Sprite;
        private var mDuration:Component;
        
        /**
         * Create a new Particle Editor
         * @param settings
         * @param initialConfig
         * @param particleView
         */
		public function ParticleEditor(settings:SettingsModel, particleView:ParticleView)
		{
            mSettings = settings;
            mParticleView = particleView;

            var backup:SharedObject = SharedObject.getLocal("backup");
            if(backup && backup.data && backup.data.particle)
                loadFromByteArray(backup.data.particle);

            mParticleView.settings = mSettings;

            initUI();
            NativeApplication.nativeApplication.addEventListener(Event.EXITING, onShutdown);
		}

        private function onShutdown(event:Event):void
        {
            var backup:SharedObject = SharedObject.getLocal("backup");
            backup.data.particle = getBytes();
            backup.flush();
        }
		
		/** Create the SimpleGUI instance */
		private function initUI():void 
		{
			mGUI = new SimpleGUI(mSettings, "General");

            mGUI.addGroup("File");
            mGUI.addButton("Load", { name:"loadButton", callback:onLoad } );
			mGUI.addButton("Save", { name:"savePartBtn", callback:saveParticle } );
			mGUI.addGroup("Edit");
			mGUI.addButton("Edit Texture", { name:"editTexBtn", callback:editTexture } );
			mGUI.addButton("Edit Background", { name:"editBGBtn", callback:editBackground } );
            mGUI.addButton("Reset Offset", { name:"resetPositionBtn", callback:resetPosition } );
            mGUI.addButton("Reset to Default", { name:"resetAllBtn", callback:resetAll } );
            mGUI.addGroup("Playback");
            mParticleView.progressBar = mGUI.addControl(ProgressBar, {}) as ProgressBar;
            mGUI.addButton("Play", { name:"playButton", callback:play } );
            mGUI.addButton("Stop", { name:"stopButton", callback:stop } );
            mGUI.addGroup("Random Settings");
            mGUI.addButton("Randomize!", { name:"randomSettings", callback:randomizeSettings } );
			
			mGUI.addColumn("Particles");
			mGUI.addGroup("Emitter Type");
            mGUI.addComboBox("emitterType", [ { label:"Gravity", data:0 }, { label:"Radial", data:1 } ], { name:"emitterType", callback:enableSettings } );
			
			mGUI.addGroup("Particle Configuration");
            mGUI.addToggle("infinite", { label:"Infinite", name:"infinite", callback:updateDurationStatus } );
            mDuration = mGUI.addSlider("duration", 0.1, 10.0, { label:"Duration", name:"duration" } );
			mGUI.addSlider("maxParts", 1.0, 1000.0, { label:"Max Particles", name:"maxParts" } );
			mGUI.addSlider("lifeSpan", 0, 10.0, { label:"Lifespan", name:"lifeSpan" } );
			mGUI.addSlider("lifeSpanVar", 0, 10.0, { label:"Lifespan Variance", name:"lifeSpanVar" } );
			mGUI.addSlider("startSize", 0, 70.0, { label:"Start Size", name:"startSize" } );
			mGUI.addSlider("startSizeVar", 0, 70.0, { label:"Start Size Variance", name:"startSizeVar" } );
			mGUI.addSlider("finishSize", 0, 70.0, { label:"Finish Size", name:"finishSize" } );
			mGUI.addSlider("finishSizeVar", 0, 70.0, { label:"Finish Size Variance", name:"finishSizeVar" } );
			mGUI.addSlider("emitAngle", 0, 360.0, { label:"Emitter Angle", name:"emitAngle" } );
			mGUI.addSlider("emitAngleVar", 0, 360.0, { label:"Angle Variance", name:"emitAngleVar" } );
			mGUI.addSlider("stRot", 0, 360.0, { label:"Start Rot.", name:"stRot" } );
			mGUI.addSlider("stRotVar", 0, 360.0, { label:"Start Rot. Var.", name:"stRotVar" } );
			mGUI.addSlider("endRot", 0, 360.0, { label:"End Rot.", name:"endRot" } );
			mGUI.addSlider("endRotVar", 0, 360.0, { label:"End Rot. Var.", name:"endRotVar" } );
			
			mGUI.addColumn("Particle Behavior");
            mGravityGroup = mGUI.addGroup("Gravity (gravity emitter)");
			mGUI.addSlider("xPosVar", 0.0, 1000.0, { label:"X Variance", name:"xPosVar" } );
			mGUI.addSlider("yPosVar", 0.0, 1000.0, { label:"Y Variance", name:"yPosVar" } );
			mGUI.addSlider("speed", 0, 500.0, { label:"Speed", name:"speed" } );
			mGUI.addSlider("speedVar", 0, 500.0, { label:"Speed Variance", name:"speedVar" } );
			mGUI.addSlider("gravX", -500, 500.0, { label:"Gravity X", name:"gravX" } );
			mGUI.addSlider("gravY", -500, 500.0, { label:"Gravity Y", name:"gravY" } );
			mGUI.addSlider("tanAcc", -500, 500, { label:"Tan. Acc.", name:"tanAcc" } );
			mGUI.addSlider("tanAccVar", 0.0, 500, { label:"Tan. Acc. Var", name:"tanAccVar" } );
			mGUI.addSlider("radialAcc", -500.00, 500.0, { label:"Rad. Acc.", name:"radialAcc" } );
			mGUI.addSlider("radialAccVar", 0, 500.0, { label:"Rad. Acc. Var.", name:"radialAccVar" } );

            mRadialGroup = mGUI.addGroup("Rotation (radial emitter)");
			mGUI.addSlider("maxRadius", 0, 500.0, { label:"Max Radius", name:"maxRadius" } );
			mGUI.addSlider("maxRadiusVar", 0, 500.0, { label:"Max Rad Variance", name:"maxRadiusVar" } );
			mGUI.addSlider("minRadius", 0, 500.0, { label:"Min Radius", name:"minRadius" } );
            mGUI.addSlider("minRadiusVar", 0, 500.0, { label:"Min Rad Variance", name:"minRadiusVar" } );
			mGUI.addSlider("degPerSec", -360.0, 360.0, { label:"Deg/Sec", name:"degPerSec" } );
			mGUI.addSlider("degPerSecVar", 0.0, 360.0, { label:"Deg/Sec Var.", name:"degPerSecVar" } );

            enableSettings();
            updateDurationStatus();
			
			mGUI.addColumn("Particle Color");
			mGUI.addGroup("Start");
			mGUI.addSlider("sr", 0, 1.0, { label:"R", name:"sr", width:150 } );
			mGUI.addSlider("sg", 0, 1.0, { label:"G", name:"sg", width:150 } );
			mGUI.addSlider("sb", 0, 1.0, { label:"B", name:"sb", width:150 } );
			mGUI.addSlider("sa", 0, 1.0, { label:"A", name:"sa", width:150 } );
			
			mGUI.addGroup("Finish");
			mGUI.addSlider("fr", 0, 1.0, { label:"R", name:"fr", width:150 } );
			mGUI.addSlider("fg", 0, 1.0, { label:"G", name:"fg", width:150 } );
			mGUI.addSlider("fb", 0, 1.0, { label:"B", name:"fb", width:150 } );
			mGUI.addSlider("fa", 0, 1.0, { label:"A", name:"fa", width:150 } );
			
			mGUI.addColumn("Particle Color Variance");
			mGUI.addGroup("Start");
			mGUI.addSlider("svr", 0, 1.0, { label:"R", name:"svr", width:150 } );
			mGUI.addSlider("svg", 0, 1.0, { label:"G", name:"svg", width:150 } );
			mGUI.addSlider("svb", 0, 1.0, { label:"B", name:"svb", width:150 } );
			mGUI.addSlider("sva", 0, 1.0, { label:"A", name:"sva", width:150 } );
			
			mGUI.addGroup("Finish");
			mGUI.addSlider("fvr", 0, 1.0, { label:"R", name:"fvr", width:150 } );
			mGUI.addSlider("fvg", 0, 1.0, { label:"G", name:"fvg", width:150 } );
			mGUI.addSlider("fvb", 0, 1.0, { label:"B", name:"fvb", width:150 } );
			mGUI.addSlider("fva", 0, 1.0, { label:"A", name:"fva", width:150 } );
			
			mGUI.addGroup("Blend Function");
            mGUI.addComboBox("srcBlend", mBlendArray, {  label:"Source", name:"srcBlend" } );
            mGUI.addComboBox("dstBlend", mBlendArray, { label:"Dest.  ", name:"dstBlend" } );
			
			mGUI.show();
		}
        
        //
        // Load a .pex file
        //
		
		/** Browse for particle files to load */
		private function onLoad(o:*):void
		{
			downloader.addEventListener(Event.SELECT, onLoadSelect);
			downloader.browse([new FileFilter("Particle Files (*.d3fx)", "*.d3fx")]);
		}

        private function play(o:*):void
        {
            mParticleView.play();
        }

        private function stop(o:*):void
        {
            mParticleView.stop();
        }
		
		/** After selecting particle file to load */
		private function onLoadSelect(event:Event):void
		{
			downloader.removeEventListener(Event.SELECT, onLoadSelect);
			downloader.addEventListener(Event.COMPLETE, onLoadComplete);
			downloader.load();
		}

        private function loadFromByteArray(bytes:ByteArray):void
        {
            var binaryParticle:BinaryParticle = new BinaryParticle(mSettings);
            binaryParticle.loadFromByteArray(bytes);
        }
		
		/** After particle file has been loaded */
		private function onLoadComplete(event:Event):void 
		{
			downloader.removeEventListener(Event.COMPLETE, onLoadComplete);
			try
			{
                loadFromByteArray(downloader.data);
                mGUI.update();
                updateDurationStatus();
			}
			catch (err:Error) 
			{
				trace(err);
                showError("Particle file appears to be malformed");
			}
		}
        
        //
        // Error display 
        //
        
        /** Display an Error Window */
        private function showError(label:String):void
        {
            var errWindow:Window = new Window(mSettings, -300, 100, "ERROR!");
            errWindow.setSize(200, 100);
            errWindow.hasCloseButton = true;
            errWindow.addEventListener(Event.CLOSE, onErrClose);
            new Label(errWindow.content, 5, 5, label);
        }
		
		/** remove error display window */
		private function onErrClose(event:Event):void 
		{
			var win:Window = event.currentTarget as Window;
			win.parent.removeChild(win);
		}

        private function getBytes():ByteArray
        {
            var binaryParticle:BinaryParticle = new BinaryParticle(mSettings);
            binaryParticle.texture = mParticleView.particleData;
            var filedata:ByteArray = binaryParticle.toByteArray();
            filedata.position = 0;
            return filedata;
        }
        
		/** Save particle texture image source and config file to .d3fx */
		private function saveParticle(o:*):void
		{
			downloader.save(getBytes(), "particle.d3fx");
		}
        
        //
        // Edit Texture
        //
		
		/** open the texture editor panel */
		private function editTexture(o:*):void 
		{
			if ((mBGEditor)) 
                onDoneBGEditing(null);
			mTexEditor = new TextureEditor(mParticleView.particleData);
            
            // Hack to get window below Particle display
            // tex editor x pos set by the editor in init method
			mTexEditor.y = 510;
            
			mTexEditor.addEventListener(Event.COMPLETE, onDoneEditing);
			mSettings.addChild(mTexEditor);
		}
		
		/** after closing texture editor panel */
		private function onDoneEditing(event:Event):void
		{
			mTexEditor.removeEventListener(Event.COMPLETE, onDoneEditing);
            mParticleView.particleData = mTexEditor.mData;
			mSettings.removeChild(mTexEditor);
			mTexEditor = null;
		}
        
        // 
        // Edit Background color 
        //
		
		/** open background editor panel */
		private function editBackground(o:*):void 
		{
			if ((mTexEditor)) 
                onDoneEditing(null);
			mBGEditor = new BackgroundEditor();
            
            // Hack to get window below Particle display
            // bg editor x pos set by the editor in init method
			mBGEditor.y = 510;
            
			mBGEditor.addEventListener(Event.COMPLETE, onDoneBGEditing);
			mSettings.addChild(mBGEditor);
		}
        
        /** after closing background editor panel */
		private function onDoneBGEditing(event:Event):void 
		{
			mBGEditor.removeEventListener(Event.COMPLETE, onDoneBGEditing);
			mSettings.removeChild(mBGEditor);
			mBGEditor = null;
		}

        private function resetPosition(o:*):void
        {
            mSettings.xPos = 0;
            mSettings.yPos = 0;
        }

        private function resetAll(o:*):void
        {
            mSettings.xml = XML(new Main.DEFAULT_CONFIG());
            mParticleView.particleData = new ParticleView.DEFAULT_PARTICLE().bitmapData;
            mParticleView.play();
        }

        /** Randomize particle settings */
        private function randomizeSettings(o:*):void
        {
            mSettings.randomize();
            updateDurationStatus();
        }

        private function updateDurationStatus(o:* = null):void
        {
            if(mDuration)
                mDuration.enabled = !mSettings.infinite;
        }

        /** enable/disable emitter type settings */
        private function enableSettings(o:* = null):void
        {
            var gravity:Boolean = mSettings.emitterType == 0;
            foreachComponent(mGravityGroup, function(component:Component):void{component.enabled = gravity;});
            foreachComponent(mRadialGroup, function(component:Component):void{component.enabled = !gravity;});
        }

        private function foreachComponent(element:DisplayObject, func:Function):void
        {
            if(element is Component)
                func(Component(element));
            if(element is DisplayObjectContainer)
            {
                var container : DisplayObjectContainer = DisplayObjectContainer(element);
                for(var i:uint = 0 ; i < container.numChildren ; i++)
                    foreachComponent(container.getChildAt(i), func);
            }
        }
	}

}