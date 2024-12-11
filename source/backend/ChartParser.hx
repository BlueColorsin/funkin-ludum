package backend;

import flixel.util.FlxColor;
import backend.NoteTypeHandler;
import flash.display.BitmapData;

using StringTools;

typedef NoteData = {
	type:NoteType,
	sustainLength:Int,
	data:Int
}

typedef ChartSection = {
	notes:Array<Array<NoteData>>,
	scale:Float
}

typedef Song = {

}

/*
	funny class that turns an array of images to chart data
*/
class ChartParser {
	public inline static var IGNORE_COLOR = "FFFFFF";

	public static var bitmap:BitmapData;

	// LMAOOOO STOLE ALL THIS FROM FLXBASETILEMAP LOLOL (it's actually not)

	public static function parse() {
		
	}

	public static function parseSection(path:String):ChartSection {
		bitmap = BitmapData.fromFile(path);
		
		var section:ChartSection = {
			notes: [],
			scale: 16 / bitmap.height // add time signature
		};

		for (y in 0...bitmap.height) {
			section.notes.push([]);

			for (x in 0...bitmap.width) {
				var color:String = getPixelColor(x, y);
				
				if (color == IGNORE_COLOR)
					continue;
		
				var note:NoteData = {
					type: NoteTypeHandler.get(color),
					sustainLength: getSustainLength(x, y, color),
					data: x
				}

				section.notes[y].push(note);
			}
		}

		bitmap.dispose(); bitmap = null;

		return section;
	}

	private static function getSustainLength(x:Int, y:Int, color:String):Int {
		var length:Int = 0;

		for (thing in y + 1...bitmap.height) {
			if(getPixelColor(x, thing) != color) break;

			bitmap.setPixel(x, thing, FlxColor.fromString('#$IGNORE_COLOR'));

			length = thing;
		}

		return length;
	}

	private static inline function getPixelColor(x:Int, y:Int):String {
		return FlxColor.fromInt(bitmap.getPixel(x, y)).toHexString(false, false);
	}
}
