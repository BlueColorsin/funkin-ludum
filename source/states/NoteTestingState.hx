package states;

import objects.Character;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import backend.Paths;
import backend.ChartParser;
import flixel.FlxState;

class NoteTestingState extends FlxState {
	override function create() {
		ChartParser.parse("spookeez");

		trace(ChartParser.data);

		super.create();
	}
}