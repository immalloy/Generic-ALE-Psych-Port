import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxMath;
import openfl.display.BlendMode;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxAxes;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import utils.Score;

var qbo:String = 'genericmenu/';

var isInDebug:Bool = false;

var score:FlxText;

var songs:Array<{song:String, title:String, playSong:String}> = [
    {song: 'toogeneric', title: 'toogenericlogo', playSong: 'too-generic'},
    {song: 'funisgeneric', title: 'funisgenericlogo', playSong: 'fun-is-generic'},
    {song: 'lordx', title: 'exenericlogo', playSong: 'exeneric'}
];

var curShit:Int = 0;
var songsGrp:FlxTypedGroup<FlxSprite>;
var titlesGrp:FlxTypedGroup<FlxSprite>;

var forceToChange:Bool = false;
var overlaping:Bool = false;

var intendedScore:Float = 0;
var lerpScore:Float = 0;

var startTimer:FlxTimer;

function onCreate()
{
    overlaping = false;
    forceToChange = false;
    curShit = 0;

    if (FlxG.sound.music == null)
        FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.2);
    else
        FlxG.sound.music.volume = 0.2;

    var bg = new FlxSprite();
    bg.frames = Paths.getSparrowAtlas(qbo + 'fondo');
    bg.animation.addByPrefix('idle', 'fondo', 24, true);
    bg.animation.play('idle');
    bg.scale.set(2.6, 2.4);
    bg.screenCenter();
    bg.antialiasing = false;
    add(bg);

    songsGrp = new FlxTypedGroup<FlxSprite>();
    titlesGrp = new FlxTypedGroup<FlxSprite>();
    add(songsGrp);
    add(titlesGrp);

    for (i in 0...songs.length)
    {
        var spr = new FlxSprite();
        spr.ID = i;
        spr.frames = Paths.getSparrowAtlas(qbo + songs[i].song);
        spr.animation.addByPrefix('idle', songs[i].song + '0000', 24, false);
        spr.animation.addByPrefix('selected', songs[i].song, 24, false);
        spr.animation.play('idle');
        spr.alpha = 0.6;
        spr.scale.set(0.85, 0.85);
        spr.antialiasing = true;

        spr.y = (FlxG.height / 2) - (spr.height / 2) + 50;

        switch (songs[i].song)
        {
            case 'toogeneric':
                spr.x = 150;
                spr.scale.set(0.75, 0.75);
            case 'funisgeneric':
                spr.screenCenter(FlxAxes.X);
            case 'lordx':
                spr.x = 815;
                spr.scale.set(0.75, 0.75);
        }

        spr.updateHitbox();
        songsGrp.add(spr);

        var title = new FlxSprite();
        title.ID = i;
        title.frames = Paths.getSparrowAtlas(qbo + songs[i].title);
        title.animation.addByPrefix('idle', songs[i].title, 24, false);
        title.animation.play('idle');
        title.alpha = 0;
        title.scale.set(0.85, 0.85);
        title.antialiasing = true;

        title.x = -40;
        title.y = 500;

        switch (songs[i].title)
        {
            case 'toogenericlogo':
                title.x += 8;
                title.y += 42;
            case 'funisgenericlogo', 'exenericlogo':
                title.y += 100;
        }

        titlesGrp.add(title);
    }

    var glow = new FlxSprite(0, 0);
    glow.frames = Paths.getSparrowAtlas(qbo + 'add');
    glow.animation.addByPrefix('idle', 'add', 24, true);
    glow.animation.play('idle');
    glow.scale.set(1, 1);
    glow.alpha = 0.6;
    glow.blend = BlendMode.ADD;
    add(glow);

    var sep = new FlxSprite(0, -45);
    sep.frames = Paths.getSparrowAtlas(qbo + 'blackbarscore');
    sep.animation.addByPrefix('idle', 'blackbarscore', 24, true);
    sep.animation.play('idle');
    sep.screenCenter(FlxAxes.X);
    sep.antialiasing = false;
    add(sep);

    score = new FlxText(0, 5, 0, 'Score: 0', 70);
    score.font = Paths.font('olawei.ttf');
    score.y = (sep.height / 2) - (score.height / 2) - 30;
    add(score);
}

function onUpdate(elapsed:Float)
{
    if (songsGrp == null || titlesGrp == null)
        return;

    overlaping = false;

    songsGrp.forEach(function(spr:FlxSprite) {
        var title = titlesGrp.members[spr.ID];
        if (title == null) return;

        spr.alpha = 0.6;
        title.alpha = 0;

        if (!forceToChange && FlxG.mouse.overlaps(spr))
        {
            overlaping = true;
            curShit = spr.ID;
            spr.alpha = 1;
            title.alpha = 1;

            if (FlxG.mouse.justPressed && !isInDebug)
            {
                forceToChange = true;
                spr.animation.play('selected', true);

                if (FlxG.sound.music != null)
                    FlxG.sound.music.fadeOut(1, 0, function(_) {
                        FlxG.sound.music.stop();
                    });

                FlxG.sound.play(Paths.sound(songs[curShit].song + '-laugh'));

                if (startTimer != null)
                    startTimer.cancel();

                startTimer = new FlxTimer().start(3.5, function(_) {
                    CoolUtil.switchState(new PlayState('freeplay', [songs[curShit].playSong], 'normal'));
                });
            }
        }
    });

    if (forceToChange)
    {
        songsGrp.forEach(function(spr:FlxSprite) {
            var title = titlesGrp.members[spr.ID];
            if (spr.ID == curShit)
            {
                overlaping = true;
                spr.alpha = 1;
                title.alpha = 1;
            }
        });
    }

    var songId:String = CoolUtil.formatToSongPath(songs[curShit].playSong + '-normal');
    var bestScore:Float = Score.song.get(songId) ?? 0;

    intendedScore = overlaping ? bestScore : 0;

    lerpScore = FlxMath.lerp(lerpScore, intendedScore, 0.4);
    if (Math.abs(lerpScore - intendedScore) <= 10)
        lerpScore = intendedScore;

    score.text = 'Score: ' + Std.int(lerpScore);
    score.x = (FlxG.width - score.width) / 2;

    if (Controls.BACK)
        CoolUtil.switchState(new CustomState('menus/GenericMenu'));
}

function onDestroy()
{
    if (startTimer != null)
        startTimer.cancel();

    songsGrp = null;
    titlesGrp = null;
}
