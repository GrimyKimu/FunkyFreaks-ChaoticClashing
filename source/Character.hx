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
	private var danceArray:Array<String> = [];

	var dumTimer:FlxTimer;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = FlxG.save.data.antialiasing;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('GF_assets','shared',true);
				frames = tex;
				//cheer will be used as the animation of Blitz catching Sheol's music box in New-Puppet
				animation.addByPrefix('cheer', 'cheer', 24, false);
				animation.addByIndices('idle', 'cheer', [0, 1, 2, 3], "", 24, false);
				animation.addByIndices('danceLeft', 'NormalIdle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'NormalIdle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(curCharacter);
				dumbVar = true;

				playAnim('idle');
			case 'gf-none':
				tex = Paths.getSparrowAtlas('GF_assets','shared',true);
				frames = tex;
				//actually no
				animation.addByIndices('idle', 'cheer', [0, 1, 2, 3], "", 24, false);
				animation.addByIndices('danceLeft', 'NormalIdle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'NormalIdle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				visible = false;
			case 'gf-blitz':
				//the variation of "gf/blitz" during Kaos
				tex = Paths.getSparrowAtlas('GF_assets','shared',true);
				frames = tex;
				animation.addByIndices('danceLeft', 'ScaryIdle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'ScaryIdle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
			case 'gf-dari':
				//the variation of "gf/dari" during KC-S, where Dari has been broken...
				tex = Paths.getSparrowAtlas('gf_Dari','shared',true);
				frames = tex;
				animation.addByIndices('danceLeft', 'Idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
			case 'gf-wSheol':
				frames = Paths.getSparrowAtlas('characters/gfwSheol');
				animation.addByIndices('danceRight', 'Idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceLeft', 'Idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('danceLeft-alt', 'Idle ALT', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight-alt', 'Idle ALT', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('cheer', 'cheer', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
			case 'gf-marenol':
				frames = Paths.getSparrowAtlas('characters/gf_marenol');
				animation.addByIndices('idle-1', 'her eyes', [0,1,2,3,4,5], "", 24, true);
				animation.addByIndices('idle-2', 'her eyes', [6,7,8,9,10,11], "", 24, true);
				animation.addByIndices('idle-3', 'her eyes', [12,13,14,15,16,17], "", 24, true);

				animation.addByPrefix('drown', 'drowning', 24, true);
				animation.addByPrefix('suffer', 'suffering', 24, false);
				animation.addByPrefix('turnAround', 'turn around', 24, false);
				animation.addByPrefix('scream', 'screamer', 24, false);
				
				loadOffsetFile(curCharacter);
			dumbVar = true;
				playAnim('idle-1');
			case 'gf-madness': //D as Hank, B as theAuditor
				tex = Paths.getSparrowAtlas('gfMadness','shared',true);
				frames = tex;
				animation.addByPrefix('cheer', 'cheer', 24, false);
				animation.addByIndices('danceLeft', 'idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
			case 'gf-death': //B & D as sum Touhou gals
				tex = Paths.getSparrowAtlas('gfDeath','shared',true);
				frames = tex;
				animation.addByPrefix('cheer', 'cheer', 24, false);
				animation.addByIndices('danceLeft', 'idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('danceLeft-alt', 'alt', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight-alt', 'alt', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'bf':
				var tex = Paths.getSparrowAtlas('BOYFRIEND','shared',true);
				frames = tex;

				//trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);

				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				animation.addByPrefix('singUP-alt', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
			case 'bf-worry':
				var tex = Paths.getSparrowAtlas('bf_worried','shared',true);
				frames = tex;

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'NOTE DOWN0', 24, false);

				animation.addByPrefix('singUPmiss', 'NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'NOTE DOWN MISS', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
			case 'bf-marenol':
				var tex = Paths.getSparrowAtlas('bf_marenol_assets','shared',true);
				frames = tex;

				//trace(tex.frames.length);

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'singUP', 24, false);
				animation.addByPrefix('singLEFT', 'singLEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'singRIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'singDOWN', 24, false);

				animation.addByPrefix('singUPmiss', 'missUP', 24, false);
				animation.addByPrefix('singLEFTmiss', 'missLEFT', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'missRIGHT', 24, false);
				animation.addByPrefix('singDOWNmiss', 'missDOWN', 24, false);

				animation.addByPrefix('firstDeath', "ded start", 24, false);
				animation.addByPrefix('deathLoop', "ded idle", 24, false);
				animation.addByPrefix('deathConfirm', "ded end", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
			case 'bf-goner':
				//the sole purpose of this "character" is only so I can have a custom death anim, lmao
				frames = Paths.getSparrowAtlas('characters/bfGoner');
				animation.addByPrefix('firstDeath', "bf GONER start", 24, false);
				animation.addByPrefix('deathLoop', "bf GONER loop", 24, true);
				animation.addByPrefix('deathConfirm', "bf GONER end", 24, false);

				loadOffsetFile(curCharacter);
				playAnim('firstDeath');
				flipX = true;
			case 'bf-blitzDead': //Blitz's usual <3 
				//time for some more death lmao!
				frames = Paths.getSparrowAtlas('characters/blitzDead');
				animation.addByPrefix('firstDeath', "bf blitz start", 24, false);
				animation.addByPrefix('deathLoop', "bf blitz loop", 24, true);
				animation.addByPrefix('deathConfirm', "bf blitz end", 24, false);

				loadOffsetFile(curCharacter);
				playAnim('firstDeath');
				flipX = true;
			case 'bf-bonked': //byonk 
				//time for some more death lmao!
				frames = Paths.getSparrowAtlas('characters/bfBonk');
				animation.addByPrefix('firstDeath', "bf bonk start", 24, false);
				animation.addByPrefix('deathLoop', "bf bonk loop", 24, true);
				animation.addByPrefix('deathConfirm', "bf bonk end", 24, false);

				loadOffsetFile(curCharacter);
				playAnim('firstDeath');
				flipX = true;

			case 'sheol':
				frames = Paths.getSparrowAtlas('characters/sheol_assets');
				animation.addByIndices('danceLeft', 'Normal Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Normal Idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28], "", 24, false);
				animation.addByPrefix('singUP', 'Normal Up', 24, false);
				animation.addByPrefix('singDOWN', 'Normal Down', 24, false);
				animation.addByPrefix('singLEFT', 'Normal Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Normal Right', 24, false);

				animation.addByPrefix('idle-alt', 'MB Idle', 24, false);
				animation.addByPrefix('singUP-alt', 'MB Up', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'MB Right', 24, false);

				scale.set(.85, .85);
				loadOffsetFile(curCharacter);
				dumbVar = true;
				playAnim('idle-alt');
			case 'sheol-angry':
				frames = Paths.getSparrowAtlas('characters/sheol_angry');
				animation.addByPrefix('idle', 'Angry Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Up', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Down', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Right', 24, false);

				animation.addByPrefix('singUP-alt', 'Angry-Alt Up', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Angry-Alt Down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Angry-Alt Left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Angry-Alt Right', 24, false);

				scale.set(.85, .85);
				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'sheol-ex':
				frames = Paths.getSparrowAtlas('characters/sheolEX');
				animation.addByPrefix('idle', 'Angry Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Up', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Down', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Right', 24, false);

				animation.addByPrefix('singUP-alt', 'Angry-Alt Up', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Angry-Alt Down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Angry-Alt Left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Angry-Alt Right', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'sheol-horror':
				frames = Paths.getSparrowAtlas('characters/sheol_horror');

				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'SingUP', 24, false);
				animation.addByPrefix('singDOWN', 'SingDOWN', 24, false);
				animation.addByPrefix('singLEFT', 'SingLEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'SingRIGHT', 24, false);
				scale.set(2, 2);
				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'sheol-tiky':
				frames = Paths.getSparrowAtlas('characters/sheol-tiky');
				animation.addByPrefix('idle', 'tiky Idle', 24, true);
				animation.addByPrefix('singUP', 'tiky Up', 24, false);
				animation.addByPrefix('singDOWN', 'tiky Down', 24, false);
				animation.addByPrefix('singLEFT', 'tiky Left', 24, false);
				animation.addByPrefix('singRIGHT', 'tiky Right', 24, false);

				animation.addByPrefix('cheer', 'tiky cheer', 24, false);

				scale.set(.85, .85);
				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'sheol-witty':
				frames = Paths.getSparrowAtlas('characters/sheol-witty');
				animation.addByPrefix('idle', 'witty Idle', 24, false);
				animation.addByPrefix('singUP', 'witty Up', 24, false);
				animation.addByPrefix('singDOWN', 'witty Down', 24, false);
				animation.addByPrefix('singLEFT', 'witty Left', 24, false);
				animation.addByPrefix('singRIGHT', 'witty Right', 24, false);

				scale.set(.85, .85);
				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'sheol-flandre':
				frames = Paths.getSparrowAtlas('characters/sheol-flandre');

				animation.addByIndices('idle-A', 'flandre Idle', [0,1,2,3,4,5,6,7,8,9,10,11], "", 24, true);
				animation.addByIndices('idle-B', 'flandre Idle', [12,13,14,15,16,17,18,19,20,21,22,23], "", 24, true);
				animation.addByIndices('idle-C', 'flandre Idle', [24,25,26,27,28,29,30,31,32,33,34,35], "", 24, true);

				danceArray = ['idle-A','idle-B','idle-C'];

				animation.addByIndices('singUP', 'flandre Up', [0,1,2,3,4,5,6,7,8,9], "", 24, false);
				animation.addByIndices('singDOWN', 'flandre Down', [0,1,2,3,4,5,6,7,8,9], "", 24, false);
				animation.addByIndices('singLEFT', 'flandre Left', [0,1,2,3,4,5,6,7,8,9], "", 24, false);
				animation.addByIndices('singRIGHT', 'flandre Right', [0,1,2,3,4,5,6,7,8,9], "", 24, false);

				animation.addByIndices('singUP-alt', 'flandre Up', [10,11,12,13,14,15,16,17,18,19], "", 24, false);
				animation.addByIndices('singDOWN-alt', 'flandre Down', [10,11,12,13,14,15,16,17,18,19], "", 24, false);
				animation.addByIndices('singLEFT-alt', 'flandre Left', [10,11,12,13,14,15,16,17,18,19], "", 24, false);
				animation.addByIndices('singRIGHT-alt', 'flandre Right', [10,11,12,13,14,15,16,17,18,19], "", 24, false);

				scale.set(.85, .85);
				loadOffsetFile(curCharacter);
				playAnim('idle-A', true);			

			case 'dari':
				frames = Paths.getSparrowAtlas('characters/dari_assets');
				animation.addByPrefix('idle', 'Idle0', 24, false);
				animation.addByPrefix('singUP', 'Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'Down Note', 24, false);
				animation.addByPrefix('singLEFT', 'Left Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Right Note', 24, false);

				animation.addByPrefix('idle-alt', 'Idle-alt', 24, true);
				animation.addByPrefix('singDOWN-alt', 'Down alt', 24, false);

				animation.addByPrefix('cheer', 'stop', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'dari-serious':
				frames = Paths.getSparrowAtlas('characters/dari_assets');
				animation.addByPrefix('idle', 'Idle0', 24, false);
				animation.addByPrefix('singUP', 'Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'Down Note', 24, false);
				animation.addByPrefix('singLEFT', 'Left Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Right Note', 24, false);

				animation.addByPrefix('idle-alt', 'Idle-alt', 24, true);
				animation.addByPrefix('singDOWN-alt', 'Down alt', 24, false);

				animation.addByPrefix('cheer', 'stop', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'blitz':
				frames = Paths.getSparrowAtlas('characters/blitz_assets');
				animation.addByPrefix('idle', 'Idle', 24, true);
				animation.addByPrefix('singUP', 'Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'Down Note', 24, false);
				animation.addByPrefix('singLEFT', 'Left Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Right Note', 24, false);
				
				animation.addByPrefix('scarUP', 'slashUp', 24, false);
				animation.addByPrefix('scarDOWN', 'slashDown', 24, false);
				animation.addByPrefix('scarLEFT', 'slashLeft', 24, false);
				animation.addByPrefix('scarRIGHT', 'slashRight', 24, false);
				loadOffsetFile(curCharacter);

				dumbVar = true;

				playAnim('idle');
			case 'blitz2':
				frames = Paths.getSparrowAtlas('characters/blitz_assets');
				animation.addByPrefix('idle', 'Idle', 24, true);
				animation.addByPrefix('singUP', 'Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'Down Note', 24, false);
				animation.addByPrefix('singLEFT', 'Left Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Right Note', 24, false);
				
				animation.addByPrefix('scarUP', 'slashUp', 24, false);
				animation.addByPrefix('scarDOWN', 'slashDown', 24, false);
				animation.addByPrefix('scarLEFT', 'slashLeft', 24, false);
				animation.addByPrefix('scarRIGHT', 'slashRight', 24, false);
				loadOffsetFile(curCharacter);

				dumbVar = true;
				visible = false;

				playAnim('idle');
			case 'blitz-horror':
				frames = Paths.getSparrowAtlas('characters/blitz_horror');
				animation.addByPrefix('idle', 'Idle', 24, true);
				animation.addByPrefix('singUP', 'Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'Down Note', 24, false);
				animation.addByPrefix('singLEFT', 'Left Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Right Note', 24, false);
				
				animation.addByPrefix('scarUP', 'slashUp', 24, false);
				animation.addByPrefix('scarDOWN', 'slashDown', 24, false);
				animation.addByPrefix('scarLEFT', 'slashLeft', 24, false);
				animation.addByPrefix('scarRIGHT', 'slashRight', 24, false);
				loadOffsetFile(curCharacter);

				dumbVar = true;

				playAnim('idle');
			case 'blitz-h2':
				frames = Paths.getSparrowAtlas('characters/blitz_horror2');
				// 'idle' has three frames
				// each 'sing' has two possible frames
				animation.addByPrefix('idle', 'Idle', 24, true);
				animation.addByPrefix('singUP', 'Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'Down Note', 24, false);
				animation.addByPrefix('singLEFT', 'Left Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Right Note', 24, false);
				loadOffsetFile(curCharacter);

				playAnim('idle');
		}

		//dance();

		if (isPlayer && frames != null)
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

	public function loadOffsetFile(character:String, library:String = 'shared')
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.txt('images/characters/' + character + "Offsets", library));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	private var swapTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (swapTimer > 0)
			swapTimer -= elapsed;
		if (swapTimer <= 0)
			swapTimer = 0;

		if (!debugMode)
		{
			if (!curCharacter.startsWith('bf') && curCharacter != 'blitz-h2' && curCharacter !='blitz2' && animation.curAnim != null)
			{
				if (animation.curAnim.name.startsWith('sing'))
				{
					holdTimer += elapsed;
				}

				var dadVar:Float = 4;

				if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
				{
					//trace('dance');
					dance();
					holdTimer = 0;
				}
			}

			
			switch (curCharacter)
			{
				case 'sheol-horror':
					scrollFactor.set(0,0);
					screenCenter();
				case 'gf-marenol':
					if (animation.curAnim.name == 'scream')
						scale.set(1.7,1.7);
					else
						scale.set(1,1);
					
					if (dumbVar && PlayState.dad.animation.curAnim.name.startsWith('sing'))
					{
						visible = false;
						alpha = 0;
					}
					else
						visible = true;

					if (alpha < 1 && visible)
						alpha += 0.01;
					if (alpha > 1)
						alpha = 1;
				case 'blitz-horror':
					if (animation.curAnim.name != 'idle')
					{
						alpha = FlxG.random.float(0.5, 1.0);
					}
					else
						alpha = 1;
				case 'blitz-h2' | 'blitz2':
					//lmao how many layers of random bools do you want
					if (!PlayState.dad.dumbVar)
					{
						//visible = PlayState.dad.visible;

						var chanceMulti:Float = 1 / PlayState.dad.alpha;

						if (swapTimer == 0)
						{
							if (FlxG.random.bool(85 * PlayState.dad.alpha))
								playAnim(PlayState.dad.animation.curAnim.name,true,false,-1);
							else
								animation.randomFrame();

							animation.stop();
							swapTimer = FlxG.random.float(0.1,Math.max(3.5 * PlayState.dad.alpha, 1.1));
						}

						if (FlxG.random.bool(5 * chanceMulti))
							alpha = FlxG.random.float(0.05,0.2);
						
						if (FlxG.random.bool(3 * chanceMulti))
							x = PlayState.dad.x + FlxG.random.int(-15,15);
						
						if (FlxG.random.bool(3 * chanceMulti))
							y = PlayState.dad.y + FlxG.random.int(-15,15);

						var randoScale = FlxG.random.float(0.9,1.1);
						if (FlxG.random.bool(1 * chanceMulti))
							scale.set(randoScale,randoScale);
					}
			}
		}
		super.update(elapsed);
	}

	private var danced:Bool = false;

	public function dance(forced:Bool = false, altAnim:Bool = false):Void
	{
		if (!debugMode)
		{
			if (curCharacter.startsWith('gf') && curCharacter != 'gf-marenol')
			{
				if (!animation.curAnim.name.startsWith('cheer') || animation.curAnim.finished)
				{
					danced = !danced;
					if (!dumbVar)
					{
						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
					else //if dumbVar == true
					{ 
						if (curCharacter == 'gf')
						{
							playAnim('idle');
						}
						else
						{
							if (danced)
								playAnim('danceRight-alt');
							else
								playAnim('danceLeft-alt');
						}
					}
				}
				return;
			}

			if (curCharacter.startsWith('blitz'))
			{
				dumbVar = false;
				if ((!animation.curAnim.name.startsWith('sing') && !animation.curAnim.name.startsWith('scar')) || animation.curAnim.finished)
				{
					if (!altAnim)
						playAnim('idle', false);
					else 
						playAnim('idle-alt', false);
				}
				return;
			}

			switch (curCharacter)
			{
				case 'dari':
					if ((!animation.curAnim.name.startsWith('sing') && animation.curAnim.name != 'cheer') || animation.curAnim.finished)
					{
						if (dumbVar)
							playAnim('idle-alt');
						else
							playAnim('idle');
					}

				case 'sheol':
					danced = !danced;

					if (dumbVar && !animation.curAnim.name.startsWith('sing'))
						playAnim('idle-alt', false);
					else if (!animation.curAnim.name.startsWith('sing') || animation.finished)
					{
						if (danced)
							playAnim('danceRight', false);
						else
							playAnim('danceLeft', false);
					}

				case 'sheol-flandre':
					if (animation.curAnim.finished)
						playAnim(danceArray[FlxG.random.int(0, 2)], true, FlxG.random.bool());

				case 'sheol-tiky':
					if (!animation.curAnim.name.startsWith('sing') || !animation.curAnim.name.startsWith('cheer') || animation.finished)
						playAnim('idle', forced);

				case 'gf-marenol':
					danceArray = ['idle-1','idle-2','idle-3'];

					if (dumbVar)
						playAnim(danceArray[FlxG.random.int(0, 2)], true, FlxG.random.bool());
				
				case 'sheol-horror':
					if (animation.curAnim.finished)
						playAnim('idle');

				default:
					if (altAnim && animation.getByName('idle-alt') != null)
						playAnim('idle-alt', forced);
					else
						playAnim('idle', forced);
			}
		}
	}

	public function playAnim(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):Void
	{
		/*if (animation.curAnim.name == 'firstDeath' && !animation.curAnim.finished)
			return;*/

		if (animName.endsWith('alt') && animation.getByName(animName) == null)
		{
			#if debug
			FlxG.log.warn(['Such alt animation doesnt exist: ' + animName]);
			#end
			animName = animName.split('-')[0];
		}

		animation.play(animName, force, reversed, frame);

		var daOffset = animOffsets.get(animName);
		if (animOffsets.exists(animName))
			offset.set(daOffset[0], daOffset[1]);
		else
			offset.set(0, 0);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0):Void
	{
		animOffsets[name] = [x, y];
	}
}
