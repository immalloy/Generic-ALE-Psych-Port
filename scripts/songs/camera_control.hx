function postCreate()
{
    if (game == null || game.CHART == null || game.strumLines == null)
        return;

    var first = findFirstCameraMovement();
    if (first == null)
        return;

    game.shouldMoveCamera = false;

    if (first.time <= 0)
    {
        applyCameraMovement(first.event);
    }
    else
    {
        applyStartCamera();
    }
}

function findFirstCameraMovement():Dynamic
{
    var earliest:Float = Math.POSITIVE_INFINITY;
    var result:Dynamic = null;

    for (eventList in game.CHART.events)
    {
        var time:Float = eventList[0];
        for (ev in cast(eventList[1], Array<Dynamic>))
        {
            if (ev == null || ev.length == 0)
                continue;
            if (Std.string(ev[0]) != 'Camera Movement')
                continue;

            if (time < earliest)
            {
                earliest = time;
                result = {time: time, event: ev};
            }
        }
    }

    return result;
}

function applyCameraMovement(ev:Array<Dynamic>)
{
    var target = ev[1];
    var doTween = ev[2];
    var steps = ev[3];
    var easeName = ev[4];
    var easeType = ev[5];

    var targetIndex:Int = mapTargetIndex(Std.int(toFloat(target, 0)));
    var strl = game.strumLines.members[targetIndex];
    if (strl == null)
        return;

    var pos = getStrumLineCamera(strl);
    if (pos == null)
        return;

    var duration:Float = (Conductor.stepCrochet * toFloat(steps, 0)) / 1000;
    var easeKey:String = (easeName == null ? '' : Std.string(easeName)) + (easeType == null ? '' : Std.string(easeType));
    var easeFunc = CoolUtil.easeFromString(easeKey);

    if (doTween == true && duration > 0 && Std.string(easeName) != 'CLASSIC' && Reflect.hasField(game.camGame, 'tweenPosition'))
        game.camGame.tweenPosition(pos.x, pos.y, duration, {ease: easeFunc});
    else
        game.camGame.position.set(pos.x, pos.y);
}

function applyStartCamera()
{
    if (game == null || game.camGame == null || game.stage == null)
        return;

    switch (game.stage.id)
    {
        case 'sonic2':
            game.camGame.position.set(1300, 1300);
        case 'majin2':
            game.camGame.position.set(1400, 1600);
        case 'lordxnew':
            game.camGame.position.set(1400, 1400);
        default:
    }
}

function mapTargetIndex(idx:Int):Int
{
    return switch (idx)
    {
        case 0: 1; // opponent
        case 1: 2; // player
        case 2: 0; // extra
        default: idx;
    }
}

function getStrumLineCamera(strl:Dynamic):Dynamic
{
    if (strl == null || strl.characters == null || strl.characters.length == 0)
        return null;

    var sumX:Float = 0;
    var sumY:Float = 0;
    var count:Int = 0;

    for (char in strl.characters)
    {
        if (char == null || !char.visible)
            continue;

        var camPos = Reflect.hasField(game, 'getCharacterCamera') ? game.getCharacterCamera(char) : null;
        if (camPos == null)
        {
            var mid = char.getMidpoint();
            camPos = {x: mid.x + char.data.cameraPosition.x * (char.type == 'player' ? -1 : 1), y: mid.y + char.data.cameraPosition.y};
        }

        var camX = camPos.x;
        var camY = camPos.y;

        sumX += camX;
        sumY += camY;
        count++;
    }

    if (count == 0)
        return null;

    return {x: sumX / count, y: sumY / count};
}

function toFloat(value, fallback:Float):Float
{
    if (value == null)
        return fallback;

    var num:Float = Std.parseFloat(Std.string(value));
    return Math.isNaN(num) ? fallback : num;
}
