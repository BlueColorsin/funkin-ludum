package substates;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxAxes;
import backend.Paths;
import flixel.FlxG;

import objects.ClippingGroup;

typedef PausedObject = {
	tag:String,
	sprite:Null<FlxSprite>,
	callback:() -> Void
}

class PauseSubstate extends FlxSubState {
	var menuItems:Array<PausedObject> = [];

	var clippingGroup:ClippingGroup;
	var clippingSprite:FlxSprite;

	var cursor:FlxSprite;

	var tween:FlxTween = null;

	var curSelected:Int = 0;

	var closed:Bool = false;

	override function create() {
		this.closed = false;

		menuItems = [{
			tag: "resume",
			sprite: null,
			callback: () -> {
				closeSubstate();
			}
		},
		{
			tag: "restart",
			sprite: null,
			callback: () -> {}
		},
		{
			tag: "exit",
			sprite: null,
			callback: () -> {}
		}];

		clippingSprite = new FlxSprite(465, 150).makeGraphic(350, 420, 0x33000000);
		add(clippingSprite);

		clippingGroup = new ClippingGroup(465, 150, clippingSprite);
		
		var paused:FlxSprite = new FlxSprite(0, 20).setFrames(Paths.getSparrowAtlas("PAUSE_ASSETS"));

		paused.animation.addByPrefix("paused", "paused", 8);
		paused.animation.play("paused");
		paused.updateHitbox();

		paused.x = (350 - paused.width) / 2;

		clippingGroup.add(paused);

		var lowestX:Float = 0;

		for(index => value in menuItems.keyValueIterator()) {
			value.sprite = new FlxSprite(0, index * 70 + 170).setFrames(Paths.getSparrowAtlas("PAUSE_ASSETS"));

			value.sprite.animation.addByPrefix(value.tag, value.tag);
			value.sprite.animation.play(value.tag);
			value.sprite.updateHitbox();
			
			value.sprite.x = (350 - value.sprite.width) / 2;

			clippingGroup.add(value.sprite);
		}

		cursor = new FlxSprite(20, 0).loadGraphic(Paths.image("pause_cursor"));
		clippingGroup.add(cursor);
		
		add(clippingGroup);
		
		changeSelection(0);

		super.create();
		
		openCallback = () -> {
			this.closed = false;

			this.clippingSprite.scale.set(0, 0);
			this.clippingSprite.updateHitbox();
			this.clippingSprite.screenCenter(XY);
			this.tween = FlxTween.tween(this.clippingSprite, {"scale.x": 1, "scale.y": 1,}, 0.5, {ease: FlxEase.backOut, onUpdate: (tween:FlxTween) -> {
				this.clippingSprite.updateHitbox();
				this.clippingSprite.screenCenter(XY);
			}});
		}
	}

	override function update(elapsed:Float) {
		trace(closed);

		if(closed == true) return;

		if (FlxG.keys.justPressed.DOWN) {
			changeSelection(1);
		}

		if (FlxG.keys.justPressed.UP) {
			changeSelection(-1);
		}

		if (FlxG.keys.justPressed.ENTER) {
			trace("sigma");
			menuItems[curSelected].callback();
		}

		cursor.y = FlxMath.lerp(menuItems[curSelected].sprite.getMidpoint().y - (cursor.height / 2), cursor.y, Math.exp(-elapsed * 9));
		cursor.x = FlxMath.lerp(menuItems[curSelected].sprite.x - 60, cursor.x, Math.exp(-elapsed * 9));
		
		super.update(elapsed);
	}

	function changeSelection(value:Int = 0) {
		curSelected = FlxMath.wrap(curSelected + value, 0, menuItems.length - 1);

		for(item in menuItems) {
			if(item == menuItems[curSelected]) {
				item.sprite.color = FlxColor.WHITE;
				continue;
			}
			item.sprite.color = 0xffa7a7a7;
		}
	}

	function closeSubstate() {
		if (tween != null)
			tween.cancel();
		
		_parentState.persistentUpdate = true;

		tween = FlxTween.tween(clippingSprite, {"scale.x": 0, "scale.y": 0,}, 0.75, {ease: FlxEase.backIn, onUpdate: (tween:FlxTween) -> {
			clippingSprite.updateHitbox();
			clippingSprite.screenCenter(XY);
		}, onComplete: (tween:FlxTween) -> {
			_parentState.resetSubState();
			closed = true;
			trace(closed);
		}});
	}
}