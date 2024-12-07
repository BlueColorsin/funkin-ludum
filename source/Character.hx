package;

import flixel.FlxSprite;

typedef CharacterAnimation = {
	name:String, //the name of the animation that will be passed into the 
	key:String,
	fps:Int,
	loop:Bool,
	offset:Array<Int>,
	indices:Null<Array<Int>>
} 

typedef CharacterData = {
	texture:String,
	icon:String,
	playable:Bool,
	animations:Array<CharacterAnimation>
}

class Character extends FlxSprite {
	public var animOffsets:Map<String, Array<Int>> = new Map<String, Array<Int>>();

	public var characters:Map<String, CharacterData> = {
		"boyfriend" => {
			playable: false,
			texture: "boyfriend",
			icon: "bf",
			animations: [
				{name: "idle",      key: "BF idle dance",  offset: [-5, 0],    fps: 24, loop: false},
				{name: "singUP",    key: "BF NOTE UP0",    offset: [-29, 27],  fps: 24, loop: false},
				{name: "singDOWN",  key: "BF NOTE DOWN0",  offset: [-10, -50], fps: 24, loop: false},
				{name: "singLEFT",  key: "BF NOTE LEFT0",  offset: [-5, 0],    fps: 24, loop: false},
				{name: "singRIGHT", key: "BF NOTE RIGHT0", offset: [-5, 0],    fps: 24, loop: false},
			]
		}
		"dad" => {
			
		}
	}

	// container for the current characters data
	public var data:Map<String, CharacterData>;

	public function new(key:String, x:Float, y:Float) {
		data = Util.castStructure(Defaults.CHARACTER_DATA, characters.get(key));

		Util.buildAnimations(this, data.animations);

		

		super(x, y);
	}

	public function playAnim(animName:String, forced:Bool = false, reversed:Bool = false, frame:Int = 0):Void {
		var daOffset = animOffsets.get(animation.curAnim.name);
		if (animOffsets.exists(animation.curAnim.name)) {
			offset.set(daOffset[0], daOffset[1]);
		}

		animation.play(animName, forced, reversed, frame);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0) {
		animOffsets[name] = [x, y];
	}
}
