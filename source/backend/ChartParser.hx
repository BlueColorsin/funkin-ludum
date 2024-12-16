package backend;

import backend.NoteTypeHandler;
import backend.Conductor;
import flixel.util.FlxColor;
import flash.display.BitmapData;

using StringTools;

typedef Event = {}

typedef Song = {
	song:String,
	sections:Int,
	bpm:Float,
	timeSignature:Array<Int>,
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
		timeSignature: [4, 4],
		bpmChanges: [],
		events: [],
		notes: []
	}

	public static var bitmaps:Array<BitmapData> = [];

	public static var data:Song = SONG_DATA;

	// LMAOOOO STOLE ALL THIS FROM FLXBASETILEMAP LOLOL (it's actually not)

	public static function parse(songName:String):Song {
		data = Util.castStructure(SONG_DATA, Paths.getJson('$songName/$songName', "songs/"));

		loadBitmaps(data.sections);

		Conductor.bpmChanges.resize(0);

		Conductor.updateBPM({
			timeStamp: 0.0,
			stepTime: 0,
			
			bpm: data.bpm,
			timeSignature: data.timeSignature
		});

		Conductor.sortBPMchanges(0.0);

		for(bpmChange in data.bpmChanges) {
			Conductor.bpmChanges.push(Util.castStructure(Conductor.BPM_CHANGE, bpmChange));
		}

		for (index in 1...bitmaps.length) {
			for(y in 0...bitmaps[index].height) {
				var scale:Float = getScale(index);

				var position:Float = (getStepLengthMs() * scale * y) + (getMeasureLengthMs() * (index -  1));

				Conductor.sortBPMchanges(position);

				for(x in 0...bitmaps[index].width) {
					var color = getPixel(index, x, y);

					if (color == IGNORE_COLOR) continue;

					if (color == SUSTAIN_COLOR) continue;

					if (!NoteTypeHandler.noteTypes.exists(color)) continue;

					data.notes.push([ /*strumTime, noteData, noteType, sustainLength*/
						position,
						x,
						color,
						getSustainLength(index, x, y)
					]);
				}
			}
		}

		return data;
	}

	public static function loadBitmaps(sections:Int, ?difficulty:String = "hard") { // null checking maybe
		for(index in 1...sections) {
			bitmaps[index] ??= BitmapData.fromFile(Paths.get('${data.song}/$difficulty/${data.song}_section_$index', 'songs/') + ".png");
		}
	}

	// gets the amount of pixels that make up the sustain 
	public static function getSustainLength(index:Int, x:Int, y:Int):Float {
		var scale:Float = getScale(index);
		var length:Float = 0;
		var index:Int = index;
		var y:Int = y + 1;

		while(getPixel(index, x, y) == SUSTAIN_COLOR) {
			y++;
			length += scale * getStepLengthMs();
			
			Conductor.sortBPMchanges((getStepLengthMs() * scale * y) + (getMeasureLengthMs() * (index -  1)));

			if(y + 1 > bitmaps[index].height) {
				index++;
				y = 0;
				scale = getScale(index);
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

	public static function getScale(index) {
		return Conductor.timeSignature[0] * Conductor.timeSignature[1] / bitmaps[index].height;
	}

	public static function getStepLengthMs():Float {
		return (60 / Conductor.bpm) * 250;
	}

	public static function getBeatLengthMs():Float {
		return (60 / Conductor.bpm) * 1000;
	}

	public static function getMeasureLengthMs():Float {
		return (60 / Conductor.bpm) * 4000;
	}
}
