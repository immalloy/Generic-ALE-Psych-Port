//coded by happi_3868

var flash = new FlxSprite(0, 0).makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
flash.cameras = [camHUD];

function onEvent(e) if (e.event.name == "Camera Flash+") {
	var params = e.event.params;
	FlxTween.cancelTweensOf(flash);
	remove(flash);
	if (params[6]) {
		insert(100000,flash);
	} else {
		insert(0,flash);
	}
	var destroy = params[7];
	flash.alpha = params[1];
	flash.colorTransform.color = params[0];
	switch (e.event.params[4]) {
		case "linear":
			FlxTween.tween(flash, {alpha: params[2]}, (Conductor.stepCrochet * params[3] ) / 1000, {onComplete: function(){
				if(destroy) flash.alpha = 0;
			}});
		default:
			FlxTween.tween(flash, {alpha: params[2]}, (Conductor.stepCrochet * params[3] ) / 1000, {ease: CoolUtil.flxeaseFromString(e.event.params[4], e.event.params[5])}, {onComplete: function(){
				if(destroy) flash.alpha = 0;
			}});
	}
}