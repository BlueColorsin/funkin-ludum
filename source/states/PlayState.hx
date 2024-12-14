package states;

import backend.Controls;
import flixel.input.keyboard.FlxKey;
import openfl.ui.Keyboard;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.sound.FlxSound;
import flixel.util.FlxTimer;
import flixel.util.FlxSort;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;

import openfl.events.KeyboardEvent;

import backend.EventHandler;
import backend.ChartParser;
import backend.Paths;
import backend.Conductor;

import objects.Strumline;
import objects.Character;
import objects.Note;

using StringTools;

class PlayState extends FlxTransitionableState {
	public static var curSong:String = 'Spookeez';

	var song:Song;

	var curBeat:Int = 0;
	var curStep:Int = 0;
	var curSection:Int = 0;

	var bf:Character;
	var dad:Character;
	var gf:Character;

	var strumLines:Array<Strumline> = [];

	var unspawnNotes:Array<Note> = [];
	var notes:FlxTypedGroup<Note>;

	var inputMap:Map<String, Int> = ["note_left" => 0, "note_down" => 1, "note_up" => 2, "note_right" => 3];

	var eventHandler:EventHandler;

	override public function create() {
		add(eventHandler = new EventHandler());

		//song = ChartParser.parse(curSong);

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, (event:KeyboardEvent) -> {
			var key:Int = validateKey(event.keyCode);

			if (key == -1) return;

			trace("KEY DOWN: " + key);
		});

		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, (event:KeyboardEvent) -> {
			var key:Int = validateKey(event.keyCode);

			if (key == -1) return;

			trace("KEY UP  : " + key);
		});

		super.create();
	}

	inline function validateKey(code:Int) {
		if(code == FlxKey.NONE) return -1;

		var keyDown:Int = -1;

		for(key in inputMap.keys()) for(keyCode in Controls.binds.get(key)) {
			if (keyCode == code) {
				keyDown = inputMap[key];
			}
		}

		return keyDown;
	}

	function startSong() {

	}

	override public function update(elapsed:Float) {


		// man fuck MusicBeatState, I am embedding this shit in the update function
		Conductor.sortBPMchanges();

		var oldStep:Int = curStep;
		
		curStep = Conductor.getCurrentStep();
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep > 0)
			stepHit();
		
		super.update(elapsed);
	}

	function stepHit() {
		if (curStep % 4 == 0)
			beatHit();
	}

	function beatHit() {

	}

	function scorePopUp() {
		
	}

	function noteMiss(direction:Int = 1) {

	}

	function badNoteCheck() {

	}

	function noteCheck(keyPressed:Bool, note:Note) {

	}

	function goodNoteHit(note:Note) {

	}
}
