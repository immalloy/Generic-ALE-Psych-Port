import flixel.util.FlxColor;
import openfl.display.BlendMode;
import flixel.util.FlxAxes;
import funkin.visuals.objects.Alphabet;

var data = Json.parse(File.getContent(Paths.getPath('data/credits.json'))).categories;

var dataDevs:Array = [];

var bg:FlxSprite;
var glow:FlxSprite;
var bgDim:FlxSprite;

var categories:FlxTypedGroup;
var developers:FlxTypedGroup;
var icons:FlxTypedGroup;

var descBG:FlxSprite;
var description:FlxText;

var selInt:Int = CoolUtil.save.custom.data.credits ?? 0;

var theY:Float = 0;
var canSelect:Bool = true;

function onCreate()
{
    bg = new FlxSprite(0, 0);
    bg.frames = Paths.getSparrowAtlas('genericmenu/fondo');
    bg.animation.addByPrefix('idle', 'fondo', 24, true);
    bg.animation.play('idle');
    bg.scale.set(2.6, 2.4);
    bg.antialiasing = false;
    bg.scrollFactor.set();
    bg.screenCenter();
    add(bg);

    bgDim = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    bgDim.alpha = 0.35;
    bgDim.scrollFactor.set();
    add(bgDim);

    glow = new FlxSprite(0, 0);
    glow.frames = Paths.getSparrowAtlas('genericmenu/add');
    glow.animation.addByPrefix('idle', 'add', 24, true);
    glow.animation.play('idle');
    glow.scale.set(1, 1);
    glow.alpha = 0.6;
    glow.blend = BlendMode.ADD;
    glow.scrollFactor.set();
    add(glow);

    add(categories = new FlxTypedGroup());
    add(developers = new FlxTypedGroup());
    add(icons = new FlxTypedGroup());

    var catOffset:Float = 80;

    for (category in data)
    {
        var catIndex:Int = data.indexOf(category);

        var title:Alphabet = new Alphabet(0, catIndex + catOffset, category.name);
        title.x = 40;
        title.y = 40 + catOffset;
        title.scrollFactor.set();
        categories.add(title);
        title.antialiasing = true;

        catOffset += title.height + 60;

        for (dev in category.developers)
        {
            dataDevs.push(dev);

            var devIndex:Int = category.developers.indexOf(dev);

            var alpha:Alphabet = new Alphabet(0, title.y + title.height + 60 + 100 * devIndex, dev.name, false);
            developers.add(alpha);
            alpha.scaleX = alpha.scaleY = 0.75;
            alpha.x = FlxG.width - alpha.width - 200;
            alpha.antialiasing = true;

            for (let in alpha)
            {
                let.colorTransform.redOffset = 255;
                let.colorTransform.greenOffset = 255;
                let.colorTransform.blueOffset = 255;
            }

            var icon:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/credits/' + dev.icon));
            icons.add(icon);
            icon.antialiasing = true;

            var size:Float = dev.size ?? 100;
            icon.scale.x = size / icon.width;
            icon.scale.y = size / icon.height;
            icon.updateHitbox();

            icon.x = alpha.x - icon.width - 20;
            icon.y = alpha.y + alpha.height / 2 - icon.height / 2;

            alpha.y -= 40;

            catOffset += 100;
        }

        catOffset += 75;
    }
    
    if (selInt >= developers.length)
        selInt = 0;

    descBG = new FlxSprite().makeGraphic(420, 1, FlxColor.BLACK);
    descBG.alpha = 0.5;
    descBG.scrollFactor.set();
    add(descBG);

    description = new FlxText(0, 0, 360, '', 26);
    description.font = Paths.font('olawei.ttf');
    description.alignment = 'left';
    add(description);
    description.scrollFactor.set();
    description.x = 40;
    description.y = FlxG.height - 160;

    descBG.scale.y = description.height + 28;
    descBG.updateHitbox();
    descBG.x = 30;
    descBG.y = description.y - 14;
    
    bg.color = CoolUtil.colorFromString(dataDevs[selInt].color);
 
    changeShit();
}

function onUpdate()
{
    if (canSelect)
    {
        if (Controls.BACK)
        {
            CoolUtil.switchState(new CustomState('menus/GenericMenu'));

            FlxG.sound.play(Paths.sound('cancelMenu'));
            canSelect = false;
        }

        if (Controls.UP_P || Controls.MOUSE_WHEEL_UP)
        {
            selInt -= 1;
            if (selInt < 0)
                selInt = developers.length - 1;
            changeShit();
        }

        if (Controls.DOWN_P || Controls.MOUSE_WHEEL_DOWN)
        {
            selInt += 1;
            if (selInt >= developers.length)
                selInt = 0;
            changeShit();
        }

        if (Controls.ACCEPT)
        {
            if (dataDevs[selInt].link != null && dataDevs[selInt].link.length > 0)
                FlxG.openURL(dataDevs[selInt].link);
        }
    }

    game.camGame.scroll.y = CoolUtil.fpsLerp(game.camGame.scroll.y, theY - 220, 0.2);

    bg.screenCenter();
    glow.screenCenter();
}

function changeShit()
{
    for (index => spr in developers)
    {
        spr.alpha = index == selInt ? 1 : 0.5;
        spr.scaleX = spr.scaleY = index == selInt ? 0.82 : 0.7;
    }

    for (index => spr in icons)
        spr.alpha = index == selInt ? 1 : 0.6;

    for (dev in developers)
        if (developers.members.indexOf(dev) == selInt)
            theY = dev.y;

    description.text = dataDevs[selInt].description;

    descBG.scale.y = description.height + 28;
    descBG.updateHitbox();
    descBG.x = 30;
    descBG.y = description.y - 14;

    bg.color = CoolUtil.colorFromString(dataDevs[selInt].color);
}
