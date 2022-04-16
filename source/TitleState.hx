package;

#if FEATURE_STEPMANIA
import smTools.SMFile;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import flixel.input.keyboard.FlxKey;

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		// TODO: Refactor this to use OpenFlAssets.
		#if FEATURE_FILESYSTEM
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			Debug.logTrace("We loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets into the default library");
		}

		FlxG.autoPause = false;

		FlxG.save.bind('funkin', 'ninjamuffin99');

		PlayerSettings.init();

		KadeEngineData.initSave();

		KeyBinds.keyCheck();
		// It doesn't reupdate the list before u restart rn lmao

		NoteskinHelpers.updateNoteskins();

		if (FlxG.save.data.volDownBind == null)
			FlxG.save.data.volDownBind = "MINUS";
		if (FlxG.save.data.volUpBind == null)
			FlxG.save.data.volUpBind = "PLUS";

		FlxG.sound.muteKeys = [FlxKey.fromString(FlxG.save.data.muteBind)];
		FlxG.sound.volumeDownKeys = [FlxKey.fromString(FlxG.save.data.volDownBind)];
		FlxG.sound.volumeUpKeys = [FlxKey.fromString(FlxG.save.data.volUpBind)];

		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0, 0);

		FlxGraphic.defaultPersist = FlxG.save.data.cacheImages;

		MusicBeatState.initSave = true;

		fullscreenBind = FlxKey.fromString(FlxG.save.data.fullscreenBind);

		Highscore.load();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		trace('hello');

		// DEBUG BULLSHIT

		super.create();

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		clean();
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		clean();
		#else
		#if !cpp
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#else
		startIntro();
		#end
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	var weeksBeaten:Array<Bool> = FlxG.save.data.weeksBeaten;
	var bgVariety:FlxTypedGroup<FlxSprite>;

	function startIntro()
	{
		persistentUpdate = true;
		weeksBeaten = FlxG.save.data.weeksBeaten;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = FlxG.save.data.antialiasing;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		if (Main.watermarks)
		{
			logoBl = new FlxSprite(-150, 1500);
			logoBl.frames = Paths.getSparrowAtlas('KadeEngineLogoBumpin');
		}
		else
		{
			logoBl = new FlxSprite(50, -100);
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		}
		logoBl.antialiasing = FlxG.save.data.antialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		/*gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = FlxG.save.data.antialiasing;
		add(gfDance);*/
		add(logoBl);

		bgVariety = new FlxTypedGroup<FlxSprite>();
		add(bgVariety);

		var childArray:Array<String> = ["","dari","blitz","sheol"];
		var childMap:Map<String, FlxSprite> = [
			"sheol" => new FlxSprite(FlxG.width * 0.65, FlxG.height * 0.18), 
			"blitz" => new FlxSprite(FlxG.width * 0.6, FlxG.height * 0.2),
			"dari" => new FlxSprite(FlxG.width * 0.43, FlxG.height * 0.2)
		];

		var behindThem = new FlxSprite(FlxG.width * 0.395, FlxG.height * 0.11);
		behindThem.frames = Paths.getSparrowAtlas('menuVariety/behindTitle');
		behindThem.animation.addByIndices('danceLeft', "behindTitle", [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		behindThem.animation.addByIndices('danceRight', "behindTitle", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		behindThem.scrollFactor.set();
		behindThem.scale.set(.85, .85);
		behindThem.updateHitbox();
		behindThem.antialiasing = FlxG.save.data.antialiasing;
		bgVariety.add(behindThem);

		for (w in 1...4)
		{
			var menacingString = "menace";
			switch(w)
			{
				// i makey a big mistakey in layers lol
				case 1:
					if (weeksBeaten[3] || !weeksBeaten[0])
						menacingString = "defeat";
				case 2:
					if (weeksBeaten[w] || !weeksBeaten[0])
						menacingString = "defeat";
				case 3:
					if (weeksBeaten[1] || !weeksBeaten[0])
						menacingString = "defeat";
			}

			var yes = childMap[childArray[w]];
			yes.scale.set(.85, .85);
			yes.frames = Paths.getSparrowAtlas('menuVariety/' + childArray[w] + 'Title');
			yes.animation.addByIndices('danceLeft', menacingString, [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			yes.animation.addByIndices('danceRight', menacingString, [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
			yes.scrollFactor.set();
			yes.updateHitbox();
			yes.antialiasing = FlxG.save.data.antialiasing;
			bgVariety.add(yes);

			//damn, I really just shortened a whole ass if-else tree into a single for loop, huh
		}

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = FlxG.save.data.antialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.loadImage('logo'));
		logo.screenCenter();
		logo.antialiasing = FlxG.save.data.antialiasing;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.loadImage('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = FlxG.save.data.antialiasing;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			if (!FlxG.save.data.weeksBeaten[0] || FlxG.save.data.weeksBeaten[5])
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				FlxG.sound.music.loopTime = 9433;
				FlxG.sound.music.endTime = 131787;
			}
			else
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu-goner'));
				FlxG.sound.music.loopTime = 12900;
				FlxG.sound.music.endTime = 144990;
			}

			FlxG.sound.music.fadeIn(4, 0, 0.7);
			Conductor.changeBPM(102);
			initialized = true;
		}

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('data/introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	var fullscreenBind:FlxKey;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.keys.anyJustPressed([fullscreenBind]))
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		if (pressedEnter && !transitioning && skippedIntro)
		{
			if (FlxG.save.data.flashing)
				titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			MainMenuState.firstStart = true;
			MainMenuState.finishedFunnyMove = false;

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				var isDemo = true;
				if (isDemo)
				{
					FlxG.switchState(new OutdatedSubState());
					clean();
				}
				else
				{
					FlxG.switchState(new MainMenuState());
					clean();
				}
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro && initialized)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump', true);
		danceLeft = !danceLeft;

		if (danceLeft)
		{
			bgVariety.forEach(function(spr:FlxSprite)
			{
				spr.animation.play('danceRight');
			});
			// gfDance.animation.play('danceRight');
		}
		else
		{
			bgVariety.forEach(function(spr:FlxSprite)
			{
				spr.animation.play('danceLeft');
			});
			// gfDance.animation.play('danceLeft');
		}
		// FlxG.log.add(curBeat);

		if (!FlxG.save.data.weeksBeaten[0] || FlxG.save.data.weeksBeaten[5])
			switch (curBeat)
			{
				case 0:
					deleteCoolText();
				case 1:
					createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
				case 2:
					addMoreText('thanks for the cool game');
				case 3:
					deleteCoolText();
				case 4:
					createCoolText(['Kade Engine by']);
				case 5:
					addMoreText('KadeDeveloper');
				case 6:
					if (FlxG.random.bool())
						addMoreText('Thanks for the engine');
					else
						addMoreText("It's functional");
				case 7:
					deleteCoolText();
				case 8:
					createCoolText([curWacky[0]]);
				case 10:
					addMoreText(curWacky[1]);
				case 12:
					deleteCoolText();
				case 13:
					addMoreText('Friday');
				case 14:
					addMoreText('Night');
				case 15:
					addMoreText('Funkin');
				case 16:
					skipIntro();
			}
		else
			switch (curBeat)
			{
				case 0:
					deleteCoolText();
				case 1:
					createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
				case 2:
					addMoreText('their game hath been butchered');
				case 3:
					deleteCoolText();
				case 4:
					createCoolText(['Kade Engine']);
				case 5:
					if (FlxG.random.bool())
						addMoreText('Look man...');
					else
						addMoreText('Dude, bro...');
				case 6:
					switch (FlxG.random.int(0, 4))
					{
						case 0:
							addMoreText("It's doing it's best");
						case 1:
							addMoreText("God it's trying");
						case 2:
							addMoreText("It's still being potty-trained");
						case 3:
							addMoreText("It turned on at least");
						case 4:
							addMoreText("Barely functioning");
					}
				case 7:
					deleteCoolText();
				case 8:
					createCoolText([curWacky[0]]);
				case 10:
					addMoreText(curWacky[1]);
				case 12:
					deleteCoolText();
				case 13:
					addMoreText("You have made");
				case 14:
					addMoreText("a horrible");
				case 15:
					addMoreText("M I S T A K E");
				case 16:
					deleteCoolText();
				case 17:
					addMoreText("Friday Night Funkin'");
				case 18:
					addMoreText("Friday Blight Funkin'");
				case 19:
					addMoreText("Friday Night Chuckin'");
				case 20:
					addMoreText("Friday Light Funkin'");
					addMoreText("Freaky Night Funkin'");
				case 21:
					addMoreText("Friday Night Forking");
					addMoreText("Funday Night Funkin'");
					addMoreText("Friday Blight Funkin'");
				case 22:
					skipIntro();
			}
		
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			Debug.logInfo("Skipping intro...");

			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);

			FlxTween.tween(logoBl, {y: 50}, 1.4, {ease: FlxEase.expoInOut});

			logoBl.angle = -4;

			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				if (logoBl.angle == -4)
					FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
				if (logoBl.angle == 4)
					FlxTween.angle(logoBl, logoBl.angle, -4, 4, {ease: FlxEase.quartInOut});
			}, 0);

			// It always bugged me that it didn't do this before.
			// Skip ahead in the song to the drop.
			if (!FlxG.save.data.weeksBeaten[0] || FlxG.save.data.weeksBeaten[5])
				FlxG.sound.music.time = 9400; // 9.4 seconds
			else
				FlxG.sound.music.time = 12900; // 12.9 seconds for "-goner" variation of title music

			skippedIntro = true;
		}
	}
}
