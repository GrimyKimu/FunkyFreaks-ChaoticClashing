package;
import flixel.graphics.frames.FlxAtlasFrames;
import lime.app.Application;
import openfl.utils.Future;
import openfl.media.Sound;
import flixel.system.FlxSound;
#if sys
import smTools.SMFile;
import sys.FileSystem;
import sys.io.File;
#end
import Song.SongData;
import flixel.input.gamepad.FlxGamepad;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.util.FlxGradient;
import lime.utils.Assets;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	public static var songs:Array<SongMetadata> = [];

	var selector:FlxText;

	public static var rate:Float = 1.0;

	public static var curSelected:Int = 0;
	public static var curDifficulty:Int = 1;

	public static var curWeek:Int = 0;

	var scoreText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	var diffCalcText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private static var grpSongs:FlxTypedGroup<Alphabet>;
	private static var curPlaying:Bool = false;

	private static var iconArray:FlxTypedGroup<HealthIcon>;

	public static var openedPreview = false;

	public static var songData:Map<String,Array<SongData>> = [];

	var weeksBeaten:Array<Bool> = FlxG.save.data.weeksBeaten;
	var bgVariety:FlxTypedGroup<FlxSprite>;
	static var childArray:Array<String> = ["all","sheol","blitz","dari", "sain"];

	static var exclusionaryZone:Int = 0;
	var exclusionTimer:Float = 0;
	var exludedText:FlxText;
	var greyBG:FlxSprite;
	var bg:FlxSprite;

	var mercyPNG:FlxSprite;

	public static function loadDiff(diff:Int, format:String, name:String, array:Array<SongData>)
	{
		try 
		{
			array.push(Song.loadFromJson(name.toLowerCase(), ''));
		}
		catch(ex)
		{
			trace('failure to load the diff for $name');
		}
	}

	override function create()
	{
		clean();
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end

		var isDebug:Bool = false;

		TimingStruct.clearTimings();

		#if debug
		isDebug = true;
		#end

		persistentUpdate = true;

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = FlxGradient.createGradientFlxSprite(FlxG.width * 2, FlxG.width * 2, FlxColor.gradient(FlxColor.WHITE, FlxColor.PINK, 8, FlxEase.linear));
		// var bg:FlxSprite = 
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		greyBG = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(150, 150, 150));
		greyBG.scrollFactor.set();
		greyBG.updateHitbox();
		greyBG.screenCenter();
		add(greyBG);

		bgVariety = new FlxTypedGroup<FlxSprite>();
		add(bgVariety);

		var varietyTex:FlxAtlasFrames = Paths.getSparrowAtlas('menuVariety/freeplayMenu');

		for (w in 1...4)
		{
			var yes = new FlxSprite();
			yes.frames = varietyTex;

			var menacingString = "_menace";
			if (weeksBeaten[w])
				menacingString = "_beaten";

			yes.alpha = 0.5;
			yes.animation.addByPrefix('idle', childArray[w] + menacingString, 24, w == 1 ? true : false);
			yes.scrollFactor.set();
			yes.updateHitbox();
			yes.antialiasing = FlxG.save.data.antialiasing;
			yes.animation.play('idle');
			// yes.scale.set(2.0,2.0);
			yes.screenCenter();
			bgVariety.add(yes);
		}

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);		

		iconArray = new FlxTypedGroup<HealthIcon>();
		add(iconArray);

		populateSongData();

		

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 200, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		diffCalcText = new FlxText(scoreText.x, scoreText.y + 66, 0, "", 24);
		diffCalcText.font = scoreText.font;
		add(diffCalcText);

		exludedText = new FlxText(scoreText.x, scoreText.y + 94, 0, "", 24);
		exludedText.font = scoreText.font;
		add(exludedText);

		var excludeTutorial = new FlxText(exludedText.x, exludedText.y + 30, 0, "Press ',' or '.'", 24);
		excludeTutorial.font = scoreText.font;
		add(excludeTutorial);
		var lmao2 = new FlxText(exludedText.x, exludedText.y + 54, 0, "to swap characters!", 24);
		lmao2.font = scoreText.font;
		add(lmao2);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.font = scoreText.font;
		add(comboText);
		
		if (FlxG.save.data.mercyMode)
		{
			mercyPNG = new FlxSprite().loadGraphic(Paths.image('mercyMode'));
			mercyPNG.scale.set(0.19,0.19);
			mercyPNG.updateHitbox();
			mercyPNG.setPosition(FlxG.width - mercyPNG.width * 1.3,FlxG.height - mercyPNG.height * 1.3);
			add(mercyPNG);
		}

		add(scoreText);

		changeSelection();
		changeDiff();

		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		super.create();
	}

	/**
	 * Every level only uses one .json file for every difficulty, so every difficulty just defaults to "normal" internally, even if displayed as something else
	 */
	static function populateSongData()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('data/freeplaySonglist'));
		songData = [];
		songs = [];

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			var meta = new SongMetadata(data[0], Std.parseInt(data[2]), data[1]);
			var format = meta.songName.toLowerCase();

			if (FlxG.save.data.weeksBeaten[meta.week] != true)
				continue;
			// if the song is attached to a week that hasn't been beaten yet, skip loading it
			// this way you cannot access specific songs in freeplay until you've beaten the required week

			if (exclusionaryZone != 0 && !meta.songCharacter.startsWith(childArray[exclusionaryZone]))
				continue;
			// excluding chosen "weeks"/"characters" in order to make navigating the freeplay menu a bit more easy

			var diffs = [];
			var diffsThatExist = [];
			if (Std.parseInt(data[3]) != 0)
				meta.isEX = true;

			diffsThatExist.push("Yes");
			FreeplayState.loadDiff(1,format,meta.songName,diffs);

			/*
			#if sys

			if (meta.isEX)
			{
				//if the song is one of the boss songs, it'll have False/True diffs
				//if (FileSystem.exists('assets/data/${format}/${format}-false.json'))
					
				//if (FileSystem.exists('assets/data/${format}/${format}-true.json'))
				diffsThatExist.push("True");
				diffsThatExist.push("False");
			}
			else
			{
				//otherwise, it's just a normal song(that only has 1 diff anyway lol)
				//haha it's all normal(hard) now mofo
				//if (FileSystem.exists('assets/data/${format}/${format}.json'))
				diffsThatExist.push("Normal");
			}
			#end
			*/
			/*
			if (diffsThatExist.contains("False"))
				FreeplayState.loadDiff(1,format,meta.songName,diffs);
			if (diffsThatExist.contains("True"))
				FreeplayState.loadDiff(1,format,meta.songName,diffs);
			*/

			meta.diffs = diffsThatExist;

			//trace("Found Diffs: " + diffsThatExist);

			FreeplayState.songData.set(meta.songName,diffs);
			//trace('loaded diffs for ' + meta.songName);
			FreeplayState.songs.push(meta);
		}

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			// lol but what if I want to
			iconArray.add(icon);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (exclusionTimer > 0)
			exclusionTimer -= FlxG.elapsed;// this is just in case doing excludeWeeks() causes slowdown, this prevents spamming keypresses and crashing the shit

		if (FlxG.sound.music.volume != 1.0)
			FlxG.sound.music.volume = FlxMath.lerp(FlxG.sound.music.volume, 1.0, 0.15);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';
		exludedText.text = childArray[exclusionaryZone].toUpperCase();

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = FlxG.keys.justPressed.ENTER;
		var dadDebug = FlxG.keys.justPressed.SIX;
		var charting = FlxG.keys.justPressed.SEVEN;
		var bfDebug = FlxG.keys.justPressed.ZERO;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (exclusionTimer <= 0)
		{
			if (gamepad != null)
			{

				if (gamepad.justPressed.DPAD_UP)
				{
					changeSelection(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					changeSelection(1);
				}
				if (gamepad.justPressed.DPAD_LEFT)
				{
					changeDiff(-1);
				}
				if (gamepad.justPressed.DPAD_RIGHT)
				{
					changeDiff(1);
				}

				//if (gamepad.justPressed.X && !openedPreview)
					//openSubState(new DiffOverview());
			}

			if (upP)
			{
				changeSelection(-1);
			}
			if (downP)
			{
				changeSelection(1);
			}

			if (FlxG.keys.justPressed.LEFT)
				changeDiff(-1);
			if (FlxG.keys.justPressed.RIGHT)
				changeDiff(1);

			#if cpp
			@:privateAccess
			{
				if (FlxG.sound.music.playing)
					lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, rate);
			}
			#end

			if (accepted)
				loadSong();
			else if (charting)
				loadSong(true);

			// AnimationDebug and StageDebug are only enabled in debug builds.
			#if debug
			if (dadDebug)
			{
				loadAnimDebug(true);
			}
			if (bfDebug)
			{
				loadAnimDebug(false);
			}
			#end

			if (FlxG.keys.justPressed.PERIOD)
				excludeWeeks(1);
			if (FlxG.keys.justPressed.COMMA)
				excludeWeeks(-1);

			if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}
		}

		//icon beat moving shit
		iconArray.forEach(function(icon)
		{
			icon.scale.set(FlxMath.lerp(1.0, icon.scale.x, 0.95),FlxMath.lerp(1.0, icon.scale.y, 0.95));
			icon.angle = FlxMath.lerp(0, icon.angle, 0.95);
			icon.updateHitbox();
		});

		if (mercyPNG != null)
		{
			mercyPNG.scale.set(FlxMath.lerp(0.19, mercyPNG.scale.x, 0.95),FlxMath.lerp(0.19, mercyPNG.scale.y, 0.95));
			mercyPNG.updateHitbox();
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		
		bg.angle += 666 * elapsed;
		greyBG.alpha = FlxMath.lerp(greyBG.alpha, Math.abs(Math.sin(Conductor.songPosition / 1800)), 0.05);
	}

	function loadAnimDebug(dad:Bool = true)
	{
		// First, get the song data.
		var hmm;
		
		try
		{
			hmm = songData.get(songs[curSelected].songName)[0];
			if (hmm == null)
				return;
		}
		catch (ex)
		{
			return;
		}
		PlayState.SONG = hmm;

		var character = dad ? PlayState.SONG.player2 : PlayState.SONG.player1;

		LoadingState.loadAndSwitchState(new AnimationDebug(character));
	}

	function loadSong(isCharting:Bool = false)
	{
		loadSongInFreePlay(songs[curSelected].songName, curDifficulty, isCharting);
		clean();
	}

	/**
	 * Load into a song in free play, by name.
	 * This is a static function, so you can call it anywhere.
	 * @param songName The name of the song to load. Use the human readable name, with spaces.
	 * @param isCharting If true, load into the Chart Editor instead.
	 */
	public static function loadSongInFreePlay(songName:String, difficulty:Int, isCharting:Bool, reloadSong:Bool = false)
	{
		// Make sure song data is initialized first.
		if (songData == null || Lambda.count(songData) == 0)
			populateSongData();

		var currentSongData;
		try
		{
			if (songData.get(songName) == null)
				return;
			currentSongData = songData.get(songName)[0];
			if (songData.get(songName)[0] == null) //	!!!
				return;
		}
		catch (ex)
		{
			return;
		}

		FlxG.sound.play(Paths.sound('confirmMenu'));

		PlayState.SONG = currentSongData;
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = difficulty;
		PlayState.storyWeek = songs[curSelected].week;
		PlayState.alreadyDied = false;
		PlayState.dedCounter = 0;
		Debug.logInfo('Loading song ${PlayState.SONG.songName} from week ${PlayState.storyWeek} into Free Play...');
		#if FEATURE_STEPMANIA
		if (songs[curSelected].songCharacter == "sm")
		{
			Debug.logInfo('Song is a StepMania song!');
			PlayState.isSM = true;
			PlayState.sm = songs[curSelected].sm;
			PlayState.pathToSm = songs[curSelected].path;
		}
		else
			PlayState.isSM = false;
		#else
		PlayState.isSM = false;
		#end

		PlayState.songMultiplier = rate;

		if (isCharting)
			LoadingState.loadAndSwitchState(new ChartingState(reloadSong));
		else
			LoadingState.loadAndSwitchState(new PlayState());
	}

	function excludeWeeks(dir:Int)
	{
		// doesn't actually exclude "weeks", but rather all characters except the one in focus
		curSelected = 0;
		exclusionaryZone += dir;

		exclusionTimer = 0.2;

		if (exclusionaryZone < 0)
			exclusionaryZone = 4;
		if (exclusionaryZone > 4)
			exclusionaryZone = 0;

		grpSongs.clear();
		iconArray.clear();

		populateSongData();

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		changeSelection();
	}

	override function stepHit()
	{
		super.stepHit();
	}

	var measureFinder:Int = 0;
	var backAndForth:Int = 1;

	override function beatHit()
	{
		super.beatHit();

		measureFinder++;
		backAndForth *= -1;
		if (measureFinder > 3)
			measureFinder = 0;

		iconArray.forEach(function(icon)
		{
			if (!icon.nonDancer)
			{	
				icon.scale.set(0.98,0.98);
				icon.updateHitbox();
				//icon.angle = 6;
			}
		});

		if (!iconArray.members[curSelected].nonDancer)
		{
			iconArray.members[curSelected].scale.set(1.2,1.2);
			iconArray.members[curSelected].updateHitbox();
			iconArray.members[curSelected].angle = 8 * backAndForth;
		}

		if (mercyPNG != null)
		{
			mercyPNG.scale.set(0.2,0.2);
			mercyPNG.updateHitbox();
		}
		

		var	varInt:Int = 1;
		
		bgVariety.forEach(function(spr:FlxSprite)
		{
			switch(varInt)
			{
				case 1:
					spr.animation.play('idle', false);
				case 2 | 3:
					if (weeksBeaten[varInt] && measureFinder % 2 == 0)
						spr.animation.play('idle', true);
					else if (!weeksBeaten[varInt] && measureFinder % 4 == 0)
						spr.animation.play('idle', true);
			}

			varInt++;
		});
	}

	function changeDiff(change:Int = 0)
	{
		if (songs.length == 0)
		{
			curDifficulty = 0;
			return;
		}

		if (change != 0)
			FlxG.sound.play(Paths.sound('boop'), 0.4);

		curDifficulty += change;

		if (!songs[curSelected].isEX)
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

		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		#end
		//diffCalcText.text = 'RATING: ${DiffCalc.CalculateDiff(songData.get(songs[curSelected].songName)[curDifficulty])}';
		diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();
	}

	function changeSelection(change:Int = 0)
	{
		if (songs.length == 0)
		{
			curSelected = 0;
			return;
		}

		measureFinder = 0;

		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		curWeek = songs[curSelected].week;

		changeDiff();

		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		// lerpScore = 0;
		#end

		//diffCalcText.text = 'RATING: ${DiffCalc.CalculateDiff(songData.get(songs[curSelected].songName)[curDifficulty])}';
		diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();
		
		#if PRELOAD_ALL
		if (songs[curSelected].songCharacter == "sm")
		{
			var data = songs[curSelected];
			//trace("Loading " + data.path + "/" + data.sm.header.MUSIC);
			var bytes = File.getBytes(data.path + "/" + data.sm.header.MUSIC);
			var sound = new Sound();
			sound.loadCompressedDataFromByteArray(bytes.getData(), bytes.length);
			FlxG.sound.playMusic(sound);
		}
		else
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var hmm;
		try
		{
			hmm = songData.get(songs[curSelected].songName)[0];
			if (hmm != null)
			{
				Conductor.changeBPM(hmm.bpm);
			}
		}
		catch(ex)
		{}

		if (openedPreview)
		{
			closeSubState();
			openSubState(new DiffOverview());
		}

		iconArray.forEach(function(icon)
		{
			icon.alpha = 0.4;
		});

		iconArray.members[curSelected].alpha = 1;

		var lmaoInt:Int = 1;

		bgVariety.forEach(function(spr:FlxSprite)
		{
			if (songs[curSelected].songCharacter.startsWith(childArray[lmaoInt]))
			{
				spr.alpha = 1.0;
				spr.scale.set(1.05,1.05);
			}
			else
			{
				if (exclusionaryZone != 0)
					spr.alpha = 0;
				else
					spr.alpha = 0.2;
				spr.scale.set(1.0,1.0);
			}

			lmaoInt++;
		});

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.4;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	#if sys
	public var sm:SMFile;
	public var path:String;
	#end
	public var songCharacter:String = "";

	public var diffs = [];

	public var isEX:Bool = false;

	#if sys
	public function new(song:String, week:Int, songCharacter:String, ?sm:SMFile = null, ?path:String = "")
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.sm = sm;
		this.path = path;
	}
	#else
	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
	#end
}
