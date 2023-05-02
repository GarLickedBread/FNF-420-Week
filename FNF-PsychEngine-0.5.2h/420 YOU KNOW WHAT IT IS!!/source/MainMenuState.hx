package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import flixel.util.FlxTimer;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

import Shaders.PulseEffect;




using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var screenshader:Shaders.PulseEffect = new PulseEffect();
	public var curbg:FlxSprite;
	public var curbg2:FlxSprite;
	public var funny:FlxSprite;
	public var dewdrop:FlxSprite;
	public static var psychEngineVersion:String = '0.5.2h'; //This is also used for Discord RPC
	public static var curSelected
	 = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	public static var firstStart:Bool = true;
	public static var finishedFunnyMove:Bool = false;

	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		//#if MODS_ALLOWED 'mods', #end
		//#if ACHIEVEMENTS_ALLOWED 'awards', #end
		//#if !switch 'donate', #end
		'options',
		'credits',
		'The_Funny_One',
		'BitchTest'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var char:FlxSprite;
	var charScoff:FlxSprite;
	var charGF:FlxSprite;
	var charGFget:FlxSprite;
	var rev:FlxSprite;
	


	override function create()
	{
		WeekData.loadTheFirstEnabledMod();
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 1)), 0.1);

		
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));

		#if windows
		screenshader.waveAmplitude = 1;
		screenshader.waveFrequency = 2;
		screenshader.waveSpeed = 1;
		if(ClientPrefs.flashing)	screenshader.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-1000, 10000);
		#end

		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
			#if windows
			// below code assumes shaders are always enabled which is bad
			var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
			testshader.waveAmplitude = .1;
			testshader.waveFrequency = 4;
			testshader.waveSpeed = 1.2;
			bg.shader = testshader.shader;
			curbg = bg;
			#end





		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBGMagenta'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		#if windows
		// below code assumes shaders are always enabled which is bad

		magenta.shader = testshader.shader;
		curbg2 = magenta;
		curbg2.color = magenta.color;
		#end
		// magenta.scrollFactor.set();

		funny = new FlxSprite(-80).loadGraphic(Paths.image('cry_about_it'));
		funny.scrollFactor.set(0, yScroll);
		funny.setGraphicSize(Std.int(bg.width * 1.175));
		funny.updateHitbox();
		funny.screenCenter();
		funny.alpha = .22;
		funny.antialiasing = ClientPrefs.globalAntialiasing;
		add(funny);



		dewdrop = new FlxSprite().loadGraphic(Paths.image('mainmenu/dewdrop'));
		dewdrop.scale.set(0.85,0.85);
		dewdrop.setPosition(-548.15, -364.55);
		dewdrop.frames = Paths.getSparrowAtlas('mainmenu/dewdrop');//here put the name of the xml
		dewdrop.animation.addByPrefix('idle', 'bdrop instance ', 24, true);//on 'idle normal' change it to your xml one
		dewdrop.animation.play('idle');//you can rename the anim however you want to
		dewdrop.antialiasing = ClientPrefs.globalAntialiasing;
		add(dewdrop);
		


		var scale:Float = .8;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/



		// for (i in 0...optionShit.length)
		// {
		// 	var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
		// 	var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
		// 	menuItem.scale.x = scale;
		// 	menuItem.scale.y = scale;
		// 	menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
		// 	menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
		// 	menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
		// 	menuItem.animation.play('idle');
		// 	menuItem.ID = i;
		// 	menuItem.x = 600;
		// 	//menuItem.y = 900;
		// 	//menuItem.screenCenter(X);
		// 	menuItems.add(menuItem);
		// 	var scr:Float = (optionShit.length - 4) * 0.135;
		// 	if(optionShit.length < 6) scr = 0;
		// 	menuItem.scrollFactor.set(0, scr);
		// 	menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		// 	menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
		// 	menuItem.updateHitbox();

		// 	switch (i)
		// 	{
		// 		case 0: //freeplay
		// 			menuItem.x = 200;
		// 			menuItem.y = 160;
		// 			case 1: //storymode
		// 				menuItem.x = 200;
		// 				menuItem.y = 299; 
		// 				case 2: //Credits
		// 					menuItem.x = 700;
		// 					menuItem.y = 160;
		// 					case 3: //options
		// 						menuItem.x = 700;
		// 						menuItem.y = 299;
		// 						case 4: //funny one
		// 							menuItem.x = 412;
		// 							menuItem.y = 470;
		// 							case 5: //funny one
		// 								menuItem.x = 415;
		// 								menuItem.y = 900;
		// 	}
		// }






		
		var testgName = 'testguy';
		var bfmen2 = 'anvil';
		var bfmen3 = 'lay';
		var bfmen1 = 'boogy';

		var gfIdle = 'gfDance';

		//BF
		switch (FlxG.random.int(2,4))
		{	
			case 1:
				char = new FlxSprite(74, 472).loadGraphic(Paths.image('mainmenu/shitheads/menu_' + testgName));//put your cords and image here
				char.frames = Paths.getSparrowAtlas('mainmenu/shitheads/menu_' + testgName);//here put the name of the xml
				char.animation.addByPrefix('idle', testgName + ' basic instance ', 24, true);//on 'idle normal' change it to your xml one
				char.animation.play('idle');//you can rename the anim however you want to
				char.antialiasing = ClientPrefs.globalAntialiasing;
				char.scrollFactor.set(0, yScroll);
				add(char);
				case 2:
					char = new FlxSprite(10.8, 380).loadGraphic(Paths.image('mainmenu/shitheads/menu_' + bfmen1));//put your cords and image here
					char.frames = Paths.getSparrowAtlas('mainmenu/shitheads/menu_' + bfmen1);//here put the name of the xml
					char.animation.addByPrefix('idle', bfmen1 + ' basic instance ', 24, true);//on 'idle normal' change it to your xml one
					char.animation.addByPrefix('death', bfmen1 + ' die basic instance ', 24, false);//on 'idle normal' change it to your xml one
					char.animation.play('idle');//you can rename the anim however you want to
					char.antialiasing = ClientPrefs.globalAntialiasing;
					char.scrollFactor.set(0, yScroll);
					add(char);	
			case 3:
				char = new FlxSprite(-11.95 + 15, 132 + 20).loadGraphic(Paths.image('mainmenu/shitheads/menu_' + bfmen2));//put your cords and image here
				char.frames = Paths.getSparrowAtlas('mainmenu/shitheads/menu_' + bfmen2);//here put the name of the xml
				char.animation.addByPrefix('idle', bfmen2 + ' basic instance ', 24, true);//on 'idle normal' change it to your xml one
				char.animation.addByPrefix('death', bfmen2 + ' die basic instance ', 24, false);//on 'idle normal' change it to your xml one
				char.animation.play('idle');//you can rename the anim however you want to
				char.antialiasing = ClientPrefs.globalAntialiasing;
				char.scrollFactor.set(0, yScroll);
				add(char);
				case 4:
					char = new FlxSprite(4.2, 360 + 26).loadGraphic(Paths.image('mainmenu/shitheads/menu_' + bfmen3));//put your cords and image here
					char.frames = Paths.getSparrowAtlas('mainmenu/shitheads/menu_' + bfmen3);//here put the name of the xml
					char.animation.addByPrefix('idle', bfmen3 + ' basic instance ', 24, true);//on 'idle normal' change it to your xml one
					char.animation.addByPrefix('death', bfmen3 + ' die basic instance ', 24, false);//on 'idle normal' change it to your xml one
					char.animation.play('idle');//you can rename the anim however you want to
					char.antialiasing = ClientPrefs.globalAntialiasing;
					char.scrollFactor.set(0, yScroll);
					add(char);	
		}
		//GF
		switch (FlxG.random.int(1,1))
		{	
			case 1:
				charGF = new FlxSprite(700, 67).loadGraphic(Paths.image('mainmenu/shitheads/menuGF_' + gfIdle));//put your cords and image here
				charGF.frames = Paths.getSparrowAtlas('mainmenu/shitheads/menuGF_' + gfIdle);//here put the name of the xml
				charGF.animation.addByPrefix('idle', gfIdle + ' basic instance ', 24, true);//on 'idle normal' change it to your xml one
				charGF.animation.addByPrefix('scared', gfIdle + ' Scared basic instance ', 24, false);//on 'idle normal' change it to your xml one
				charGF.animation.play('idle');//you can rename the anim however you want to
				charGF.antialiasing = ClientPrefs.globalAntialiasing;
				charGF.scrollFactor.set(0, yScroll);
				add(charGF);
		}


		//Revives
		switch (FlxG.random.int(1,3))
		{
			case 1:
				//prepare the revive shit
				rev = new FlxSprite(-113.25,212.65).loadGraphic(Paths.image('mainmenu/shitheads/revives/revive_1'));
		
				rev.frames = Paths.getSparrowAtlas('mainmenu/shitheads/revives/revive_1');//here put the name of the xml
				rev.animation.addByPrefix('idle', 'revive basic instance', 24, false);//on 'idle normal' change it to your xml one
				rev.animation.addByPrefix('wait', 'revive wait basic instance', 24, false);//on 'idle normal' change it to your xml one
				rev.animation.play('wait');//you can rename the anim however you want to
				rev.scrollFactor.set(0, yScroll);
				rev.antialiasing = ClientPrefs.globalAntialiasing;
				add(rev);
				//lol!
				case 2:
					//prepare the revive shit
					rev = new FlxSprite(-82.2 - 20 ,212.65).loadGraphic(Paths.image('mainmenu/shitheads/revives/revive_2'));

					rev.frames = Paths.getSparrowAtlas('mainmenu/shitheads/revives/revive_2');//here put the name of the xml
					rev.animation.addByPrefix('idle', 'revive A basic ', 24, false);//on 'idle normal' change it to your xml one
					rev.animation.addByPrefix('wait', 'revive wait basic', 24, false);//on 'idle normal' change it to your xml one
					rev.animation.play('wait');//you can rename the anim however you want to
					rev.scrollFactor.set(0, yScroll);
					rev.antialiasing = ClientPrefs.globalAntialiasing;
					add(rev);
					//lol!
			case 3:
				//prepare the revive shit
				rev = new FlxSprite(-105.35,164.8).loadGraphic(Paths.image('mainmenu/shitheads/revives/revive_3'));

				rev.frames = Paths.getSparrowAtlas('mainmenu/shitheads/revives/revive_3');//here put the name of the xml
				rev.animation.addByPrefix('idle', 'revive B basic ', 24, false);//on 'idle normal' change it to your xml one
				rev.animation.addByPrefix('wait', 'revive wait basic', 24, false);//on 'idle normal' change it to your xml one
				rev.animation.play('wait');//you can rename the anim however you want to
				rev.scrollFactor.set(0, yScroll);
				rev.antialiasing = ClientPrefs.globalAntialiasing;
				add(rev);
				//lol!

		}
		 var xoffy:Int = -150; 
		 var yoffy:Int = 337;

		rev.offset.set(xoffy - 13, yoffy - 23);
		char.offset.set(xoffy, yoffy - 23);
		char.scale.set(0.85,0.85);
		charGF.scale.set(0.85,0.85);
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		
		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for(i in 0...optionShit.length) {
			var testButton:FlxSprite = new FlxSprite(0, 130);
			testButton.ID = i;
			testButton.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			testButton.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			testButton.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			testButton.animation.play('idle');
			testButton.antialiasing = true;
			testButton.scale.set(0.50 ,0.50);
			testButton.updateHitbox();
			testButton.screenCenter(X);
			testButton.scrollFactor.set();
			
			

			//hi
			switch(i) {
				case 0:
					testButton.setPosition(230, 475);
				case 1:
					testButton.setPosition(730, 475);
				case 2:
					testButton.setPosition(230, 580);
				case 3:
					testButton.setPosition(730, 580);
				case 4:
					testButton.alpha = 0;
					testButton.scale.set(0.34,0.4);
					testButton.setPosition(252,143.35 + 20);
					// testButton.x = char.x + xoffy;
					// testButton.y = char.y + yoffy;
					//testButton.offset.set(xoffy, yoffy);
				case 5: //BITCH BUTTON!
					testButton.setPosition(99999, 99999);

			}
			menuItems.add(testButton);
		}		

		add(menuItems);

		



		FlxG.camera.follow(camFollowPos, null, 3);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "NOT MADE WITH Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();

		FlxG.mouse.visible = true;



	}





	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;
	var fuckerDead:Bool = false;

	var canClick:Bool = true;
	var usingMouse:Bool = false;
	
	var timerThing:Float = 0;

	override function update(elapsed:Float)
	{


		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		
		timerThing += elapsed;

		funny.alpha = Math.sin(timerThing) + 0.1;
		menuItems.forEach(function(spr:FlxSprite)
				{
					if(usingMouse)
					{
						if(!FlxG.mouse.overlaps(spr))
							spr.animation.play('idle');
					}
			
					if (FlxG.mouse.overlaps(spr))
					{
						if(canClick)
						{
							curSelected = spr.ID;
							usingMouse = true;
							spr.animation.play('selected');
						}
							
						if(FlxG.mouse.pressed && canClick)
						{
							switch (optionShit[curSelected]) {
								case 'The_Funny_One':
									canClick = false;
									usingMouse = false;
								FlxG.sound.play(Paths.sound('deadMF'));
									switch (FlxG.random.int(1,2))
									{	
										case 1:
											FlxG.sound.play(Paths.sound('intro1-pixel'));
											case 2:
											FlxG.sound.play(Paths.sound('introGo-pixel'));		
									}
									char.animation.play('death');
									charGF.animation.play('scared');		
									//FlxFlicker.flicker(magenta, 1.1, 0.15, false);
									new FlxTimer().start(2.3, function(tmr:FlxTimer)
										{
											rev.animation.play('idle');
											FlxG.sound.play(Paths.sound('revive'));
											char.animation.play('idle');
											charGF.animation.play('idle');



											canClick = true;
											usingMouse = true;
										});
								default: 
									selectSomething();

							}
						}
					}
		
					//starFG.x -= 0.03;
					//starBG.x -= 0.01;
			
					spr.updateHitbox();
				});

		//var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		//camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		 if (!selectedSomethin)
			{	
		// 		canClick = false;
		// 		if (controls.UI_UP_P)
		// 		{	
		// 			if (optionShit[curSelected] == 'story_mode')
		// 				{
		// 					FlxG.sound.play(Paths.sound('scrollMenu'));
		// 					changeItem(1);
		// 				}
		// 				else if (optionShit[curSelected] == 'options')
		// 					{
		// 						FlxG.sound.play(Paths.sound('scrollMenu'));
		// 						changeItem(1);
		// 					}
		// 				else if (optionShit[curSelected] == 'The_Funny_One')
		// 					{							
		// 						FlxG.sound.play(Paths.sound('scrollMenu'));
		// 						changeItem(4);
		// 					}
		// 				else
		// 					{
		// 						FlxG.sound.play(Paths.sound('scrollMenu'));
		// 						changeItem(-1);
		// 					}
		// 		}
	
		// 		if (controls.UI_DOWN_P)
		// 		{	
		// 			if (optionShit[curSelected] == 'freeplay')
		// 				{							
		// 					FlxG.sound.play(Paths.sound('scrollMenu'));
		// 					changeItem(3);
		// 				}
		// 				else 
		// 			{
		// 				FlxG.sound.play(Paths.sound('scrollMenu'));
		// 				changeItem(1);
		// 			}
	
		// 		}
		// 		if (controls.UI_RIGHT_P)
		// 		{	
		// 			if (optionShit[curSelected] == 'credits')
		// 				{							
		// 					FlxG.sound.play(Paths.sound('scrollMenu'));
		// 					changeItem(-2);
		// 				}
		// 			else if (optionShit[curSelected] == 'options')
		// 				{							
		// 					FlxG.sound.play(Paths.sound('scrollMenu'));
		// 					changeItem(-2);
		// 				}
		// 			else 
		// 				{				
		// 						FlxG.sound.play(Paths.sound('scrollMenu'));
		// 						changeItem(2);
		// 				}
	
	
		// 		}
		// 		if (controls.UI_LEFT_P)
		// 			{	
		// 				if (optionShit[curSelected] == 'story_mode') 
		// 				{
		// 					FlxG.sound.play(Paths.sound('scrollMenu'));
		// 					changeItem(2);
		// 				}
		// 				else if (optionShit[curSelected] == 'freeplay')
		// 				{						
		// 					FlxG.sound.play(Paths.sound('scrollMenu'));
		// 					changeItem(2);
		// 				}
		// 				else
		// 					{
		// 						FlxG.sound.play(Paths.sound('scrollMenu'));
		// 						changeItem(-2);
		// 					}
		// 			}
				if (controls.BACK)
				{	
					// FlxG.camera.fade(FlxColor.BLACK, 0.7, false);
					// FlxTween.tween(spr, {alpha: 0}, 1.3, {
					// 	ease: FlxEase.quadOut,
					// 	onComplete: function(twn:FlxTween)
					// 	{
					// 		spr.kill();
					// 	}
					// });
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
	
				}
	
		// 		if (controls.ACCEPT)
		// 		{
		// 			if (optionShit[curSelected] == 'donate')
		// 			{
		// 				FlxG.sound.play(Paths.sound('finalC'));
		// 				FlxFlicker.flicker(magenta, 1.1, 0.15, false);
		// 			}
	
		// 			else if (optionShit[curSelected] == 'The_Funny_One')
						
		// 					{
		// 						FlxG.sound.play(Paths.sound('finalC'));
		// 						FlxFlicker.flicker(magenta, 1.1, 0.15, false);
		// 					}
		// 					else if (optionShit[curSelected] == 'BitchTest')
								
		// 						{
		// 							FlxG.sound.play(Paths.sound('deadMF'));
		// 								switch (FlxG.random.int(1,2))
		// 								{	
		// 									case 1:
		// 										FlxG.sound.play(Paths.sound('intro1-pixel'));
		// 										case 2:
		// 										FlxG.sound.play(Paths.sound('introGo-pixel'));		
		// 								}
		// 								char.animation.play('death');//you can rename the anim however you want to			
		// 								//FlxFlicker.flicker(magenta, 1.1, 0.15, false);
		// 						}
		// 			else
		// 			{
		// 				selectedSomethin = true;
		// 				FlxG.sound.play(Paths.sound('confirmMenu'));
	
		// 				if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);
	
		// 				menuItems.forEach(function(spr:FlxSprite)
		// 				{
		// 					if (curSelected != spr.ID)
		// 					{
		// 						FlxTween.tween(spr, {alpha: 0}, 0.4, {
		// 							ease: FlxEase.quadOut,
		// 							onComplete: function(twn:FlxTween)
		// 							{
		// 								spr.kill();
		// 							}
		// 						});
		// 					}
		// 					else
		// 					{
		// 						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
		// 						{
		// 							var daChoice:String = optionShit[curSelected];
	
		// 							switch (daChoice)
		// 							{
		// 								case 'story_mode':
		// 									MusicBeatState.switchState(new StoryMenuState());
		// 								case 'freeplay':
		// 									MusicBeatState.switchState(new FreeplayState());
		// 								#if MODS_ALLOWED
		// 								case 'mods':
		// 									MusicBeatState.switchState(new ModsMenuState());
		// 								#end
		// 								case 'awards':
		// 									MusicBeatState.switchState(new AchievementsMenuState());
		// 								case 'credits':
		// 									MusicBeatState.switchState(new CreditsState());
		// 								case 'options':
		// 									LoadingState.loadAndSwitchState(new options.OptionsState());
												
		// 							}
		// 						});
		// 					}
		// 				});
		// 			}
		// 		}
		//THIS SHIT FOR DEBUG!! DISABLE PLEASE FAGGOT
			#if desktop
				else if (FlxG.keys.anyJustPressed(debugKeys))
				{
					selectedSomethin = true;
					MusicBeatState.switchState(new MasterEditorMenu());
				}
				#end
			}

		#if windows
		if (curbg != null)
		{
			if (curbg.active)
				
			{	
				if(ClientPrefs.flashing)
				{				var shad = cast(curbg.shader, Shaders.GlitchShader);
						shad.uTime.value[0] += elapsed;
				}

			}
		}
		#end

		//#if windows
		//if (curbg2 != null)
		//{
			//if (curbg2.active) // only the furiosity background is active
			//{	
				//if(ClientPrefs.flashing)
				//var shad = cast(curbg2.shader, Shaders.GlitchShader);
				//shad.uTime.value[0] += elapsed;
			//}
		//}
		//#end



		super.update(elapsed);


	}

	function selectSomething()
		{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

	
				
				canClick = false;
	
				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxG.camera.fade(FlxColor.BLACK, 0.7, false);
						FlxTween.tween(spr, {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxG.camera.fade(FlxColor.BLACK, 0.7, false);
						 new FlxTimer().start(1, function(tmr:FlxTimer)
						 	{
						 		goToState();
							});
					}
				});
		}
		function goToState()
		{
			var daChoice:String = optionShit[curSelected];
	
			switch (daChoice)
			{
				case 'story_mode':
					FlxG.switchState(new StoryMenuState());
					trace("Story Menu Selected");
				case 'freeplay':
					FlxG.switchState(new FreeplayState());
					trace("Freeplay Menu Selected");
				case 'options':
					LoadingState.loadAndSwitchState(new options.OptionsState());
					trace("Options Menu Selected");
				case 'credits':
					FlxG.switchState(new CreditsState());
					trace("Credits Menu Selected");
			}		
		}

		function changeItem(huh:Int = 0)
			{
				if (finishedFunnyMove)
				{
					curSelected += huh;
		
					if (curSelected >= menuItems.length)
						curSelected = 0;
					if (curSelected < 0)
						curSelected = menuItems.length - 1;
				}
				menuItems.forEach(function(spr:FlxSprite)
				{
					spr.animation.play('idle');
		
					if (spr.ID == curSelected && finishedFunnyMove)
					{
						spr.animation.play('selected');				
					}
		
					spr.updateHitbox();
				});
			}
		}