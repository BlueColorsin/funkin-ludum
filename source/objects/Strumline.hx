package objects;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;

import objects.Note;

class StrumNote extends FlxSprite {

}

class Strumline extends FlxTypedSpriteGroup<StrumNote> {
	var notes:FlxTypedSpriteGroup<Note>;

	override function new() {
		notes = new FlxTypedSpriteGroup<Note>();

		super();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function getHittableNotes():Array<Note> {
		return notes.members.filter((note:Note) -> {
			return note != null && note.alive && !note.hasBeenHit && note.canHit;
		});
	}
}