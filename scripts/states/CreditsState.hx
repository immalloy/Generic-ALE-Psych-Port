import flixel.util.FlxColor;

var data = Json.parse(File.getContent(Paths.getPath('data/credits.json'))).categories;

var dataDevs:Array = [];

var bg:FlxSprite;

var categories:FlxTypedGroup;
var developers:FlxTypedGroup;
var icons:FlxTypedGroup;

var descBG:FlxSprite;
var description:FlxText;

var selInt:Int = CoolUtil.save.custom.data.credits ?? 0;

var theY:Float = 0;

function onCreate()
{
    bg = new FlxSprite().loadGraphic(Paths.image('ui/menuBG'));
    bg.scrollFactor.set();
    add(bg);
    bg.scale.x = bg.scale.y = 1.25;
    bg.antialiasing = ClientPrefs.data.antialiasing;

    add(categories = new FlxTypedGroup());
    add(developers = new FlxTypedGroup());
    add(icons = new FlxTypedGroup());

    var catOffset:Float = 0;

    for (category in data)
    {
        var catIndex:Int = data.indexOf(category);

        var title:Alphabet = new Alphabet(0, catIndex + catOffset, category.name);
        title.x = FlxG.width / 2 - title.width / 2;
        categories.add(title);
        title.antialiasing = ClientPrefs.data.antialiasing;

        catOffset += title.height + 60;

        for (dev in category.developers)
        {
            dataDevs.push(dev);

            var devIndex:Int = category.developers.indexOf(dev);

            var alpha:Alphabet = new Alphabet(0, title.y + title.height + 60 + 100 * devIndex, dev.name, false);
            developers.add(alpha);
            alpha.scaleX = alpha.scaleY = 0.75;
            alpha.x = FlxG.width / 2 - alpha.width / 2;
            alpha.antialiasing = ClientPrefs.data.antialiasing;

            for (let in alpha)
            {
                let.colorTransform.redOffset = 255;
                let.colorTransform.greenOffset = 255;
                let.colorTransform.blueOffset = 255;
            }

            var icon:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/credits/' + dev.icon));
            icons.add(icon);
            icon.antialiasing = ClientPrefs.data.antialiasing;

            var size:Float = dev.size ?? 100;
            icon.scale.x = size / icon.width;
            icon.scale.y = size / icon.height;
            icon.updateHitbox();

            alpha.x -= icon.width / 2 - 10;

            icon.x = alpha.x + alpha.width + 20;
            icon.y = alpha.y + alpha.height / 2 - icon.height / 2;

            alpha.y -= 40;

            catOffset += 100;
        }

        catOffset += 75;
    }
    
    if (selInt >= developers.length)
        selInt = 0;

    descBG = new FlxSprite().makeGraphic(FlxG.width, 1, FlxColor.BLACK); 
    descBG.alpha = 0.5;
    descBG.scrollFactor.set();
    add(descBG);

    description = new FlxText(20, 0, FlxG.width - 40, '', 30);
    description.font = Paths.font('vcr.ttf');
    description.alignment = 'center';
    add(description);
    description.scrollFactor.set();
    description.x = FlxG.width - description.width;
    description.y = FlxG.height - 100 - description.height / 2;

    descBG.scale.y = description.height + 40;
    descBG.updateHitbox();
    descBG.y = description.y - 20;
    
    bg.color = CoolUtil.colorFromString(dataDevs[selInt].color);
 
    changeShit();
}

var canSelect:Bool = true;

function onUpdate()
{
    if (canSelect)
    {
        if (Controls.BACK)
        {
            CoolUtil.switchState(new CustomState('menus/GenericMenu'));

            FlxG.sound.play(Paths.sound('cancelMenu'));
        }

        if (Controls.UP_P)
        {
            selInt -= 1;
            if (selInt < 0)
                selInt = developers.length - 1;
            changeShit();
        }

        if (Controls.DOWN_P)
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
}

function changeShit()
{
    for (index => spr in developers)
    {
        spr.alpha = index == selInt ? 1 : 0.6;
        spr.scaleX = spr.scaleY = index == selInt ? 0.8 : 0.7;
    }

    for (index => spr in icons)
        spr.alpha = index == selInt ? 1 : 0.6;

    description.text = dataDevs[selInt].description;

    descBG.scale.y = description.height + 40;
    descBG.updateHitbox();
    descBG.y = description.y - 20;

    bg.color = CoolUtil.colorFromString(dataDevs[selInt].color);
}
