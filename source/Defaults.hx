package source;

typedef AnimationData = {
	name:String,
	prefix:String,
	fps:Float,
	loop:Bool,
	offets:Array<Int>,
	indices:Array<Int>
}

typedef CharacterData = {
	texture:String,
	icon:String,
	cameraOffsets:Array<Float>,
	animations:Array<AnimationData>,
}

class Defaults {
	public static final ANIMATION_DATA:AnimationData = {

	}

	public static final CHARACTER_DATA:CharacterData = {
		
	}
}