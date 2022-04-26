package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";
	//public static var currChanges:String = "dk";
	
	private var bgColors:Array<String> = [
		'#314d7f',
		'#4e7093',
		'#70526e',
		'#594465'
	];
	private var colorRotation:Int = 1;

	var txt:FlxText;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('week54prototype', 'shared'));
		bg.scale.x *= 1.55;
		bg.scale.y *= 1.55;
		bg.screenCenter();
		bg.antialiasing = FlxG.save.data.antialiasing;
		add(bg);
		
		var kadeLogo:FlxSprite = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image('KadeEngineLogo'));
		kadeLogo.scale.y = 0.3;
		kadeLogo.scale.x = 0.3;
		kadeLogo.x -= kadeLogo.frameHeight;
		kadeLogo.y -= 180;
		kadeLogo.alpha = 0.8;
		kadeLogo.antialiasing = FlxG.save.data.antialiasing;
		add(kadeLogo);
		
		txt = new FlxText(0, 0, FlxG.width,
			"Hey, uh, just in case you didn't know..."
			+ "\nThis is a demo of my mod, it's currently uncompletable."
			+ "\nThank you for coming to play it <3"
			+ "\n\nI really do appreciate it.\n\n"
			+ "\nIf you want spoilers as to what is currently missing,"
			+ "\npress Space/Enter to view the planned stuff and things."
			+ "\n\nOr press ESC to move on to the demo.",
			32);

		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);
		
		FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
		FlxTween.angle(kadeLogo, kadeLogo.angle, -10, 2, {ease: FlxEase.quartInOut});
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
			if(colorRotation < (bgColors.length - 1)) colorRotation++;
			else colorRotation = 0;
		}, 0);
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			if(kadeLogo.angle == -10) FlxTween.angle(kadeLogo, kadeLogo.angle, 10, 2, {ease: FlxEase.quartInOut});
			else FlxTween.angle(kadeLogo, kadeLogo.angle, -10, 2, {ease: FlxEase.quartInOut});
		}, 0);
		
		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			if(kadeLogo.alpha == 0.8) FlxTween.tween(kadeLogo, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
			else FlxTween.tween(kadeLogo, {alpha: 0.8}, 0.8, {ease: FlxEase.quartInOut});
		}, 0);
	}

	var justOnce:Bool = false;

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT && !justOnce)
		{
			justOnce = true;
			FlxTween.tween(txt, {alpha: 0.0}, 0.5, {ease: FlxEase.linear});

			new FlxTimer().start(0.6, function(tmr:FlxTimer)
			{
				FlxTween.tween(txt, {alpha: 1.0}, 0.6, {ease: FlxEase.linear});

				txt.text = "You asked for it!"
					+ "\nCurrently missing: "
					+ "\nBlitz's & Darian's 'boss music': 'Murderous-Blitz' and 'M-E-M-E' respectively"
					+ "\n Actually the music for both is actually 'done', barring any major changes, it's hidden in the files (:"
					+ "\n\n The finale song: 'Creator', which ends the main story."
					+ "\n The actual music has yet to be finished."
					+ "\nEach of those levels and stuff have animations, mechanics, and story CGs that they need. Plenty of stuff."
					+ "\n + Bonus freeplay mode remixes and stuff, 'cause I gotta procrastinate in a way that still technically works towards completion"
					+ "\n\nYou may now press ESC to move on to the demo.";
			}, 0);
		}
		super.update(elapsed);
	}
}
