import openfl.display.BlendMode;

var bright:FlxSprite;

function postCreate()
{
    bright = new FlxSprite().loadGraphic(Paths.image('stages/majin2/brightness'));
    if (bright != null)
    {
        bright.blend = BlendMode.ADD;
        add(bright);
    }
}
