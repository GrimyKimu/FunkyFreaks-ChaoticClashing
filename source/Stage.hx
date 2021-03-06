package;

import flixel.group.FlxSpriteGroup;
import flixel.addons.plugin.screengrab.FlxScreenGrab;
import flixel.math.FlxRandom;
import flixel.util.FlxGradient;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

class Stage extends MusicBeatState
{
	public var curStage:String = '';
	public var camZoom:Float; // The zoom of the camera to have at the start of the game
	public var hideLastBG:Bool = false; // True = hide last BGs and show ones from slowBacks on certain step, False = Toggle visibility of BGs from SlowBacks on certain step
	// Use visible property to manage if BG would be visible or not at the start of the game
	public var tweenDuration:Float = 2; // How long will it tween hiding/showing BGs, variable above must be set to True for tween to activate
	public var toAdd:Array<Dynamic> = []; // Add BGs on stage startup, load BG in by using "toAdd.push(bgVar);"
	// Layering algorithm for noobs: Everything loads by the method of "On Top", example: You load wall first(Every other added BG layers on it), then you load road(comes on top of wall and doesn't clip through it), then loading street lights(comes on top of wall and road)
	public var swagBacks:Map<String,
		FlxSprite> = []; // Store BGs here to use them later (for example with slowBacks, using your custom stage event or to adjust position in stage debug menu(press 8 while in PlayState with debug build of the game))
	public var swagGroup:Map<String, FlxSpriteGroup> = []; // Store Groups
	public var bgSibs:Map<String, BGSibs> = [];
	public var animatedBacks:Array<FlxSprite> = []; // Store animated backgrounds and make them play animation(Animation must be named Idle!! Else use swagGroup/swagBacks and script it in stepHit/beatHit function of this file!!)
	public var layInFront:Array<Array<FlxSprite>> = [[], [], []]; // BG layering, format: first [0] - in front of GF, second [1] - in front of opponent, third [2] - in front of boyfriend(and technically also opponent since Haxe layering moment)
	public var slowBacks:Map<Int,
		Array<FlxSprite>> = []; // Change/add/remove backgrounds mid song! Format: "slowBacks[StepToBeActivated] = [Sprites,To,Be,Changed,Or,Added];"

	// BGs still must be added by using toAdd Array for them to show in game after slowBacks take effect!!
	// BGs still must be added by using toAdd Array for them to show in game after slowBacks take effect!!
	// All of the above must be set or used in your stage case code block!!
	public var positions:Map<String, Map<String, Array<Int>>> = [
		// Assign your characters positions on stage here!
		'halloween' => ['spooky' => [100, 300], 'monster' => [100, 200]],
		'philly' => ['pico' => [100, 400]],
		'limo' => ['bf-car' => [1030, 230]],
		'mall' => ['bf-christmas' => [970, 450], 'parents-christmas' => [-400, 100]],
		'mallEvil' => ['bf-christmas' => [1090, 450], 'monster-christmas' => [100, 150]],
		'school' => [
			'gf-pixel' => [580, 430],
			'bf-pixel' => [970, 670],
			'senpai' => [250, 460],
			'senpai-angry' => [250, 460]
		],
		'schoolEvil' => ['gf-pixel' => [580, 430], 'bf-pixel' => [970, 670], 'spirit' => [-50, 200]]
	];

