import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxMath;
import openfl.display.BlendMode;

var logo:FlxSprite;
var qbo:String = 'genericmenu/';

function onCreate()
{
    if (FlxG.sound.music == null)
    {
        FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
        FlxG.sound.music.fadeIn(2, 0, 0.2);
    }

    FlxG.mouse.visible = true;
    FlxG.mouse.useSystemCursor = true;

    var bg = new FlxSprite(0, 0);
    bg.frames = Paths.getSparrowAtlas(qbo + 'fondo');
    bg.animation.addByPrefix('idle', 'fondo', 24, true);
    bg.animation.play('idle');
    bg.scale.set(2.6, 2.4);
    bg.antialiasing = false;
    bg.screenCenter();
    add(bg);

    logo = new FlxSprite(0, 0);
    logo.frames = Paths.getSparrowAtlas(qbo + 'logo');
    logo.animation.addByPrefix('idle', 'logo', 24, true);
    logo.animation.play('idle');
    logo.updateHitbox();
    logo.antialiasing = false;
    logo.screenCenter();
    add(logo);

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
    if (logo == null)
        return;

    logo.scale.x = FlxMath.lerp(1, logo.scale.x, 1 - elapsed * 2);
    logo.scale.y = FlxMath.lerp(1, logo.scale.y, 1 - elapsed * 2);
    if (FlxG.mouse.overlaps(logo))
    {
        logo.scale.x = FlxMath.lerp(1.2, logo.scale.x, 1 - elapsed * 2);
        logo.scale.y = FlxMath.lerp(1.2, logo.scale.y, 1 - elapsed * 2);

        if (FlxG.mouse.justPressed)
            CoolUtil.switchState(new CustomState('menus/GenericMenu'));
    }
}
