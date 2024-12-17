package objects;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.util.typeLimit.OneOfTwo;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxBasic;

class UiGroup extends FlxTypedSpriteGroup<FlxSprite> {
	public var data = {};

	public var baseSprite:FlxSprite = null;

	override public function new(x, y, ?sprite:FlxSprite) {
		baseSprite = sprite != null ? sprite : new FlxSprite(x, y).makeGraphic(300, 300, FlxColor.WHITE);
		FlxG.state.add(baseSprite);

		super(x, y);
	}

	/*clipping system*/

	//if I forget to remove this, this is for the flixel debug console
	//state.members[1].members[0].scale.set(1.5, 0.5)
	//state.members[1].members[0].scale.set(0.5, 1.5)

	inline function getRawX(sprite:FlxSprite):Float {
		return (sprite.x - (this.camera.scroll.x * sprite.scrollFactor.x));
	}

	inline function getRawY(sprite:FlxSprite):Float {
		return sprite.y - (this.camera.scroll.y * sprite.scrollFactor.y);
	}

	override function update(elapsed:Float) {
		forEachAlive((sprite:FlxSprite) -> {
			if(sprite.clipRect == null)
				sprite.clipRect = FlxRect.get();

			sprite.clipRect = sprite.clipRect.set(
				0 - ((getRawX(sprite) - getRawX(baseSprite)) * (1 / sprite.scale.x) - (sprite.pixels.width * (1 - (1 / sprite.scale.x)) / 2)),
				0 - ((getRawY(sprite) - getRawY(baseSprite)) * (1 / sprite.scale.y) - (sprite.pixels.height * (1 - (1 / sprite.scale.y)) / 2)),
				baseSprite.width * (1 / sprite.scale.x),
				baseSprite.height * (1 / sprite.scale.y)
			);
		});
		
		super.update(elapsed);
	}
}