package states;

import lime.utils.Preloader;
import flixel.FlxG;
import flixel.util.FlxColor;
import objects.Character;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import backend.Paths;
import backend.ChartParser;
import flixel.FlxState;
import substates.PauseSubstate;

import objects.ClippingGroup;

class NoteTestingState extends FlxState {
	var sprite:FlxSprite;
	var ui:ClippingGroup;

	override function create() {
		FlxG.camera.bgColor = FlxColor.GRAY;

		
	}

	var speed:Float = 10;
	override function update(elapsed:Float) {
		if(FlxG.keys.justPressed.ENTER) {
			openSubState(new PauseSubstate());
		}
		
		super.update(elapsed);
	}
}