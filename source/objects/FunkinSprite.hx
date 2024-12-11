package objects;

import backend.Util;
import backend.Paths;
import flixel.FlxSprite;

using StringTools;

typedef AnimationData = {
	name:String,
	prefix:String,
	fps:Float,
	looped:Bool,
	offset:Array<Int>,
	indices:Array<Int>
}

class FunkinSprite extends FlxSprite {
	public static final ANIMATION_DATA:AnimationData = {
		name: "idle",
		prefix: "idle",
		fps: 24,
		looped: false,
		offset: [0, 0],
		indices: [],
	}

	public var animOffsets:Map<String, Array<Int>> = [];

	public function getAsset(path:String, ?subfolder = "images/") {
		if(Paths.exists('$path.xml', subfolder)) {
			frames = Paths.getSparrowAtlas(path, subfolder);
			return;
		}

		loadGraphic(Paths.image(path, subfolder));
	}

	public function buildAnimations(animsData:Array<AnimationData>) {
		for (anim in animsData) {
			var anim:AnimationData = Util.castStructure(ANIMATION_DATA, anim);

			addOffset(anim.name, anim.offset[0], anim.offset[1]);

			if (anim.indices.length == 0) {
				animation.addByPrefix(anim.name, anim.prefix, anim.fps, anim.looped);
				continue;
			}
			
			animation.addByIndices(anim.name, anim.prefix, anim.indices, "", anim.fps, anim.looped);	
		}
	}

	public function playAnim(animName:String, forced:Bool = false, reversed:Bool = false, frame:Int = 0):Void {
		if (!animation.exists(animName)) return;

		var offsets = animOffsets.get(animName);
		offset.set(offsets[0], offsets[1]);

		animation.play(animName, forced, reversed, frame);
	}
	
	/*idle stuff*/

	public var idleSteps:Array<String> = ["idle"];
	private var idleIndex:Int = 0;

	public var idleCondition:(curBeat:Int) -> Bool = (curBeat:Int) -> {
		return curBeat % 2 == 0;
	}

	public function dance(curBeat:Int) {
		if(idleCondition(curBeat)) {
			idleIndex++;
			if(idleIndex > idleSteps.length) idleIndex = 0;
			playAnim(idleSteps[idleIndex]);
		}
	}

	/*animation offsets yayyyy*/
	
	public function addOffset(name:String, ?offsetX:Int = 0, ?offsetY:Int = 0) {
		animOffsets.set(name, [offsetX, offsetY]);
	}

	@:noCompletion override function initVars():Void {
		super.initVars();
		animOffsets = new Map<String, Array<Int>>();
	}

	override public function destroy():Void {
		animOffsets = null;
		super.destroy();
	}
}
