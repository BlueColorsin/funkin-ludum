package;

import states.PlayState;
import states.NoteTestingState;
import states.TitleState;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();

		addChild(new FlxGame(0, 0, NoteTestingState)).name = "FlxGame";

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF)).name = "FPS";
		#end
	}
}
