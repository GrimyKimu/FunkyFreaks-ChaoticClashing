package;

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
				['New-Puppet','Kaos','Apology','KittyCat-Sonata']
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
		else //if (FlxG.save.data.weeksBeaten[0] && FlxG.save.data.weeksBeaten[4])
		{
			return [
				['', 'bf', '']
			];
		}
		/*else
		{
			return [
				['sheol', 'bf-blitz', 'bf-dari']
			];
		}*/
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

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	function unlockWeeks():Array<Bool>
	{
		var weeks:Array<Bool> = [];
		#if debug
		for(i in 0...weekNames.length)
			weeks.push(true);
		#else
		if(FlxG.save.data.weeksBeaten[0])
			weeks = [true, true, true];
		else
			weeks = [true, true, true];
		#end

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
			if (FlxG.save.data.weeksBeaten[0])
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

			if((songOrigin == 'new-puppet' || songOrigin == 'kaos' || songOrigin == 'apology' || songOrigin == 'kittycat-sonata') && didLose)
			{
				noPlay = true;
			}

			if (didLose && diffOrigin != 'false' && !noPlay)
			{
				superFail = 'failed';
			}

			if (!noPlay)
			{
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/sain/$songOrigin-$diffOrigin' + superFail));

				doof = new DialogueBox(dialogue, 'sain', false);
				doof.scrollFactor.set();

				sainShallSpeak(doof);
			}
		}
		super.create();
	}

	function sainShallSpeak(?dialogueBox:DialogueBox):Void
	{
		FlxG.sound.music.stop();

		new FlxTimer().start(1.0, function(tmr:FlxTimer)
		{
			if (dialogueBox != null)
			{
				inCutscene = true;
				add(dialogueBox);
			}
			else
			{
				songOrigin = null;
				diffOrigin = null;
				inCutscene = false;
				didLose = false;
				FlxG.sound.playMusic(Paths.music('freakyMenu-goner'));
			}
		});
	}

	//find me
	private var inCutscene:Bool = false;
	private var doof:DialogueBox;
	private var dialogue:Array<String> = ['sain: Aw shit, here we go again.'];
	public static var songOrigin:String = '';
	public static var diffOrigin:String;
	public static var didLose:Bool;
	public static var savedChildren:Array<Bool> = [false,false,false,false]; //0 = she, 1 = blitz, 2 = dari

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
				{
					selectWeek();
				}
			}

			if (controls.BACK && !movedBack && !selectedWeek)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				movedBack = true;
				FlxG.switchState(new MainMenuState());
			}
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
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				if (grpWeekCharacters.members[1].character == 'bf')
					grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

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

			var poop:String = Highscore.formatSong(songFormat, 1);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.conversionChecks(Song.loadFromJson(poop, PlayState.storyPlaylist[0]));
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			PlayState.alreadyDied = false;
			PlayState.dedCounter = 0;

			if (!FlxG.save.data.weeksBeaten[0])
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					//play initial cutscene here
					var video:MP4Handler = new MP4Handler();
					video.stateCallback = new PlayState();
					video.playMP4(Paths.video('introCutscene'));
				});
			}
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					LoadingState.loadAndSwitchState(new PlayState(), true);
				});
			}
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

		grpWeekCharacters.members[0].bopHead();
		grpWeekCharacters.members[1].bopHead();
		grpWeekCharacters.members[2].bopHead();
	}
}
