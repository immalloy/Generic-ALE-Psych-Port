function onEventHit(eventId, p1, p2, p3, p4, p5, p6, p7, p8)
{
    var strumIndex = p1;
    var charName = p2;
    var memberIndex = p3;
    var updateBar = p4;
    if (eventId != null && Std.string(eventId) != 'Change Character')
        return;

    if (game == null || game.strumLines == null)
        return;

    var originalIndex:Int = Std.int(toFloat(strumIndex, 0));
    var sIndex:Int = mapTargetIndex(originalIndex);
    var mIndex:Int = Std.int(toFloat(memberIndex, 0));
    var newChar:String = Std.string(charName);

    var strl = game.strumLines.members[sIndex];
    if (strl == null || strl.characters == null || mIndex < 0 || mIndex >= strl.characters.length)
        return;

    var character = strl.characters[mIndex];
    if (character == null)
        return;

    var updateBarBool:Bool = updateBar == true || Std.string(updateBar) == 'true' || Std.string(updateBar) == '1';

    var changeFunc = Reflect.field(game, 'changeCharacter');
    if (changeFunc != null)
        Reflect.callMethod(game, changeFunc, [character, newChar]);
    else
        character.change(newChar);

    if (Reflect.hasField(game, 'resetCharacterPosition'))
        game.resetCharacterPosition(character);

    if (originalIndex == 1)
    {
        if (game.playerIcon != null)
            game.playerIcon.change(character.data.icon);
        if (game.healthBar != null)
            game.healthBar.leftBar.color = CoolUtil.colorFromString(character.data.barColor);
    }
    else if (originalIndex == 0)
    {
        if (game.opponentIcon != null)
            game.opponentIcon.change(character.data.icon);
        if (game.healthBar != null)
            game.healthBar.rightBar.color = CoolUtil.colorFromString(character.data.barColor);
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

function toFloat(value, fallback:Float):Float
{
    if (value == null)
        return fallback;

    var num:Float = Std.parseFloat(Std.string(value));
    return Math.isNaN(num) ? fallback : num;
}