	public function new(daStage:String)
	{
		super();
		this.curStage = daStage;
		camZoom = 1.05; // Don't change zoom here, unless you want to change zoom of every stage that doesn't have custom one
		if (PlayStateChangeables.Optimize)
			return;
		var curSong = PlayState.SONG.song.toLowerCase();

        switch(daStage)
        {
            case 'nowhere':
				camZoom = 0.7;
				//LOAD ALL THE CUSTOM STAGE ART IN THE RIGHT ORDER, FROM HERE DOWN IT GOES FROM BACK TO FRONT

				var bg:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width * 2, FlxG.height * 2, FlxColor.gradient(FlxColor.WHITE, FlxColor.GRAY, 6));
				//new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2);
				bg.screenCenter().y += 240;
				bg.updateHitbox(); 
				bg.active = false;
				toAdd.push(bg);

				var groundBitz = new FlxSprite(-350, 225);
				groundBitz.frames = Paths.getSparrowAtlas('nowhere/groundBitz', 'shared');
				groundBitz.animation.addByPrefix('idle', 'groundBitz', 24, true, true);
				groundBitz.setGraphicSize(Std.int(groundBitz.width * 1.15));
				groundBitz.updateHitbox();
				groundBitz.antialiasing = true;
				groundBitz.scrollFactor.set(0.7, 0.7);
				groundBitz.animation.play('idle');
				toAdd.push(groundBitz);
				swagBacks['groundBitz'] = groundBitz;

				var noGround:FlxSprite = new FlxSprite(-250, 670).loadGraphic(Paths.image('nowhere/noGround', 'shared'));
				noGround.antialiasing = true;
				noGround.scrollFactor.set(0.95, 0.95);
				noGround.setGraphicSize(Std.int(noGround.width * 1.2));
				noGround.updateHitbox();
				toAdd.push(noGround);

				var bgDari = new BGSibs(1000, 340, 'dari', false);
				bgDari.scrollFactor.set(0.95, 0.95);
				bgDari.scale.set(0.9, 0.9);
				if (curSong != 'not-sorry' && curSong != 'kittycat-sonata')
				{
					toAdd.push(bgDari);
					bgSibs['bgDari'] = bgDari;
				}

				var lostRain = new FlxSprite(-650, -300);
				lostRain.frames = Paths.getSparrowAtlas('nowhere/lostRain', 'shared');
				lostRain.animation.addByPrefix('idle', 'lostRain', 24, true);
				lostRain.setGraphicSize(Std.int(lostRain.width * 2.5));
				lostRain.updateHitbox();
				lostRain.antialiasing = true;
				lostRain.scrollFactor.set(2.5, 2.5);
				lostRain.alpha = 0;
				lostRain.visible = false;
				lostRain.animation.play('idle');
				layInFront[2].push(lostRain);
				swagBacks['lostRain'] = lostRain;

				var moreBitz = new FlxSprite(-750, 1100);
				moreBitz.frames = Paths.getSparrowAtlas('nowhere/groundBitz', 'shared');
				moreBitz.animation.addByPrefix('idle', 'groundBitz', 20, true, false, true);
				moreBitz.setGraphicSize(Std.int(moreBitz.width * 1.5));
				moreBitz.updateHitbox();
				moreBitz.antialiasing = true;
				moreBitz.scrollFactor.set(2.5, 2.5);
				moreBitz.animation.play('idle');
				layInFront[2].push(moreBitz);
				swagBacks['moreBitz'] = moreBitz;
			
			case 'nowhereScary':
				camZoom = 0.7;

				var bg:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width * 2, FlxG.height * 2, FlxColor.gradient(FlxColor.WHITE, FlxColor.BLACK, 6, FlxEase.quadIn));
				//new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2);
				bg.screenCenter().y += 240;
				bg.updateHitbox(); 
				bg.active = false;
				toAdd.push(bg);

				var ballistics = new FlxSprite(-200, -200);
				ballistics.frames = Paths.getSparrowAtlas('nowhere/ballistics', 'shared');
				ballistics.animation.addByPrefix('singLEFT', 'left', 24, false);
				ballistics.animation.addByPrefix('singDOWN', 'down', 24, false);
				ballistics.animation.addByPrefix('singUP', 'up', 24, false);
				ballistics.animation.addByPrefix('singRIGHT', 'right', 24, false);
				ballistics.setGraphicSize(Std.int(ballistics.width * 5.5));
				ballistics.updateHitbox();
				ballistics.antialiasing = true;
				ballistics.scrollFactor.set(0.9, 0.9);
				ballistics.animation.play('singLEFT');
				if (curSong == 'ballistic')
				{
					layInFront[2].push(ballistics);
					swagBacks['ballistics'] = ballistics;
				}

				var groundBitz = new FlxSprite(-350, 225);
				groundBitz.frames = Paths.getSparrowAtlas('nowhere/groundBitz', 'shared');
				groundBitz.animation.addByPrefix('idle', 'groundBitz', 24, true, true);
				groundBitz.setGraphicSize(Std.int(groundBitz.width * 1.15));
				groundBitz.updateHitbox();
				groundBitz.antialiasing = true;
				groundBitz.scrollFactor.set(0.7, 0.7);
				groundBitz.animation.play('idle');
				toAdd.push(groundBitz);
				swagBacks['groundBitz'] = groundBitz;

				var noGround:FlxSprite = new FlxSprite(-250, 670).loadGraphic(Paths.image('nowhere/noGround', 'shared'));
				noGround.antialiasing = true;
				noGround.scrollFactor.set(0.95, 0.95);
				noGround.setGraphicSize(Std.int(noGround.width * 1.2));
				noGround.updateHitbox();
				toAdd.push(noGround);

