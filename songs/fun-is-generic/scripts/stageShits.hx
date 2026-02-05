var mapingf:FlxSprite;
var light:FlxSprite;
var light1:FlxSprite;
var light2:FlxSprite;
var mapinVolando:FlxSprite;

var mapinTween:FlxTween;
var mapinTween2:FlxTween;
var mapinTimer:FlxTimer;
var lightTween:FlxTween;
var lightTween1:FlxTween;
var lightTween2:FlxTween;
var dadStart:{x:Float, y:Float};
var bfStart:{x:Float, y:Float};

function postCreate()
{
    mapingf = stageObj('mapingf');
    light = stageObj('light');
    light1 = stageObj('light1');
    light2 = stageObj('light2');
    mapinVolando = stageObj('mapinVolando');

    if (game != null && game.gf != null)
        game.gf.visible = false;

    if (game != null)
    {
        if (game.dad != null)
            dadStart = {x: game.dad.x, y: game.dad.y};
        if (game.boyfriend != null)
            bfStart = {x: game.boyfriend.x, y: game.boyfriend.y};
    }

    if (mapingf != null)
    {
        mapingf.frames = Paths.getSparrowAtlas('stages/majin2/mapingf');
        mapingf.animation.addByPrefix('idle', 'idle', 24, true);
        mapingf.animation.addByPrefix('vuelavuela', 'anim', 24, false);
        mapingf.animation.play('idle');
        mapingf.updateHitbox();
    }

    if (light != null)
    {
        light.angle = 2;
        light.origin.set(light.width / 2, light.height);
        lightTween = FlxTween.tween(light, { angle: -2 }, 2, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
    }

    if (light1 != null)
    {
        light1.angle = 15;
        light1.origin.set(light1.width / 2, light1.height);
        lightTween1 = FlxTween.tween(light1, { angle: -15 }, 2, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
    }

    if (light2 != null)
    {
        light2.angle = -15;
        light2.origin.set(light2.width / 2, light2.height);
        lightTween2 = FlxTween.tween(light2, { angle: 15 }, 2, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
    }

    if (mapingf != null)
    {
        mapingf.y -= 80;
        mapinTween = FlxTween.tween(mapingf, { y: mapingf.y + 80 }, 2, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
    }
}

function onBeatHit(curBeat)
{
    if (curBeat == 164 && mapingf != null)
    {
        mapingf.offset.y = 300;
        mapingf.animation.play('vuelavuela');

        if (mapinVolando != null)
        {
            if (mapinTimer != null)
                mapinTimer.cancel();

            mapinTimer = new FlxTimer().start(2, function(_) {
                FlxTween.tween(mapinVolando, { y: mapinVolando.y - 4500 }, 0.7, { ease: FlxEase.expoOut, onComplete: function(_) {
                    mapinVolando.alpha = 0;
                }});
            });
        }
    }

}

function onStepHit(curStep)
{
    if (curStep == 712 && game != null)
    {
        if (game.dad != null)
            game.dad.setPosition(1608.82, 360.85);

        if (game.boyfriend != null)
            game.boyfriend.setPosition(2568.14, 561.78);

        if (game.dad != null)
            mapinTween2 = FlxTween.tween(game.dad, { y: game.dad.y + 80 }, 2, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
    }

    if (curStep == 935 && game != null)
    {
        if (mapinTween2 != null)
        {
            mapinTween2.cancel();
            mapinTween2 = null;
        }

        if (game.dad != null && dadStart != null)
            game.dad.setPosition(dadStart.x, dadStart.y);

        if (game.boyfriend != null && bfStart != null)
            game.boyfriend.setPosition(bfStart.x, bfStart.y);
    }
}

function onDestroy()
{
    if (mapinTween != null)
        mapinTween.cancel();
    if (mapinTween2 != null)
        mapinTween2.cancel();
    if (lightTween != null)
        lightTween.cancel();
    if (lightTween1 != null)
        lightTween1.cancel();
    if (lightTween2 != null)
        lightTween2.cancel();
    if (mapinTimer != null)
        mapinTimer.cancel();
}

function stageObj(id:String):FlxSprite
{
    if (game == null || game.stage == null)
        return null;

    return game.stage.get(id);
}
