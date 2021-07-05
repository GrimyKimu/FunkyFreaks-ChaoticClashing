package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BackgroundGirls extends Character
{	//I'm making this extend Character rather than FlxSprite, will that fix the broken bg characters bullshit?
	//they aren't girls tho

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
		else if (name == 'dari')
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

		addOffset('danceLeft', 0, -9);
		addOffset('danceRight', 0, -9);

		playAnim('danceLeft');
	}

	var danceDir:Bool = false;

	public override function dance():Void 
	{
		danceDir = !danceDir;

		if (danceDir)
			playAnim('danceRight');
		else
			playAnim('danceLeft');
	}
}