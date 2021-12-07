package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.addons.effects.chainable.FlxWaveEffect;

class Stage
{
    public var curStage:String = '';
    public var halloweenLevel:Bool = false;
    public var camZoom:Float;
    public var hideLastBG:Bool = false; // True = hide last BG and show ones from slowBacks on certain step, False = Toggle Visibility of BGs from SlowBacks on certain step
    public var tweenDuration:Float = 2; // How long will it tween hiding/showing BGs, variable above must be set to True for tween to activate
    public var toAdd:Array<Dynamic> = []; // Add BGs on stage startup, load BG in by using "toAdd.push(bgVar);"
    // Layering algorithm for noobs: Everything loads by the method of "On Top", example: You load wall first(Every other added BG layers on it), then you load road(comes on top of wall and doesn't clip through it), then loading street lights(comes on top of wall and road)
    public var swagBacks:Map<String, FlxSprite> = []; // Store BGs here to use them later in PlayState or when slowBacks activate
	public var bgSibs:Map<String, BGSibs> = [];
    public var swagGroup:Map<String, FlxTypedGroup<Dynamic>> = []; //Store Groups
    public var animatedBacks:Array<FlxSprite> = []; // Store animated backgrounds and make them play animation(Animation must be named Idle!! Else use swagGroup)
    public var layInFront:Array<Array<FlxSprite>> = [[], [], []]; // BG layering, format: first [0] - in front of GF, second [1] - in front of opponent, third [2] - in front of boyfriend(and techincally also opponent since Haxe layering moment)
    public var slowBacks:Map<Int, Array<FlxSprite>> = []; // Change/add/remove backgrounds mid song! Format: "slowBacks[StepToBeActivated] = [Sprites,To,Be,Changed,Or,Added];"

