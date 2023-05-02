package;

import flixel.graphics.FlxGraphic;
#if desktop
import Discord.DiscordClient;
#end
// WAAAA
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.ui.MouseButton;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Window;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.Sprite;
import openfl.utils.Assets;


import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import Shaders.PulseEffect;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import Note.EventNote;
import openfl.events.KeyboardEvent;
import flixel.util.FlxSave;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
#if sys
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;

	public static var ratingStuff:Array<Dynamic> = [
		['No one loves you', 0.2], //From 0% to 19%
		['Oh my lord', 0.4], //From 20% to 39%
		['Oh my god just hit the notes', 0.5], //From 40% to 49%
		['??? how', 0.6], //From 50% to 59%
		['Eh', 0.69], //From 60% to 68%
		['Yeah nice', 0.7], //69%
		['Pretty good', 0.8], //From 70% to 79%
		['Wow!', 0.9], //From 80% to 89%
		['Damn!!', 1], //From 90% to 99%
		['HOLY FUCK!?', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, ModchartText> = new Map<String, ModchartText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();
	//event variables
	private var isCameraOnForcedPos:Bool = false;
	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	#end

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;

	public var songSpeedTween:FlxTween;
	public var songSpeed(default, set):Float = 1;
	public var songSpeedType:String = "multiplicative";
	public var noteKillOffset:Float = 350;
	
	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public static var curStage:String = '';
	public var curbg:FlxSprite;
	private var auraBF:FlxSprite;
	public static var isPixelStage:Bool = false;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	private	var clankynite:Float = (0.09);
	private	var clankyniteP2:Float = (0.09);
	public	var drainy:Float = (0);
	public var vocals:FlxSound;

	

	public var dad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Boyfriend = null;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<EventNote> = [];

	private var strumLine:FlxSprite;
	private var floatshit:Float = 0; 
	private var floatshit2:Float = 0; 
	private var hasJunked:Bool = false;
	private var randshit:Float = FlxG.random.int(-170, 170) * 0.01;
	private var gotAura:Bool = false;

	
	public static var screenshader:Shaders.PulseEffect = new PulseEffect();

	//Handles the new epic mega sexy cam code that i've done
	private var camFollow:FlxPoint;
	private var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	var cameraLocked:Bool = false;
	var auraMult:Float = ClientPrefs.auraScroll;
	var canauraMult:Bool = true;
	
	var camebopHud:Bool = false;
	var camBopAngle:Bool = true;
	var camBopInterval:Int = 4;
	var camBopIntensity:Float = 1;
	var camAngled:Bool = false;
	var extraZoom:Float = 0;

	var camZoomingDefault:Bool = true;



	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public var camZooming:Bool = false;

	private var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;

	private var healthBarBG:AttachedSprite;
	public var healthBar:FlxBar;
	var songPercent:Float = 0;

	private var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;
	
	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;
	public var holds:Int = 0;
	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	public var startingSong:Bool = false;
	private var updateTime:Bool = true;
	public static var changedDifficulty:Bool = false;
	public static var chartingMode:Bool = false;

	//Gameplay settings
	public var healthGain:Float = 1;
	public var healthLoss:Float = 1;
	public var instakillOnMiss:Bool = false;
	public var cpuControlled:Bool = false;
	public var practiceMode:Bool = false;

	public var botplaySine:Float = 0;
	public var botplayTxt:FlxText;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	public var cameraSpeed:Float = 1;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogueJson:DialogueFile = null;

	var halloweenBG:BGSprite;
	var halloweenWhite:BGSprite;


	var trainSound:FlxSound;

	var fire:FlxSprite;

	var heyTimer:Float;


	var wiggleShit:WiggleEffect = new WiggleEffect();
	var windowTitle:String = 'Wow! Default text!';

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	public var scoreTxt:FlxText;
	var timeTxt:FlxText;
	var gfText:FlxText;
	var scoreTxtTween:FlxTween;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;

	public var defaultCamZoom:Float = 1.05;
	public var defaultCamAngle:Float = 0;
	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;
	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var inCutscene:Bool = false;
	public var skipCountdown:Bool = false;
	var songLength:Float = 0;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	//Achievement shit
	var keysPressed:Array<Bool> = [];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	// Lua shit
	public static var instance:PlayState;
	public var luaArray:Array<FunkinLua> = [];
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var introSoundsSuffix:String = '';

	// Debug buttons
	private var debugKeysChart:Array<FlxKey>;
	private var debugKeysCharacter:Array<FlxKey>;
	
	// Less laggy controls
	private var keysArray:Array<Dynamic>;

	var windowDad:Window;
	var dadWin = new Sprite();
	var dadScrollWin = new Sprite();
	var windowed:Bool = false;
	 var remoteScaleTween:FlxTween;
 	var remoteAlphaTween:FlxTween;
	public var gfTween:FlxTween;
	public var dadTween:FlxTween;
	var remote:FlxSprite;
	var remoteFPS:Float;
	
	var process:FlxSprite;
	var fuckyoulaz:FlxSprite;
	var sign:FlxSprite;
	var signTitle:FlxSprite;


	var buildings:Array<FlxSprite>;
	public var tranceActive:Bool = false;
	public var tranceNotActiveYet:Bool = false;

	var alreadyHit:Bool = false;
	var canHitPendulum:Bool = false;
	var tranceInterval:Int = 0;
	var beatInterval:Float = 2; 

	var tweenDir:Bool = true;
	

	var dagfTweened:Bool = false;
	var dadYpre:Float;
	var bfYpre:Float;
	//sorry vs hypno team had to steal ur code rq i'll learn how it works one day and rewrite it myself
	override public function create()
	{
		Paths.clearStoredMemory();
		
		// for lua
		instance = this;

		debugKeysChart = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		debugKeysCharacter = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));
		PauseSubState.songName = null; //Reset to default

		keysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];

		// For the "Just the Two of Us" achievement
		for (i in 0...keysArray.length)
		{
			keysPressed.push(false);
		}

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// Gameplay settings
		healthGain = ClientPrefs.getGameplaySetting('healthgain', 1);
		healthLoss = ClientPrefs.getGameplaySetting('healthloss', 1);
		instakillOnMiss = ClientPrefs.getGameplaySetting('instakill', false);
		practiceMode = ClientPrefs.getGameplaySetting('practice', false);
		cpuControlled = ClientPrefs.getGameplaySetting('botplay', false);

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camGame.bgColor = 0xFFFFFFFF;
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;
		
		
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther);
		

		
	
		persistentUpdate = true;
		persistentDraw = true;

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		FlxCamera.defaultCameras = [camGame];
		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		CustomFadeTransition.nextCamera = camOther;
		//FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		#if desktop
		storyDifficultyText = CoolUtil.difficulties[storyDifficulty];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: " + WeekData.getCurrentWeek().weekName;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end

		GameOverSubstate.resetVariables();
		var songName:String = Paths.formatToSongPath(SONG.song);

		curStage = PlayState.SONG.stage;
		//trace('stage is: ' + curStage);
		if(PlayState.SONG.stage == null || PlayState.SONG.stage.length < 1) {
			switch (songName)
			{

				default:
					curStage = 'stage';
			}
		}

		var stageData:StageFile = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,
			
				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100],
				hide_girlfriend: false,
			
				camera_boyfriend: [0, 0],
				camera_opponent: [0, 0],
				camera_girlfriend: [0, 0],
				camera_speed: 1
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		if(stageData.camera_speed != null)
			cameraSpeed = stageData.camera_speed;

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if(boyfriendCameraOffset == null) //Fucks sake should have done it since the start :rolling_eyes:
			boyfriendCameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if(opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];
		
		girlfriendCameraOffset = stageData.camera_girlfriend;
		if(girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);
		

		var mechDiff:String = ClientPrefs.radarMech;
		switch (mechDiff)
		{
			case 'Default':
				if (Paths.formatToSongPath(SONG.song) == 'radar') {
						tranceActive = true;
						// remoteFPS = 0.14 *  SONG.bpm - .6;
						// remote.scale.x = 0.8;
						// remote.scale.y = 0.8;
					remote = new FlxSprite().loadGraphic(Paths.image('radar/Radars1', '420'));
					remote.frames = Paths.getSparrowAtlas('radar/Radars1', '420');
					remote.animation.addByPrefix('goodBop', 'Radar', 24, false);
					remote.animation.addByPrefix('badBop', 'BrokenRadar', 24, false);
					remote.animation.addByPrefix('idle', 'IdleRadar', 24, true);
					remote.antialiasing = true;
					remote.scrollFactor.set();
					remote.active = true;
					remote.screenCenter();

					if (ClientPrefs.downScroll)
						remote.y -= 240;
					else
						remote.y += 240;
					remote.x -= 515;
					add(remote);
					}
					else
					tranceActive = false;
					remote = new FlxSprite().loadGraphic(Paths.image('radar/Radars1', '420'));
					remote.visible = false;
				case 'On':
							tranceActive = true;
							// remoteFPS = 0.14 *  SONG.bpm - .6;
							// remote.scale.x = 0.8;
							// remote.scale.y = 0.8;
							remote = new FlxSprite().loadGraphic(Paths.image('radar/Radars1', '420'));
							remote.frames = Paths.getSparrowAtlas('radar/Radars1', '420');
							remote.animation.addByPrefix('goodBop', 'Radar', 24, false);
							remote.animation.addByPrefix('badBop', 'BrokenRadar', 24, false);
							remote.animation.addByPrefix('idle', 'IdleRadar', 24, true);
							remote.antialiasing = true;
							remote.scrollFactor.set();
							remote.active = true;
							remote.screenCenter();
							
							if (ClientPrefs.downScroll)
								remote.y -= 240;
							else
								remote.y += 240;
							remote.x -= 515;
							add(remote);
				case 'Off':
				tranceActive = false;
				remote = new FlxSprite().loadGraphic(Paths.image('radar/Radars1', '420'));
				remote.visible = false;
		}
		var auraDiff:String = ClientPrefs.auraMech;
		switch (auraDiff)
		{
			case 'Default':
				canauraMult = true;
				case 'On':
					canauraMult = true;
					case 'Off':
					canauraMult = false;
		}



		
		// if(ClientPrefs.radarMech)
		// 	{
		// 		tranceActive = true;
		// 				// remoteFPS = 0.14 *  SONG.bpm - .6;
		// 				// remote.scale.x = 0.8;
		// 				// remote.scale.y = 0.8;
		// 		remote = new FlxSprite().loadGraphic(Paths.image('radar/Radars1', '420'));
		// 		remote.frames = Paths.getSparrowAtlas('radar/Radars1', '420');
		// 		remote.animation.addByPrefix('goodBop', 'Radar', 24, false);
		// 		remote.animation.addByPrefix('badBop', 'BrokenRadar', 24, false);
		// 		remote.animation.addByPrefix('idle', 'IdleRadar', 24, true);
		// 		remote.antialiasing = true;
		// 		remote.scrollFactor.set();
		// 		remote.active = true;
		// 		remote.screenCenter();
				
		// 		if (ClientPrefs.downScroll)
		// 			remote.y -= 240;
		// 		else
		// 			remote.y += 240;
		// 		remote.x -= 515;
		// 		add(remote);
		// 	} else {
				
		// 		tranceActive = false;
		// 		remote = new FlxSprite().loadGraphic(Paths.image('radar/Radars1', '420'));
		// 		remote.visible = false;
		// 	}

		switch (curStage)
		{
			case 'stage': //Week 1
				var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
				add(bg);

				var stageFront:BGSprite = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				add(stageFront);
				if(!ClientPrefs.lowQuality) {
					var stageLight:BGSprite = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					add(stageLight);
					var stageLight:BGSprite = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					stageLight.flipX = true;
					add(stageLight);

					var stageCurtains:BGSprite = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					add(stageCurtains);
				}

				case 'fuckyou': //moron
					
					curStage = 'fuckyou';
					var bg:FlxSprite = new FlxSprite(-600,-550).loadGraphic(Paths.image('fuckyou'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.6, 0.6);
					bg.active = true;

					add(bg);
					
					CoolUtil.precacheSound('moron/squeak', '420');
					process = new FlxSprite().loadGraphic(Paths.image('moron/process', '420'));
					process.frames = Paths.getSparrowAtlas('moron/process', '420');
					process.animation.addByPrefix('idle', 'render', 24, true);
					process.animation.addByPrefix('talk', 'fagRender', 24, true);
					process.animation.addByPrefix('enter', 'slorpRender', 24, false);
					process.animation.addByPrefix('blep', 'blepRender', 24, false);
					process.antialiasing = true;
					process.scrollFactor.set();
					process.active = true;
					process.screenCenter();
					add(process);

					process.alpha = 0.001;

					fuckyoulaz = new FlxSprite(-170, -300).loadGraphic(Paths.image('moron/fucklaser', '420'));
					fuckyoulaz.frames = Paths.getSparrowAtlas('moron/fucklaser', '420');
					fuckyoulaz.animation.addByPrefix('bop', 'fuck', 24, true);
					fuckyoulaz.animation.play('bop');
					fuckyoulaz.antialiasing = true;
					fuckyoulaz.scrollFactor.set();
					fuckyoulaz.active = true;
					add(fuckyoulaz);

					fuckyoulaz.alpha = 0.001;
					
				case 'weedy':

					defaultCamZoom = 0.85;
						curStage = 'weedy';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('weedbg'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.6, 0.6);
						bg.active = true;
	
						add(bg);
					#if windows
					// below code assumes shaders are always enabled which is bad
					var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
					testshader.waveAmplitude = 0.1;
					testshader.waveFrequency = 5;
					testshader.waveSpeed = 2;
					bg.shader = testshader.shader;
					curbg = bg;
					#end
					windowTitle = 'This shader took me 3 days';
				case 'sexcity':
					defaultCamZoom = 0.65;

					var sky:FlxSprite = new FlxSprite(-700, -200).loadGraphic(Paths.image('radar/sky', '420'));
					sky.setGraphicSize(Std.int(sky.width * 1.1));
					sky.antialiasing = true;
					sky.scrollFactor.set(0.2,0.2);
					add(sky);
					buildings = [];
					var randomheheho = FlxG.random.int(1, 3);

					var KILLYOURSELFFAGGOT:FlxSprite = new FlxSprite(-800, -95).loadGraphic(Paths.image('radar/BuildSet-' + randomheheho, '420'));
					KILLYOURSELFFAGGOT.antialiasing = true;
					KILLYOURSELFFAGGOT.scrollFactor.set(0.6, 0.6);
					KILLYOURSELFFAGGOT.setGraphicSize(Std.int(KILLYOURSELFFAGGOT.width * .9));
					KILLYOURSELFFAGGOT.active = true;
					add(KILLYOURSELFFAGGOT);

					var KILLYOURSELFFAGGOT2:FlxSprite = new FlxSprite(-800 - KILLYOURSELFFAGGOT.width, -95).loadGraphic(Paths.image('radar/BuildSet-' + randomheheho , '420'));
					KILLYOURSELFFAGGOT2.antialiasing = true;
					KILLYOURSELFFAGGOT2.scrollFactor.set(0.6, 0.6);
					KILLYOURSELFFAGGOT2.setGraphicSize(Std.int(KILLYOURSELFFAGGOT2.width * .9));
					KILLYOURSELFFAGGOT2.active = true;
					add(KILLYOURSELFFAGGOT2);
					
					var fagindustries:Int = 0;
					
					FlxTween.tween(KILLYOURSELFFAGGOT, {x:  KILLYOURSELFFAGGOT.x + KILLYOURSELFFAGGOT.width }, 10, {type: FlxTween.LOOPING, ease: FlxEase.linear, onComplete:
						function (twn:FlxTween)
						{
							// KILLYOURSELFFAGGOT.x = -800;
						}
					});
					FlxTween.tween(KILLYOURSELFFAGGOT2, {x: KILLYOURSELFFAGGOT2.x + KILLYOURSELFFAGGOT2.width}, 10, {type: FlxTween.LOOPING,	 ease: FlxEase.linear, onComplete:
						function (twn:FlxTween)
						{
							

							if (fagindustries == 0)
								{
									randomheheho = FlxG.random.int(1, 3);
									KILLYOURSELFFAGGOT2.loadGraphic(Paths.image('radar/BuildSet-' + randomheheho, '420'));
									var lastone = randomheheho;
									fagindustries = 1;
								}
								else
									{
										
										KILLYOURSELFFAGGOT.loadGraphic(Paths.image('radar/BuildSet-' + randomheheho, '420'));
										fagindustries = 0	;
									}
							// KILLYOURSELFFAGGOT = KILLYOURSELFFAGGOT2;
							KILLYOURSELFFAGGOT.x = -800;
							KILLYOURSELFFAGGOT2.x = -800 - KILLYOURSELFFAGGOT.width;
							

							
						}
					});

					var street:FlxSprite = new FlxSprite(sky.x - 200,sky.getMidpoint().y - 120).loadGraphic(Paths.image('radar/street', '420'));
					street.antialiasing = true;
					street.setGraphicSize(Std.int(street.width * 1.1));
					street.scrollFactor.set(0.7, 0.7);
					add(street);

					var whiteScreen:FlxSprite = new FlxSprite(-700, -200).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2.2), FlxColor.GREEN);
					add(whiteScreen);
					whiteScreen.scrollFactor.set();
					whiteScreen.blend = MULTIPLY;
					whiteScreen.alpha = 0.35;

					// case 'trans':
					// 	var whiteScreen:FlxSprite = new FlxSprite(-600, -200).makeGraphic(Std.int(FlxG.width * 1.2), Std.int(FlxG.height), FlxColor.WHITE);
					// 	add(whiteScreen);


		}

		if(isPixelStage) {
			introSoundsSuffix = '-pixel';
		}




		add(gfGroup);
		add(dadGroup);
		add(boyfriendGroup);


		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		#if windows
		screenshader.waveAmplitude = 1;
        screenshader.waveFrequency = 2;
        screenshader.waveSpeed = 1;
        screenshader.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000, 100000);
		#end



		// "GLOBAL" SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('scripts/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('scripts/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/scripts/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end
		

		// STAGE SCRIPTS
		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}

		if(doPush) 
			luaArray.push(new FunkinLua(luaFile));
		#end

		

		var gfVersion:String = SONG.gfVersion;
		if(gfVersion == null || gfVersion.length < 1) {
			switch (curStage)
			{
				default:
					gfVersion = 'gf';
			}
			SONG.gfVersion = gfVersion; //Fix for the Chart Editor
		}

		if (!stageData.hide_girlfriend)
		{
			gf = new Character(0, 0, gfVersion);
			startCharacterPos(gf);
			gf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(gf);
			startCharacterLua(gf.curCharacter);
		}

		dad = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		dadGroup.add(dad);
		startCharacterLua(dad.curCharacter);
		
		boyfriend = new Boyfriend(0, 0, SONG.player1);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);
		//boyfriendGroup.add(auraBF);
		startCharacterLua(boyfriend.curCharacter);
		
		var camPos:FlxPoint = new FlxPoint(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if(gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}

		if(dad.curCharacter.startsWith('gf')) {
			dad.setPosition(GF_X, GF_Y);
			if(gf != null)
				gf.visible = false;
		}
		dadYpre = (dad.y);
		bfYpre = (boyfriend.y);


		auraBF = new FlxSprite().loadGraphic(Paths.image('aura'));
		auraBF.antialiasing = true;
		auraBF.setPosition(boyfriend.getMidpoint().x,boyfriend.getMidpoint().y);
		//auraBF.offset.set(217, 235); // Positive X = left/ Positve Y = up
		auraBF.offset.set(217, 235); // Positive X = left/ Positve Y = up
		auraBF.frames = Paths.getSparrowAtlas('aura');
		auraBF.animation.addByPrefix('idle', 'Fire', 20, true);	
		auraBF.animation.play('idle');
		auraBF.visible = false;

		add(auraBF);
		auraBF.blend = ADD;
		//200,-1100
		sign = new FlxSprite(250,-1100).loadGraphic(Paths.image('signs/gf', '420'));

		sign.frames = Paths.getSparrowAtlas('signs/gf', '420');
		sign.animation.addByPrefix('idle', 'signGf', 24, true);
		sign.animation.play('idle');
		sign.antialiasing = true;
		
		add(sign);
		sign.visible = false;
		signTitle = new FlxSprite(sign.x,sign.y).loadGraphic(Paths.image('signs/titles/moron', '420'));

		signTitle.frames = Paths.getSparrowAtlas('signs/titles/moron', '420');
		signTitle.animation.addByPrefix('jump', 'moronTitle', 24, false);
		signTitle.antialiasing = true;
		signTitle.visible = false;
		add(signTitle);



		var file:String = Paths.json(songName + '/dialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -5000;


		if(SONG.stage.toLowerCase() == 'sexcity')
			STRUM_X = -278;
		else
			STRUM_X = 42;
		strumLine = new FlxSprite(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) 
			{
				strumLine.y = FlxG.height - 150;
				
					tweenDir = false;
			}
			
		strumLine.scrollFactor.set();
		//STRUM_X + (FlxG.width / 2) - 248
		var showTime:Bool = (ClientPrefs.timeBarType != 'Disabled');
		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("Vertexjoint.ttf"), 32, 0x0bb633, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = showTime;





		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 44;

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.text = SONG.song;
		}
		updateTime = showTime;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = showTime;
		timeBarBG.color = 0x069754;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;
		add(timeBarBG);

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0x069754, 0x0bb633);
		timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timeBar.alpha = 0;
		timeBar.visible = showTime;
		add(timeBar);
		add(timeTxt);
		timeBarBG.sprTracker = timeBar;

		
		

		

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.size = 24;
			timeTxt.y += 3;
		}

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		// startCountdown();

		generateSong(SONG.song);
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys())
		{
			var luaToLoad:String = Paths.modFolders('custom_notetypes/' + notetype + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
		}
		for (event in eventPushedMap.keys())
		{
			var luaToLoad:String = Paths.modFolders('custom_events/' + event + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_events/' + event + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
		}
		#end
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters
		// add(strumLine);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);
		
		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);
		
		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		

		FlxG.camera.zoom = defaultCamZoom;
		// FlxG.camera.width = FlxG.width * 3;
		// FlxG.camera.height = FlxG.height * 3;
		// FlxG.camera.maxScrollX = FlxG.width * 3;
		// FlxG.camera.maxScrollY = FlxG.height * 3;
		camGame.angle = defaultCamAngle;
		// camGame.camera.maxScrollX = FlxG.width * 3;
		// camGame.camera.maxScrollY = FlxG.height * 3;
		FlxG.camera.focusOn(camFollow);

		// camGame.camera.setScrollBoundsRect(0, 0, FlxG.width * 4, FlxG.height * 4, true);
		// FlxG.camera.setBounds(0, 0, FlxG.width, FlxG.height);



		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
		trace(FlxG.width);
		trace(FlxG.height);
		FlxG.fixedTimestep = false;
		moveCameraSection(0);


		

		healthBarBG = new AttachedSprite('healthBar');
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = !ClientPrefs.hideHud;
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;
		add(healthBarBG);
		if(ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		// healthBar
		healthBar.visible = !ClientPrefs.hideHud;
		healthBar.alpha = ClientPrefs.healthBarAlpha;
		add(healthBar);
		healthBarBG.sprTracker = healthBar;

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - 90;
		iconP1.visible = !ClientPrefs.hideHud;
		iconP1.alpha = ClientPrefs.healthBarAlpha;
		add(iconP1);

		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.y = healthBar.y - 90;
		iconP2.visible = !ClientPrefs.hideHud;
		iconP2.alpha = ClientPrefs.healthBarAlpha;
		add(iconP2);
		reloadHealthBarColors();

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20,  FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]), CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		add(scoreTxt);



		botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "BOTPLAY", 32);
		botplayTxt.setFormat(Paths.font("Vertexjoint.ttf"), 32, FlxColor.MAGENTA, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		botplayTxt.visible = cpuControlled;
		add(botplayTxt);
		if(ClientPrefs.downScroll) {
			botplayTxt.y = timeBarBG.y - 78;
		}

		


		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		sign.cameras = [camHUD];
		signTitle.cameras = [camHUD];
		remote.cameras = [camHUD];



		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		// SONG SPECIFIC SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('data/' + Paths.formatToSongPath(SONG.song) + '/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('data/' + Paths.formatToSongPath(SONG.song) + '/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/data/' + Paths.formatToSongPath(SONG.song) + '/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end
		
		var daSong:String = Paths.formatToSongPath(curSong);
		
		switch (daSong)
		{
			case 'moron' :
				gf.alpha = 0;
				skipCountdown = true;
				cameraLocked = true;
				Application.current.window.fullscreen = false;

				windowTitle = 'Wheatley Vs Jermey! Who will win!! rahh!!';
			case 'radar':
				gf.alpha = 0;
				windowTitle = 'aw fuckk naww boroo daddy dearest and gf be lookin for byofriend!! ahh!!';
				camZoomingDefault = false;

			case 'trans-wrongs':
				camBopAngle = false;
				skipCountdown = true;
				windowTitle = 'AHHH!!! RACISM!!!! ';
				CoolUtil.precacheSound('trans/fire', '420');
				CoolUtil.precacheSound('trans/ext', '420');

				fire = new FlxSprite().loadGraphic(Paths.image('trans/fire', '420'));
				fire.frames = Paths.getSparrowAtlas('trans/fire', '420');
				fire.animation.addByPrefix('kys', 'fire', 24, true);
				fire.antialiasing = false;
				fire.active = true;
				fire.scale.set(1.6,1.6);
				fire.setPosition(DAD_X + dad.x, DAD_Y + dad.y);
				fire.offset.set(100,200);
				
				fire.animation.play('kys');
			
				add(fire);
				auraBF.offset.set(870,200);
				// fire.alpha = 0.0001;
				fire.blend = ADD;

			default:
				windowTitle = 'Couldnt find funny flavor text! Current song: ' + songName;	
		}

		if (!seenCutscene)
		{
			switch (daSong)
			{
				case "monster":
					var whiteScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
					add(whiteScreen);
					whiteScreen.scrollFactor.set();
					whiteScreen.blend = ADD;
					camHUD.visible = false;
					snapCamFollowToPos(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					inCutscene = true;

					FlxTween.tween(whiteScreen, {alpha: 0}, 1, {
						startDelay: 0.1,
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							camHUD.visible = true;
							remove(whiteScreen);
							startCountdown();
						}
					});
					FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
					if(gf != null) gf.playAnim('scared', true);
					boyfriend.playAnim('scared', true);

				case "trans-wrongs":
					var blackScreen:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 1.1), Std.int(FlxG.height * 1.1), FlxColor.BLACK);
					
					add(blackScreen);

					var mankys:FlxSprite = new FlxSprite(BF_X + 50, BF_Y + 200).loadGraphic(Paths.image('trans/manshut', '420'));
					mankys.frames = Paths.getSparrowAtlas('trans/manshut', '420');
					mankys.animation.addByPrefix('kys', 'Loser', 24, false);
					mankys.antialiasing = false;
					// mankys.scrollFactor.set();
					mankys.active = true;
					mankys.scale.set(1.6,1.6);
					boyfriend.alpha = 0;
					// mankys.setPosition(boyfriend.getMidpoint().x,boyfriend.getMidpoint().y);
					
					addBehindDad(mankys);

					// blackScreen.scrollFactor.set();
					snapCamFollowToPos(gf.getMidpoint().x + 65, gf.getMidpoint().y + 10);
					FlxG.camera.zoom = 1.45;
					camHUD.zoom += 1.2;
					dad.angle = -40;
					dad.y += dad.height;

					inCutscene = true;
					new FlxTimer().start(1, function(tmr:FlxTimer) //DELAY BEFORE CUTSCENE STARTS!!
						{
		
							FlxTween.tween(blackScreen, {alpha: 0}, 0.2, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween) {
									remove(blackScreen);
								}
							});


							FlxTween.tween(dad, {angle: 0, y: dad.y - dad.height}, 2.1, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween) {
									
									dad.playAnim('singDOWN', true);
									dad.specialAnim = true;
									dad.heyTimer = 3;

									FlxG.sound.play(Paths.sound('cutscene/shutyourass', '420'));
									mankys.animation.play('kys');
								}
							});

							
							
							FlxG.camera.focusOn(camFollow);
							
							
							new FlxTimer().start(11.5, function(tmr:FlxTimer)
							{
								remove(blackScreen);
								remove(mankys);
								boyfriend.alpha = 1;
								FlxTween.tween(camHUD, {zoom: camHUD.zoom - 1.2}, 2.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
									ease: FlxEase.quadInOut,
									onComplete: function(twn:FlxTween)
									{
										startCountdown();
										
									}
								});
							});



						});


					
					//VIDEO INTRO SHIT



					//End Of Video Intro Shit
					
				default:
					startCountdown();
			}
			seenCutscene = true;
		}
		else
		{	
					startCountdown();	
		}
		RecalculateRating();

		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
		if(ClientPrefs.hitsoundVolume > 0) CoolUtil.precacheSound('hitsound');
		CoolUtil.precacheSound('missnote1');
		CoolUtil.precacheSound('missnote2');
		CoolUtil.precacheSound('missnote3');

		CoolUtil.precacheSound('auraGet');
		CoolUtil.precacheSound('auraLose');
		CoolUtil.precacheSound('taunt');
		if (PauseSubState.songName != null) {
			CoolUtil.precacheMusic(PauseSubState.songName);
		} else if(ClientPrefs.pauseMusic != 'None') {
			CoolUtil.precacheMusic(Paths.formatToSongPath(ClientPrefs.pauseMusic));
		}

		#if desktop
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}

		Conductor.safeZoneOffset = (ClientPrefs.safeFrames / 60) * 1000;
		callOnLuas('onCreatePost', []);
		
		super.create();

		Paths.clearUnusedMemory();
		CustomFadeTransition.nextCamera = camOther;
	}

	function set_songSpeed(value:Float):Float
	{
		if(generatedMusic)
		{
			var ratio:Float = value / songSpeed; //funny word huh
			for (note in notes)
			{
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					note.scale.y *= ratio;
					note.updateHitbox();
				}
			}
			for (note in unspawnNotes)
			{
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					note.scale.y *= ratio;
					note.updateHitbox();
				}
			}
		}
		songSpeed = value;
		noteKillOffset = 350 / songSpeed;
		return value;
	}

	public function addTextToDebug(text:String) {
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += 20;
		});

		if(luaDebugGroup.members.length > 34) {
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new DebugLuaText(text, luaDebugGroup));
		#end
	}

	public function reloadHealthBarColors() {
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
			
		healthBar.updateBar();
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					startCharacterLua(newBoyfriend.curCharacter);
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterLua(newDad.curCharacter);
				}

			case 2:
				if(gf != null && !gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					startCharacterLua(newGf.curCharacter);
				}
		}
	}

	function startCharacterLua(name:String)
	{
		#if LUA_ALLOWED
		var doPush:Bool = false;
		var luaFile:String = 'characters/' + name + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}
		
		if(doPush)
		{
			for (lua in luaArray)
			{
				if(lua.scriptName == luaFile) return;
			}
			luaArray.push(new FunkinLua(luaFile));
		}
		#end
	}
	
	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];

	}

	public function startVideo(name:String):Void {
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = #if MODS_ALLOWED Paths.modFolders('videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
		#if sys
		if(FileSystem.exists(fileName)) {
			foundFile = true;
		}
		#end

		if(!foundFile) {
			fileName = Paths.video(name);
			#if sys
			if(FileSystem.exists(fileName)) {
			#else
			if(OpenFlAssets.exists(fileName)) {
			#end
				foundFile = true;
			}
		}

		if(foundFile) {
			inCutscene = true;
			var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			bg.scrollFactor.set();
			bg.cameras = [camHUD];
			add(bg);

			(new FlxVideo(fileName)).finishCallback = function() {
				remove(bg);
				startAndEnd();
			}
			return;
		}
		else
		{
			FlxG.log.warn('Couldnt find video file: ' + fileName);
			startAndEnd();
		}
		#end
		startAndEnd();
	}

	function startAndEnd()
	{
		if(endingSong)
			endSong();
		else
			
						startCountdown();
	}

	var dialogueCount:Int = 0;
	public var psychDialogue:DialogueBoxPsych;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(psychDialogue != null) return;

		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			CoolUtil.precacheSound('dialogue');
			CoolUtil.precacheSound('dialogueClose');
			psychDialogue = new DialogueBoxPsych(dialogueFile, song);
			psychDialogue.scrollFactor.set();
			if(endingSong) {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					endSong();
				}
			} else {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					startCountdown();
				}
			}
			psychDialogue.nextDialogueThing = startNextDialogue;
			psychDialogue.skipDialogueThing = skipDialogue;
			psychDialogue.cameras = [camHUD];
			add(psychDialogue);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			if(endingSong) {
				endSong();
			} else {
				startCountdown();
			}
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += 300;

		var songName:String = Paths.formatToSongPath(SONG.song);
		if (songName == 'roses' || songName == 'thorns')
		{
			remove(black);

			if (songName == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (Paths.formatToSongPath(SONG.song) == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countdownTree:FlxSprite;
	public var countdownReady:FlxSprite;
	public var countdownSet:FlxSprite;
	public var countdownGo:FlxSprite;
	public static var startOnTime:Float = 0;

	public function startCountdown():Void
	{
		if(startedCountdown) {
			callOnLuas('onStartCountdown', []);
			return;
		}

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', []);
		if(ret != FunkinLua.Function_Stop) {
			if (skipCountdown || startOnTime > 0) skipArrowStartTween = true;

			generateStaticArrows(0);
			generateStaticArrows(1);
			for (i in 0...playerStrums.length) {
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
			}
			for (i in 0...opponentStrums.length) {
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				//if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
				if (ClientPrefs.middleScroll || SONG.stage.toLowerCase() == 'sexcity')
					opponentStrums.members[i].visible = false;
			}

			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 7.5;
			setOnLuas('startedCountdown', true);
			callOnLuas('onCountdownStarted', []);

			var swagCounter:Int = 0;

			if (skipCountdown || startOnTime > 0) {
				clearNotesBefore(startOnTime);
				setSongTime(startOnTime - 500);
				return;
			}
			
			startTimer = new FlxTimer().start(Conductor.crochet / 1000 , function(tmr:FlxTimer)
			{
				if (gf != null && tmr.loopsLeft % Math	.round(gfSpeed * gf.danceEveryNumBeats) == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
				{
					gf.dance();
				}
				if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
				{
					boyfriend.dance();
				}
				if (tmr.loopsLeft % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
				{
					dad.dance();
				}

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', 'set', 'go','tree']);
				introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);
				
				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				if(isPixelStage) {
					introAlts = introAssets.get('pixel');
					antialias = false;
				}
				// Hey! anyone snooping arund here! if I havent solved this already how do I get the intro assets to be apart of the gamehud camera?
				//Like I know its an array n shit but how would I get all the sprites in the array and set their cameras to gamehud besides manually doing it?
				// introAssets.cameras = [camHUD];

				switch (swagCounter)
				{
					case 0:
						countdownTree = new FlxSprite().loadGraphic(Paths.image(introAlts[3]));
						countdownTree.scrollFactor.set();
						countdownTree.updateHitbox();
						countdownTree.cameras = [camHUD];
						if (PlayState.isPixelStage)
							countdownTree.setGraphicSize(Std.int(countdownTree.width * daPixelZoom));

						countdownTree.screenCenter();
						countdownTree.antialiasing = antialias;
						add(countdownTree);
						FlxTween.tween(countdownTree, {y: countdownTree.y - 200, angle: countdownTree.angle - 20 }, Conductor.crochet / 500, {
							ease: FlxEase.cubeOut,
							onComplete: function(twn:FlxTween)
							{
								FlxTween.tween(countdownTree, {alpha: 0}, Conductor.crochet / 750, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
								remove(countdownTree);
								countdownTree.destroy();
									}
								});
							}
						});

						FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
					case 1:
						countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						countdownReady.scrollFactor.set();
						countdownReady.updateHitbox();
						countdownReady.cameras = [camHUD];
						if (PlayState.isPixelStage)
							countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));

						countdownReady.screenCenter();
						countdownReady.antialiasing = antialias;
						add(countdownReady);
						FlxTween.tween(countdownReady, {y: countdownReady.y + 200, angle: countdownReady.angle + 20}, Conductor.crochet / 500, {
							ease: FlxEase.cubeOut,
							onComplete: function(twn:FlxTween)
							{
								FlxTween.tween(countdownReady, {alpha: 0}, Conductor.crochet / 750, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
								remove(countdownReady);
								countdownReady.destroy();
									}
								});
									
							}
						});
						FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
					case 2:
						countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						countdownSet.scrollFactor.set();
						countdownSet.cameras = [camHUD];
						if (PlayState.isPixelStage)
							countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));

						countdownSet.screenCenter();
						countdownSet.antialiasing = antialias;
						add(countdownSet);
						FlxTween.tween(countdownSet, {x: countdownSet.x + 	330, angle: countdownSet.angle - 30}, Conductor.crochet / 500, {
							ease: FlxEase.cubeOut,
							onComplete: function(twn:FlxTween)
							{	
								FlxTween.tween(countdownSet, {alpha: 0}, Conductor.crochet / 750, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
								remove(countdownSet);
								countdownSet.destroy();
									}
								});
									
							}
						
						});
						FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
					case 3:
						countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						countdownGo.scrollFactor.set();
						countdownGo.cameras = [camHUD];
						if (PlayState.isPixelStage)
							countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));

						countdownGo.updateHitbox();

						countdownGo.screenCenter();
						countdownGo.antialiasing = antialias;
						add(countdownGo);
						FlxTween.tween(countdownGo, {x: countdownGo.x - 380, angle: countdownGo.angle + 30}, Conductor.crochet / 500, {
							ease: FlxEase.cubeOut,
							onComplete: function(twn:FlxTween)
							{
								FlxTween.tween(countdownGo, {alpha: 0}, Conductor.crochet / 750, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
								remove(countdownGo);
								countdownGo.destroy();
									}
								});
							}
						});
						FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
					case 4:
				}

				notes.forEachAlive(function(note:Note) {
					note.copyAlpha = false;
					note.alpha = note.multAlpha;
					if(ClientPrefs.middleScroll && !note.mustPress) {
						note.alpha *= 0.5;
					}
				});
				callOnLuas('onCountdownTick', [swagCounter]);

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	}

	public function addBehindGF(obj:FlxObject)
		{
			insert(members.indexOf(gfGroup), obj);
		}
		public function addBehindBF(obj:FlxObject)
		{
			insert(members.indexOf(boyfriendGroup), obj);
		}
		public function addBehindDad (obj:FlxObject)
		{
			insert(members.indexOf(dadGroup), obj);
		}

	public function clearNotesBefore(time:Float)
	{
		var i:Int = unspawnNotes.length - 1;
		while (i >= 0) {
			var daNote:Note = unspawnNotes[i];
			if(daNote.strumTime - 500 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				unspawnNotes.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notes.length - 1;
		while (i >= 0) {
			var daNote:Note = notes.members[i];
			if(daNote.strumTime - 500 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
	}

	public function setSongTime(time:Float)
	{
		if(time < 0) time = 0;

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.time = time;
		FlxG.sound.music.play();

		vocals.time = time;
		vocals.play();
		Conductor.songPosition = time;
	}

	function startNextDialogue() {
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue() {
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{	

		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = onSongComplete;
		vocals.play();

		if(startOnTime > 0)
		{
			setSongTime(startOnTime - 500);
		}
		startOnTime = 0;

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
		}
		new FlxTimer().start(.3, function(tmr:FlxTimer)
			{
				
				signTitle.animation.play('jump');
				
			});
		
		FlxTween.tween(sign, {y: -600}, 1, {ease: FlxEase.elasticOut});
		FlxTween.tween(signTitle, {y: -600}, 1.1,  {
			ease: FlxEase.elasticOut,
			onComplete: function(twn:FlxTween)
			{
				new FlxTimer().start(4, function(tmr:FlxTimer)
					{
						
						FlxTween.tween(sign, {y: -1100}, 2, {ease: FlxEase.elasticIn});
						FlxTween.tween(signTitle, {y: -1100}, 2.1,  {ease: FlxEase.elasticIn,			onComplete: function(twn:FlxTween)
							{
								sign.destroy();
								signTitle.destroy();
							}});
						
					});
			}
		});
		
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		FlxTween.tween(timeBar, {alpha: 1}, 1.1, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 1.1, {ease: FlxEase.circOut, startDelay: 1});
		
		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength);
		#end


		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();
	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
		songSpeedType = ClientPrefs.getGameplaySetting('scrolltype','multiplicative');

		switch(songSpeedType)
		{
			case "multiplicative":
				songSpeed = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1);
			case "constant":
				songSpeed = ClientPrefs.getGameplaySetting('scrollspeed', 1);
		}
		
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);
		
		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var songName:String = Paths.formatToSongPath(SONG.song);
		var file:String = Paths.json(songName + '/events');
		#if sys
		if (FileSystem.exists(Paths.modsJson(songName + '/events')) || FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var eventsData:Array<Dynamic> = Song.loadFromJson('events', songName).events;
			for (event in eventsData) //Event Notes
			{
				for (i in 0...event[1].length)
				{
					var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
					var subEvent:EventNote = {
						strumTime: newEventNote[0] + ClientPrefs.noteOffset,
						event: newEventNote[1],
						value1: newEventNote[2],
						value2: newEventNote[3]
					};
					subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
					eventNotes.push(subEvent);
					eventPushed(subEvent);
				}
			}
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.mustPress = gottaHitNote;
				swagNote.sustainLength = songNotes[2];
				swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
				swagNote.noteType = songNotes[3];
				if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
				
				swagNote.scrollFactor.set();

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				var floorSus:Int = Math.floor(susLength);
				if(floorSus > 0) {
					for (susNote in 0...floorSus+1)
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)), daNoteData, oldNote, true);
						sustainNote.mustPress = gottaHitNote;
						sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
						sustainNote.noteType = swagNote.noteType;
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);

						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
						else if(ClientPrefs.middleScroll)
						{
							sustainNote.x += 310;
							if(daNoteData > 1) //Up and Right
							{
								sustainNote.x += FlxG.width / 2 + 25;
							}
						}
					}
				}

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else if(ClientPrefs.middleScroll)
				{
					swagNote.x += 310;
					if(daNoteData > 1) //Up and Right
					{
						swagNote.x += FlxG.width / 2 + 25;
					}
				}

				if(!noteTypeMap.exists(swagNote.noteType)) {
					noteTypeMap.set(swagNote.noteType, true);
				}
			}
			daBeats += 1;
		}
		for (event in songData.events) //Event Notes
		{
			for (i in 0...event[1].length)
			{
				var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
				var subEvent:EventNote = {
					strumTime: newEventNote[0] + ClientPrefs.noteOffset,
					event: newEventNote[1],
					value1: newEventNote[2],
					value2: newEventNote[3]
				};
				subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
				eventNotes.push(subEvent);
				eventPushed(subEvent);
			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		checkEventNote();
		generatedMusic = true;
	}

	function eventPushed(event:EventNote) {
		switch(event.event) {
			case 'Change Character':
				var charType:Int = 0;
				switch(event.value1.toLowerCase()) {
					case 'gf' | 'girlfriend' | '1':
						charType = 2;
					case 'dad' | 'opponent' | '0':
						charType = 1;
					default:
						charType = Std.parseInt(event.value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event.value2;
				addCharacterToList(newCharacter, charType);
		}

		if(!eventPushedMap.exists(event.event)) {
			eventPushedMap.set(event.event, true);
		}
	}

	function eventNoteEarlyTrigger(event:EventNote):Float {
		var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event.event]);
		if(returnedValue != 0) {
			return returnedValue;
		}


		return 0;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:EventNote, Obj2:EventNote):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public var skipArrowStartTween:Bool = false; //for lua
	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var targetAlpha:Float = 1;
			if (player < 1 && ClientPrefs.middleScroll) targetAlpha = 0.35;

			var babyArrow:StrumNote = new StrumNote(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player);
			babyArrow.downScroll = ClientPrefs.downScroll;
			if (!isStoryMode && !skipArrowStartTween)
			{
				//babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {/*y: babyArrow.y + 10,*/ alpha: targetAlpha}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				babyArrow.alpha = targetAlpha;
			}

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				if(ClientPrefs.middleScroll)
				{
					babyArrow.x += 310;
					if(i > 1) { //Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
				}
				opponentStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;
			if (songSpeedTween != null)
				songSpeedTween.active = false;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = false;
				}
			}

			for (tween in modchartTweens) {
				tween.active = false;
			}
			for (timer in modchartTimers) {
				timer.active = false;
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{	
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}
			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;
			if (songSpeedTween != null)
				songSpeedTween.active = true;
			
			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = true;
				}
			}
			
			for (tween in modchartTweens) {
				tween.active = true;
			}
			for (timer in modchartTimers) {
				timer.active = true;
			}
			paused = false;
			callOnLuas('onResume', []);

			#if desktop
			if (startTimer != null && startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	public var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;


	override public function update(elapsed:Float)
	{
		

	//auraBF.x = boyfriend.getMidpoint().x;
	//auraBF.y = boyfriend.getMidpoint().y;
		/*if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
		}*/
		Application.current.window.title = windowTitle;

		
		callOnLuas('onUpdate', [elapsed]);


		
		floatshit2 += elapsed * 2.5;
		auraBF.alpha = Math.sin(floatshit2);
		
		switch (curStage)
		{
			case 'weedy':

				floatshit += elapsed;
				

				auraBF.x = boyfriend.getMidpoint().x;
				auraBF.y = boyfriend.getMidpoint().y;

					dad.y += Math.sin(floatshit * 4);
					dad.x = Math.sin(floatshit2) * 300 - (dad.width / 2);
					dad.x += 500;
					// dad.scale.x += Math.sin(floatshit - dad.width * 0.8);
					if ((Math.sin(floatshit2) >= 0.95 || Math.sin(floatshit2) <= -0.95) && !hasJunked){
						hasJunked = true;
					}
					if (hasJunked && !(Math.sin(floatshit2) >= 0.95 || Math.sin(floatshit2) <= -0.95)) hasJunked = false;
		
					dad.angle += Math.sin(floatshit * 5);
					boyfriend.y += Math.cos(floatshit * randshit * 1.6);
					boyfriend.x += Math.sin(floatshit * 2);
					boyfriend.angle += 1;
					gf.y += Math.sin(floatshit * 2);
					gf.x += Math.cos(floatshit * randshit);
					gf.angle += Math.sin(floatshit * 5);
			case 'sexcity':
			auraBF.x = boyfriend.getMidpoint().x;
			auraBF.y = boyfriend.getMidpoint().y;
		}

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 1.2 * cameraSpeed, 0, 1);
			if (!cameraLocked)
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			
			if(!startingSong && !endingSong && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
		}

		super.update(elapsed);



		

		if(ratingName == '?') {
			scoreTxt.text = 'Score: ' + songScore + ' | Fuck ups: ' + songMisses + ' | Rank: ' + ratingName;
		} else {
			scoreTxt.text = 'Score: ' + songScore + ' | Fuck ups: ' + songMisses + ' | Rank: ' + ratingName + ' (' + Highscore.floorDecimal(ratingPercent * 100, 2) + '%)' + ' - ' + ratingFC;//peeps wanted no integer rating
		}

		if(botplayTxt.visible) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}
		if (windowed)
			{
				var screenwidth = Application.current.window.display.bounds.width;
				var screenheight = Application.current.window.display.bounds.height;
				Application.current.window.width = 1280;
				Application.current.window.height = 720;
			}
		if (controls.PAUSE && startedCountdown && canPause)
		{
			var ret:Dynamic = callOnLuas('onPause', []);
			if(ret != FunkinLua.Function_Stop) {
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				// 1 / 1000 chance for Gitaroo Man easter egg
				/*if (FlxG.random.bool(0.1))
				{
					// gitaroo man easter egg
					cancelMusicFadeTween();
					MusicBeatState.switchState(new GitarooPause());
				}
				else {*/
				if(FlxG.sound.music != null) {
					FlxG.sound.music.pause();
					vocals.pause();
				}
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				//}
		
				#if desktop
				DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
				Application.current.window.title = 'The little bitchboy has paused the game! hurrah!';
			}
		}

		if (FlxG.keys.anyJustPressed(debugKeysChart) && !endingSong && !inCutscene)
		{
			openChartEditor();
			Application.current.window.title = 'THIS DUDE IN THE CHART EDITOR TOO??? CHILL?';
		}

		if (FlxG.keys.pressed.C && !boyfriend.animation.curAnim.name.endsWith('hey') && boyfriend.animation.getByName('hey') != null)
			{
				boyfriend.playAnim('hey', true);
				boyfriend.specialAnim = true;
				boyfriend.heyTimer = 0.4;
				FlxG.sound.play(Paths.sound('taunt'));
			}
			
		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);  
		iconP1.centerOffsets();
		iconP2.centerOffsets();
	  
		iconP1.updateHitbox();
		iconP2.updateHitbox();
	  
		var iconOffset:Int = 26;
	  
		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset) - 3.2;
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset) - 3.2;
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		// var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		// iconP1.scale.set(mult, mult);
		// iconP1.updateHitbox();

		// var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		// iconP2.scale.set(mult, mult);
		// iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset - 3.2;
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2 - 3.2 ;

		if (health > 2)
			health = 2;

		// var healthShit = healthBar.percent;
		// switch(true)
		// {
		// 	case  healthShit < 35:
		// 		iconP1.animation.curAnim.curFrame = 1;

		// 	case healthShit > 65:
		// 		iconP1.animation.curAnim.curFrame = 1;

		// 	case healthShit > 75:
		// 		iconP2.animation.curAnim.curFrame = 1;
		// 		clankynite = (.23);
		// 		clankyniteP2 = (.03);

		// 	case healthShit < 37:
		// 		iconP2.animation.curAnim.curFrame = 2;
		// 		clankyniteP2 = (.23);

		// 	default:
		// 		iconP1.animation.curAnim.curFrame = 0;	
		// 		clankynite = (0.09);
		// 		clankyniteP2 = (0.09);
		// }



	//Whoops! April 25th 12:18 AM! Cant figure out how to use swithc statements for this... Hopefully it doesnt affect performance TOO much oh well




			//if (healthBar.percent > 60)	
					//health -= 0.0001;

		if (FlxG.keys.anyJustPressed(debugKeysCharacter) && !endingSong && !inCutscene) {
			persistentUpdate = false;
			paused = true;
			cancelMusicFadeTween();
			MusicBeatState.switchState(new CharacterEditorState(SONG.player2));
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime) {
					var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);
					if(ClientPrefs.timeBarType == 'Time Elapsed') songCalc = curTime;

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					if(ClientPrefs.timeBarType != 'Song Name')
						timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming && !cameraLocked)
			{
				
				FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom + extraZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
				if (camBopAngle)
				camGame.angle = FlxMath.lerp(defaultCamAngle, camGame.angle, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
				
				if (camebopHud)
				camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
				
				
				
			}

			camFollowPos.angle += 15;

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		// RESET = Quick Game Over Screen
		if (!ClientPrefs.noReset && controls.RESET && !inCutscene && !endingSong)
		{
			health = 0;
			trace("RESET = True");
			windowed = false;
			if (windowDad != null)
				{
					windowDad.close();
				}
		}
		doDeathCheck();

		if (tranceActive)
			{
				var convertedTime:Float = ((Conductor.songPosition / (Conductor.crochet * beatInterval)) * Math.PI);
				var faggot:Float = SONG.bpm / 180;
				if (remote.animation.curAnim != null)
				remote.animation.curAnim.frameRate = 24 / faggot;
				 
				// pendulum.screenCenter();
				// /*
				var pendulumTimeframe = Math.floor(((convertedTime / Math.PI) - Math.floor(convertedTime / Math.PI)) * 1000) / 1000;
				var reach:Float = 0.2;
				if (!tranceNotActiveYet)
				{
					if (pendulumTimeframe < reach || pendulumTimeframe > (1 - reach))
					{
						if (!alreadyHit)
							canHitPendulum = true;
					}
					else
					{
						alreadyHit = false;
						if (canHitPendulum)
						{
							if (tranceInterval % 2 == 0 )
								{	
									//trace('uhm you gotta press the button dude?');
									if (!remote.animation.curAnim.name.startsWith('goodBop'))
									remote.animation.play('idle');
									if (remoteAlphaTween == null)
										{
											remoteAlphaTween = FlxTween.tween(remote, {alpha: 0.7, "scale.x": 0.63, "scale.y": 0.63},  .75, {ease: FlxEase.quadOut, onComplete:
												function (twn:FlxTween)
												{
													remoteAlphaTween = null;
												}
											});
											// remoteScaleTween = FlxTween.tween(remote.scale, {x: 0.63, y: 0.63}, .75, {ease: FlxEase.quadOut, onComplete:
											// 	function (twn:FlxTween)
											// 	{
											// 		remoteScaleTween = null;
											// 	}
											// });
										}
								}

							tranceInterval++;
							canHitPendulum = false;
						}
					}
					
					// /*

					if (FlxG.keys.justPressed.SPACE)
					{	
						if (remote.animation.curAnim != null)
							remote.animation.curAnim.stop();
						if (canHitPendulum)
						{
							canHitPendulum = false;
							alreadyHit = true;
							

							remote.animation.play('goodBop');
							FlxG.sound.play(Paths.sound('radar/Radar', '420'), ClientPrefs.radarVolume);
						}
						else
							{	


								remote.animation.play('badBop');
								
								
								FlxG.sound.play(Paths.sound('radar/BadRadar', '420'), ClientPrefs.radarVolume);
								//


							}
							if (remoteAlphaTween != null)
								{
									// remoteScaleTween.cancel();
									remoteAlphaTween.cancel();
								}

								remoteAlphaTween = FlxTween.tween(remote, {alpha: 1, "scale.x": 0.8, "scale.y": 0.8}, .4 , {ease: FlxEase.quadOut, onComplete:
									function (twn:FlxTween)
									{
										remoteAlphaTween = null;
									}

								});
								// remoteScaleTween = FlxTween.tween(remote.scale, {x: 0.8, y: 0.8}, .6, {ease: FlxEase.quadOut, onComplete:
								// 	function (twn:FlxTween)
								// 	{
								// 		remoteScaleTween = null;
								// 	}
								// });



					}
				}
			}


		if (unspawnNotes[0] != null)
		{
			var time:Float = 3000;//shit be werid on 4:3
			if(songSpeed < 1) time /= songSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			if (!inCutscene) {


				if(!cpuControlled) {
					keyShit();
				} else if(boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')) {
					boyfriend.dance();
					//boyfriend.animation.curAnim.finish();
				}
			}

			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
				if(!daNote.mustPress) strumGroup = opponentStrums;

				if (!daNote.mustPress && (ClientPrefs.middleScroll || windowed || SONG.stage.toLowerCase() == 'sexcity'))
					{
						daNote.active = true;
						daNote.visible = false;
					}
					else if (daNote.y > FlxG.height)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}

				var strumX:Float = strumGroup.members[daNote.noteData].x;
				var strumY:Float = strumGroup.members[daNote.noteData].y;
				var strumAngle:Float = strumGroup.members[daNote.noteData].angle;
				var strumDirection:Float = strumGroup.members[daNote.noteData].direction;
				var strumAlpha:Float = strumGroup.members[daNote.noteData].alpha;
				var strumScroll:Bool = strumGroup.members[daNote.noteData].downScroll;

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				strumAngle += daNote.offsetAngle;
				strumAlpha *= daNote.multAlpha;

				if (strumScroll) //Downscroll
				{
					//daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
					daNote.distance = (0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
				}
				else //Upscroll
				{
					//daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
					daNote.distance = (-0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
				}

				var angleDir = strumDirection * Math.PI / 180;
				if (daNote.copyAngle)
					daNote.angle = strumDirection - 90 + strumAngle;

				if(daNote.copyAlpha)
					daNote.alpha = strumAlpha;
				
				if(daNote.copyX)
					daNote.x = strumX + Math.cos(angleDir) * daNote.distance;

				if(daNote.copyY)
				{
					daNote.y = strumY + Math.sin(angleDir) * daNote.distance;

					//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
					if(strumScroll && daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith('end')) {
							daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * songSpeed + (46 * (songSpeed - 1));
							daNote.y -= 46 * (1 - (fakeCrochet / 600)) * songSpeed;
							if(PlayState.isPixelStage) {
								daNote.y += 8 + (6 - daNote.originalHeightForCalcs) * PlayState.daPixelZoom;
							} else {
								daNote.y -= 19;
							}
						} 
						daNote.y += (Note.swagWidth / 2) - (60.5 * (songSpeed - 1));
						daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (songSpeed - 1);
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
				{
					opponentNoteHit(daNote);
					if (healthBar.percent > 75)
						health -= 0.008 * healthLoss;
					if (daNote.visible)
						{
							spawnNoteSplashOnNoteDAD(daNote);
						}
					
				}

				if(daNote.mustPress && cpuControlled) {
					if(daNote.isSustainNote) {
						if(daNote.canBeHit) {
							goodNoteHit(daNote);

						}
					} else if(daNote.strumTime <= Conductor.songPosition || (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress)) {
						goodNoteHit(daNote);
						
					}
				}
				
				var center:Float = strumY + Note.swagWidth / 2;
				if(strumGroup.members[daNote.noteData].sustainReduce && daNote.isSustainNote && (daNote.mustPress || !daNote.ignoreNote) &&
					(!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					if (strumScroll)
					{
						if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.height = (center - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;

							daNote.clipRect = swagRect;
						}
					}
					else
					{
						if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
							swagRect.y = (center - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;

							daNote.clipRect = swagRect;
						}
					}
				}

				// Kill extremely late notes and cause misses
				if (Conductor.songPosition > noteKillOffset + daNote.strumTime)
				{
					if (daNote.mustPress && !cpuControlled &&!daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
						noteMiss(daNote);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
		checkEventNote();
		
		#if debug
		if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE) {
				KillNotes();
				FlxG.sound.music.onComplete();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				setSongTime(Conductor.songPosition + 10000);
				clearNotesBefore(Conductor.songPosition);
			}
		}
		#end

		#if windows
		if (curbg != null)
		{
			if (curbg.active) 
			{
				var shad = cast(curbg.shader, Shaders.GlitchShader);
				shad.uTime.value[0] += elapsed;
			}
		}
		#end
		
		setOnLuas('cameraX', camFollowPos.x);
		setOnLuas('cameraY', camFollowPos.y);
		setOnLuas('botPlay', cpuControlled);
		callOnLuas('onUpdatePost', [elapsed]);

		@:privateAccess
        var dadFrame = dad._frame;
        
        if (dadFrame == null || dadFrame.frame == null) return; // prevents crashes (i think???)
            
        var rect = new Rectangle(dadFrame.frame.x, dadFrame.frame.y, dadFrame.frame.width, dadFrame.frame.height);
        
        dadScrollWin.scrollRect = rect;
        dadScrollWin.x = (((dadFrame.offset.x) - (dad.offset.x / 2)) * dadScrollWin.scaleX);
        dadScrollWin.y = (((dadFrame.offset.y) - (dad.offset.y / 2)) * dadScrollWin.scaleY);    
	}
	function camAngler()
		{
			
		if (camAngled)
		{
			camAngled = false;
			camGame.angle += 2 * camBopIntensity;

		}
	
	else
		{
			camAngled = true;
			camGame.angle += 2 * camBopIntensity * -1;

		}
		
	}



	function popupWindow(customWidth:Int, customHeight:Int, ?customX:Int, ?customName:String) {
		
		
        var display = Application.current.window.display.currentMode;
        // PlayState.defaultCamZoom = 0.5;

		if(customName == '' || customName == null){
			customName = 'Opponent.json';
		}



        windowDad = Lib.application.createWindow({
            title: customName,
            width: customWidth,
            height: customHeight,
            borderless: true,
            alwaysOnTop: true

        });
		if(customX == null){
			customX = -10;
		}
        windowDad.x = customX;
	    	windowDad.y = 800;
        windowDad.stage.color = 0xFF010101;
        @:privateAccess
        windowDad.stage.addEventListener("keyDown", FlxG.keys.onKeyDown);
        @:privateAccess
        windowDad.stage.addEventListener("keyUp", FlxG.keys.onKeyUp);

		FlxTransWindow.getWindowsTransparent();
        // Application.current.window.x = Std.int(display.width / 2) - 640;
        // Application.current.window.y = Std.int(display.height / 2);

        // var bg = Paths.image(PUT YOUR IMAGE HERE!!!!).bitmap;
        // var spr = new Sprite();
		// var transgenderBg:FlxSprite = new FlxSprite().makegraphic(FlxG.width,FlxG.height, FlxColor.fromRBG(1,1,1));

        var m = new Matrix();

        // spr.graphics.beginBitmapFill(bg, m);
        // spr.graphics.drawRect(0, 0, bg.width, bg.height);
        // spr.graphics.endFill();
        FlxG.mouse.useSystemCursor = true;

        //Application.current.window.resize(640, 480);



        dadWin.graphics.beginBitmapFill(dad.pixels, m);
        dadWin.graphics.drawRect(0, 0, dad.pixels.width, dad.pixels.height);
        dadWin.graphics.endFill();
        dadScrollWin.scrollRect = new Rectangle();
	// windowDad.stage.addChild(spr);
        windowDad.stage.addChild(dadScrollWin);
        dadScrollWin.addChild(dadWin);
        dadScrollWin.scaleX = 0.8;
        dadScrollWin.scaleY = 0.8;
        dadGroup.visible = false;
        // uncomment the line above if you want it to hide the dad ingame and make it visible via the windoe
		
		windowed = true;

		FlxTween.tween(windowDad, {x: -20}, 3, {ease: FlxEase.elasticOut});
		FlxTween.tween(windowDad, {y: Std.int(display.height / 2)}, 2.2, {ease: FlxEase.elasticOut});
		for (i in 0...opponentStrums.length) {
			setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
			setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
			//if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
			
				opponentStrums.members[i].visible = false;
		}
        Application.current.window.focus();
	    	FlxG.autoPause = false;
			Application.current.window.onClose.add(function()
				{
					FlxG.autoPause = true;
						windowDad.close();
						
				}, false, 100);

    }
	function fuckThatWindow() {
		if (windowDad != null)
			{
				windowDad.close();
			}
		

		windowed = false;
		FlxG.autoPause = true;
		for (i in 0...opponentStrums.length) {
			// setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
			// setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
			//if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
			
				opponentStrums.members[i].visible = true;
		}
    }

	function switchChar(value1:String,value2:String)
		{
				var charType:Int = 0;
				switch(value1) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(value2);
							boyfriend.alpha = lastAlpha;
							iconP1.changeIcon(boyfriend.healthIcon);
						}
						setOnLuas('boyfriendName', boyfriend.curCharacter);

					case 1:
						if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							dad.alpha = lastAlpha;
							iconP2.changeIcon(dad.healthIcon);
						}
						setOnLuas('dadName', dad.curCharacter);

					case 2:
						if(gf != null)
						{
							if(gf.curCharacter != value2)
							{
								if(!gfMap.exists(value2))
								{
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(value2);
								gf.alpha = lastAlpha;
							}
							setOnLuas('gfName', gf.curCharacter);
						}
				}
				reloadHealthBarColors();
			
			}
			

	function radarCharBounce(fuck:Bool,ye:Float)
		//hey! 0.6 is the time for a BPM of 105! not sure how itll work on other bpms but thats for me to find out
		//-78.5 is default y val!
		{//bfYpre
			// trace('dadypre = ' + dadYpre);
			// trace('dad.y = ' + dad.y);
			// trace('DAD_Y = ' + DAD_Y);

			// trace('bfypre = ' + bfYpre);
			// trace('bf.y = ' + boyfriend.y);
			// trace('BF_Y = ' + BF_Y);
			if (gfTween != null && dadTween != null)
				{
					dadTween.cancel();
					gfTween.cancel();
				}
				var faggot:Float = SONG.bpm / 105;
			if (!fuck)
				{	
					boyfriend.y = bfYpre;
					dad.y = dadYpre;
					gfTween = FlxTween.tween(boyfriend, {y: /*bfYpre - 78.5 */ (ye) }, 0.6 / faggot, {ease: FlxEase.quadOut});
					dadTween = FlxTween.tween(dad, {y:                     121.5 }, 0.6 / faggot, {ease: FlxEase.quadOut});


				}
								//something htat always occurs when the first beats hit				
				else
					{


						gfTween = FlxTween.tween(boyfriend, {y: bfYpre }, 0.6 / faggot, {ease: FlxEase.quadIn});
						dadTween = FlxTween.tween(dad, {y: dadYpre}, 0.6 / faggot, {ease: FlxEase.quadIn});

					}
							

								//something htat always occurs when the second beats hit

							
		}

	function openChartEditor()
	{
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		MusicBeatState.switchState(new ChartingState());
		chartingMode = true;

		#if desktop
		DiscordClient.changePresence("Chart Editor", null, null, true);
		#end
	}

	public var isDead:Bool = false; //Don't mess with this on Lua!!!
	function doDeathCheck(?skipHealthCheck:Bool = false) {
		if (((skipHealthCheck && instakillOnMiss) || health <= 0) && !practiceMode && !isDead)
		{
			var ret:Dynamic = callOnLuas('onGameOver', []);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;
				deathCounter++;

				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				persistentUpdate = false;
				persistentDraw = false;
				for (tween in modchartTweens) {
					tween.active = true;
				}
				for (timer in modchartTimers) {
					timer.active = true;
				}
				if (windowDad != null)
					{
						windowDad.close();
					}
				FlxG.autoPause = true;
				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1], camFollowPos.x, camFollowPos.y));

				// MusicBeatState.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				
				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var leStrumTime:Float = eventNotes[0].strumTime;
			if(Conductor.songPosition < leStrumTime) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0].value1 != null)
				value1 = eventNotes[0].value1;

			var value2:String = '';
			if(eventNotes[0].value2 != null)
				value2 = eventNotes[0].value2;

			triggerEventNote(eventNotes[0].event, value1, value2);
			eventNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	

	
	public function triggerEventNote(eventName:String, value1:String, value2:String) {
		switch(eventName) {
			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					} else if (gf != null) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}

				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value) || value < 1) value = 1;
				gfSpeed = value;

			case 'Add Camera Zoom':
				if(ClientPrefs.camZooms && FlxG.camera.zoom < 1.35) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
				}
			case 'Trans Zoom':
				var camZoom:Float = Std.parseFloat(value1);
				if(Math.isNaN(camZoom)) camZoom = 2;
				camZooming = false;

				// fire.setPosition(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1]);
				
				// fire.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
				fire.setPosition(DAD_X + dad.x, DAD_Y + dad.y);
				if (value2 == 'no')
					{
						


						FlxTween.tween(camGame, {zoom: camZoom}, 0.3, {ease: FlxEase.cubeIn, onComplete:
							function (twn:FlxTween)
							{	

								FlxTween.tween(camGame, {zoom: defaultCamZoom,angle: -15}, 0.5, {ease: FlxEase.backOut, onComplete:
									function (twn:FlxTween)
									{	


										
										
										camHUD.flash(0xFFFF4D00, 0.2, null, true);
										switchChar('dad','miraFire');
										fire.alpha = 1;
										FlxG.sound.play(Paths.sound('trans/fire', '420'));
										camZooming = camZoomingDefault;
										camebopHud = true;
										camBopInterval = 1;
										camBopIntensity = 4;
									}
								});
							}
						});
						FlxTween.tween(camHUD, {angle: -15 * .4}, 0.4, {ease: FlxEase.elasticInOut});
					}
					else if (value2 == 'yes')
						{
						FlxTween.tween(camGame, {zoom: camZoom}, 0.3, {ease: FlxEase.cubeIn, onComplete:
								function (twn:FlxTween)
								{
									FlxTween.tween(camGame, {zoom: defaultCamZoom,angle: 0}, 0.45, {ease: FlxEase.backOut, onComplete:
										function (twn:FlxTween)
										{	
											camHUD.flash(0xFFAFAFAF, 0.3, null, true);
											switchChar('dad','mira');
											fire.alpha = 0.00001;
											FlxG.sound.play(Paths.sound('trans/ext', '420'));
											camZooming = camZoomingDefault;
											camebopHud = false;
											camBopInterval = 4;
											camBopIntensity = 1;

										}
									});
								}
							});
							FlxTween.tween(camHUD, {angle: 0}, 0.65, {ease: FlxEase.elasticInOut});
						}
						else if (value2 == 'no2')
							{
								FlxTween.tween(camHUD, {angle: 15 * .4}, 0.3, {ease: FlxEase.elasticInOut});
							FlxTween.tween(camGame, {zoom: camZoom}, 0.3, {ease: FlxEase.cubeIn, onComplete:
								function (twn:FlxTween)
								{	
									
									FlxTween.tween(camGame, {zoom: defaultCamZoom,angle: 15}, 0.45, {ease: FlxEase.backOut, onComplete:
										function (twn:FlxTween)
										{	
											camHUD.flash(0xFFFF4D00, 0.18, null, true);
											
											switchChar('dad','miraFire');
											fire.alpha = 1;
											FlxG.sound.play(Paths.sound('trans/fire', '420'));
											camZooming = camZoomingDefault;
											camebopHud = true;
											camBopInterval = 1;
											camBopIntensity = 5;
										}
									});
									
								}
							});
						}


				case 'HUD Fade':
					var charType:Int = Std.parseInt(value1);
					var val2:Float = Std.parseFloat(value2);
					if (Math.isNaN(charType))
						charType = 0;
					if(Math.isNaN(val2)) val2 = 0;

					switch (charType)
					{
						case 0:

								FlxTween.tween(camHUD, {alpha: 1}, val2, {ease: FlxEase.quadInOut});
						case 1:

							FlxTween.tween(camHUD, {alpha: 0}, val2, {ease: FlxEase.quadInOut});
					}

					case 'Renderproc cutscene':

						if (value1 == 'start')
							{
								camHUD.visible = false;
								fuckyoulaz.alpha = 1;
								boyfriendGroup.visible = false;
								dadGroup.visible = false;
								auraBF.x = 1000000;
							}
							else if (value1 == 'start2')
								{
									process.alpha = 1;
									fuckyoulaz.alpha = 0;
									
								}
								else if (value1 == 'start3')
									{	
										boyfriendGroup.visible = false;
										dadGroup.visible = false;
										FlxTween.tween(fuckyoulaz, {alpha: 0}, 0.8, {ease: FlxEase.quadOut});
									}
						if (value2 == 'talk')
							{
								process.animation.play('talk');
								process.alpha = 1;
								trace(value2);
							}
							else if (value2 == 'idle')
								{
									process.animation.play('idle');
									process.alpha = 1;
									trace(value2);
								}
								else if (value2 == 'blep')
									{
										process.animation.play('blep');
										process.alpha = 1;
										FlxG.sound.play(Paths.sound('moron/squeak', '420'));
										trace(value2);
										windowTitle = 'Blep';
									}
									else if (value2 == 'enter')
										{
											process.animation.play('enter');
											process.alpha = 1;
											trace(value2);
											windowTitle = 'Me! I win!!';
										}
						

						
					case 'Aura mult':
						var val1:Float = Std.parseFloat(value1);
						if(Math.isNaN(val1)) val1 = 1.2;
						auraMult = val1;

						if (value2 == 'bye')
							{
								if (ClientPrefs.auraMech == 'Default')
								canauraMult = false;
								trace(canauraMult);
							}
							else
							{
								if (ClientPrefs.auraMech == 'Default')
									canauraMult = true;
									trace(canauraMult);
							}

					case 'DAD WINDOW':
						if (value1 == 'go')
							{
								popupWindow(700, 830, 0, 'Moron.exe');
							}
							else if (value1 == 'close')
							{
								fuckThatWindow();
								
							}
							if (value2 == 'showdad')
								{
									dadGroup.visible = true;
								}
								else if (value2 == 'nodad')
									{
										dadGroup.visible = false;
									}



				case 'Cam lock':
					if (value1 == 'in')
					{
						defaultCamZoom = 1.2;
						camGame.camera.zoom = 1.2	;
						cameraLocked = true;
						if (value2 == 'dad')
						{
							camFollowPos.setPosition(dad.getMidpoint().x, dad.getMidpoint().y);
							FlxG.camera.focusOn(camFollowPos.getPosition());
						}
						else if (value2 == 'nobod')
							{
								//do nuthin! just zoom in lmao!
							}
							else
						{
							camFollowPos.setPosition(boyfriend.getMidpoint().x, boyfriend.getMidpoint().y);
							FlxG.camera.focusOn(camFollowPos.getPosition());	
						}
					}
					else
					{
						cameraLocked = true;
						defaultCamZoom = 0.7;
						FlxG.camera.zoom = 0.7;
						camFollowPos.setPosition(gf.getMidpoint().x - 25, gf.getMidpoint().y);
						FlxG.camera.focusOn(camFollowPos.getPosition());
					}


			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;

						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}

			case 'Camera Follow Pos':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 0;
				if(Math.isNaN(val2)) val2 = 0;

				isCameraOnForcedPos = false;
				if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
					camFollow.x = val1;
					camFollow.y = val2;
					isCameraOnForcedPos = true;
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = 0;
					var intensity:Float = 0;
					if(split[0] != null) duration = Std.parseFloat(split[0].trim());
					if(split[1] != null) intensity = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}


			case 'Change Character':
				var charType:Int = 0;
				switch(value1) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(value2);
							boyfriend.alpha = lastAlpha;
							iconP1.changeIcon(boyfriend.healthIcon);
						}
						setOnLuas('boyfriendName', boyfriend.curCharacter);

					case 1:
						if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							dad.alpha = lastAlpha;
							iconP2.changeIcon(dad.healthIcon);
						}
						setOnLuas('dadName', dad.curCharacter);

					case 2:
						if(gf != null)
						{
							if(gf.curCharacter != value2)
							{
								if(!gfMap.exists(value2))
								{
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(value2);
								gf.alpha = lastAlpha;
							}
							setOnLuas('gfName', gf.curCharacter);
						}
				}
				reloadHealthBarColors();
			

			
			case 'Change Scroll Speed':
				if (songSpeedType == "constant")
					return;
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 1;
				if(Math.isNaN(val2)) val2 = 0;

				var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * val1;

				if(val2 <= 0)
				{
					songSpeed = newValue;
				}
				else
				{
					songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, val2, {ease: FlxEase.linear, onComplete:
						function (twn:FlxTween)
						{
							songSpeedTween = null;
						}
					});
				}
		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	function moveCameraSection(?id:Int = 0):Void {
		if(SONG.notes[id] == null) return;

		if (gf != null && SONG.notes[id].gfSection)
		{
			camFollow.set(gf.getMidpoint().x, gf.getMidpoint().y);
			camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
			camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
			tweenCamIn();
			callOnLuas('onMoveCamera', ['gf']);
			return;
		}

		if (!SONG.notes[id].mustHitSection)
		{
			moveCamera(true);
			callOnLuas('onMoveCamera', ['dad']);

		}
		else
		{
			moveCamera(false);
			callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	var cameraTwn:FlxTween;
	var sexed:Bool = false;
		
	var zoomEl:Float = 1.3;
	public function moveCamera(isDad:Bool)
	{
		if(isDad)
		{
			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];

					tweenCamIn();
	
			gf.idleSuffix = '-alt';

		// 	if (healthBar.percent > 65)
		// 		{
		// 			if (canauraMult)
		// 				{
		// 					trace(auraMult);
		// 					//songSpeed = SONG.speed * auraMult;

		// 					var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * auraMult;
		// 					songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, 1, {ease: FlxEase.linear, onComplete:
		// 						function (twn:FlxTween)
		// 						{
		// 							songSpeedTween = null;
		// 						}
		// 					});
		// 		}
		// 		else if (healthBar.percent < 65)
		// 			{
						
		// 				songSpeedTween = FlxTween.tween(this, {songSpeed: SONG.speed}, .8, {ease: FlxEase.linear, onComplete:
		// 					function (twn:FlxTween)
		// 					{
		// 						songSpeedTween = null;
		// 					}
		// 				});
		// 			}
		// }
		// 		else if (healthBar.percent < 65)
		// 			{
		// 				songSpeed = SONG.speed;
		// 			}
		}
		else
		{
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
			camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];

			gf.idleSuffix = '';
			sexed = false;
			if (Paths.formatToSongPath(SONG.song) == 'radar' && cameraTwn == null && FlxG.camera.zoom != 1)
			{
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 0.65}, (Conductor.stepCrochet * 4 / 980), {ease: FlxEase.quadInOut, onComplete:
					function (twn:FlxTween)
					{
						cameraTwn = null;
					}
				});
			}
		}
	}

	function tweenCamIn() {
		if (Paths.formatToSongPath(SONG.song) == 'radar' && cameraTwn == null && FlxG.camera.zoom != 1.3) {
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 980), {ease: FlxEase.backInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	//Any way to do this without using a different function? kinda dumb
	private function onSongComplete()
	{
		finishSong(false);
	}
	public function finishSong(?ignoreNoteOffset:Bool = false):Void
	{
		var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.pause();
		if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
			finishCallback();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
				finishCallback();
			});
		}
	}


	public var transitioning = false;
	public function endSong():Void
	{
		//Should kill you if you tried to cheat
		if(!startingSong) {
			notes.forEach(function(daNote:Note) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			});
			for (daNote in unspawnNotes) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			}

			if(doDeathCheck()) {
				return;
			}
		}
		
		timeBarBG.visible = false;
		timeBar.visible = false;
		timeTxt.visible = false;
		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		deathCounter = 0;
		seenCutscene = false;

		
		#if LUA_ALLOWED
		var ret:Dynamic = callOnLuas('onEndSong', []);
		#else
		var ret:Dynamic = FunkinLua.Function_Continue;
		#end

		if(ret != FunkinLua.Function_Stop && !transitioning) {
			if (SONG.validScore)
			{
				#if !switch
				var percent:Float = ratingPercent;
				if(Math.isNaN(percent)) percent = 0;
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent);
				#end
			}

			if (chartingMode)
			{
				openChartEditor();
				return;
			}

			if (isStoryMode)
			{
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					cancelMusicFadeTween();
					if(FlxTransitionableState.skipNextTransIn) {
						CustomFadeTransition.nextCamera = null;
					}
					MusicBeatState.switchState(new StoryMenuState());
					if (windowDad != null)
						{
							windowDad.close();
						}
					FlxG.autoPause = true;
					// if ()
					if(!ClientPrefs.getGameplaySetting('practice', false) && !ClientPrefs.getGameplaySetting('botplay', false)) {
						StoryMenuState.weekCompleted.set(WeekData.weeksList[storyWeek], true);

						if (SONG.validScore)
						{
							Highscore.saveWeekScore(WeekData.getWeekFileName(), campaignScore, storyDifficulty);
						}

						FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted;
						FlxG.save.flush();
					}
					changedDifficulty = false;
				}
				else
				{
					var difficulty:String = CoolUtil.getDifficultyFilePath();

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					var winterHorrorlandNext = (Paths.formatToSongPath(SONG.song) == "eggnog");
					if (winterHorrorlandNext)
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if(winterHorrorlandNext) {
						new FlxTimer().start(1.5, function(tmr:FlxTimer) {
							cancelMusicFadeTween();
							LoadingState.loadAndSwitchState(new PlayState());
						});
					} else {
						cancelMusicFadeTween();
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				if (windowDad != null)
					{
						windowDad.close();
					}
				FlxG.autoPause = true;
				cancelMusicFadeTween();
				if(FlxTransitionableState.skipNextTransIn) {
					CustomFadeTransition.nextCamera = null;
				}
				MusicBeatState.switchState(new FreeplayState());

				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				changedDifficulty = false;
			}
			transitioning = true;
		}
	}



	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	public var totalPlayed:Int = 0;
	public var totalNotesHit:Float = 0.0;

	public var showCombo:Bool = true;
	public var showRating:Bool = true;
	public var rating:FlxSprite = new FlxSprite();
	
	//true is up and false is down
	public var scoreTween:FlxTween;
	public var scoreAppear:FlxTween;
	private function popUpScore(note:Note = null, isHold:Bool = false):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
		//trace(noteDiff, ' ' + Math.abs(note.strumTime - Conductor.songPosition));
		var daRating:String;
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;
		var shitter:Int = 70;
		var aftershit:Int = 30;
		//

		
		
		var score:Int = 350;

		//tryna do MS based judgment due to popular demand
		if (!isHold)
			{
				daRating = Conductor.judgeNote(note, noteDiff);
				shitter = 70;
			}

		else
			{
				daRating =  'hold';
				shitter = 18;
			}



		trace(daRating);

		switch (daRating)
		{
			case "shit": // shit
				totalNotesHit += 0;
				note.ratingMod = 0;
				score = 50;
				if(!note.ratingDisabled) shits++;
			case "bad": // bad
				totalNotesHit += 0.5;
				note.ratingMod = 0.5;
				score = 100;
				if(!note.ratingDisabled) bads++;
			case "good": // good
				totalNotesHit += 0.75;
				note.ratingMod = 0.75;
				score = 200;
				if(!note.ratingDisabled) goods++;
			case "sick": // sick
				totalNotesHit += 1;
				note.ratingMod = 1;
				if(!note.ratingDisabled) sicks++;
			case "hold": //hold
				totalNotesHit += 1;
				note.ratingMod = 0.25;
				if(!note.ratingDisabled) holds++;
		}
		
		note.rating = daRating;


		if(daRating == 'sick' || daRating == 'hold' )
		{
			spawnNoteSplashOnNote(note);
						if(ClientPrefs.scoreZoom)
			{
				if(scoreTxtTween != null) {
					scoreTxtTween.cancel();
				}
				scoreTxt.scale.x = 1.2;
				scoreTxt.scale.y = 1.75;
				scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.cubeOut,
					onComplete: function(twn:FlxTween) {
						scoreTxtTween = null;
					}
				});
			}
		}

		if(!practiceMode && !cpuControlled) {
			songScore += score;
			if(!note.ratingDisabled)
			{
				songHits++;
				totalPlayed++;
				RecalculateRating();
			}


		}

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (PlayState.isPixelStage)
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}
		
		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.cameras = [camHUD];
		rating.screenCenter();
		rating.alpha = 1;
		rating.scale.set(0.5,0.5);
		
		if (tranceActive)
			{
				rating.x = coolText.x + 395 + 200;

				// rating.velocity.x -= FlxG.random.int(15, -405);
			}
			else if (!tranceActive)
			{

				rating.x = coolText.x - 395;
				
				// rating.velocity.x -= FlxG.random.int(-15, 405);
			}
			

			if (!tweenDir)
				{
					shitter = -shitter;
					aftershit = -aftershit;
					//  rating.y -= 345;
					 rating.y = healthBar.y - 10;
				}
				else
					//  rating.y += 345;
				 rating.y = healthBar.y - 35;

					rating.angle = FlxG.random.float(-10, 10);
					rating.scale.set(0.45, 0.45);
					rating.visible = (!ClientPrefs.hideHud && showRating);
		// rating.x = coolText.x - 40;
		// rating.y -= 60;
		// rating.acceleration.y = 550;
		// rating.velocity.y -= FlxG.random.int(140, 175);
		// rating.velocity.x -= FlxG.random.int(0, 10);
		// rating.visible = (!ClientPrefs.hideHud && showRating);
		// rating.x += ClientPrefs.comboOffset[0];
		// rating.y -= ClientPrefs.comboOffset[1];

		// var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		// comboSpr.cameras = [camHUD];
		// comboSpr.screenCenter();
		// comboSpr.x = coolText.x;
		// comboSpr.acceleration.y = 600;
		// comboSpr.velocity.y -= 150;
		// comboSpr.visible = (!ClientPrefs.hideHud && showCombo);



		// comboSpr.velocity.x += FlxG.random.int(1, 10);
		insert(members.indexOf(strumLineNotes), rating);

		if (!PlayState.isPixelStage)
			// rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;

		else

			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.85));
			// comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.85));


		// comboSpr.updateHitbox();
		rating.updateHitbox();

		// var seperatedScore:Array<Int> = [];

		// if(combo >= 1000) {
		// 	seperatedScore.push(Math.floor(combo / 1000) % 10);
		// }
		// seperatedScore.push(Math.floor(combo / 100) % 10);
		// seperatedScore.push(Math.floor(combo / 10) % 10);
		// seperatedScore.push(combo % 10);

		// var daLoop:Int = 0;
		// for (i in seperatedScore)
		// {
		// 	var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
		// 	numScore.cameras = [camHUD];
		// 	numScore.screenCenter();
		// 	numScore.x = coolText.x + (43 * daLoop) - 90;
		// 	numScore.y += 80;

		// 	numScore.x += ClientPrefs.comboOffset[2];
		// 	numScore.y -= ClientPrefs.comboOffset[3];

		// 	if (!PlayState.isPixelStage)
		// 	{
		// 		numScore.antialiasing = ClientPrefs.globalAntialiasing;
		// 		numScore.setGraphicSize(Std.int(numScore.width * 0.5));
		// 	}
		// 	else
		// 	{
		// 		numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
		// 	}
		// 	numScore.updateHitbox();

		// 	numScore.acceleration.y = FlxG.random.int(200, 300);
		// 	numScore.velocity.y -= FlxG.random.int(140, 160);
		// 	numScore.velocity.x = FlxG.random.float(-5, 5);
		// 	numScore.visible = !ClientPrefs.hideHud;

		// 	//if (combo >= 10 || combo == 0)
		// 		insert(members.indexOf(strumLineNotes), numScore);

		// 	FlxTween.tween(numScore, {alpha: 0}, 0.2, {
		// 		onComplete: function(tween:FlxTween)
		// 		{
		// 			numScore.destroy();
		// 		},
		// 		startDelay: Conductor.crochet * 0.002
		// 	});

		// 	daLoop++;
		// }
		// /* 
		// 	trace(combo);
		// 	trace(seperatedScore);
		//  */

		// coolText.text = Std.string(seperatedScore);
		// add(coolText);
		if (scoreTween != null)
			{
				scoreTween.cancel();
			}
			if (scoreAppear != null)
				{
					scoreAppear.cancel();
				}
				scoreAppear = FlxTween.tween(rating, {y: rating.y - shitter  }, .45, {ease: FlxEase.cubeOut});

		scoreTween = FlxTween.tween(rating, {alpha: 0, y: rating.y + aftershit, "scale.x": 1.3, "scale.y": 1.3 }, .5, {ease: FlxEase.cubeIn,
			startDelay: Conductor.crochet * 0.0016,

			onComplete: function(twn:FlxTween) {
				scoreTween = null;
			}
		});

		
	}

	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		//trace('Pressed: ' + eventKey);

		if (!cpuControlled && !paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode))
		{
			if(!boyfriend.stunned && generatedMusic && !endingSong)
			{
				//more accurate hit time for the ratings?
				var lastTime:Float = Conductor.songPosition;
				Conductor.songPosition = FlxG.sound.music.time;

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var pressNotes:Array<Note> = [];
				//var notesDatas:Array<Int> = [];
				var notesStopped:Bool = false;

				var sortedNotesList:Array<Note> = [];
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote)
					{
						if(daNote.noteData == key)
						{
							sortedNotesList.push(daNote);
							//notesDatas.push(daNote.noteData);
						}
						canMiss = true;
					}
				});
				sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				if (sortedNotesList.length > 0) {
					for (epicNote in sortedNotesList)
					{
						for (doubleNote in pressNotes) {
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								doubleNote.kill();
								notes.remove(doubleNote, true);
								doubleNote.destroy();
							} else
								notesStopped = true;
						}
							
						// eee jack detection before was not super good
						if (!notesStopped) {
							goodNoteHit(epicNote);
							pressNotes.push(epicNote);
						}

					}
				}
				else if (canMiss) {
					noteMissPress(key);
					callOnLuas('noteMissPress', [key]);
				}

				// I dunno what you need this for but here you go
				//									- Shubs

				// Shubs, this is for the "Just the Two of Us" achievement lol
				//									- Shadow Mario
				keysPressed[key] = true;

				//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
				Conductor.songPosition = lastTime;
			}

			var spr:StrumNote = playerStrums.members[key];
			if(spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyPress', [key]);
		}
		//trace('pressed: ' + controlArray);
	}
	
	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		if(!cpuControlled && !paused && key > -1)
		{
			var spr:StrumNote = playerStrums.members[key];
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyRelease', [key]);
		}
		//trace('released: ' + controlArray);
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if(key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if(key == keysArray[i][j])
					{
						return i;
					}
				}
			}
		}
		return -1;
	}

	// Hold notes
	private function keyShit():Void
	{
		// HOLDING
		var up = controls.NOTE_UP;
		var right = controls.NOTE_RIGHT;
		var down = controls.NOTE_DOWN;
		var left = controls.NOTE_LEFT;
		var controlHoldArray:Array<Bool> = [left, down, up, right];
		
		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var controlArray:Array<Bool> = [controls.NOTE_LEFT_P, controls.NOTE_DOWN_P, controls.NOTE_UP_P, controls.NOTE_RIGHT_P];
			if(controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if(controlArray[i])
						onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[i][0]));
				}
			}
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (!boyfriend.stunned && generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (daNote.isSustainNote && controlHoldArray[daNote.noteData] && daNote.canBeHit 
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit) {
					goodNoteHit(daNote);
				}
			});

			if (controlHoldArray.contains(true) && !endingSong) {
			}
			else if (boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.dance();
				//boyfriend.animation.curAnim.finish();
			}
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var controlArray:Array<Bool> = [controls.NOTE_LEFT_R, controls.NOTE_DOWN_R, controls.NOTE_UP_R, controls.NOTE_RIGHT_R];
			if(controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if(controlArray[i])
						onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[i][0]));
				}
			}
		}
	}

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes
		//Dupe note remove
		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 1) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});
		combo = 0;

		health -= daNote.missHealth * healthLoss;
		if(instakillOnMiss)
		{
			vocals.volume = 0;
			doDeathCheck(true);
		}

		//For testing purposes
		//trace(daNote.missHealth);
		songMisses++;
		vocals.volume = 0;
		if(!practiceMode) songScore -= 10;
		
		totalPlayed++;
		RecalculateRating();

		var char:Character = boyfriend;
		if(daNote.gfNote) {
			char = gf;
		}

		if(char != null && char.hasMissAnimations)
		{
			var daAlt = '';
			if(daNote.noteType == 'Alt Animation') daAlt = '-alt';

			var animToPlay:String = singAnimations[Std.int(Math.abs(daNote.noteData))] + 'miss' + daAlt;
			
			char.playAnim(animToPlay, true);
		}

		callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote]);
	}

	function noteMissPress(direction:Int = 1):Void //You pressed a key when there was no notes to press for this key
	{
		if (!boyfriend.stunned)
		{
			health -= 0.05 * healthLoss;
			if(instakillOnMiss)
			{
				vocals.volume = 0;
				doDeathCheck(true);
			}

			if(ClientPrefs.ghostTapping) return;

			if (combo > 5 && gf != null && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;

			if(!practiceMode) songScore -= 10;
			if(!endingSong) {
				songMisses++;
			}
			totalPlayed++;
			RecalculateRating();

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*boyfriend.stunned = true;

			// get stunned for 1/60 of a second, makes you able to
			new FlxTimer().start(1 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});*/

			if(boyfriend.hasMissAnimations) {
				boyfriend.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
			}
			vocals.volume = 0;
		}
	}

	function opponentNoteHit(note:Note):Void
	{

			camZooming = camZoomingDefault;

		if(note.noteType == 'Hey!' && dad.animOffsets.exists('hey')) {
			dad.playAnim('hey', true);
			dad.specialAnim = true;
			dad.heyTimer = 0.6;
		} else if(!note.noAnimation) {
			var altAnim:String = "";

			var curSection:Int = Math.floor(curStep / 16);
			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim || note.noteType == 'Alt Animation') {
					altAnim = '-alt';
				}
			}

			var char:Character = dad;
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))] + altAnim;
			if(note.gfNote) {
				char = gf;
			}

			if(char != null)
			{
				char.playAnim(animToPlay, true);
				char.holdTimer = 0;
			}
		}

		if (SONG.needsVoices)
			vocals.volume = 1;

		var time:Float = 0.15;
		if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
			time += 0.15;
		}
		StrumPlayAnim(true, Std.int(Math.abs(note.noteData)) % 4, time);
		note.hitByOpponent = true;

		callOnLuas('opponentNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), note.noteType, note.isSustainNote]);

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (ClientPrefs.hitsoundVolume > 0 && !note.hitsoundDisabled)
			{
				FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
			}

			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			if(note.hitCausesMiss) {
				noteMiss(note);

					spawnNoteSplashOnNote(note);


				switch(note.noteType) {
					case 'Hurt Note': //Hurt note
						if(boyfriend.animation.getByName('hurt') != null) {
							boyfriend.playAnim('hurt', true);
							boyfriend.specialAnim = true;
						}
				}
				
				note.wasGoodHit = true;
				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			if (!note.isSustainNote)
				{
					combo += 1;
					popUpScore(note,false);
					if(combo > 9999) combo = 9999;
					health += note.hitHealth * healthGain;
				}
				else
				{
					popUpScore(note,true);
					health += note.hitHealth * healthGain / 1.4;
				}


			

			if(!note.noAnimation) {
				var daAlt = '';
				if(note.noteType == 'Alt Animation') daAlt = '-alt';
	
				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];

				if(note.gfNote) 
				{
					if(gf != null)
					{
						gf.playAnim(animToPlay + daAlt, true);
						gf.holdTimer = 0;
					}
				}
				else if (!boyfriend.animation.curAnim.name.endsWith('attack'))
				{	
						
							boyfriend.playAnim(animToPlay + daAlt, true);
							boyfriend.holdTimer = 0;
				}

				if(note.noteType == 'Hey!') {
					if(boyfriend.animOffsets.exists('hey')) {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
					}
	
					if(gf != null && gf.animOffsets.exists('cheer')) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
				}
			}

			if(cpuControlled) {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
				}
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)) % 4, time);
			} else {
				playerStrums.forEach(function(spr:StrumNote)
				{
					if (Math.abs(note.noteData) == spr.ID)
					{
						spr.playAnim('confirm', true);
					}
				});
			}
			note.wasGoodHit = true;
			vocals.volume = 1;

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}

		}
	}

	function spawnNoteSplashOnNoteDAD(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {

			var strumDAD:StrumNote = opponentStrums.members[note.noteData];
			if(strumDAD != null) {
				spawnNoteSplash(strumDAD.x, strumDAD.y, note.noteData, note);
			}

		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;
		
		var hue:Float = ClientPrefs.arrowHSV[data % 4][0] / 360;
		var sat:Float = ClientPrefs.arrowHSV[data % 4][1] / 100;
		var brt:Float = ClientPrefs.arrowHSV[data % 4][2] / 100;
		if(note != null) {
			skin = note.noteSplashTexture;
			hue = note.noteSplashHue;
			sat = note.noteSplashSat;
			brt = note.noteSplashBrt;
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}







	private var preventLuaRemove:Bool = false;
	override function destroy() {
		preventLuaRemove = true;
		for (i in 0...luaArray.length) {
			luaArray[i].call('onDestroy', []);
			luaArray[i].stop();
		}
		luaArray = [];

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		super.destroy();
	}

	public static function cancelMusicFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	public function removeLua(lua:FunkinLua) {
		if(luaArray != null && !preventLuaRemove) {
			luaArray.remove(lua);
		}
	}

	var lastStepHit:Int = -1;
	override function stepHit()
	{
		super.stepHit();
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20))
		{
			resyncVocals();
		}

		if(curStep == lastStepHit) {
			return;
		}

		lastStepHit = curStep;
		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var lastBeatHit:Int = -1;
	
	
	
	
	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			//trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				//FlxG.log.add('CHANGED BPM!');
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[Math.floor(curStep / 16)].mustHitSection);
			setOnLuas('altAnim', SONG.notes[Math.floor(curStep / 16)].altAnim);
			setOnLuas('gfSection', SONG.notes[Math.floor(curStep / 16)].gfSection);
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !isCameraOnForcedPos)
		{
			moveCameraSection(Std.int(curStep / 16));
		}
		if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms && curBeat % camBopInterval == 0 && !cameraLocked)
			{
				
				FlxG.camera.zoom += 0.03 * camBopIntensity;

				
				if (camebopHud)
				camHUD.zoom += 0.03 * camBopIntensity;
				if (camBopAngle)
					camAngler();

			} /// WOOO YOU CAN NOW MAKE IT AWESOME




		iconP1.scale.set(1.2, 1);
		iconP2.scale.set(1.2, 1);

		iconP1.updateHitbox();
		iconP2.updateHitbox();
		
		if (gf != null && curBeat % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing") )
		{
			gf.dance();
		}

				

		//  var heheho:Float = (healthBar.percent * 0.022);
		//  var heheho2:Float = (100 / -healthBar.percent * 0.022);
		// ^ rip! Was meant to make the icons bounce more whwen health was higher but i found a better way 
		//although it only works when at a certain health range instead of it being dynamic so that stinks :/
		//OMG WAIT NVM I CAN USE THIS FOR ICON SCALING
		//nvm looks like shit
		//Woo! April 15th! 2:16 AM! ima try and use this code for the radar bounce hopefully it works LMAO?
		  if (curBeat % gfSpeed == 0) {
			curBeat % (gfSpeed * 2) == 0 ? {
			 iconP1.scale.set(0.8, 1.1);
			 iconP2.scale.set(1.3, 1.1);
				
			 FlxTween.angle(iconP1, SONG.bpm * -clankynite , 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
			 FlxTween.angle(iconP2, SONG.bpm * clankyniteP2 , 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
			} : {
			 iconP1.scale.set(1.3, 1.1);
			 iconP2.scale.set(0.8, 1.1);
		 
			 FlxTween.angle(iconP2, SONG.bpm * -clankyniteP2 , 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
			 FlxTween.angle(iconP1, SONG.bpm * clankynite , 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
			}
		 
			FlxTween.tween(iconP1, {'scale.x': 1, 'scale.y': .7}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quadOut});
			FlxTween.tween(iconP2, {'scale.x': 1, 'scale.y': .7}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quadOut});
		 
			iconP1.updateHitbox();
			iconP2.updateHitbox();
		   } 


		if (curBeat % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
		{
			boyfriend.dance();
		}
		if (curBeat % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
		{
			dad.dance();
		}

		if(SONG.stage.toLowerCase() == 'sexcity')
			{
				if (curBeat % gfSpeed == 0) {
					curBeat % (gfSpeed * 2) == 0 ? {
					//something htat always occurs when the first beats hit
					
						radarCharBounce(false, -78.5);		
		
						/*
						gfTween = FlxTween.tween(dad, {y: dadYpre - 78.5 }, 0.6, {ease: FlxEase.quadOut});
						dagfTweened = true;
						trace('first beat!' + curBeat);
						trace('first beat!' + boyfriend.danceEveryNumBeats);
						*/
					
					} : {
						//something htat always occurs when the second beats hit
						radarCharBounce(true, -78.5);	
						/*	
						gfTween = FlxTween.tween(dad, {y: dadYpre }, 0.6, {ease: FlxEase.quadIn});
						dagfTweened = false;
						trace('second beat!' + curBeat);
						trace('second beat!' + boyfriend.danceEveryNumBeats);
						*/
					}
					//something htat always occurs when a beats hit
					
				   } 
			}





		if (curBeat % 4 == 0)
			{
				if (healthBar.percent > 65)
					{
				auraBF.visible = true;
				if (!gotAura) 
					{
						gotAura = true;
						FlxG.sound.play(Paths.sound('auraGet'), ClientPrefs.auraVolume);
						if(boyfriend.animation.getByName('pre-attack') != null)
							{
						boyfriend.playAnim('pre-attack', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.5;
							}
					}	

					if (canauraMult)
						{
							trace(auraMult);
							//songSpeed = SONG.speed * auraMult;

							var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * auraMult;
							songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, 1, {ease: FlxEase.quadIn, onComplete:
								function (twn:FlxTween)
								{
									songSpeedTween = null;
								}
							});
				}
				}
				else
					{
						auraBF.visible = false;
						if (gotAura) 
						{
							gotAura = false;
							FlxG.sound.play(Paths.sound('auraLose'), ClientPrefs.auraVolume);
							if(boyfriend.animation.getByName('hurt') != null)
							{
							boyfriend.playAnim('hurt', true);
							boyfriend.specialAnim = true;
							boyfriend.heyTimer = 0.5;
							}
						}
	
						songSpeedTween = FlxTween.tween(this, {songSpeed: SONG.speed}, .8, {ease: FlxEase.quadOut, onComplete:
							function (twn:FlxTween)
							{
								songSpeedTween = null;
							}
						});
	
					}

			}


				if (healthBar.percent < 35)
					iconP1.animation.curAnim.curFrame = 1;
			else if (healthBar.percent > 65)
					iconP1.animation.curAnim.curFrame = 2;
			else
					iconP1.animation.curAnim.curFrame = 0;			
	
			if (healthBar.percent > 75)
				{
					iconP2.animation.curAnim.curFrame = 1;
					clankynite = (.23);
					clankyniteP2 = (.03);	
				}
			else if (healthBar.percent < 37)
				{	
					iconP2.animation.curAnim.curFrame = 2;
					clankyniteP2 = (.23);
				}
			else
				{
					iconP2.animation.curAnim.curFrame = 0;
					clankynite = (0.09);
					clankyniteP2 = (0.09);
				}
				


				// if (healthBar.percent > 75)
				// 	{
				// 		iconP2.animation.curAnim.curFrame = 1;
				// 		clankynite = (.23);
				// 		clankyniteP2 = (.03);	
				// 	}
				// 	else if (healthBar.percent > 65)
				// 		iconP1.animation.curAnim.curFrame = 2;
				// 	else if (healthBar.percent < 37)
				// 		{	
				// 			iconP2.animation.curAnim.curFrame = 2;
				// 			clankyniteP2 = (.23);
				// 		}
				// 	else if (healthBar.percent < 35)
				// 		iconP1.animation.curAnim.curFrame = 1;
				// 	else
				// 		{
				// 			iconP2.animation.curAnim.curFrame = 0;
				// 			clankynite = (0.09);
				// 			clankyniteP2 = (0.09);
				// 		}



		lastBeatHit = curBeat;

		setOnLuas('curBeat', curBeat); //DAWGG?????
		callOnLuas('onBeatHit', []);
	}

	public var closeLuas:Array<FunkinLua> = [];
	public function callOnLuas(event:String, args:Array<Dynamic>):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			var ret:Dynamic = luaArray[i].call(event, args);
			if(ret != FunkinLua.Function_Continue) {
				returnVal = ret;
			}
		}

		for (i in 0...closeLuas.length) {
			luaArray.remove(closeLuas[i]);
			closeLuas[i].stop();
		}
		#end
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic) {
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			luaArray[i].set(variable, arg);
		}
		#end
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	public var ratingName:String = '?';
	public var ratingPercent:Float;
	public var ratingFC:String;
	public function RecalculateRating() {
		setOnLuas('score', songScore);
		setOnLuas('misses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', []);
		if(ret != FunkinLua.Function_Stop)
		{
			if(totalPlayed < 1) //Prevent divide by 0
				ratingName = '?';
			else
			{
				// Rating Percent
				ratingPercent = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));
				//trace((totalNotesHit / totalPlayed) + ', Total: ' + totalPlayed + ', notes hit: ' + totalNotesHit);

				// Rating Name
				if(ratingPercent >= 1)
				{
					ratingName = ratingStuff[ratingStuff.length-1][0]; //Uses last string
				}
				else
				{
					for (i in 0...ratingStuff.length-1)
					{
						if(ratingPercent < ratingStuff[i][1])
						{
							ratingName = ratingStuff[i][0];
							break;
						}
					}
				}
			}

			// Rating FC
			ratingFC = "";
			if (sicks > 0) ratingFC = "HSFC"; //holy shit full combo!
			if (goods > 0) ratingFC = "OKFC"; // ok full combo
			if (bads > 0 || shits > 0) ratingFC = "SFC"; // SHIT FULL COMBO
			if (songMisses > 0 && songMisses < 10) ratingFC = "IDKWTM"; //Idk what SDCB meant
			else if (songMisses >= 10) ratingFC = "Loser";
			else if (songMisses >= 20) ratingFC = "MORE THAN 20 MISSES?? come on dude";
		}
		setOnLuas('rating', ratingPercent);
		setOnLuas('ratingName', ratingName);
		setOnLuas('ratingFC', ratingFC);
	}

	


}
