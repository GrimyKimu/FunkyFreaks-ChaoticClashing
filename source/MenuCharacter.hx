package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class CharacterSetting
{
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var scale(default, null):Float;
	public var flipped(default, null):Bool;

	public function new(x:Int = 0, y:Int = 0, scale:Float = 1.0, flipped:Bool = false)
	{
		this.x = x;
		this.y = y;
		this.scale = scale;
		this.flipped = flipped;
	}
}

class MenuCharacter extends FlxSprite
{
	private static var settings:Map<String, CharacterSetting> = [
		'bf' => new CharacterSetting(0, -15, 1.0, true),
		'bf-goner' => new CharacterSetting(-32, -32, 0.9, true),

		'sheol' => new CharacterSetting(-70, 60, 1.0),
		'sheol-horror' => new CharacterSetting(0, 40, 1.0),
		'dari' => new CharacterSetting(-25, 130, 0.65),
		'blitz' => new CharacterSetting(0, 140, 0.65),

		'bg-dari' => new CharacterSetting(100, 50, 2.2, true),
		'bg-blitz' => new CharacterSetting(100, -20, 1.1, true)
	];

	private var flipped:Bool = false;
	//questionable variable name lmfao
	private var goesLeftNRight:Bool = false;
	private var danceLeft:Bool = false;
	public var character:String = '';

	public function new(x:Int, y:Int, scale:Float, flipped:Bool)
	{
		super(x, y);
		this.flipped = flipped;

		antialiasing = FlxG.save.data.antialiasing;

		frames = Paths.getSparrowAtlas('campaign_menu_UI_characters');

		animation.addByPrefix('bf', "BF idle dance white", 24, false);
		animation.addByPrefix('bfConfirm', 'BF HEY!!', 24, false);
		animation.addByPrefix('bf-goner', "bf goner", 24, false);

		animation.addByPrefix('sheol', "Sheol idle Black Lines", 24, false);
		animation.addByPrefix('sheol-horror', "sheol horror", 24, true);
		animation.addByPrefix('dari', "dari serious lines", 24, true);
		animation.addByPrefix('blitz', "blitz lines", 24, true);

		animation.addByIndices('bg-dari-left', "bg dari lines", [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		animation.addByIndices('bg-dari-right', "bg dari lines", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

		animation.addByIndices('bg-blitz-right', "bg blitz lines", [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		animation.addByIndices('bg-blitz-left', "bg blitz lines", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

		setGraphicSize(Std.int(width * scale));
		updateHitbox();
	}

	public function setCharacter(character:String):Void
	{
		var sameCharacter:Bool = character == this.character;
		this.character = character;
		if (character == '')
		{
			visible = false;
			return;
		}
		else
		{
			visible = true;
		}

		if (!sameCharacter) {
			bopHead(true);
		}

		var setting:CharacterSetting = settings[character];
		offset.set(setting.x, setting.y);
		setGraphicSize(Std.int(width * setting.scale));
		flipX = setting.flipped != flipped;
	}

	public function bopHead(LastFrame:Bool = false):Void
	{
		if (character.startsWith('bg')) 
		{
			danceLeft = !danceLeft;

			if (danceLeft)
				animation.play(character + "-left", true);
			else
				animation.play(character + "-right", true);
		}
		else {
			//no spooky nor girlfriend so we do da normal animation
			if (animation.name == "bfConfirm")
				return;
			else if (character == 'dari' || character == 'blitz')
				animation.play(character, false);
			else
				animation.play(character, true);
		}
		if (LastFrame) {
			animation.finish();
		}
	}
}
