function onEventHit(eventId, p1, p2, p3, p4, p5, p6, p7, p8)
{
    if (eventId != null && Std.string(eventId) != 'BPM Change')
        return;

    var newBpm:Float = toFloat(p1, Conductor.bpm);
    if (!Math.isNaN(newBpm))
        Conductor.bpm = newBpm;
}

function toFloat(value, fallback:Float):Float
{
    if (value == null)
        return fallback;

    var num:Float = Std.parseFloat(Std.string(value));
    return Math.isNaN(num) ? fallback : num;
}