				var bgDari = new BGSibs(1000, 340, 'dari', true);
				bgDari.scrollFactor.set(0.95, 0.95);
				bgDari.scale.set(0.9, 0.9);
				if (curSong != 'death-waltz' && curSong != 'madness')
				{
					toAdd.push(bgDari);
					bgSibs['bgDari'] = bgDari;
				}

				var moreBitz = new FlxSprite(-750, 1100);
				moreBitz.frames = Paths.getSparrowAtlas('nowhere/groundBitz', 'shared');
				moreBitz.animation.addByPrefix('idle', 'groundBitz', 20, true, false, true);
				moreBitz.setGraphicSize(Std.int(moreBitz.width * 1.5));
				moreBitz.updateHitbox();
				moreBitz.antialiasing = true;
				moreBitz.scrollFactor.set(2.5, 2.5);
				moreBitz.animation.play('idle');
				layInFront[2].push(moreBitz);
				swagBacks['moreBitz'] = moreBitz;

				var fgHorror = new FlxSprite(-580, 0);
				fgHorror.frames = Paths.getSparrowAtlas('nowhere/fgHorror', 'shared');
				fgHorror.animation.addByPrefix('idle', 'fgHorror', 24, true);
				fgHorror.setGraphicSize(Std.int(fgHorror.width * 1.2));
				fgHorror.updateHitbox();
				fgHorror.antialiasing = true;
				fgHorror.scrollFactor.set(1.55, 1.55);
				fgHorror.alpha = 0.0;
				fgHorror.animation.play('idle');
				layInFront[0].push(fgHorror);
				swagBacks['fgHorror'] = fgHorror;
			
			case 'arg': 
				camZoom = 0.5;

				//a completely empty stage, devoid of anything except for Sheol(?) and the player
				var fgHorror = new FlxSprite();
				fgHorror.frames = Paths.getSparrowAtlas('nowhere/fgHorror', 'shared');
				fgHorror.animation.addByPrefix('idle', 'fgHorror', 24, true);
				fgHorror.setGraphicSize(Std.int(fgHorror.width * 1.15));
				fgHorror.updateHitbox();
				fgHorror.antialiasing = true;
				fgHorror.scrollFactor.set(1.55, 1.55);
				fgHorror.alpha = 0.0;
				fgHorror.animation.play('idle');
				fgHorror.visible = false;
				layInFront[0].push(fgHorror);
				swagBacks['fgHorror'] = fgHorror;

				var drown:FlxSprite = new FlxSprite(FlxG.width, FlxG.height);
				drown.frames = Paths.getSparrowAtlas('nowhere/drown', 'shared');
				drown.animation.addByPrefix('idle', 'drown', 4, true);
				drown.setGraphicSize(Std.int(drown.width * 3));
				drown.updateHitbox();
				drown.antialiasing = true;
				drown.alpha = 0.0;
				drown.animation.play('idle');
				toAdd.push(drown);
				swagBacks['drown'] = drown;
			
			case 'blitzy':
	
				var bDeaths = FlxG.save.data.blitzDeaths;
				camZoom = 0.85;

