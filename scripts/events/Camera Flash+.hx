var flash:FlxSprite;
var flashTimer:FlxTimer;

var flash:FlxSprite;

function onEventHit(eventId, p1, p2, p3, p4, p5, p6, p7, p8)
{
    var color = p1;
    var alphaStart = p2;
    var alphaEnd = p3;
    var steps = p4;
    var easeName = p5;
    var easeType = p6;
    var overHud = p7;
    var destroy = p8;
    if (eventId != null && Std.string(eventId) != 'Camera Flash+')
        return;

    if (game == null)
        return;

    if (flash == null)
    {
        flash = new FlxSprite(0, 0);
        flash.cameras = [game.camHUD];
    }
    flash.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    flash.visible = true;

    FlxTween.cancelTweensOf(flash);
    remove(flash, true);

    if (overHud == true)
        insert(100000, flash);
    else
        insert(0, flash);

    flash.alpha = toFloat(alphaStart, 1);
    if (color != null)
        flash.colorTransform.color = Std.int(color);

    var duration:Float = (Conductor.stepCrochet * toFloat(steps, 0)) / 1000;
    if (duration > 0.8)
        duration = 0.8;
    var easeKey:String = (easeName == null ? '' : Std.string(easeName)) + (easeType == null ? '' : Std.string(easeType));
    var easeFunc = CoolUtil.easeFromString(easeKey);

    var endAlpha:Float = 0;

    if (duration <= 0)
    {
        flash.alpha = 0;
        remove(flash, true);
        return;
    }

    if (Std.string(easeName) == 'linear')
        FlxTween.tween(flash, {alpha: endAlpha}, duration, {onComplete: (_) -> { remove(flash, true); }});
    else
        FlxTween.tween(flash, {alpha: endAlpha}, duration, {ease: easeFunc, onComplete: (_) -> { remove(flash, true); }});

    if (flashTimer != null)
        flashTimer.cancel();

    flashTimer = new FlxTimer().start(duration + 0.1, function(_) {
        remove(flash, true);
    });
}

function toFloat(value, fallback:Float):Float
{
    if (value == null)
        return fallback;

    var num:Float = Std.parseFloat(Std.string(value));
    return Math.isNaN(num) ? fallback : num;
}
