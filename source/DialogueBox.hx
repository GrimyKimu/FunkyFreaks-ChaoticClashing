package;

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
	var box:FlxSprite;

	var curCharacter:String = '';
	var isLoud:Bool;
	var talkingRight:Bool = true;

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	var swagDialogue:FlxTypeText;

	public var finishThing:Void->Void;

	var curSong:String = '';
	var postGame:Bool = false;
	var deathCount:Int = 0;

	private var curSlide:Int = 0; //the current slide being shown
	private var slidesToBeLoad:Int = 0; //initialized in create(), determines how many images to load in per cutscene

	var sound:FlxSound;

	public function new(?dialogueList:Array<String>, curSong:String, postGame:Bool)
	{
		super();

		deathCount = PlayState.dedCounter;

		var bg:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		this.curSong = curSong;
		this.postGame = postGame;
		//trace(curSong);

		FlxG.sound.music.stop();

		this.dialogueList = dialogueList;
		if(cleanDialog())
			if(cleanDialog())
				cleanDialog();

		var changeSongName = StringTools.replace(curSong, "-", "");
		var afterString = '';

		if (postGame)
			afterString = '-after';

		for (i in 0...slidesToBeLoad)
		{
			//loads the graphic "songName-afterString-index", then forcefully inserts the loaded png
			//into a specific spot in the member[] array, making it easier to access again
			//does this for every single slide that needs to be loaded, going from the 1st at index 0 in the array
			var notI = i + 1;
			trace("loading: " + 'story CGs/$changeSongName' + '$afterString' + '-$notI');
			var yes = new FlxSprite(FlxG.width, FlxG.height).loadGraphic(Paths.image('story CGs/$changeSongName' + afterString + '-$notI'));
			yes.alpha = 0;
			yes.scrollFactor.set();
			yes.updateHitbox();
			yes.screenCenter();
			yes.antialiasing = FlxG.save.data.antialiasing;
			insert(i, yes);
		}
		curSlide = 0; //remember that index 0 is the FIRST object in any array!
		trace("success in loading all the story CGs for this song");

		/*
		if (curSong == 'sain')
		{
			for (i in 0...3)
			{
				var yes:FlxSprite = new FlxSprite();
				yes.frames = Paths.getSparrowAtlas('menuVariety/sain-$i');
				//0 = sheol // 1 = blitz // 2 = dari // 3 = sain
				yes.screenCenter();
				yes.animation.addByPrefix('appear', 'appear', 24, true);
				yes.animation.addByPrefix('idle', 'idle', 24, true);
				yes.animation.addByPrefix('change', 'change', 24, true);
				yes.visible = StoryMenuState.savedChildren[i];

				yes.animation.play('appear', false);
				bgChildren['sain-$i'] = yes;
			}
		}*/
		
		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			members[curSlide].alpha += 1 / 5;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = true;
		box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('normal', 'speech bubble normal1 ', 24, true);
		box.animation.addByPrefix('loudOpen', 'speech bubble loud open ', 24, false);
		box.animation.addByPrefix('loud', 'AHH speech bubble ', 24, true);

		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);
		box.screenCenter(X);
		box.y += 300;

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'VCR OSD MONO Bold';
		swagDialogue.color = 0xFF3F2021;
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	private var bgChildren:Map<String, FlxSprite> = [];

	override function update(elapsed:Float)
	{
		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
			else if (box.animation.curAnim.name == 'loudOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('loud');
				dialogueOpened = true;
			}
		}

		if (curSong == 'sain')
		{
			for (i in 0...3)
			{
				/*
				if (bgChildren['sain-$i'].animation.curAnim.name != 'appear' || bgChildren['sain-$i'].animation.curAnim.name != 'change')
					bgChildren['sain-$i'].animation.play('idle', false);
				*/
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
			FlxG.sound.play(Paths.sound('clickText'), 0.4);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						members[curSlide].alpha -= 1 / 5;
						swagDialogue.alpha -= 1 / 5;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		var delayNum = 0.1;

		var oldSlide = curSlide;
		if(cleanDialog())
			if(cleanDialog())
				cleanDialog();

		if (isLoud)
		{
			if (box.animation.curAnim.name != 'loud')
			{
				box.animation.play('loudOpen');
			}
		}
		else
		{
			if (box.animation.curAnim.name != 'normal')
			{
				box.animation.play('normalOpen');
			}
		}

		if (curCharacter.toLowerCase().startsWith('dari') || curCharacter.toLowerCase().startsWith('scarfed'))
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dari_1'), 0.4),
				FlxG.sound.load(Paths.sound('dari_2'), 0.4),
				FlxG.sound.load(Paths.sound('dari_3'), 0.4)];

			delayNum = 0.045;
		}
		else if (curCharacter.toLowerCase().startsWith('sheol') || curCharacter.toLowerCase().startsWith('strange'))
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('sheol_0'), 0.3),
				FlxG.sound.load(Paths.sound('sheol_1'), 0.3)];

			delayNum = 0.035;
		}
		else if (curCharacter.toLowerCase().startsWith('blitz') || curCharacter.toLowerCase().startsWith('cat'))
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('blitz_0'), 0.4), 
				FlxG.sound.load(Paths.sound('blitz_1'), 0.4), FlxG.sound.load(Paths.sound('blitz_2'), 0.4), 
				FlxG.sound.load(Paths.sound('blitz_3'), 0.4)];

			delayNum = 0.04;
		}
		else if (curCharacter.toLowerCase().startsWith('bf'))
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bf_ai'), 0.5), 
				FlxG.sound.load(Paths.sound('bf_ii'), 0.5), FlxG.sound.load(Paths.sound('bf_ah'), 0.5)];

			delayNum = 0.03;
		}
		else if (curCharacter.toLowerCase().startsWith('sain'))
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('sain_0'), 0.4), 
				FlxG.sound.load(Paths.sound('sain_1'), 0.4), FlxG.sound.load(Paths.sound('sain_2'), 0.4),
				FlxG.sound.load(Paths.sound('sain_3'), 0.4)];

			delayNum = 0.05;
		}
		else
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

			delayNum = 0.05;
		}

		if (oldSlide != curSlide)
		{
			FlxTween.tween(members[oldSlide], {alpha: 0}, 1.2, {ease: FlxEase.linear, type: ONESHOT});
			FlxTween.tween(members[curSlide], {alpha: 1}, 0.4, {ease: FlxEase.linear, type: ONESHOT});
		}

		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(delayNum, true);
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
			bgChildren['sain-$rescueVar'].animation.play('appear', true);
			bgChildren['sain-$rescueVar'].visible = true;

			return true;
		}

		curCharacter = splitName[1];

		if (splitName[0] == 'loud')
		{
			isLoud = true;
		}
		else
		{
			isLoud = false;
		}
		dialogueList[0] = dialogueList[0].substr(splitName[0].length + 1).trim();
		dialogueList[0].replace('death_count', '$deathCount');
		return false;
	}
}
