var cached:Bool = false;

function onCreate()
{
    if (cached)
        return;

    cached = true;

    var files = Paths.readDirectory('data/characters');
    if (files == null)
        return;

    for (file in files)
    {
        if (!StringTools.endsWith(file, '.json'))
            continue;

        var id = file.substr(0, file.length - 5);
        cacheCharacter(id);
    }
}

function cacheCharacter(id:String)
{
    var json = Paths.json('data/characters/' + id, true, false);
    if (json == null)
        return;

    if (Reflect.hasField(json, 'format') && json.format == 'ale-character-v0.1')
    {
        var textures = Reflect.field(json, 'textures');
        var type = Std.string(Reflect.field(json, 'type'));

        if (type == 'map')
            Paths.getAnimateAtlas(textures[0], true, false);
        else
            Paths.getMultiAtlas(textures, true, false);

        if (Reflect.hasField(json, 'icon'))
            Paths.image('icons/' + Std.string(Reflect.field(json, 'icon')), true, false);
    }
    else
    {
        var image = Std.string(Reflect.field(json, 'image'));
        var images = [for (img in image.split(',')) img.trim()];
        Paths.getMultiAtlas(images, true, false);

        if (Reflect.hasField(json, 'healthicon'))
            Paths.image('icons/' + Std.string(Reflect.field(json, 'healthicon')), true, false);
    }
}