				var bg:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width * 2, FlxG.height * 2, FlxColor.gradient(FlxColor.RED, FlxColor.BLACK, 8, FlxEase.circInOut));
				//new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2);
				bg.screenCenter();
				bg.updateHitbox(); 
				bg.alpha = 0;
				toAdd.push(bg);
				swagBacks['bg'] = bg;

				var bgChains = new FlxSprite();
				bgChains.frames = Paths.getSparrowAtlas('nowhere/MB_bgChains', 'shared');
				bgChains.animation.addByPrefix('idle', 'bgChains', 24, true, true);
				bgChains.setGraphicSize(Std.int(bgChains.width * 1.2));
				bgChains.scrollFactor.set(0.1,0.1);
				bgChains.screenCenter();
				bgChains.y -= 180;
				bgChains.x -= 120;
				bgChains.updateHitbox();
				bgChains.animation.play('idle');
				toAdd.push(bgChains);

				
				var hangingGroup = new FlxSpriteGroup();
				for (d in 0...bDeaths)
				{
					// The many hanging bodies of the many(?) lives lost
					var mathShit:Float = 0.2 + 0.8 * Math.abs(Math.sin(d * 666));
					var lostBF = new FlxSprite().loadGraphic(Paths.image('nowhere/MB_hanging', 'shared'));
					lostBF.scale.set(mathShit, mathShit);
					lostBF.screenCenter().setPosition(666 * Math.sin(d * 0.25) + 600, lostBF.y - (40 + 360 * lostBF.scale.y));
					lostBF.scrollFactor.set(0.1 * lostBF.scale.x, 0.05 * lostBF.scale.x);
					lostBF.alpha = 0.4 + 0.6 * lostBF.scale.x;
					lostBF.origin.set(lostBF.graphic.width / 2, 0);

					hangingGroup.add(lostBF);
				}
				toAdd.push(hangingGroup);
				swagGroup["hangingGroup"] = hangingGroup;

				var poikeGroup = new FlxSpriteGroup();

				for (p in 0...FlxG.random.int(10,30))
				{
					// the positions of the BG pikes are randomized, to add a bit of randomized flair to the stage
					var randoVar:Float = FlxG.random.float(-1.0,1.0);
					var poike = new FlxSprite().loadGraphic(Paths.image('nowhere/MB_pike', 'shared'));
					poike.origin.set(poike.graphic.width / 2, poike.graphic.height);
					poike.scale.set(FlxG.random.float(0.2,0.9), FlxG.random.float(0.8,1.5));
					poike.screenCenter().setPosition(720 * randoVar + 480,-300 + (360 * poike.scale.y));
					poike.scrollFactor.set(1.5 * poike.scale.x,0.2 * poike.scale.y);
					poike.alpha = 0.2 + 0.8 * poike.scale.x;
					poike.angle = ((poike.x - 250) / 100) + (33 * randoVar);

					poikeGroup.add(poike);
				}
				toAdd.push(poikeGroup);
				swagGroup["poikeGroup"] = poikeGroup;

				var fgChains = new FlxSprite();
				fgChains.frames = Paths.getSparrowAtlas('nowhere/MB_fgChains', 'shared');
				fgChains.animation.addByPrefix('idle', 'fgChains', 24, true, true);
				fgChains.setGraphicSize(Std.int(fgChains.width * 1.5));
				fgChains.scrollFactor.set(2.5,2.5);
				fgChains.screenCenter().x -= 360;
				fgChains.updateHitbox();
				fgChains.animation.play('idle');
				layInFront[2].push(fgChains);

			case 'bonkers':
				// It's literally just Dari's true form as the BG
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!PlayStateChangeables.Optimize)
		{
			switch (curStage)
			{
				case "nowhere" | "nowhereScary":
					swagBacks['groundBitz'].angle = 8 * Math.sin(Conductor.songPosition / 900);
					swagBacks['moreBitz'].angle = -4 * Math.sin(Conductor.songPosition / 1400);
				case "blitzy":
					swagBacks['bg'].alpha = Math.abs(Math.sin(Conductor.songPosition / 1800));
					swagGroup["poikeGroup"].forEach(function (poike:FlxSprite)
						{
							poike.y = -300 + (360 * poike.scale.y) + (35 * poike.scale.y * Math.sin(Conductor.songPosition / 2400));
						});
					swagGroup["hangingGroup"].forEach(function (lostBF:FlxSprite)
						{
							lostBF.angle = FlxMath.lerp(0, lostBF.angle, 0.85);
						});
			}
		}
	}

	override function stepHit()
	{
		if (!PlayStateChangeables.Optimize)
		{
			var array = slowBacks[curStep];
			if (array != null && array.length > 0)
			{
				if (hideLastBG)
				{
					for (bg in swagBacks)
					{
						if (!array.contains(bg))
						{
							var tween = FlxTween.tween(bg, {alpha: 0}, tweenDuration, {
								onComplete: function(tween:FlxTween):Void
								{
									bg.visible = false;
								}
							});
						}
					}
					for (bg in array)
					{
						bg.visible = true;
						FlxTween.tween(bg, {alpha: 1}, tweenDuration);
					}
				}
				else
				{
					for (bg in array)
						bg.visible = !bg.visible;
				}
			}
		}
		super.stepHit();
	}

	override function beatHit()
	{
		if (FlxG.save.data.distractions && animatedBacks.length > 0)
		{
			for (bg in animatedBacks)
				bg.animation.play('idle', true);
		}

		if (!PlayStateChangeables.Optimize)
		{
			switch (curStage)
			{
				case "nowhere":
					if (bgSibs['bgDari'] != null)
						bgSibs['bgDari'].dance(true);
				case 'nowhereScary':
					if (bgSibs['bgDari'] != null)
						bgSibs['bgDari'].dance(true);
					if (swagBacks['fgHorror'] != null)
						swagBacks['fgHorror'].animation.play('idle', false);
			}
		}
		super.beatHit();
	}
}
