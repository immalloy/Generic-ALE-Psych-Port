function onEventHit(eventId, p1, p2, p3, p4, p5, p6, p7, p8)
{
    var doTween = p1;
    var zoomValue = p2;
    var camId = p3;
    var steps = p4;
    var easeName = p5;
    var easeType = p6;
    var mode = p7;
    var permanent = p8;
    if (eventId != null && Std.string(eventId) != 'Camera Zoom')
        return;

    if (game == null)
        return;

    var cam = resolveCamera(camId);
    if (cam == null)
        return;

    var target:Float = toFloat(zoomValue, cam.zoom);

    if (Std.string(mode) == 'stage' && game.stage != null && game.stage.data != null)
        target = (game.stage.data.zoom ?? 1) * target;

    var duration:Float = toFloat(steps, 0);
    duration = (Conductor.stepCrochet * duration) / 1000;

    var easeKey:String = (easeName == null ? '' : Std.string(easeName)) + (easeType == null ? '' : Std.string(easeType));
    var easeFunc = CoolUtil.easeFromString(easeKey);

    if (doTween == true && duration > 0 && Reflect.hasField(cam, 'tweenZoom'))
    {
        cam.tweenZoom(target, duration, {ease: easeFunc}, permanent == null ? true : permanent);
    }
    else
    {
        cam.zoom = target;
        if (Reflect.hasField(cam, 'targetZoom'))
            cam.targetZoom = target;
    }
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
