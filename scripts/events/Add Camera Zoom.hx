function onEventHit(eventId, p1, p2, p3, p4, p5, p6, p7, p8)
{
    var amount = p1;
    var camId = p2;
    if (eventId != null && Std.string(eventId) != 'Add Camera Zoom')
        return;

    if (game == null)
        return;

    var cam = resolveCamera(camId);
    if (cam == null)
        return;

    var add:Float = toFloat(amount, 0);
    cam.zoom += add;
    if (Reflect.hasField(cam, 'targetZoom'))
        cam.targetZoom += add;
}

function resolveCamera(id)
{
    if (game == null)
        return null;

    switch (Std.string(id))
    {
        case 'camHUD':
            return game.camHUD;
        case 'camOther':
            return game.camOther;
        default:
            return game.camGame;
    }
}

function toFloat(value, fallback:Float):Float
{
    if (value == null)
        return fallback;

    var num:Float = Std.parseFloat(Std.string(value));
    return Math.isNaN(num) ? fallback : num;
}
