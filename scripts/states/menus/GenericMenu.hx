import flixel.FlxSprite;
import flixel.FlxG;
import openfl.display.BlendMode;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxAxes;

var qbo:String = 'genericmenu/';

var options:Array<String> = [
    'story',
    'options',
    'credits'
];

var curShit:Int = 0;
var optionsGrp:FlxTypedGroup<FlxSprite>;

function onCreate()
{
    FlxG.sound.music.volume = 0.2;

    var bg = new FlxSprite(0, 0);
    bg.frames = Paths.getSparrowAtlas(qbo + 'fondo');
    bg.animation.addByPrefix('idle', 'fondo', 24, true);
    bg.animation.play('idle');
    bg.scale.set(2.6, 2.4);
    bg.antialiasing = false;
    bg.screenCenter();
    add(bg);

    var sep = new FlxSprite(FlxG.width - 500, -800);
    sep.frames = Paths.getSparrowAtlas(qbo + 'blackbarsoptions');
    sep.animation.addByPrefix('idle', 'blackbarsoptions', 24, true);
    sep.animation.play('idle');
    sep.scale.set(1, 1);
    sep.antialiasing = false;
    add(sep);

    optionsGrp = new FlxTypedGroup<FlxSprite>();
    add(optionsGrp);

    for (i in 0...options.length)
    {
        var spr = new FlxSprite(100, 50);
        spr.ID = i;
        spr.frames = Paths.getSparrowAtlas(qbo + options[i]);
        spr.animation.addByPrefix('idle', options[i] + '0000', 24, false);
        spr.animation.addByPrefix('selected', options[i] + 'press', 24, false);
        spr.animation.play('idle');
        spr.scale.set(0.9, 0.9);
        spr.antialiasing = true;
        optionsGrp.add(spr);

        switch (options[spr.ID])
        {
            case 'credits':
                spr.y = 500;
            case 'options':
                spr.screenCenter(FlxAxes.Y);
                spr.x = 600;
                spr.angle = 10;
        }
    }

    var glow = new FlxSprite(0, 0);
    glow.frames = Paths.getSparrowAtlas(qbo + 'add');
    glow.animation.addByPrefix('idle', 'add', 24, true);
    glow.animation.play('idle');
    glow.scale.set(1, 1);
    glow.alpha = 0.6;
    glow.blend = BlendMode.ADD;
    add(glow);
}

function onUpdate(elapsed:Float)
{
    if (optionsGrp == null)
        return;

    optionsGrp.forEach(function(spr:FlxSprite) {
        if (FlxG.mouse.overlaps(spr))
        {
            curShit = spr.ID;

            var ops:String = options[spr.ID];
            spr.animation.play('selected', false);

            switch (ops)
            {
                case 'story':
                    spr.offset.set(20, 5);
                case 'credits':
                    spr.offset.set(0, 5);
                case 'options':
                    spr.offset.set(20, 10);
            }

            if (FlxG.mouse.justPressed)
            {
                switch (ops)
                {
                    case 'story':
                        CoolUtil.switchState(new CustomState('menus/GenericStory'));
                    case 'credits':
                        CoolUtil.switchState(new CustomState('CreditsState'));
                    case 'options':
                        CoolUtil.switchState(new CustomState(CoolVars.data.optionsState));
                }
            }
        }
        else
        {
            spr.animation.play('idle');
            spr.offset.set(0, 0);
        }
    });

    if (Controls.BACK)
        CoolUtil.switchState(new CustomState('GenericTitle'));
}
