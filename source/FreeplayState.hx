package;
import lime.app.Application;
import openfl.utils.Future;
import openfl.media.Sound;
import flixel.system.FlxSound;
#if sys
import smTools.SMFile;
import sys.FileSystem;
import sys.io.File;
#end
import Song.SwagSong;
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
	var previewtext:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	public static var openedPreview = false;

	public static var songData:Map<String,Array<SwagSong>> = [];

	private var weeksBeaten:Array<Bool> = FlxG.save.data.weeksBeaten;
	private var bgVariety:FlxTypedGroup<FlxSprite>;

	public static function loadDiff(diff:Int, format:String, name:String, array:Array<SwagSong>)
	{
		try 
		{
			array.push(Song.loadFromJson(Highscore.formatSong(format, diff), name));
		}
		catch(ex)
		{
			trace('failure to load the diff for $name');
		}
	}

	override function create()
	{
		clean();
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('data/freeplaySonglist'));

		//var diffList = "";

		songData = [];
		songs = [];

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			var meta = new SongMetadata(data[0], Std.parseInt(data[2]), data[1]);
			var format = meta.songName.toLowerCase();

			if (Std.parseInt(data[3]) != 0)
			{
				meta.isEX = true;
			}

			if (weeksBeaten[meta.week] != true)
			{
				//if the week the song is attached to hasn't been beaten yet, skip loading it
				//this way you cannot access specific songs in freeplay until you've beaten the required week
				continue;
			}

			var diffs = [];
			var diffsThatExist = [];

			#if sys
			/*
			if (FileSystem.exists('assets/data/${format}/${format}-hard.json'))
				diffsThatExist.push("Hard");
			if (FileSystem.exists('assets/data/${format}/${format}-easy.json'))
				diffsThatExist.push("Easy");
			*/

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
			/*if (diffsThatExist.contains("Easy"))
				FreeplayState.loadDiff(0,format,meta.songName,diffs);*/
			if (diffsThatExist.contains("Normal"))
				FreeplayState.loadDiff(1,format,meta.songName,diffs);
			/*if (diffsThatExist.contains("Hard"))
				FreeplayState.loadDiff(2,format,meta.songName,diffs);*/
			if (diffsThatExist.contains("False"))
				FreeplayState.loadDiff(1,format,meta.songName,diffs);
			if (diffsThatExist.contains("True"))
				FreeplayState.loadDiff(1,format,meta.songName,diffs);

			meta.diffs = diffsThatExist;

			//trace("Found Diffs: " + diffsThatExist);

			FreeplayState.songData.set(meta.songName,diffs);
			//trace('loaded diffs for ' + meta.songName);
			songs.push(meta);
		}

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		persistentUpdate = true;

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(144, 90, 111));
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		bgVariety = new FlxTypedGroup<FlxSprite>();
		add(bgVariety);

		if (weeksBeaten[0])
		{
			if (weeksBeaten[1])
			{
				var yes:FlxSprite = new FlxSprite(-100);
				yes.frames = Paths.getSparrowAtlas('menuVariety/sheol');
				yes.animation.addByPrefix('idle', 'sheol_beaten', 24, true);
				yes.alpha = 0.5;
				bgVariety.add(yes);
			}
			else
			{
				var yes:FlxSprite = new FlxSprite(-100);
				yes.frames = Paths.getSparrowAtlas('menuVariety/sheol');
				yes.animation.addByPrefix('idle', 'sheol_menace', 24, true);
				bgVariety.add(yes);
			}

			if (weeksBeaten[2])
			{
				var yes:FlxSprite = new FlxSprite(-100);
				yes.frames = Paths.getSparrowAtlas('menuVariety/blitz');
				yes.animation.addByPrefix('idle', 'blitz_beaten', 24, true);
				yes.alpha = 0.5;
				bgVariety.add(yes);
			}
			else
			{
				var yes:FlxSprite = new FlxSprite(-100);
				yes.frames = Paths.getSparrowAtlas('menuVariety/blitz');
				yes.animation.addByPrefix('idle', 'blitz_menace', 24, true);
				bgVariety.add(yes);
			}

			if (weeksBeaten[3])
			{
				var yes:FlxSprite = new FlxSprite(-100);
				yes.frames = Paths.getSparrowAtlas('menuVariety/dari');
				yes.animation.addByPrefix('idle', 'dari_beaten', 24, true);
				yes.alpha = 0.5;
				bgVariety.add(yes);
			}
			else
			{
				var yes:FlxSprite = new FlxSprite(-100);
				yes.frames = Paths.getSparrowAtlas('menuVariety/dari');
				yes.animation.addByPrefix('idle', 'dari_menace', 24, true);
				bgVariety.add(yes);
			}
		}
		else
		{
			var yes:FlxSprite = new FlxSprite(-100);
			yes.frames = Paths.getSparrowAtlas('menuVariety/menuBG');
			yes.animation.addByPrefix('idle', 'menuBG', 24, true);
			yes.alpha = 0.5;
			bgVariety.add(yes);
		}

		bgVariety.forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set();
			spr.updateHitbox();
			spr.screenCenter();
			spr.antialiasing = FlxG.save.data.antialiasing;
			spr.animation.play('idle');
			add(spr);
		});

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		if (songs.length != 0)
		{
			for (i in 0...songs.length)
			{
				var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
				songText.isMenuItem = true;
				songText.targetY = i;
				grpSongs.add(songText);
	
				var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
				icon.sprTracker = songText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}
		else
		{
			var sorryText:Alphabet = new Alphabet(0, 30, "Play through story mode to unlock songs!", true, false, true);
			sorryText.isMenuItem = true;
			sorryText.targetY = 0;
			grpSongs.add(sorryText);

			var icon:HealthIcon = new HealthIcon('face');
			icon.sprTracker = sorryText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 135, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		diffCalcText = new FlxText(scoreText.x, scoreText.y + 66, 0, "", 24);
		diffCalcText.font = scoreText.font;
		add(diffCalcText);

		previewtext = new FlxText(scoreText.x, scoreText.y + 94, 0, "Rate: " + rate + "x", 24);
		previewtext.font = scoreText.font;
		add(previewtext);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		add(comboText);

		add(scoreText);

		changeSelection();
		changeDiff();

		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		if (FlxG.sound.music.volume > 0.8)
		{
			FlxG.sound.music.volume -= 0.5 * FlxG.elapsed;
		}

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = FlxG.keys.justPressed.ENTER;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

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
		{
			if (weeksBeaten[0])
			{
				trace('enter press: I\'m tryin here! CurDiff = ' + curDifficulty);

				var hmm;
				var indexArrayBullshit:Int = 0;

				switch (curDifficulty)
				{
					case 1:
						indexArrayBullshit = 0;
					case 3:
						indexArrayBullshit = 0;
					case 4:
						indexArrayBullshit = 1;
				}

				hmm = songData.get(songs[curSelected].songName)[indexArrayBullshit];
				if (hmm == null)
				{
					trace("FUCK! It's coming out as null, no wonder it's fucked");
					return;
				}

				FlxG.sound.play(Paths.sound('confirmMenu'));

				PlayState.SONG = Song.conversionChecks(hmm);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				PlayState.storyWeek = songs[curSelected].week;
				trace('CUR WEEK: ' + PlayState.storyWeek);			
				PlayState.alreadyDied = false;
				PlayState.dedCounter = 0;
				PlayState.isSM = false;
				PlayState.songMultiplier = rate;

				LoadingState.loadAndSwitchState(new PlayState());
				clean();
			}
			else
			{
				FlxG.sound.play(Paths.sound('nope'), 1.4);
			}
		}
		

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
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

		//curWeek = songs[curSelected].week;

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
			hmm = songData.get(songs[curSelected].songName)[curDifficulty];
			if (hmm != null)
				Conductor.changeBPM(hmm.bpm);
		}
		catch(ex)
		{}

		if (openedPreview)
		{
			closeSubState();
			openSubState(new DiffOverview());
		}

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
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
