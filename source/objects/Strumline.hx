package objects;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class Strum extends FlxSprite {

}

class Strumline extends FlxTypedSpriteGroup<Strum> {
	var notes:Array<Note>;

	override function new() {
		super();
	}
}