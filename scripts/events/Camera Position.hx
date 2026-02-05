function onEventHit(eventId, p1, p2, p3, p4, p5, p6, p7, p8)
{
    var x = p1;
    var y = p2;
    var doTween = p3;
    var steps = p4;
    var easeName = p5;
    var easeType = p6;
    var relative = p7;
    if (eventId != null && Std.string(eventId) != 'Camera Position')
        return;

    if (game == null || game.camGame == null)
        return;

    var cam = game.camGame;
    var targetX:Float = toFloat(x, cam.position.x);
    var targetY:Float = toFloat(y, cam.position.y);

    if (relative == true)
    {
        targetX += cam.position.x;
        targetY += cam.position.y;
    }

    var duration:Float = toFloat(steps, 0);
    duration = (Conductor.stepCrochet * duration) / 1000;

    var easeKey:String = (easeName == null ? '' : Std.string(easeName)) + (easeType == null ? '' : Std.string(easeType));
    var easeFunc = CoolUtil.easeFromString(easeKey);

    if (doTween == true && duration > 0 && Reflect.hasField(cam, 'tweenPosition'))
    {
        cam.tweenPosition(targetX, targetY, duration, {ease: easeFunc});
    }
    else
    {
        cam.position.set(targetX, targetY);
    }
}

function toFloat(value, fallback:Float):Float
{
    if (value == null)
        return fallback;

    var num:Float = Std.parseFloat(Std.string(value));
    return Math.isNaN(num) ? fallback : num;
}
