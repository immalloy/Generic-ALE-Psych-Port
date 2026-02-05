function onEventHit(eventId, p1, p2, p3, p4, p5, p6, p7, p8)
{
    var imagePath = p1;
    var fadeDuration = p2;
    var fadeDelay = p3;
    var playSound = p4;
    if (eventId != null && Std.string(eventId) != 'Vine Boom Image')
        return;

    if (game == null)
        return;

    var image = new FlxSprite().loadGraphic(Paths.image(Std.string(imagePath)));
    if (image == null)
        return;

    image.updateHitbox();
    image.screenCenter();
    image.cameras = [game.camHUD];
    image.scale.set(FlxG.height / image.height, FlxG.height / image.height);
    add(image);

    var duration:Float = toFloat(fadeDuration, 0.5);
    var delay:Float = toFloat(fadeDelay, 0);
    FlxTween.tween(image, {alpha: 0}, duration, {startDelay: delay, onComplete: (_) -> { image.kill(); image.destroy(); }});

    if (playSound == true)
    {
        var snd = Paths.sound('vineBoom');
        if (snd != null)
            FlxG.sound.play(snd);
    }
}

function toFloat(value, fallback:Float):Float
{
    if (value == null)
        return fallback;

    var num:Float = Std.parseFloat(Std.string(value));
    return Math.isNaN(num) ? fallback : num;
}
