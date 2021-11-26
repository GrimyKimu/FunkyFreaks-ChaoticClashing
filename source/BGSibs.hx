package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BGSibs extends FlxSprite
{	//I'm making this extend Character rather than FlxSprite, will that fix the broken bg characters bullshit?
	//Blitz and Darian aren't girls, they nb

	private var stupidVar:Bool = false;
	//ok, I got way confused with the animations and how they're playing, and now I think stuff are backwards??

	public function new(x:Float, y:Float, name:String, scary:Bool)
	{
		super(x, y);
		flipX = false;

		// BG girls stolen code so I can get characters in the BG lmao how sad
		if (name == 'blitz')
		{
			frames = Paths.getSparrowAtlas('characters/bgBlitz');
			stupidVar = true;
		}
		if (name == 'dari')
		{
			frames = Paths.getSparrowAtlas('characters/bgDari');
		}

		if (scary)
		{
			animation.addByIndices('danceLeft', 'ScaryIdle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			animation.addByIndices('danceRight', 'ScaryIdle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		}
		else
		{
			animation.addByIndices('danceLeft', 'NormalIdle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			animation.addByIndices('danceRight', 'NormalIdle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		}

		animation.play('danceLeft', true);
	}

	var danceDir:Bool = false;

	public function dance(forced:Bool = false):Void
	{
		danceDir = !danceDir;

		if (danceDir)
			animation.play('danceRight', forced);
		else
			animation.play('danceLeft', forced);
	}
}