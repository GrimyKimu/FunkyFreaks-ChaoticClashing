package;

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

	var sound:FlxSound;

	public function new(?dialogueList:Array<String>, curSong:String, postGame:Bool)
	{
		super();

		finishedTyping = false;

		deathCount = PlayState.dedCounter;

		bg = new FlxSprite().makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.BLACK);
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);
		
		this.curSong = curSong;
		this.postGame = postGame;
		//trace(curSong);

		FlxG.sound.music.stop();

		this.dialogueList = dialogueList;
		for(i in 0...999999999)
		{
			if (!cleanDialog())
				break;
		}

		switch (curSong)
		{
			case 'm-e-m-e':
				curSong = 'meme';
			case 'murderous-blitz':
				curSong = 'MB';
			case 'kittycat-sonata':
				curSong = 'KCS';
		}
		var afterString = '';

		if (postGame)
			afterString = '-after';
		
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

		swagDialogue = new FlxTypeText(FlxG.width * 0.05, FlxG.height * 0.05, Std.int(FlxG.width * 0.9), "", 36);
		swagDialogue.font = 'VCR OSD MONO Bold';
		swagDialogue.color = FlxColor.WHITE;
		swagDialogue.setTypingVariation(0.95, true);
		swagDialogue.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
		swagDialogue.finishSounds = true;
		swagDialogue.autoSize = false;
		swagDialogue.alignment = FlxTextAlign.CENTER;
		add(swagDialogue);

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
					endDialogue();
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
			endDialogue();

		super.update(elapsed);
	}

	public function trueStart():Void
	{
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			FlxTween.tween(members[curSlide], {alpha: 1}, 1.1, {ease: FlxEase.linear, type: ONESHOT});
			FlxTween.tween(bg, {alpha: 0}, 1.1, {ease: FlxEase.linear, type: ONESHOT});
		});
	}

	function endDialogue():Void
	{
		if (!isEnding)
		{
			FlxG.sound.play(Paths.sound('endText','shared'), 0.4);
			isEnding = true;

			new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
				members[curSlide].alpha -= 1 / 5;
				swagDialogue.alpha -= 1 / 5;
			}, 5);

			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
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
			//yeah yeah, this is a stupid funkin way to do this, but whatever
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

	function cleanDialog():Bool
	{
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
}
