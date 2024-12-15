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
	public static var curSong:String = 'spookeez';

	var song:Song;

	var curBeat = 0.0;
	var curStep = 0.0;
	var curSection:Int = 0;

	var bf:Character;
	var dad:Character;
	var gf:Character;

	var inst:FlxSound;
	var tracks:Array<FlxSound> = [];

	var strumLines:Array<Strumline> = [];

	var unspawnNotes:Array<Note> = [];
	var notes:FlxTypedGroup<Note>;

	var inputMap:Map<String, Int> = ["note_left" => 0, "note_down" => 1, "note_up" => 2, "note_right" => 3];

	var eventHandler:EventHandler;

	var sigma:Float = 0;

	override public function create() {
		add(eventHandler = new EventHandler());

		song = ChartParser.parse(curSong);
		
		trace(song);

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
		
		inst = new FlxSound().loadEmbedded(Paths.audio("inst", 'songs/$curSong/audio/'));

		tracks.push(new FlxSound().loadEmbedded(Paths.audio("voices", 'songs/$curSong/audio/')));

		super.create();

		FlxG.sound.list.add(tracks[0]);

		#if debug
			FlxG.watch.add(Conductor, "songPosition", "songPosition");
			FlxG.watch.add(Conductor, "bpm", "bpm");
			FlxG.watch.add(Conductor, "crochet", "crochet");
			FlxG.watch.add(Conductor, "stepCrochet", "stepCrochet");
			FlxG.watch.add(this, "curStep", "curStep");
			FlxG.watch.add(this, "curBeat", "curBeat");
		#end

		startSong();
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
		if(FlxG.sound.music != null)
			FlxG.sound.music.stop();

		@:privateAccess
		FlxG.sound.playMusic(inst._sound, 1, false);

		for(track in tracks) {
			track.play();
		}
	}

	var lastMusicTime:Float = 0;

	override public function update(elapsed:Float) {
		
		if(FlxG.sound.music.active == true)
			Conductor.songPosition = FlxG.sound.music.time;
		
		if(lastMusicTime < Conductor.songPosition - 50) {
			FlxG.sound.music.time = lastMusicTime;
			Conductor.songPosition = FlxG.sound.music.time;
		}

		checkResync();

		lastMusicTime = Conductor.songPosition;

		Conductor.sortBPMchanges();
		
		// man fuck MusicBeatState, I am embedding this shit in the update function
		var oldStep:Float = curStep;
		
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

	var safeOffset:Int = 50;

	function checkResync() {

		for (track in tracks) {
			if (track.time > FlxG.sound.music.time + safeOffset || track.time < FlxG.sound.music.time - safeOffset) {
				track.time = FlxG.sound.music.time;
				trace("crazy ass resync at: " + Conductor.songPosition);
			}
		}
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
