package;

import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var char:String = 'bf';
	public var isPlayer:Bool = false;
	public var isOldIcon:Bool = false;
	public var nonDancer:Bool = false;

	private var nonDanceMap:Map<String, Bool> = CoolUtil.coolMapFile(Paths.txt('data/characterList'));

	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(?char:String = "bf", ?isPlayer:Bool = false)
	{
		super();

		if (nonDanceMap.exists(char))
			if (!nonDanceMap[char])
				nonDancer = true;

		this.char = char;
		this.isPlayer = isPlayer;

		isPlayer = isOldIcon = false;

		antialiasing = FlxG.save.data.antialiasing;

		changeIcon(char);
		scrollFactor.set();
	}

	public function swapOldIcon()
	{
		(isOldIcon = !isOldIcon) ? changeIcon("bf-old") : changeIcon(char);
	}

	public function changeIcon(char:String)
	{
		loadGraphic(Paths.image('icons/icon-' + char), true, 150, 150);
		antialiasing = FlxG.save.data.antialiasing;
		animation.add(char, [0, 1], 0, false, isPlayer);
		animation.play(char);

		if (nonDanceMap.exists(char))
			if (!nonDanceMap[char])
				nonDancer = true;
			else
				nonDancer = false;
		else
			nonDancer = false;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 40);
	}
}
