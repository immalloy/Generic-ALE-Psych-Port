function onEventHit(eventId, p1, p2, p3, p4, p5, p6, p7, p8)
{
    var doTween = p1;
    var newSpeed = p2;
    var duration = p3;
    var easeName = p4;
    var easeType = p5;
    var _affectAll = p6;
    if (eventId != null && Std.string(eventId) != 'Scroll Speed Change')
        return;

    if (game == null || game.strumLines == null)
        return;

    var target:Float = toFloat(newSpeed, null);
    if (target == null)
        return;

    var time:Float = toFloat(duration, 0);
    var easeKey:String = (easeName == null ? '' : Std.string(easeName)) + (easeType == null ? '' : Std.string(easeType));
    var easeFunc = CoolUtil.easeFromString(easeKey);

    if (doTween == true && time > 0)
    {
        for (strl in game.strumLines.members)
        {
            if (strl == null)
                continue;

            FlxTween.num(strl.scrollSpeed, target, time, {ease: easeFunc}, (val) -> {
                strl.scrollSpeed = val;
            });
        }
    }
    else
    {
        for (strl in game.strumLines.members)
            if (strl != null)
                strl.scrollSpeed = target;
    }
}

function toFloat(value, fallback:Null<Float>):Null<Float>
{
    if (value == null)
        return fallback;

    var num:Float = Std.parseFloat(Std.string(value));
    return Math.isNaN(num) ? fallback : num;
}
