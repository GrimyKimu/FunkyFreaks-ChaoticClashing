package; 
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';
	var isLoud:Bool;
	var talkingRight:Bool = true;

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(?dialogueList:Array<String>)
	{
		super();

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);

		var hasDialog = true;
		box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('normal', 'speech bubble normal1 ', 24, true);
		box.animation.addByPrefix('loudOpen', 'speech bubble loud open ', 24, false);
		box.animation.addByPrefix('loud', 'AHH speech bubble ', 24, true);
		

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
	
		//other portraits
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('portraits/chaosPortraits', 'shared');

		portraitLeft.animation.addByPrefix('sheol-normal', 'SheolNormal', 24, true);
		portraitLeft.animation.addByPrefix('sheol-surprise', 'SheolSurprise', 24, true);
		portraitLeft.animation.addByPrefix('sheol-serious', 'SheolSerious', 24, true);
		portraitLeft.animation.addByPrefix('sheol-pout', 'SheolPout', 24, true);
		portraitLeft.animation.addByPrefix('sheol-true', 'SheolHorror', 24, true);
		portraitLeft.animation.addByPrefix('dari-normal', 'DariNormal', 24, true);
		portraitLeft.animation.addByPrefix('dari-diss', 'DariDiss', 24, true);

		portraitLeft.scale.set(1.25, 1.25);
		portraitLeft.x += 130;
		portraitLeft.y += 145;
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		
		//bf's portraits
		portraitRight = new FlxSprite(-20, 40);
		portraitRight.frames = Paths.getSparrowAtlas('portraits/boyfriendPortrait', 'shared');
		portraitRight.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
		portraitRight.updateHitbox();
		portraitRight.y -= 50;
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		

		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);
		box.screenCenter(X);
		box.y += 300;
		
		

		handSelect = new FlxSprite(FlxG.width, FlxG.height).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'VCR OSD MONO Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'VCR OSD MONO Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (!talkingRight)
		{
			box.flipX = true;
		}
		else
		{
			box.flipX = false;
		}

		dropText.text = swagDialogue.text;

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

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
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
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;

		if (curCharacter == 'dad')
		{
			portraitRight.visible = false;
			if (!portraitLeft.visible)
			{
				portraitLeft.visible = true;
				talkingRight = false;
				portraitLeft.animation.play('enter');
			}
		}
		else if (curCharacter == 'bf')
		{
			portraitLeft.visible = false;
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
			if (!portraitRight.visible)
			{
				talkingRight = true;
				portraitRight.visible = true;
				portraitRight.animation.play('enter');
			}
		}
		else if (curCharacter.startsWith('dari'))
		{
			portraitRight.visible = false;
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('Speech_Darian'), 0.5)];
			talkingRight = false;
			portraitLeft.visible = true;
			portraitLeft.animation.play(curCharacter);
		}
		else if (curCharacter.startsWith('sheol'))
		{
			portraitRight.visible = false;
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('Speech_Sheol'), 0.5)];
			talkingRight = false;
			portraitLeft.visible = true;
			portraitLeft.animation.play(curCharacter);
		}

		if (isLoud)
		{
			if (box.animation.curAnim.name == 'loud')
			{
				return;
			}
			else
			{
				box.animation.play('loudOpen');
			}
		}
		else
		{
			if (box.animation.curAnim.name == 'normal')
			{
				return;
			}
			else
			{
				box.animation.play('normalOpen');
			}
		}

		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		if (splitName[2] == 'loud')
		{
			isLoud = true;
		}
		else
		{
			isLoud = false;
		}
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[2].length + 3).trim();
	}
}
