function onEventHit(eventId, p1, p2, p3, p4, p5, p6, p7, p8)
{
    var target = p1;
    var animName = p2;
    var force = p3;
    var _context = p4;
    if (eventId != null && Std.string(eventId) != 'Play Animation')
        return;

    if (game == null)
        return;

    var idx:Int = Std.int(toFloat(target, 0));
    var anim:String = Std.string(animName);
    var doForce:Bool = force == true;

    var character:Dynamic = null;
    switch (idx)
    {
        case 0:
            character = game.dad;
        case 1:
            character = game.boyfriend;
        case 2:
            character = game.gf;
        default:
    }

    if (character != null && anim != null)
        character.playAnim(anim, doForce);
}

function toFloat(value, fallback:Float):Float
{
    if (value == null)
        return fallback;

    var num:Float = Std.parseFloat(Std.string(value));
    return Math.isNaN(num) ? fallback : num;
}
