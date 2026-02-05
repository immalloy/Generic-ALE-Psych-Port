import funkin.visuals.shaders.ALERuntimeShader;

var shaders:Array<ALERuntimeShader> = [];

function postCreate()
{
    if (ClientPrefs.data == null || !ClientPrefs.data.shaders)
        return;

    shaders = [
        new ALERuntimeShader('lowquality_0_reduce'),
        new ALERuntimeShader('lowquality_1_sharpen'),
        new ALERuntimeShader('lowquality_2_blockEffect'),
        new ALERuntimeShader('lowquality_3_main'),
        new ALERuntimeShader('lowquality_4_amplification')
    ];

    if (game != null)
    {
        if (game.camGame != null)
            game.camGame.setShaders(shaders);
        if (game.camHUD != null)
            game.camHUD.setShaders(shaders);
    }
}

function onDestroy()
{
    if (game != null)
    {
        if (game.camGame != null)
            game.camGame.setShaders([]);
        if (game.camHUD != null)
            game.camHUD.setShaders([]);
    }
}
