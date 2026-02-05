var sky:FlxSprite;
var background:FlxSprite;
var midground:FlxSprite;
var foreground:FlxSprite;
var lel:FlxSprite;

function postCreate()
{
    sky = stageObj('sky');
    background = stageObj('background');
    midground = stageObj('midground');
    foreground = stageObj('foreground');
    lel = stageObj('lel');

    if (game != null && game.gf != null)
        game.gf.visible = false;

    if (lel != null)
        lel.visible = false;
}

function onStepHit(curStep)
{
    if (curStep == 1471)
    {
        if (lel != null) lel.visible = true;
        if (sky != null) sky.visible = false;
        if (background != null) background.visible = false;
        if (midground != null) midground.visible = false;
        if (foreground != null) foreground.visible = false;

        if (game != null)
        {
            if (game.boyfriend != null) game.boyfriend.visible = false;
            if (game.dad != null) game.dad.visible = true;
            game.shouldMoveCamera = false;

            if (game.camGame != null && game.dad != null && Reflect.hasField(game, 'getCharacterCamera'))
            {
                var camPos = game.getCharacterCamera(game.dad);
                if (camPos != null)
                    game.camGame.position.set(camPos.x, camPos.y);
            }
        }
    }

    if (curStep == 1503)
    {
        fadeHud();
        moveStrums();
    }
}

function fadeHud()
{
    if (game == null)
        return;

    if (game.playerIcon != null)
        FlxTween.tween(game.playerIcon, {alpha: 0}, 0.5);

    if (game.opponentIcon != null)
        FlxTween.tween(game.opponentIcon, {alpha: 0}, 0.5);

    if (game.healthBar != null)
        FlxTween.tween(game.healthBar, {alpha: 0}, 0.5);

    if (game.scoreText != null)
        FlxTween.tween(game.scoreText, {alpha: 0}, 0.5);
}

function moveStrums()
{
    if (game == null || game.strumLines == null)
        return;

    for (strl in game.strumLines.members)
    {
        if (strl == null || strl.strums == null)
            continue;

        var offset:Float = 0;
        var hide:Bool = false;

        if (strl.type == 'opponent')
        {
            offset = -1050;
            hide = true;
        }
        else if (strl.type == 'player')
        {
            offset = -320;
        }

        for (strum in strl.strums.members)
        {
            if (strum == null)
                continue;

            var props:Dynamic = { x: strum.x + offset };
            if (hide)
                props.alpha = 0;

            FlxTween.tween(strum, props, 1.5, { ease: FlxEase.quadOut });
        }
    }
}

function stageObj(id:String):FlxSprite
{
    if (game == null || game.stage == null)
        return null;

    return game.stage.get(id);
}
