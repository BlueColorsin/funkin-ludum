package;

import flixel.FlxSprite;

class Util {
	public static function castStructure<T>(defaults:T, ?input:T):T {
		var defaults = reserialize(defaults);

		if (input == null)
			return defaults;
		
		var defaultFields = Reflect.fields(defaults);

		for(field in defaultFields) {
			if (Reflect.hasField(input, field)) {
				if (Reflect.field(input, field) == null)
					Reflect.setField(input, field, Reflect.field(defaults, field));
			} else {
				Reflect.setField(input, field, Reflect.field(defaults, field));
			}
		}
		
		for(field in Reflect.fields(input)) {
			if (!defaultFields.contains(field))
				Reflect.deleteField(input, field);
		}

		return input;
	}

	public static function buildAnimations(object:Character, animations:Array<Character.AnimationData>) {
		for (animation in animations) {
			var animation:Character.AnimationData = castStructure(Character.ANIMATION_DATA, animation);

			object.addOffset(animation.name, animation.offset[0], animation.offset[1]);

			if (animation.indices.length == 0) {
				object.animation.addByPrefix(animation.name, animation.prefix, animation.fps, animation.looped);
				continue;
			}
			
			object.animation.addByIndices(animation.name, animation.prefix, animation.indices, "", animation.fps, animation.looped);	
		}
	}

	/*
		function that basically returns a pure unbound copy of arg1
	*/
	public static inline function reserialize<T>(data:T):T {
        return haxe.Unserializer.run(haxe.Serializer.run(data));
	}
}
