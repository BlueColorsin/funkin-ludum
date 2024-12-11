package states;

import flixel.FlxSprite;
import backend.Paths;
import backend.ChartParser;
import flixel.FlxState;

class NoteTestingState extends FlxState {
	override function create() {
		var section = ChartParser.parseSection("assets/section.png");

		var sex = new FlxSprite(50, 50, Paths.cacheBitmap("section", ChartParser.bitmap));
		sex.scale.set(8, 8);
		sex.updateHitbox();
		add(sex);
		

		for(note in section.notes)
			trace(note);

		super.create();
	}
}