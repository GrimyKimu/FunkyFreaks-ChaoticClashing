package;

import cpp.Random;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	static function weekData():Array<Dynamic>
	{
		if (FlxG.save.data.weeksBeaten[0] && !FlxG.save.data.weeksBeaten[4])
		{
			return [
				['MARENOL'],
				['Murderous-Blitz'],
				['M-E-M-E']
			];
		}
		else if (FlxG.save.data.weeksBeaten[0] && FlxG.save.data.weeksBeaten[4])
		{
			return [
				['Creator']
			];
		}
		else
		{
			return [
				['New-Puppet','Kaos','Not-Sorry','KittyCat-Sonata']
			];
		}
	}
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [];

	static function whatCharacters():Array<Dynamic> 
	{
		if (FlxG.save.data.weeksBeaten[0] && !FlxG.save.data.weeksBeaten[4])
		{
			return [
				['sheol-horror', 'bf-goner', ''],
				['blitz', 'bf-goner', ''],
				['dari', 'bf-goner', '']
			];
		}
		else if (FlxG.save.data.weeksBeaten[0] && FlxG.save.data.weeksBeaten[4])
		{
			return [
				['', 'bf', '']
			];
		}
		else
		{
			return [
				['sheol', 'bg-blitz', 'bg-dari']
			];
		}
	}

	var weekCharacters = whatCharacters();

	static function whatWeeks(yes:Array<String>):Array<String>
	{
		if (FlxG.save.data.weeksBeaten[0])
		{
			yes.remove('Funky Freaks and Clashing Chaos');
		}
		if (FlxG.save.data.weeksBeaten[4])
		{
			yes.remove('Dreams Worse Than Death');
			yes.remove('Killer Karma Cat');
			yes.remove('Measured Emotion and Memorable Elation');
		}
		return yes;
	}

	var weekNames:Array<String> = whatWeeks(CoolUtil.coolTextFile(Paths.txt('data/weekNames')));

	var txtWeekTitle:FlxText;

	static var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var mercyPNG:FlxSprite;

	function unlockWeeks():Array<Bool>
	{
		var weeks:Array<Bool> = [];
		if(FlxG.save.data.weeksBeaten[0] && !FlxG.save.data.weeksBeaten[4])
			for (i in 0...3)
			{
				weeks[i] = !FlxG.save.data.weeksBeaten[i + 1];
			}
		else
			weeks = [true];

		return weeks;
	}

	override function create()
	{
		weekUnlocked = unlockWeeks();

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, FlxColor.GRAY);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		for (i in 0...weekData().length)
		{
			var notI = i;
			if (FlxG.save.data.weeksBeaten[4])
				notI = 4;
			else if (FlxG.save.data.weeksBeaten[0])
				notI = i + 1;
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, notI);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = FlxG.save.data.antialiasing;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				//trace('locking week ' + i);
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = FlxG.save.data.antialiasing;
				grpLocks.add(lock);
			}
		}

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.addByPrefix('false', 'FALSE');
		sprDifficulty.animation.addByPrefix('true', 'TRUE');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		diabg = new FlxSprite().makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.BLACK);
		diabg.scrollFactor.set();
		diabg.screenCenter();
		diabg.updateHitbox();

		add(yellowBG);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		if (FlxG.save.data.mercyMode)
		{
			mercyPNG = new FlxSprite().loadGraphic(Paths.image('mercyMode'));
			mercyPNG.scale.set(0.19,0.19);
			mercyPNG.updateHitbox();
			mercyPNG.setPosition(FlxG.width - mercyPNG.width * 1.3,FlxG.height - mercyPNG.height * 1.3);
			add(mercyPNG);
		}

		updateText();


		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		if (songOrigin != null && diffOrigin != null)
		{
			diffOrigin = diffOrigin.toLowerCase();
			var noPlay:Bool = false;
			var superFail:String = '';

			switch(songOrigin)
			{
				case 'new-puppet' | 'kaos' | 'not-sorry':
					noPlay = true;
				case 'kittycat-sonata':
					if (didLose)
						noPlay = true;
					else
						songOrigin = 'KCS';
				case 'murderous-blitz':
					songOrigin = 'MB';
				case 'm-e-m-e':
					songOrigin = 'meme';
				case 'menu':
					if (FlxG.save.data.weeksBeaten[0])
					{
						noPlay = FlxG.random.bool(60); //a 40% chance for moving from mainMenu -> StoryMenu to trigger a Sain dialogue
						superFail = '$menuDial';
						menuDial++;
						if (menuDial > 5)
							menuDial = 1;
					}
					else
						noPlay = true;
			}

			if (didLose && diffOrigin != 'false')
			{
				superFail = 'failed' + '$songDial';
				songDial++;

				if (songDial > 3)
					songDial = 1;
			}

			if (!noPlay)
			{
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/sain/$songOrigin-$diffOrigin' + superFail));

				doof = new DialogueBox(dialogue, 'sain', false);
				doof.scrollFactor.set();
				doof.finishThing = returnToMenu;

				sainShallSpeak(doof);
			}
			/*
			else
			{
				if (FlxG.sound.music != null)
				{
					if (!FlxG.sound.music.playing)
					{
						if (!FlxG.save.data.weeksBeaten[0])
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
						else
							FlxG.sound.playMusic(Paths.music('freakyMenu-goner'));
						Conductor.changeBPM(102);
					}
				}
			}
			*/
		}
		super.create();
	}

	function returnToMenu():Void
	{
		FlxTween.tween(diabg, {alpha: 0}, 1.5, { 
			onComplete: function(tween:FlxTween) 
				{
					remove(diabg, true);
				}
			});
		songOrigin = null;
		diffOrigin = null;
		inCutscene = false;
		didLose = false;
		/*
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
			FlxG.sound.playMusic(Paths.music('freakyMenu-goner'),0);
			FlxG.sound.music.loopTime = 12900;
			FlxG.sound.music.endTime = 144990;
			FlxG.sound.music.time = 12900;
			FlxG.sound.music.fadeIn(2.5,0.0,1.0);
		}
		*/
	}

	function sainShallSpeak(?dialogueBox:DialogueBox):Void
	{
		//FlxG.sound.music.stop();
		add(diabg);

		if (dialogueBox != null)
		{
			inCutscene = true;
			add(dialogueBox);
		}
	}

	//find me
	private static var songDial:Int = 1;
	private static var menuDial:Int = 1;
	private var inCutscene:Bool = false;
	private var doof:DialogueBox;
	private var dialogue:Array<String> = ['sain: Aw shit, here we go again.'];
	public static var songOrigin:String = '';
	public static var diffOrigin:String;
	public static var didLose:Bool;
	public static var savedChildren:Array<Bool> = [false,false,false,false]; //0 = she, 1 = blitz, 2 = dari
	private var songName:String = "";
	private var bgmList:Array<String> = CoolUtil.coolTextFile(Paths.txt('music/bgmData', "shared"));
	var bgmStats:Array<String> = [];
	private var diabg:FlxSprite;
	// bgmStats[0 = name, 1 = parsed looping point, 2 = parsed end point(can be null, if so simply loop from the end of the bgm rather than a specific point)]

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!inCutscene)
		{
			if (!movedBack)
			{
				if (!selectedWeek)
				{
					var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

					if (gamepad != null)
					{
						if (gamepad.justPressed.DPAD_UP)
						{
							changeWeek(-1);
						}
						if (gamepad.justPressed.DPAD_DOWN)
						{
							changeWeek(1);
						}

						if (gamepad.pressed.DPAD_RIGHT)
							rightArrow.animation.play('press')
						else
							rightArrow.animation.play('idle');
						if (gamepad.pressed.DPAD_LEFT)
							leftArrow.animation.play('press');
						else
							leftArrow.animation.play('idle');

						if (gamepad.justPressed.DPAD_RIGHT)
						{
							changeDifficulty(1);
						}
						if (gamepad.justPressed.DPAD_LEFT)
						{
							changeDifficulty(-1);
						}
					}

					if (FlxG.keys.justPressed.UP)
					{
						changeWeek(-1);
					}

					if (FlxG.keys.justPressed.DOWN)
					{
						changeWeek(1);
					}

					if (controls.RIGHT)
						rightArrow.animation.play('press')
					else
						rightArrow.animation.play('idle');

					if (controls.LEFT)
						leftArrow.animation.play('press');
					else
						leftArrow.animation.play('idle');

					if (controls.RIGHT_P)
						changeDifficulty(1);
					if (controls.LEFT_P)
						changeDifficulty(-1);
				}

				if (controls.ACCEPT)
					selectWeek();
			}

			if (controls.BACK && !movedBack && !selectedWeek)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				movedBack = true;
				FlxG.switchState(new MainMenuState());
			}
		}

		if (mercyPNG != null)
		{
			mercyPNG.scale.set(FlxMath.lerp(0.19, mercyPNG.scale.x, 0.95),FlxMath.lerp(0.19, mercyPNG.scale.y, 0.95));
			mercyPNG.updateHitbox();
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek] && curWeek != 2 /*<---- DEMO ONLY*/)
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				if (grpWeekCharacters.members[1].character == 'bf')
					grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			FlxG.sound.music.fadeOut(0.75,0.0);

			PlayState.storyPlaylist = weekData()[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;
			PlayState.songMultiplier = 1;
			PlayState.storyDifficulty = curDifficulty;

			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}

			//var poop:String = Highscore.formatSong(songFormat, 1);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.conversionChecks(Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), ''));
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			PlayState.alreadyDied = false;
			PlayState.dedCounter = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
		else
		{
			FlxG.sound.play(Paths.sound('nope'), 1.4);
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (change != 0)
			FlxG.sound.play(Paths.sound('boop'), 0.4);

		if (!FlxG.save.data.weeksBeaten[0])
		{
			curDifficulty = 1;
		}
		else
		{
			if (curDifficulty < 3)
				curDifficulty = 3;
			else if (curDifficulty > 4)
				curDifficulty = 4;
		}

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
			case 3:
				sprDifficulty.animation.play('false');
				sprDifficulty.offset.x = 30;
			case 4:
				sprDifficulty.animation.play('true');
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData().length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData().length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		changeDifficulty();
		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData()[curWeek];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	public static function unlockNextWeek(week:Int):Void
	{
		/*if(week <= weekData().length - 1 && FlxG.save.data.weekUnlocked == week)
		{
			weekUnlocked.push(true);
			//trace('Week ' + week + ' beat (Week ' + (week + 1) + ' unlocked)');
		}*/
		if (!FlxG.save.data.weeksBeaten[0])
		{
			FlxG.save.data.weeksBeaten[0] = true;
			FlxG.save.flush();
		}
		else
		{
			FlxG.save.data.weeksBeaten[week + 1] = true;
			FlxG.save.flush();
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (mercyPNG != null)
		{
			mercyPNG.scale.set(0.2,0.2);
			mercyPNG.updateHitbox();
		}

		grpWeekCharacters.members[0].bopHead();
		grpWeekCharacters.members[1].bopHead();
		grpWeekCharacters.members[2].bopHead();
	}
}
