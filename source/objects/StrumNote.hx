package objects;

import states.PlayState;
import backend.Paths;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class StrumNote extends FlxSprite {
	public static function generateStrums(group:FlxTypedSpriteGroup<StrumNote>) {
		for (index in 0...4) {
			var sprite:StrumNote = new StrumNote(Note.swagWidth * index);
			sprite.setFrames(Paths.getSparrowAtlas("NOTE_ASSETS"));
			sprite.animation.addByPrefix("static", 'arrow${PlayState.directionMap[index].toUpperCase()}');
			sprite.animation.addByPrefix("pressed", '${PlayState.directionMap[index]} press', 24, false);
			sprite.animation.addByPrefix("confirm", '${PlayState.directionMap[index]} confirm', 24, false);
			sprite.setGraphicSize(Std.int(sprite.width * 0.7));
			sprite.updateHitbox();
			sprite.playAnim("static");

			group.add(sprite);
		}
	}

	public var downscroll:Bool = true;

	var resetAnim:Float = 0;

	override public function new(?x:Float = 0, ?y:Float = 0) {
		super(x, y);		
		antialiasing = true;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if(resetAnim == 0) return;

		resetAnim -= elapsed;
		if(resetAnim <= 0) {
			playAnim('static');
			resetAnim = 0;
		}
	}

	public function playAnim(anim:String, ?forced:Bool = false, ?resetAnim:Float = 0) {
		animation.play(anim, forced);
		this.resetAnim = resetAnim;

		if(animation.curAnim != null) {
			centerOffsets();
			centerOrigin();
		}
	}
}