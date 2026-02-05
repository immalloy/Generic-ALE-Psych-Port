import openfl.display.BlendMode;

var addA:FlxSprite;

function postCreate()
{
    addA = new FlxSprite().loadGraphic(Paths.image('stages/lordxnew/add'));
    if (addA != null)
    {
        addA.blend = BlendMode.ADD;
        add(addA);
    }
}

function onStepHit(curStep)
{
    if (curStep == 1471 && addA != null)
        addA.visible = false;
}
