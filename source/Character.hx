package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var dumbVar:Bool = false;
	public var triggeredAlready:Bool = false;
	
	var dumTimer:FlxTimer;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		if(FlxG.save.data.antialiasing)
			{
				antialiasing = true;
			}

		switch (curCharacter)
		{
			case 'gf':
			{
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
			}
			case 'gf-wSheol':
			{
				frames = Paths.getSparrowAtlas('characters/gfwSheol');
				animation.addByPrefix('sad', 'gf sad', 24, false);
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft-idle', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight-idle', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('danceLeft-alt', 'GF ALT', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight-alt', 'GF ALT', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				
				addOffset('sad', 0, -15);	// 669 * 636 // x = -21.6?
				addOffset('danceLeft-idle', 0, 0);	//712 * 651
				addOffset('danceRight-idle', 0, 0);
				addOffset('danceLeft-alt', 0, 75);	//712 * 726
				addOffset('danceRight-alt', 0, 75);
				playAnim('danceRight-idle');
			}
			case 'gf-wSheol2':
			{
				frames = Paths.getSparrowAtlas('characters/gfwSheol_cheer');
				animation.addByPrefix('cheer', 'gf cheer', 24, false);
				animation.addByIndices('yes', 'gf cheer', [1], "", 1, true);

				addOffset('cheer', 50, 120);	//759 * 771
				addOffset('yes', 50, 120);	//759 * 771

				playAnim('yes');
			}
			case 'bf':
			{
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
				frames = tex;

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;
			}
			case 'bf-goner':
			{
				//the sole purpose of this "character" is only so I can have a custom death anim, lmao
				frames = Paths.getSparrowAtlas('characters/bfGoner');
				animation.addByPrefix('singUP', "bf GONER start", 24, false);
				animation.addByPrefix('firstDeath', "bf GONER start", 24, false);
				animation.addByPrefix('deathLoop', "bf GONER loop", 24, true);
				animation.addByPrefix('deathConfirm', "bf GONER end", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -34, -36);
				addOffset('deathConfirm', -35, 60);
				playAnim('firstDeath');
				updateHitbox();
				flipX = true;
			}
				
			case 'sheol':
			{
				frames = Paths.getSparrowAtlas('characters/sheol_assets');
				animation.addByPrefix('idle', 'Normal Idle', 24, false);
				animation.addByPrefix('singUP', 'Normal Up', 24, true);
				animation.addByPrefix('singDOWN', 'Normal Down', 24, true);
				animation.addByPrefix('singLEFT', 'Normal Left', 24, true);
				animation.addByPrefix('singRIGHT', 'Normal Right', 24, true);

				addOffset('idle', 0, 0);
				addOffset("singUP", 164, 7);
				addOffset("singRIGHT", 7, 3);
				addOffset("singLEFT", 174, -5);
				addOffset("singDOWN", -20, -50);

				playAnim('idle');
			}
			case 'sheol-angry':
			{
				frames = Paths.getSparrowAtlas('characters/sheol_angry');
				animation.addByPrefix('idle', 'Angry Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Up', 24, true);
				animation.addByPrefix('singDOWN', 'Angry Down', 24, true);
				animation.addByPrefix('singLEFT', 'Angry Left', 24, true);
				animation.addByPrefix('singRIGHT', 'Angry Right', 24, true);

				animation.addByPrefix('idle-alt', 'Angry-Alt Idle', 24, false);
				animation.addByPrefix('singUP-alt', 'Angry-Alt Up', 24, true);
				animation.addByPrefix('singDOWN-alt', 'Angry-Alt Down', 24, true);
				animation.addByPrefix('singLEFT-alt', 'Angry-Alt Left', 24, true);
				animation.addByPrefix('singRIGHT-alt', 'Angry-Alt Right', 24, true);
				//the plan is to utilize 'idle-alt' as an animation that will play at the end of the song, Chaos.

				addOffset('idle');
				addOffset('idle-alt');
				addOffset("singUP", 155, -12);
				addOffset("singRIGHT", 126, -26);
				addOffset("singLEFT", 65, -15);
				addOffset("singDOWN", 175, -68);
				addOffset("singUP-alt", 163, 2);
				addOffset("singRIGHT-alt", 117, 1);
				addOffset("singLEFT-alt", 19, -10);
				addOffset("singDOWN-alt", -3, -45);

				playAnim('idle');
			}
			case 'sheol-horror':
			{
				frames = Paths.getSparrowAtlas('characters/sheol_horror');
				animation.addByPrefix('idle', 'Horror Idle', 24, true);
				animation.addByPrefix('singUP', 'Horror Up', 24, true);
				animation.addByPrefix('singDOWN', 'Horror Down', 24, true);
				animation.addByPrefix('singLEFT', 'Horror Left', 24, true);
				animation.addByPrefix('singRIGHT', 'Horror Right', 24, true);

				animation.addByPrefix('singUP-alt', 'Horror AltUp', 24, true);
				animation.addByPrefix('singDOWN-alt', 'Horror AltDown', 24, true);
				animation.addByPrefix('singLEFT-alt', 'Horror AltLeft', 24, true);
				animation.addByPrefix('singRIGHT-alt', 'Horror AltRight', 24, true);

				addOffset('idle', 0, 0);
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
				addOffset("singUP-alt", 0, 0);
				addOffset("singRIGHT-alt", 0, 0);
				addOffset("singLEFT-alt", 0, 0);
				addOffset("singDOWN-alt", 0, 0);

				playAnim('idle');
			}
			case 'dari':
			{
				frames = Paths.getSparrowAtlas('characters/dari_assets');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'Down Note', 24, false);
				animation.addByPrefix('singLEFT', 'Left Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Right Note', 24, false);
				animation.addByPrefix('wave', 'Waving', 24, false);

				addOffset('idle');		//664 * 674
				addOffset("singUP", 67, -1);	//774 * 673
				addOffset("singRIGHT", -52, -1);	//593 * 674
				addOffset("singLEFT", 55, -1);	//542 * 673
				addOffset("singDOWN", -59, -1);	//491 * 673
				addOffset("wave", 46, 92);

				playAnim('idle');
			}
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public function loadOffsetFile(character:String)
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.txt('images/characters/' + character + "Offsets", 'shared'));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(forced:Bool = false)
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-wSheol':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;
						if (!dumbVar)
						{
							if (danced)
								playAnim('danceRight-idle');
							else
								playAnim('danceLeft-idle');
						}
						else
						{
							if (danced)
								playAnim('danceRight-alt');
							else
								playAnim('danceLeft-alt');
						}
					}
				case 'gf-wSheol2':
					if (dumbVar && !triggeredAlready && animation.curAnim.name != 'cheer')
						{
							playAnim('cheer');
							dumTimer = new FlxTimer().start(6, function(tmr:FlxTimer)
								{triggeredAlready = true;});
						}
				case 'dari':
				{
					if (dumbVar && !triggeredAlready)
					{
						playAnim('wave');
						triggeredAlready = true;

					}
					else if (animation.curAnim.name != 'wave' || !animation.curAnim.name.startsWith('sing'))
					{
						playAnim('idle');
					}
				}
				default:
					playAnim('idle', forced);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
