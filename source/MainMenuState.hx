package;

import flixel.math.FlxRandom;
import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxGradient;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import io.newgrounds.NG;
import flixel.addons.text.FlxTypeText;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options',  'gallery'];

	var menuDesc:Array<String> = [
		'Start here! Play through the story.',
		'Play songs completed in the story here.',
		'Change your options and stuff here nya',
		"Let's appreciate some art together! Yay!"
	];
	var corruptDesc:Array<String> = [
		"Finish what you have started, please...",
		'Save them, please save them, please save them, please save them, please save them, please save them, please save them, please save them, please save them',
		'Far beyond my static, will you require "Mercy Mode"?',
		'Look deep into my void. Can you see me?'
	];

	var newGaming:FlxText;
	var newGaming2:FlxText;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.7" + nightly;
	public static var gameVer:String = "0.2.7.1";
	var menaceArray:Array<Bool> = [];

	var magenta:FlxSprite;
	var whiteFlash:FlxSprite;
	var bg:FlxSprite;
	// var camFollow:FlxObject;
	// public static var finishedFunnyMove:Bool = false;

	var theClock:FlxTypedGroup<FlxSprite>;

	var weeksBeaten:Array<Bool> = FlxG.save.data.weeksBeaten;
	var bgVariety:FlxTypedGroup<FlxSprite>;
	var menuText:FlxTypeText;

	override function create()
	{
		clean();
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			if (!FlxG.save.data.weeksBeaten[0] || FlxG.save.data.weeksBeaten[5])
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'),0);
				FlxG.sound.music.loopTime = 9433;
				FlxG.sound.music.endTime = 131787;
				FlxG.sound.music.time = 9433;
				FlxG.sound.music.fadeIn(2.5,0.0,1.0);
			}
			else
			{
				FlxG.sound.playMusic(Paths.music('grim grave'));
				FlxG.sound.music.loopTime = 20820;
				FlxG.sound.music.endTime = null;
				Conductor.changeBPM(150);
				FlxG.sound.music.fadeIn(2.5,0.0,1.0);
			}
		}

		persistentUpdate = persistentDraw = true;

		bg = FlxGradient.createGradientFlxSprite(FlxG.width * 2, FlxG.width * 2, FlxColor.gradient(FlxColor.fromRGB(222, 222, 255), FlxColor.fromRGB(176, 143, 255), 8, FlxEase.linear));
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		// camFollow = new FlxObject(0, 0, 1, 1);
		// add(camFollow);

		magenta = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(253, 113, 155));
		magenta.scrollFactor.set();
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.alpha = 0.5;
		magenta.visible = false;
		add(magenta);

		bgVariety = new FlxTypedGroup<FlxSprite>();
		add(bgVariety);

		var childArray:Array<String> = ["bf","dari","blitz","sheol"];
		var varietyTex:FlxAtlasFrames = Paths.getSparrowAtlas('menuVariety/mainMenu');

		for (w in 0...4)
		{
			var isMenace = true;

			var yes = new FlxSprite();
			yes.frames = varietyTex;

			switch(w)
			{ 
				// i makey a big mistakey in layers lol
				case 0:
					if (!weeksBeaten[0] || weeksBeaten[5])
						isMenace = false;
				case 1:
					if (weeksBeaten[3] || !weeksBeaten[0])
						isMenace = false;
				case 2:
					if (weeksBeaten[w] || !weeksBeaten[0])
						isMenace = false;
				case 3:
					if (weeksBeaten[1] || !weeksBeaten[0])
						isMenace = false;

			}

			menaceArray[w] = isMenace;

			yes.alpha = 0.0;
			yes.animation.addByPrefix('idle', childArray[w] + (isMenace ? "_menace" : "_beaten"), 24, true);
			yes.animation.addByPrefix('cheer', childArray[w] + "_cheer", 24, true);
			yes.scrollFactor.set();
			//yes.screenCenter();
			yes.scale.set(1.5,1.5);
			yes.updateHitbox();
			yes.antialiasing = FlxG.save.data.antialiasing;
			yes.animation.play('idle');
			bgVariety.insert(w, yes);
		}

		theClock = new FlxTypedGroup<FlxSprite>();

		var clockBase:FlxSprite = new FlxSprite().loadGraphic(Paths.image('clockBase'));
		clockBase.centerOrigin();
		clockBase.setPosition(clockBase.graphic.width * -0.3,FlxG.height- clockBase.graphic.height * 0.85);
		theClock.add(clockBase);

		for (c in 0...7)
		{
			var yes = new FlxSprite().loadGraphic(Paths.image('clockHand'));
			yes.origin.set(yes.graphic.width / 2, yes.graphic.height * 0.95);
			yes.setPosition(clockBase.x + clockBase.graphic.width * 0.45, clockBase.y);
			yes.alpha = 0.85;

			switch(c)
			{
				case 0:
					yes.scale.set(0.6, 1.8);
				case 1:
					yes.scale.set(1.0, 1.0);
				case 2:
					yes.scale.set(0.5, 0.5);
				case 3:
					yes.setPosition(FlxG.width, -180);
					yes.angle = -135;
					yes.scale.set(1.5,2.5);
					yes.alpha = 0.5;
				case 4:
					yes.setPosition(-5, -175);
					yes.angle = 135;
					yes.scale.set(1.0,3.0);
					yes.alpha = 0.5;
				case 5:
					yes.setPosition(FlxG.width, -180);
					yes.angle = -135;
					yes.scale.set(1.1,1.6);
					yes.alpha = 0.5;
				case 6:
					yes.setPosition(FlxG.width, FlxG.height - yes.graphic.height * 0.9);
					yes.angle = -45;
					yes.scale.set(0.75,1.5);
					yes.alpha = 0.35;
			}
			theClock.add(yes);
		}

		menuItems = new FlxTypedGroup<FlxSprite>();

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite();
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.origin.set(menuItem.width * 0.05, menuItem.height * 0.5);
			menuItem.setPosition(clockBase.x + clockBase.graphic.width * 0.4, clockBase.y + clockBase.graphic.height * 0.26);
			menuItem.ID = i;
			menuItem.antialiasing = FlxG.save.data.antialiasing;

			// menuItem.origin.set(clockBase.x, clockBase.y + clockBase.graphic.height * 0.3);
			menuItems.add(menuItem);
		}

		menuText = new FlxTypeText(clockBase.x + FlxG.width * 0.3, clockBase.y + clockBase.graphic.height * 0.65, 9999, "The end is never the end is never the end ", 42);
		menuText.font = 'VCR OSD MONO Bold';
		menuText.color = FlxColor.WHITE;
		menuText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4, 1);
		menuText.autoSize = false;
		menuText.alignment = FlxTextAlign.LEFT;

		var textBGBar:FlxSprite = new FlxSprite(0, menuText.y).makeGraphic(FlxG.width, Std.int(menuText.height), FlxColor.BLACK);
		textBGBar.alpha = 0.5;

		add(theClock);
		add(textBGBar);
		add(menuItems);
		add(menuText);
		
		// FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		whiteFlash = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		whiteFlash.scrollFactor.set();
		whiteFlash.updateHitbox();
		whiteFlash.screenCenter();
		whiteFlash.alpha = 0.0;
		add(whiteFlash);
		

		// NG.core.calls.event.logEvent('swag').send();

		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;
	var deciBeats:Float = 0.0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		bg.angle += 50 * elapsed;
		deciBeats = Conductor.songPosition / Conductor.crochet;

		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}

			if (FlxG.keys.justPressed.UP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (goToState(false))
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					whiteFlash.alpha = 1.0;
					FlxTween.tween(whiteFlash, {alpha: 0}, 0.35, {
						ease: FlxEase.circIn,
						type: ONESHOT,
						onComplete: function(twn:FlxTween)
						{
							whiteFlash.kill();
						}
					});

					FlxFlicker.flicker(magenta, 0, 0.1, true);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.8, {
								ease: FlxEase.quadOut,
								type: ONESHOT,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								goToState(true);
							});
						}
					});

					bgVariety.forEach(function(spr:FlxSprite)
					{
						if (!menaceArray[curSelected])
							spr.animation.play("cheer");
					});
				}
				else
				{
					FlxFlicker.flicker(magenta, 0.4, 0.1, false);
					FlxG.sound.play(Paths.sound('nope'));
				}
				
			}
		}

		var clockNum:Int = 0;
		theClock.forEach(function(spr:FlxSprite)
		{
			switch (clockNum)
			{
				case 0:
					spr.scale.set(FlxMath.lerp(1.0, spr.scale.x, 0.97),FlxMath.lerp(1.0, spr.scale.y, 0.97));
				case 1:
					// asdf
				case 2:
					// asdf
				case 3:
					spr.angle = 360 * deciBeats; 
				case 4:
					spr.angle = -135 + (35 * Math.sin(deciBeats / 2 * Math.PI));
				case 5:
					// asdf
				case 6:
					spr.angle = -135 + (35 * Math.sin(deciBeats * Math.PI));
				case 7:
					spr.angle = 360 * deciBeats / 4; 
					
			}

			clockNum++;
		});

		var lmaoInt:Int = 0;
		bgVariety.forEach(function(spr:FlxSprite)
		{
			if (curSelected == lmaoInt)
				spr.alpha = FlxMath.lerp(1.0, spr.alpha, 0.9);
			else
				spr.alpha = FlxMath.lerp(0.0, spr.alpha, 0.9);

			lmaoInt++;
		});

		menuItems.forEach(function(spr:FlxSprite)
		{
			var easeVar:Float = 0.95;

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				spr.alpha = FlxMath.lerp(1.0, spr.alpha, easeVar);
				spr.angle = FlxMath.lerp(0.0, spr.angle, easeVar);

				if (selectedSomethin)
					spr.scale.set(FlxMath.lerp(1.0, spr.scale.x, easeVar - 0.01), FlxMath.lerp(0.75, spr.scale.x, easeVar - 0.01));
				else
					spr.scale.set(FlxMath.lerp(0.75, spr.scale.x, easeVar), FlxMath.lerp(0.75, spr.scale.x, easeVar));

			}
			else
			{
				// 0 -> 1 -> 2 -> 3 -> 0
				spr.animation.play('idle');
				var dist:Int = spr.ID - curSelected;
				// ^ non-seleced sprite's menu-distance FROM the currently selected menu option
				// why the fuck did I do this to myself

				switch (dist)
				{
					case -1 | 3: // hurray circular wonkiness
						spr.scale.set(FlxMath.lerp(0.5, spr.scale.x, easeVar + 0.015), FlxMath.lerp(0.5, spr.scale.x, easeVar + 0.015));
						spr.alpha = FlxMath.lerp(0.5, spr.alpha, easeVar + 0.015);
						spr.angle = FlxMath.lerp(-33, spr.angle, easeVar + 0.015);

					case 2 | -2:
						spr.scale.set(FlxMath.lerp(0.4, spr.scale.x, easeVar + 0.025), FlxMath.lerp(0.4, spr.scale.x, easeVar + 0.025));
						spr.alpha = FlxMath.lerp(0.35, spr.alpha, easeVar + 0.025);
						spr.angle = FlxMath.lerp(-66, spr.angle, easeVar + 0.025);

					case -3 | 1:
						spr.scale.set(FlxMath.lerp(0.3, spr.scale.x, easeVar + 0.035), FlxMath.lerp(0.3, spr.scale.x, easeVar + 0.035));
						spr.alpha = FlxMath.lerp(0.2, spr.alpha, easeVar + 0.035);
						spr.angle = FlxMath.lerp(-99, spr.angle, easeVar + 0.035);
				}
			}
		});

		super.update(elapsed);
	}
	
	function goToState(travelling:Bool = false):Bool
	{
		var daChoice:String = optionShit[curSelected];
		
		switch (daChoice)
		{
			case 'story mode':
				if (travelling)
					FlxG.switchState(new StoryMenuState());
				if (!weeksBeaten[5])
				{
					StoryMenuState.songOrigin = 'menu';
					StoryMenuState.diffOrigin = '';
					StoryMenuState.didLose = false;
					return true;
				}
				else
					return false;
				
			case 'freeplay':
				if (travelling)
					FlxG.switchState(new FreeplayState());
				if (weeksBeaten[0])
					return true;
				else
					return false;

			case 'gallery':
				return false;

			case 'options':
				if (travelling)
					FlxG.switchState(new OptionsMenu());
				return true;
			default:
				return false;
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		if ((weeksBeaten[curSelected] || !weeksBeaten[0]) && (curSelected == 0 ? weeksBeaten[5] : true))
			menuText.resetText(menuDesc[curSelected]);
		else
			menuText.resetText(corruptDesc[curSelected]);

		menuText.start(0.02, true, false, null);
	}

	override function stepHit()
	{
		super.stepHit();
	}

	static var backAndForth:Int = 1;
	static var halfTime = false;
	var halfDancer = true;
	var tikTok:Bool = false; //cringe

	override function beatHit()
	{
		if (Conductor.bpm >= 140)
			halfTime = true;
		else
			halfTime = false;

		var clockNum:Int = 0;
		theClock.forEach(function(spr:FlxSprite)
		{
			switch (clockNum)
			{
				case 0:
					spr.scale.set(1.04, 1.04);
				case 1:
					spr.angle = (spr.angle + 1) % 360;
				case 2:
					spr.angle = (spr.angle + 15) % 360;
				case 3:
					// asdf
				case 4:
					// asdf
				case 5:
					spr.angle = 135 + (40 * Math.sin(curBeat / 36 * Math.PI));
				case 6:
					// asdf
				case 7:
					// asdf
			}

			clockNum++;
		});

		if (halfDancer)
		{
			var lmaoInt:Int = 0;
			bgVariety.forEach(function(spr:FlxSprite)
				{
					if (!selectedSomethin)
						spr.animation.play('idle', !menaceArray[lmaoInt]);

					lmaoInt++;
				});

			if (tikTok)
				FlxG.sound.play(Paths.sound('tick'),0.6);
			else
				FlxG.sound.play(Paths.sound('tock'),0.6);

			tikTok = !tikTok;
		}

		if (halfTime)
			halfDancer = !halfDancer;
		else
			halfDancer = true;

		super.beatHit();
	}
}
