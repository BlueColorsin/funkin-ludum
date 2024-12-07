package source;

using Reflect;

class Util {
	public static function castStructure<T>(defaults:T, ?input:T):T {
		var defaults = reserialize(defaults);

		if (input == null)
			return defaults;
		
		var defaultFields = defaults.fields();

		for(field in defaultFields) {
			if (input.hasField(field)) {
				if (input.field(field) == null)
					input.setField(field, defaults.field(field));
			} else
				input.setField(field, defaults.field(field));
		}
		
		for(field in input.fields()) {
			if (!defaultFields.contains(field))
				input.deleteField(field);
		}

		return input;
	}

	public static function buildAnimations(object:FlxSprite, animations:Array<AnimationData>) {
		for (animation in animations) {
			var animation:AnimationData = castStructure(Defaults.ANIMATION_DATA, animation);

			if (Reflect.hasField(object, "animOffsets"))
				object.animOffsets.set(animation.name, animation.offsets);
		
			if (animation.indices == null && animation.indices.length == 0) {
				object.addByPrefix(animation.name, animation.prefix, animation.fps, animation.loop);
				continue;
			}
			
			object.addByIndices(animation.name, animation.prefix, animation.indices, animation.fps, animation.loop);
		}
	}

	/*
		function that basically returns a pure unbound copy of arg1
	*/
	public static inline function reserialize<T>(data:T):T {
        return haxe.Unserializer.run(haxe.Serializer.run(data));
	}
}
