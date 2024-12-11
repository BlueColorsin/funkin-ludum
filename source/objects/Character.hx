package objects;

import flixel.util.FlxTimer;
import backend.Util;
import objects.FunkinSprite;

typedef CharacterData = {
	icon:String,
	texture:String,
	idleSteps:Array<String>,
	holdTime:Float,
	antialiasing:Bool,
	cameraOffsets:Array<Float>,
	animations:Array<AnimationData>,
	createCallback:Dynamic
}

class Character extends FunkinSprite {
	public static final CHARACTER_DATA:CharacterData = {
		texture: "characters/bf",
		idleSteps: ["idle"],
		icon: "bf",
		holdTime: 0.6,
		cameraOffsets: [0, 0],
		antialiasing: true,
		animations:[],
		createCallback: null
	}

	public static var characters:Map<String, Dynamic> = [
		"boyfriend" => {
			cameraOffsets: [0, 0],
			texture: "characters/bf",
			icon: "bf",
			animations: [
				{name:"idle", prefix: "idle", offset: [-5, 0]},
	
				{name: "singUP",    prefix: "singUP",    offset: [-20,  27]},
				{name: "singDOWN",  prefix: "singDOWN",  offset: [-20, -51]},
				{name: "singLEFT",  prefix: "singLEFT",  offset: [ 5 , -6 ]},
				{name: "singRIGHT", prefix: "singRIGHT", offset: [-48,  7 ]},
	
				{name: "singRIGHTmiss", prefix: "missRIGHT", offset: [-44,  22]},
				{name: "singLEFTmiss",  prefix: "missLEFT",  offset: [ 7 ,  19]},
				{name: "singUPmiss",    prefix: "missUP",    offset: [-46,  27]},
				{name: "singDOWNmiss",  prefix: "missDOWN",  offset: [-15, -19]}
			]
		},
		"dad" => {
			cameraOffsets: [0, 0],
			texture: "characters/dad",
			icon: "dad",
			animations: [
				{name:"idle", prefix: "idle", offset: [0, 0]},
	
				{name: "singUP",    prefix: "singUP",    offset: [-6 ,  50]},
				{name: "singDOWN",  prefix: "singDOWN",  offset: [ 0 , -30]},
				{name: "singLEFT",  prefix: "singLEFT",  offset: [-9 ,  10]},
				{name: "singRIGHT", prefix: "singRIGHT", offset: [ 0 ,  27]}
			],
			createCallback: (char:Character) -> trace("MY NAME IS DAVID, DAD I WANT SOME ICE CREAM")
		}
	];

	// container for the current characters data
	public var data:CharacterData;

	public var holdTimer:FlxTimer;

	// in seconds how much time it takes for the character to idle after hitting a note
	public var holdTime:Float = 0.6;

	public var stunned:Bool = false;

	public function new(key:String, ?x:Float = 0, ?y:Float = 0) {
		data = Util.castStructure(CHARACTER_DATA, characters.get(key));
	
		super(x, y);

		getAsset(data.texture);
		buildAnimations(data.animations);

		antialiasing = data.antialiasing;
		
		holdTime = data.holdTime;

		idleSteps = data.idleSteps;

		idleCondition = (curBeat:Int) -> {
			return (curBeat % 2 == 0) && (holdTimer.finished);
		}

		if (data.createCallback)
			data.createCallback(this);
	}

	override function playAnim(animName:String, forced:Bool = false, reversed:Bool = false, frame:Int = 0) {
		super.playAnim(animName, forced, reversed, frame);
		holdTimer.start(holdTime, (_)->playAnim("idle", true));
	}

	override function initVars() {
		super.initVars();

		holdTimer = new FlxTimer();
	}

	override function destroy() {
		super.destroy();

		holdTimer.destroy();
	}
}