    public function new(daStage:String)
    {
        this.curStage = daStage;
        camZoom = 1.05; // Don't change zoom here, unless you want to change zoom of every stage that doesn't have custom one
        halloweenLevel = false;

		var curSong = PlayState.SONG.song.toLowerCase();

        switch(daStage)
        {
            case 'limo':
				{
					camZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset', 'week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					skyBG.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['skyBG'] = skyBG;
					toAdd.push(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo', 'week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					bgLimo.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['bgLimo'] = bgLimo;
					toAdd.push(bgLimo);
					
					var fastCar:FlxSprite;
					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol', 'week4'));
					fastCar.antialiasing = FlxG.save.data.antialiasing;

					if (FlxG.save.data.distractions)
					{
						var grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						swagGroup['grpLimoDancers'] = grpLimoDancers;
						toAdd.push(grpLimoDancers);

						for (i in 0...5)
						{
							var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
							dancer.scrollFactor.set(0.4, 0.4);
							grpLimoDancers.add(dancer);
						}

						swagBacks['fastCar'] = fastCar;
						layInFront[2].push(fastCar);
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay', 'week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive', 'week4');

					var limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = FlxG.save.data.antialiasing;
					layInFront[0].push(limo);
					swagBacks['limo'] = limo;

					// Testing 
					//
					// hideLastBG = true;
					// slowBacks[40] = [limo];
					// slowBacks[120] = [limo, bgLimo, skyBG, fastCar];
				}
			case 'mall':
			{
				camZoom = 0.80;

				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls', 'week5'));
				bg.antialiasing = FlxG.save.data.antialiasing;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var upperBoppers = new FlxSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop', 'week5');
				upperBoppers.animation.addByPrefix('idle', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = FlxG.save.data.antialiasing;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				if (FlxG.save.data.distractions)
				{
					swagBacks['upperBoppers'] = upperBoppers;
					toAdd.push(upperBoppers);
					animatedBacks.push(upperBoppers);
				}

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator', 'week5'));
				bgEscalator.antialiasing = FlxG.save.data.antialiasing;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				swagBacks['bgEscalator'] = bgEscalator;
				toAdd.push(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree', 'week5'));
				tree.antialiasing = FlxG.save.data.antialiasing;
				tree.scrollFactor.set(0.40, 0.40);
				swagBacks['tree'] = tree;
				toAdd.push(tree);

				var bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop', 'week5');
				bottomBoppers.animation.addByPrefix('idle', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = FlxG.save.data.antialiasing;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				if (FlxG.save.data.distractions)
				{
					swagBacks['bottomBoppers'] = bottomBoppers;
					toAdd.push(bottomBoppers);
					animatedBacks.push(bottomBoppers);
				}

				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow', 'week5'));
				fgSnow.active = false;
				fgSnow.antialiasing = FlxG.save.data.antialiasing;
				swagBacks['fgSnow'] = fgSnow;
				toAdd.push(fgSnow);

				var santa = new FlxSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('christmas/santa', 'week5');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = FlxG.save.data.antialiasing;
				if (FlxG.save.data.distractions)
				{
					swagBacks['santa'] = santa;
					toAdd.push(santa);
					animatedBacks.push(santa);
				}
			}
			case 'nowhere':
			{
				camZoom = 0.7;
				//LOAD ALL THE CUSTOM STAGE ART IN THE RIGHT ORDER, FROM HERE DOWN IT GOES FROM BACK TO FRONT

				var bg:FlxSprite = new FlxSprite(-1000, 0).loadGraphic(Paths.image('nowhere/noBG'));
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox(); 
				bg.antialiasing = true;
				bg.active = false;
				toAdd.push(bg);

				var groundBitz = new FlxSprite(-350, 225);
				groundBitz.frames = Paths.getSparrowAtlas('nowhere/groundBitz');
				groundBitz.animation.addByPrefix('idle', 'groundBitz', 24, true, true);
				groundBitz.setGraphicSize(Std.int(groundBitz.width * 1.15));
				groundBitz.updateHitbox();
				groundBitz.antialiasing = true;
				groundBitz.scrollFactor.set(0.7, 0.7);
				groundBitz.animation.play('idle');
				animatedBacks.push(groundBitz);
				swagBacks['groundBitz'] = groundBitz;

				var noGround:FlxSprite = new FlxSprite(-250, 670).loadGraphic(Paths.image('nowhere/noGround'));
				noGround.antialiasing = true;
				noGround.scrollFactor.set(0.95, 0.95);
				noGround.setGraphicSize(Std.int(noGround.width * 1.2));
				noGround.updateHitbox();
				toAdd.push(noGround);

				var bgDari = new BGSibs(1000, 340, 'dari', false);
				bgDari.scrollFactor.set(0.95, 0.95);
				bgDari.scale.set(0.9, 0.9);
				if (curSong != 'apology')
				{
					animatedBacks.push(bgDari);
					bgSibs['bgDari'] = bgDari;
				}

				var lostRain = new FlxSprite(0, 0);
				lostRain.frames = Paths.getSparrowAtlas('nowhere/lostRain');
				lostRain.animation.addByPrefix('idle', 'lostRain', 24, true);
				lostRain.setGraphicSize(Std.int(lostRain.width * 2));
				lostRain.updateHitbox();
				lostRain.antialiasing = true;
				lostRain.scrollFactor.set(1.5, 1.5);
				lostRain.alpha = 0;
				lostRain.visible = false;
				lostRain.animation.play('idle');
				layInFront[2].push(lostRain);
				swagBacks['lostRain'] = lostRain;

				var moreBitz = new FlxSprite(-750, 1000);
				moreBitz.frames = Paths.getSparrowAtlas('nowhere/groundBitz');
				moreBitz.animation.addByPrefix('idle', 'groundBitz', 20, true, false, true);
				moreBitz.setGraphicSize(Std.int(moreBitz.width * 1.5));
				moreBitz.updateHitbox();
				moreBitz.antialiasing = true;
				moreBitz.scrollFactor.set(2.5, 2.5);
				moreBitz.animation.play('idle');
				layInFront[2].push(moreBitz);
				swagBacks['moreBitz'] = moreBitz;
			}
			case 'nowhereScary':
			{
				camZoom = 0.7;

				var bg:FlxSprite = new FlxSprite(-1000, 0).loadGraphic(Paths.image('nowhere/noBG2'));
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox(); 
				bg.antialiasing = true;
				bg.active = false;
				toAdd.push(bg);

				var ballistics = new FlxSprite(-200, -200);
				ballistics.frames = Paths.getSparrowAtlas('nowhere/ballistics');
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
				groundBitz.frames = Paths.getSparrowAtlas('nowhere/groundBitz');
				groundBitz.animation.addByPrefix('idle', 'groundBitz', 24, true, true);
				groundBitz.setGraphicSize(Std.int(groundBitz.width * 1.15));
				groundBitz.updateHitbox();
				groundBitz.antialiasing = true;
				groundBitz.scrollFactor.set(0.7, 0.7);
				groundBitz.animation.play('idle');
				animatedBacks.push(groundBitz);
				swagBacks['groundBitz'] = groundBitz;

				var noGround:FlxSprite = new FlxSprite(-250, 670).loadGraphic(Paths.image('nowhere/noGround'));
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
					animatedBacks.push(bgDari);
					bgSibs['bgDari'] = bgDari;
				}

				var moreBitz = new FlxSprite(-750, 1000);
				moreBitz.frames = Paths.getSparrowAtlas('nowhere/groundBitz');
				moreBitz.animation.addByPrefix('idle', 'groundBitz', 20, true, false, true);
				moreBitz.setGraphicSize(Std.int(moreBitz.width * 1.5));
				moreBitz.updateHitbox();
				moreBitz.antialiasing = true;
				moreBitz.scrollFactor.set(2.5, 2.5);
				moreBitz.animation.play('idle');
				layInFront[2].push(moreBitz);
				swagBacks['moreBitz'] = moreBitz;

				var fgHorror = new FlxSprite(-570, -20);
				fgHorror.frames = Paths.getSparrowAtlas('nowhere/fgHorror');
				fgHorror.animation.addByPrefix('idle', 'fgHorror', 23, true);
				fgHorror.setGraphicSize(Std.int(fgHorror.width * 1.15));
				fgHorror.updateHitbox();
				fgHorror.antialiasing = true;
				fgHorror.scrollFactor.set(1.55, 1.55);
				fgHorror.alpha = 0.0;
				fgHorror.animation.play('idle');
				layInFront[0].push(fgHorror);
				swagBacks['fgHorror'] = fgHorror;
			}
			case 'arg':
			{
				//a completely empty stage, devoid of anything except for Sheol(?) and the player
				var fgHorror = new FlxSprite(-500, -20);
				fgHorror.frames = Paths.getSparrowAtlas('nowhere/fgHorror');
				fgHorror.animation.addByPrefix('idle', 'fgHorror', 23, true);
				fgHorror.setGraphicSize(Std.int(fgHorror.width * 1.15));
				fgHorror.updateHitbox();
				fgHorror.antialiasing = true;
				fgHorror.scrollFactor.set(1.55, 1.55);
				fgHorror.alpha = 0.0;
				fgHorror.animation.play('idle');
				layInFront[0].push(fgHorror);
				swagBacks['fgHorror'] = fgHorror;
			}
		}
    }
}