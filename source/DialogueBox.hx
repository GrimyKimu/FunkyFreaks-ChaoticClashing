package;

import flixel.system.FlxSplash;
import flixel.util.FlxAxes;
import flixel.math.FlxRandom;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput.FlxInputState;
import haxe.macro.Expr.Case;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var curCharacter:String = '';
	var isLoud:Bool;
	var talkingRight:Bool = true;
	var speedoTalk:Float = 1.0;

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	var swagDialogue:FlxTypeText;

	public var finishThing:Void->Void;

	private var bg:FlxSprite;

	var curSong:String = '';
	var postGame:Bool = false;
	var deathCount:Int = 0;

	private var curSlide:Int = 0; //the current slide being shown
	private var slidesToBeLoad:Int = 0; //initialized in create(), determines how many images to load in per cutscene

	private var staticFront:FlxSprite = new FlxSprite().loadGraphic(Paths.image('staticLayer', 'shared'));
	private var colorFlash:FlxSprite;

	private var activeDialogue:Bool = false;

	public function new(?whatDialogue:Array<String>, curSong:String, postGame:Bool, didDie:Bool = false)
	{
		super();

		finishedTyping = false;

		deathCount = PlayState.dedCounter;
		
		this.curSong = curSong;
		this.postGame = postGame;
		//trace(curSong);

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		this.dialogueList = whatDialogue;

		cleanDialog();

		switch (curSong)
		{
			case 'marenol':
				deathCount = deathCount * 321321;
			case 'm-e-m-e':
				curSong = 'meme';
			case 'murderous-blitz':
				curSong = 'MB';
				deathCount = FlxG.save.data.blitzDeaths;
				if (didDie)
					for (i in 0...dialogueList.length)
						if (dialogueList[i] != dialogueList[deathCount])
							dialogueList.remove(dialogueList[i]);
			case 'kittycat-sonata':
				curSong = 'KCS';
		}

		var afterString = '';
		if (postGame)
			afterString = '-after';
		
		if (slidesToBeLoad != 0)
		{
			for (i in 0...slidesToBeLoad)
			{
				//loads the graphic "songName-afterString-index", then forcefully inserts the loaded png
				//into a specific spot in the member[] array, making it easier to access again
				//does this for every single slide that needs to be loaded, going from the 1st at index 0 in the array
				var notI = i + 1;
				trace("loading: " + 'story CGs/$curSong' + '$afterString' + '-$notI');
				var yes = new FlxSprite(FlxG.width, FlxG.height).loadGraphic(Paths.image('story CGs/$curSong' + afterString + '-$notI'));
				yes.alpha = 0;
				yes.scrollFactor.set();
				yes.updateHitbox();
				yes.screenCenter();
				yes.antialiasing = FlxG.save.data.antialiasing;
				insert(i, yes);
			}
			trace("success in loading all the story CGs for this song");	
		}
		else
			trace("skipping the CGs for some reason?");	

		
		/*if (curSong == 'sain')
		{
			for (i in 0...3)
			{
				var yes:FlxSprite = new FlxSprite();
				yes.frames = Paths.getSparrowAtlas('menuVariety/sain-$i');
				//0 = sheol // 1 = blitz // 2 = dari // 3 = sain
				yes.screenCenter();
				yes.animation.addByPrefix('appear', 'appear', 24, false);
				yes.animation.addByPrefix('idle', 'idle', 24, true);
				yes.animation.addByPrefix('change', 'change', 24, false);
				yes.visible = StoryMenuState.savedChildren[i];

				yes.animation.play('appear', false);
				bgChildren['sain-$i'] = yes;
			}
		}*/

		colorFlash = new FlxSprite().makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.RED);
		colorFlash.alpha = 0;
		colorFlash.scrollFactor.set();
		colorFlash.updateHitbox();
		colorFlash.screenCenter();
		add(colorFlash);

		swagDialogue = new FlxTypeText(FlxG.width * 0.05, FlxG.height * 0.05, Std.int(FlxG.width * 0.9), "", 36);
		swagDialogue.font = 'VCR OSD MONO Bold';
		swagDialogue.color = FlxColor.WHITE;
		swagDialogue.setTypingVariation(0.25, true);
		swagDialogue.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
		swagDialogue.finishSounds = true;
		swagDialogue.autoSize = false;
		swagDialogue.alignment = FlxTextAlign.CENTER;
		add(swagDialogue);

		staticFront.alpha = 0;
		add(staticFront);

		dialogueOpened = true;
		dialogue = new Alphabet(0, 80, "", false, true);
		startDialogue();
	}

	public function doneTyping():Void
	{
		finishedTyping = true;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var bgChildren:Map<String, FlxSprite> = [];
	var isEnding:Bool = false;
	var finishedTyping:Bool = false;

	var screenShake:Float = 0;
	var shakeMultiplier:Float = 0;

	override function update(elapsed:Float)
	{
		/*
		if (curSong == 'sain')
		{
			for (i in 0...3)
			{
				if ((bgChildren['sain-$i'].animation.curAnim.name != 'appear' || bgChildren['sain-$i'].animation.curAnim.finished) && bgChildren['sain-$i'].animation.curAnim.name != 'change')
					bgChildren['sain-$i'].animation.play('idle', false);
			}
		}
		*/

		staticFront.flipX = FlxG.random.bool(50);
		staticFront.flipY = FlxG.random.bool(50);

		if (screenShake != 0)
		{
			if (screenShake < 0.05)
				screenShake = 0;
			else
				screenShake *= shakeMultiplier;

			forEach(function(ohno:FlxSprite)
				{
					ohno.offset.set(screenShake * FlxG.random.float(-1.5, 1.5, [0.0]), screenShake * FlxG.random.float(-1.5, 1.5, [0.0]));
				});
		}

		if (dialogueOpened && !dialogueStarted)
		{
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true && !isEnding)
		{
			if (finishedTyping)
			{
				remove(dialogue);
	
				if (dialogueList[1] == null && dialogueList[0] != null)
				{
					endDialogue(false);
					finishedTyping = false;
				}
				else
				{
					FlxG.sound.play(Paths.sound('clickText','shared'), 0.4);
					dialogueList.remove(dialogueList[0]);
					startDialogue();
				}
			}
			else
			{
				swagDialogue.skip();
				doneTyping();
			}
		}

		if ((PlayerSettings.player1.controls.BACK || FlxG.keys.justPressed.ESCAPE) && dialogueStarted == true)
			endDialogue(false);

		super.update(elapsed);
	}

	public function trueStart():Void
	{
		activeDialogue = true;
		for(i in 0...999999999)
		{
			if (!cleanDialog())
				break;
		}

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			FlxTween.tween(members[curSlide], {alpha: 1}, 1.1, {ease: FlxEase.linear, type: ONESHOT});
			//FlxTween.tween(bg, {alpha: 0}, 1.1, {ease: FlxEase.linear, type: ONESHOT});
		});
	}

	public function endDialogue(outSide:Bool):Void
	{
		if (!isEnding)
		{
			FlxG.sound.play(Paths.sound('endText','shared'), 0.4);
			isEnding = true;

			if (FlxG.sound.music != null && curSong != 'sain')
			{
				if (outSide)
					FlxG.sound.music.stop();
				else
				{
					FlxG.sound.music.fadeIn(1.5, FlxG.sound.music.volume, 0.0);
				}
			}

			if (extraBGM != [])
			{
				FlxG.sound.list.forEach(function(yes:FlxSound){
					if (extraBGM.contains(yes))
						yes.stop();

				});
			}

			new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
				members[curSlide].alpha -= 1 / 5;
				swagDialogue.alpha -= 1 / 5;
			}, 5);

			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				if (!outSide)
					finishThing();
				kill();
				destroy();
			});
		}
	}

	function startDialogue():Void
	{
		var delayNum = 0.1;
		finishedTyping = false;

		var oldSlide = curSlide;
		for(i in 0...999999999)
		{
			// yeah yeah, this is a stupid funkin way to do this, but whatever
			if (!cleanDialog())
				break;
		}

		if (curCharacter.toLowerCase().startsWith('dari') || curCharacter.toLowerCase().startsWith('scarfed'))
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dari_1'), 0.4),
				FlxG.sound.load(Paths.sound('dari_2','shared'), 0.4),
				FlxG.sound.load(Paths.sound('dari_3','shared'), 0.4)];

			delayNum = 0.029;
		}
		else if (curCharacter.toLowerCase().startsWith('sheol') || curCharacter.toLowerCase().startsWith('strange'))
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('sheol_0','shared'), 0.3),
				FlxG.sound.load(Paths.sound('sheol_1','shared'), 0.3)];

			delayNum = 0.024;
		}
		else if (curCharacter.toLowerCase().startsWith('blitz') || curCharacter.toLowerCase().startsWith('cat'))
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('blitz_0'), 0.4), 
				FlxG.sound.load(Paths.sound('blitz_1','shared'), 0.4), FlxG.sound.load(Paths.sound('blitz_2','shared'), 0.4), 
				FlxG.sound.load(Paths.sound('blitz_3','shared'), 0.4)];

			delayNum = 0.026;
		}
		else if (curCharacter.toLowerCase().startsWith('bf'))
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bf_ai','shared'), 0.5), 
				FlxG.sound.load(Paths.sound('bf_ii','shared'), 0.5), FlxG.sound.load(Paths.sound('bf_ah','shared'), 0.5)];

			delayNum = 0.028;
		}
		else if (curCharacter.toLowerCase().startsWith('sain') || curCharacter.toLowerCase().startsWith('???'))
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('sain_0','shared'), 0.4), 
				FlxG.sound.load(Paths.sound('sain_1','shared'), 0.4), FlxG.sound.load(Paths.sound('sain_2','shared'), 0.4),
				FlxG.sound.load(Paths.sound('sain_3','shared'), 0.4)];

			delayNum = 0.03;
		}
		else
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText','shared'), 0.6)];

			delayNum = 0.015;
		}

		if (oldSlide != curSlide)
		{
			FlxTween.tween(members[oldSlide], {alpha: 0}, 0.7, {ease: FlxEase.linear, type: ONESHOT});
			FlxTween.tween(members[curSlide], {alpha: 1}, 0.6, {ease: FlxEase.linear, type: ONESHOT});
		}

		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(delayNum * speedoTalk, true, false, null, doneTyping);
		//trace('$delayNum + $speedoTalk');
	}

	var bgmList:Array<String>;
	var extraBGM:Array<FlxSound> = [];

	function cleanDialog():Bool
	{
		bgmList = CoolUtil.coolTextFile(Paths.txt('music/bgmData'));
		var splitName:Array<String> = dialogueList[0].split(":");
		
		if (splitName[0] == 'data')
		{
			slidesToBeLoad = Std.parseInt(splitName[1]);
			trace('Slides to be loaded: ' + '$slidesToBeLoad');
			dialogueList.remove(dialogueList[0]);
			return true;
		}

		if (splitName[0] == 'change')
		{
			curSlide = curSlide + Std.parseInt(splitName[1]);
			dialogueList.remove(dialogueList[0]);
			trace('Slide changed to: ' + curSlide);
			return true;
		}

		if (splitName[0] == 'bgm')
		{
			var bgmName:String = splitName[1];
			var fadeTimer = splitName[2] != null ? Std.parseFloat(splitName[2]) : 1.0;
			dialogueList.remove(dialogueList[0]);
			
			if (bgmName == 'stop')
			{
				trace('halting the song...');
				if (FlxG.sound.music != null)
				{
					if (fadeTimer == 1.0)
						FlxG.sound.music.pause();
					else
						FlxG.sound.music.fadeOut(fadeTimer,0.0);
				}

				return true;
			}

			if (bgmName == 'continue')
			{
				trace('continuing the song!');
				if (FlxG.sound.music != null)
				{
					if (fadeTimer == 1.0)
						FlxG.sound.music.play();
					else
					{
						FlxG.sound.music.volume = 0;
						FlxG.sound.music.fadeIn(fadeTimer, 0.0, 0.8);
					}
				}
				
				return true;
			}
			
			FlxG.sound.playMusic(Paths.music(bgmName, "shared"), 0, true);
			FlxG.sound.music.fadeIn(fadeTimer, 0, 0.4);

			if (bgmName == "sain")
			{
				for (i in 1...3)	
				{
					if (FlxG.save.data.weeksBeaten[i])
					{
						var moreSong = new FlxSound().loadEmbedded(Paths.music('sain' + i), true, true);
						moreSong.volume = 0;
						moreSong.fadeIn(fadeTimer, 0, 0.8);

						FlxG.sound.list.add(moreSong);
						extraBGM.push(moreSong);
					}
				}
			}

			for (bgm in bgmList)
			{
				if (bgm.startsWith(bgmName) && bgmName != "sain")
				{
					var bgmStats = bgm.split(":");
					FlxG.sound.music.loopTime = bgmStats[1] == null ? 0.0 : Std.parseFloat(bgmStats[1]);
					FlxG.sound.music.endTime = bgmStats[2] == null ? null : Std.parseFloat(bgmStats[2]);
					break;
				}
			}

			trace('playing song ' + '"$bgmName"');			
			return true;
		}

		if (splitName[0] == 'sfx')
		{
			// play wacky sound here
			var sfxName:String = splitName[1];
			var sfxVolume:Float = splitName[2] != null ? Std.parseFloat(splitName[2]) : 1.0;
			FlxG.sound.play(Paths.sound(sfxName), sfxVolume);
			
			trace('played sfx ' + '"$sfxName"');

			dialogueList.remove(dialogueList[0]);

			return true;
		}

		if (splitName[0] == 'vfx')
		{
			// cause wacky on-screen effects to occur here
			switch(splitName[1])
			{
				case "color":
					/**
					 * splitName[2 = starting alpha of the flash, 3 = duration of flash, 4 = string that becomes a color, 
					 * 5 = optional gradient color, if not null the color will fade from the first to the one set in this one
					 * 6 = optional timer for how long it takes for the gradient to complete its transition, if not set will default to half of flash duration]
					 */
					colorSplash(Std.parseFloat(splitName[2]),Std.parseFloat(splitName[3]),FlxColor.fromString(splitName[4]),
						splitName[5] == null ? null : FlxColor.fromString(splitName[5]), splitName[6] == null ? null : Std.parseFloat(splitName[6]));
				case "static":
					/**
					 * splitName[2 = starting alpha of static flash, 3 = duration of static flash]
					 */
					staticFlash(Std.parseFloat(splitName[2]),Std.parseFloat(splitName[3]));
				case "shake":
					/**
					 * splitName[2 = intensity of screen shaking, 3 = multiplier that determines how quickly the shaking ends, 1.0 makes it last infinitely]
					 */
					screenShake = Std.parseFloat(splitName[2]);
					shakeMultiplier = Std.parseFloat(splitName[3]);
				case "flip":
					/**
					 * splitName[2 = X, 3 = Y, doesn't matter what they're set to it just has to NOT be null]
					 */
					if (splitName[2] != null)
						flipX = !flipX;

					if (splitName[3] != null)
						flipY = !flipY;
			}
			
			//trace('played sfx ' + '"$sfxName"');

			dialogueList.remove(dialogueList[0]);


			return true;
		}

		if (splitName[0] == 'save')
		{
			var rescueVar = Std.parseInt(splitName[1]);
			dialogueList.remove(dialogueList[0]);
			StoryMenuState.savedChildren[rescueVar] = true;
			if (rescueVar != 3)
			{
				bgChildren['sain-$rescueVar'].animation.play('appear', true);
				bgChildren['sain-$rescueVar'].visible = true;
			}
			else
			{
				for (i in 0...3)
				{
					bgChildren['sain-$i'].animation.play('change', false);
				}
			}

			return true;
		}

		if (splitName[0] == 'end')
		{
			FlxG.save.data.weeksBeaten[4] = true;
			FlxG.save.flush();
			FlxG.resetGame();

			return true;
		}

		if (splitName[0] == 'loud')
		{
			speedoTalk = 0.75;
		}
		else
		{
			speedoTalk = 1.0;
		}

		curCharacter = splitName[1];		
		dialogueList[0] = dialogueList[0].substr(splitName[0].length + 1).trim();
		dialogueList[0] = dialogueList[0].replace('death_count', '$deathCount');
		return false;
	}

	function colorSplash(flashMax:Float, flashTimer:Float, whatColor:FlxColor, ?gradient:FlxColor, ?gradientTimer:Float)
	{
		colorFlash.color = whatColor;
		colorFlash.alpha = flashMax;

		if (gradientTimer == null)
		{
			gradientTimer == flashTimer * 0.5;
		}

		FlxTween.tween(colorFlash, {alpha: 0}, flashTimer, {ease: FlxEase.quadOut});

		if (gradient != null)
			FlxTween.color(colorFlash, gradientTimer, whatColor, gradient);
	}

	function staticFlash(staticAlpha:Float, duration:Float)
	{
		staticFront.alpha = staticAlpha;
		FlxTween.tween(staticFront, {alpha: 0}, duration);
	}
}
