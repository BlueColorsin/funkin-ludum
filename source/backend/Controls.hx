package backend;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Controls {
	public static var binds:Map<String, Array<FlxKey>> = [
		"note_left"  => [D, LEFT],
		"note_down"  => [F, DOWN],
		"note_up"    => [J, UP],
		"note_right" => [K, RIGHT]
	];

	public static function pressed(key:String):Bool {
		return FlxG.keys.anyPressed(binds.get(key));
	}

	public static function justPressed(key:String):Bool {
		return FlxG.keys.anyJustPressed(binds.get(key));
	}

	public static function justReleased(key:String):Bool {
		return FlxG.keys.anyJustReleased(binds.get(key));
	}
}
