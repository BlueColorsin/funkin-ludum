package objects;

import backend.Paths;
import backend.Util;
import flixel.FlxSprite;

typedef CharacterData = {
	icon:String,
	texture:String,
	idleSteps:Array<String>,
	antialiasing:Bool,
	cameraOffsets:Array<Float>,
	animations:Array<AnimationData>,
}

typedef AnimationData = {
	name:String,
	prefix:String,
	fps:Float,
	looped:Bool,
	offset:Array<Int>,
	indices:Array<Int>
}

class Character extends FlxSprite {
	public static final CHARACTER_DATA:CharacterData = {
		icon: "bf",
		idleSteps: ["idle"],
		texture: "characters/boyfriend",
		cameraOffsets: [0, 0],
		antialiasing: true,
		animations:[]
	}

	public static final ANIMATION_DATA:AnimationData = {
		name: "idle",
		prefix: "idle",
		fps: 24,
		looped: false,
		offset: [0, 0],
		indices: [],
	}

	public static var characters:Map<String, Dynamic> = [
		"boyfriend" => {
			cameraOffsets: [0, 0],
			texture: "characters/BOYFRIEND",
			icon: "bf",
			antialiasing: true,
			animations: [
				{name: "idle",      prefix: "BF idle dance",  offset: [-5, 0]},
				{name: "singUP",    prefix: "BF NOTE UP0",    offset: [-20, 27]},
				{name: "singDOWN",  prefix: "BF NOTE DOWN0",  offset: [-20, -51]},
				{name: "singLEFT",  prefix: "BF NOTE LEFT0",  offset: [5, -6]},
				{name: "singRIGHT", prefix: "BF NOTE RIGHT0", offset: [-48, 7]},
			]
		},
		"dad" => {
			
		}
	];

	// container for the current characters data
	public var data:CharacterData;

	public var stunned:Bool = false;

	public var animOffsets:Map<String, Array<Float>>;

	public function new(key:String, ?x:Float = 0, ?y:Float = 0) {
		animOffsets = new Map<String, Array<Float>>();
		
		data = Util.castStructure(CHARACTER_DATA, characters.get(key));
	
		super(x, y);
		
		frames = Paths.getSparrowAtlas(data.texture);
		Util.buildAnimations(this, data.animations);
	}

	public function playAnim(animName:String, forced:Bool = false, reversed:Bool = false, frame:Int = 0):Void {
		if (!animation.exists(animName)) return;

		var offsets = animOffsets.get(animName);
		offset.set(offsets[0], offsets[1]);

		animation.play(animName, forced, reversed, frame);
	}
	
	public function addOffset(name:String, x:Float = 0, y:Float = 0) {
		animOffsets.set(name, [x, y]);
	}
}
