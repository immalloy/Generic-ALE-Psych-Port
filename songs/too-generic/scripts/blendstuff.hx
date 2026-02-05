import openfl.display.BlendMode;

var tone:FlxSprite;

function postCreate()
{
    tone = new FlxSprite().loadGraphic(Paths.image('stages/sonic2/tone'));
    if (tone != null)
    {
        tone.blend = BlendMode.ADD;
        add(tone);
    }

    if (game != null && game.gf != null)
        game.gf.visible = false;
}
