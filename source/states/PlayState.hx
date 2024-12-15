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

import objects.Character;
import objects.Note;
import objects.StrumNote;

using StringTools;

class PlayState extends FlxTransitionableState {
	public static var curSong:String = 'spookeez';

	public static var songSpeed:Float = 2.2;

	public var spawnTime:Float = 2000;

	var song:Song;

	var curBeat = 0.0;
	var curStep = 0.0;
	var curSection:Int = 0;

	var bf:Character;
	var dad:Character;
	var gf:Character;

	var inst:FlxSound;
	var tracks:Array<FlxSound> = [];

	var songStarted:Bool = false;

	var playerStrums:FlxTypedSpriteGroup<StrumNote>;
	var opponentStrums:FlxTypedSpriteGroup<StrumNote>;

	var unspawnNotes:Array<Note> = [];
	var notes:FlxTypedSpriteGroup<Note>;

	var inputMap:Map<String, Int> = ["note_left" => 0, "note_down" => 1, "note_up" => 2, "note_right" => 3];

	var eventHandler:EventHandler;

	override public function create() {
		add(eventHandler = new EventHandler());

		song = ChartParser.parse(curSong);
		trace(song);
		
		inst = new FlxSound().loadEmbedded(Paths.audio("inst", 'songs/$curSong/audio/'));

		tracks.push(new FlxSound().loadEmbedded(Paths.audio("voices", 'songs/$curSong/audio/')));
		FlxG.sound.list.add(tracks[0]);

		/*NOTES & INPUT SYSTEM*/

		add(notes = new FlxTypedSpriteGroup<Note>());

		var directionMap:Map<Int, String> = [0 => "left", 1 => "down", 2 => "up", 3 => "right"];

		add(playerStrums = new FlxTypedSpriteGroup<StrumNote>(775, 550));

		for (index in 0...4) {
			var sprite:StrumNote = new StrumNote(Note.swagWidth * index);
			sprite.setFrames(Paths.getSparrowAtlas("NOTE_ASSETS"));
			sprite.animation.addByPrefix("static", 'arrow${directionMap[index].toUpperCase()}');
			sprite.animation.addByPrefix("pressed", '${directionMap[index]} press', 24, false);
			sprite.animation.addByPrefix("confirm", '${directionMap[index]} confirm', 24, false);
			sprite.setGraphicSize(Std.int(sprite.width * 0.7));
			sprite.updateHitbox();
			sprite.playAnim("static");

			playerStrums.add(sprite);
		}

		add(opponentStrums = new FlxTypedSpriteGroup<StrumNote>(65, 550));

		for (index in 0...4) {
			var sprite:StrumNote = new StrumNote(Note.swagWidth * index);
			sprite.setFrames(Paths.getSparrowAtlas("NOTE_ASSETS"));
			sprite.animation.addByPrefix("static", 'arrow${directionMap[index].toUpperCase()}');
			sprite.animation.addByPrefix("pressed", '${directionMap[index]} press', 24, false);
			sprite.animation.addByPrefix("confirm", '${directionMap[index]} confirm', 24, false);
			sprite.setGraphicSize(Std.int(sprite.width * 0.7));
			sprite.updateHitbox();
			sprite.playAnim("static");

			opponentStrums.add(sprite);
		}

		for (noteData in song.notes) {
			var note:Note = new Note(noteData[0], noteData[1], noteData[3], notes.length != 0 ? notes.members[notes.length - 1] : null);

			if(noteData[1] > 3) {
				note.mustPress = true;
			}

			unspawnNotes.insert(unspawnNotes.length, note);
		}

		song.notes.sort((note1, note2) -> {
			return note1.strumTime - note2.strumTime;
		});

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

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, (event:KeyboardEvent) -> {
			var key:Int = validateKey(event.keyCode);

			if (key == -1 || !songStarted) return;

			var inputNotes:Array<Note> = notes.members.filter((note:Note) -> {
				var canHit:Bool = note != null && note.alive && !note.hasBeenHit  && !note.tooLate && note.canHit;
				return canHit && !note.isSustain && note.noteData == key;
			});

			if (inputNotes.length != 0) {
				goodNoteHit(inputNotes[0]);
			} else {
				noteMiss(key);
			}
		});

		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, (event:KeyboardEvent) -> {
			var key:Int = validateKey(event.keyCode);

			if (key == -1) return;

			trace("KEY UP  : " + key);
		});

		super.create();

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

		if (unspawnNotes[0] != null) {
			while (unspawnNotes.length > 0 && (unspawnNotes[0].strumTime - Conductor.songPosition) < (spawnTime / songSpeed)) {
				notes.insert(0, unspawnNotes[0]).spawned = true;
				unspawnNotes.splice(unspawnNotes.indexOf(unspawnNotes[0]), 1);
			}
		}

		notes.forEachAlive((note:Note) -> {
			var strum = note.noteData > 3 ? playerStrums : opponentStrums; 

			note.followStrum(strum.members[note.noteData % 4]);
		});

		lastMusicTime = Conductor.songPosition;

		Conductor.sortBPMchanges();
		
		super.update(elapsed);

		// man fuck MusicBeatState, I am embedding this shit in the update function
		var oldStep:Float = curStep;
		
		curStep = Conductor.getCurrentStep();
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep > 0)
			stepHit();
		
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
			}
		}
	}

	function scorePopUp() {
		
	}

	function noteMiss(direction:Int = 0, note:Note = null) {

	}

	function badNoteCheck() {

	}

	function noteCheck(keyPressed:Bool, note:Note) {

	}

	function goodNoteHit(note:Note) {

	}
}
