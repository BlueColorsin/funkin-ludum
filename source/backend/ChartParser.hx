package backend;

import haxe.PosInfos;
import haxe.Json;
import openfl.display.Bitmap;
import flixel.util.FlxColor;
import backend.NoteTypeHandler;
import flash.display.BitmapData;

using StringTools;

typedef BPMchange = {}
typedef Event = {}

typedef Song = {
	song:String,
	sections:Int,
	bpm:Float,
	bpmChanges:Array<BPMchange>,
	events:Array<Event>,
	notes:Array<Dynamic>
}

/*
	funny class that turns an array of images to chart data
*/
class ChartParser {
	public inline static var IGNORE_COLOR = "FFFFFF";

	public inline static var SUSTAIN_COLOR = "708090";

	public static final SONG_DATA:Song = {
		song: "null",
		sections: 0,
		bpm: 60,
		bpmChanges: [],
		events: [],
		notes: []
	}

	public static var bitmaps:Array<BitmapData> = [];

	public static var data:Song = SONG_DATA;

	// LMAOOOO STOLE ALL THIS FROM FLXBASETILEMAP LOLOL (it's actually not)

	public static function parse(songName:String) {
		data = Util.castStructure(SONG_DATA, Paths.getJson('$songName/$songName', "songs/"));

		loadBitmaps(data.sections);

		for (index in 1...bitmaps.length) {
			for(y in 0...bitmaps[index].height) {
				var scale:Float = 16 / bitmaps[index].height;

				for(x in 0...bitmaps[index].width) {
					var color = getPixel(index, x, y);

					if (color == IGNORE_COLOR) continue;

					if (color == SUSTAIN_COLOR) continue;

					if (!NoteTypeHandler.noteTypes.exists(color)) continue;

					data.notes.push([ /*type, strumTime, sustainLength*/
						color,
						(getStepCrochet() * scale * y) + (getMeasureCrochet() * (index -  1)),
						getSustainLength(index, x, y)
					]);
				}
			}
		}


		return data;
	}

	public static function loadBitmaps(sections:Int) { // null checking maybe
		for(index in 1...sections + 1) {
			bitmaps[index] ??= BitmapData.fromFile(Paths.get('${data.song}/${data.song}_section_$index', 'songs/') + ".png");
		}
	}

	// gets the amount of pixels that make up the sustain 
	public static function getSustainLength(index:Int, x:Int, y:Int):Float {
		var length:Float = 0;
		var scale:Float = 16 / bitmaps[index].height; // TODO: TIME SIGNATURE
		var index:Int = index;
		var y:Int = y + 1;

		while(getPixel(index, x, y) == SUSTAIN_COLOR) {
			y++;
			length += scale * getStepCrochet(0.0); // TODO: BPM CHANGE

			if(y + 1 > bitmaps[index].height) {
				index++;
				y = 0;
				scale = 16 / bitmaps[index].height; // TODO: TIME SIGNATURE
			}
		}
		
		return length;
	}

	public static inline function getPixel(index:Int, x:Int, y:Int):String {
		return FlxColor.fromInt(bitmaps[index].getPixel(x, y)).toHexString(false, false);
	}

	public static inline function setPixel(index:Int, x:Int, y:Int, color:Int) {
		bitmaps[index].setPixel(x, y, color);
	}

	public static function getTimeScale(position:Float = 0.0) { // TODO: BPM CHANGE, TIME SIGNATURE
		return 4 * 4;
	}

	public static function getScale(index, position:Float = 0.0) { // TODO: BPM CHANGE, TIME SIGNATURE
		return getTimeScale(position) / bitmaps[index].height;
	}

	public static function getBPM(position:Float = 0.0) { // TODO: BPM CHANGE
		return data.bpm;
	}

	public static function getStepCrochet(position:Float = 0.0):Float {
		return (60 / getBPM(position)) * 250;
	}

	public static function getCrochet(position:Float = 0.0):Float {
		return (60 / getBPM(position)) * 1000;
	}

	public static function getMeasureCrochet(position:Float = 0.0):Float {
		return (60 / getBPM(position)) * 4000;
	}

	// public static function parseSection(path:String):ChartSection {
	// 	bitmap = BitmapData.fromFile(path);
		
	// 	var section:ChartSection = {
	// 		notes: [],
	// 		scale: 16 / bitmap.height // add time signature
	// 	};

	// 	for (y in 0...bitmap.height) {
	// 		section.notes.push([]);

	// 		for (x in 0...bitmap.width) {
	// 			var color:String = getPixelColor(x, y);
				
	// 			if (color == IGNORE_COLOR)
	// 				continue;
		
				// var note:NoteData = {
				// 	type: NoteTypeHandler.get(color),
				// 	sustainLength: getSustainLength(x, y, color),
				// 	data: x
				// }

				// section.notes[y].push(note);
	// 		}
	// 	}

	// 	bitmap.dispose(); bitmap = null;

	// 	return section;
	// }

	// private static function getSustainLength(x:Int, y:Int, color:String):Int {
	// 	var length:Int = 0;

	// 	for (thing in y + 1...bitmap.height) {
	// 		if(getPixelColor(x, thing) != color) break;

	// 		bitmap.setPixel(x, thing, FlxColor.fromString('#$IGNORE_COLOR'));

	// 		length = thing;
	// 	}

	// 	return length;
	// }
}
