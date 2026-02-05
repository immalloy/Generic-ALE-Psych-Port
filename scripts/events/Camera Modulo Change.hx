function onEventHit(eventId, p1, p2, p3, p4, p5, p6, p7, p8)
{
    var modulo = p1;
    var zoom = p2;
    var _mode = p3;
    var _unused = p4;
    if (eventId != null && Std.string(eventId) != 'Camera Modulo Change')
        return;

    if (game == null || game.camGame == null)
        return;

    var mod:Int = Std.int(toFloat(modulo, game.camGame.bopModulo));
    var z:Float = toFloat(zoom, game.camGame.bopZoom);

    game.camGame.bopModulo = mod;
    game.camGame.bopZoom = z;
}

function toFloat(value, fallback:Float):Float
{
    if (value == null)
        return fallback;

    var num:Float = Std.parseFloat(Std.string(value));
    return Math.isNaN(num) ? fallback : num;
}
