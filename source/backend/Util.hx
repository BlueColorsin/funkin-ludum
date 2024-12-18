package backend;

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

	/*
		function that basically returns a pure unbound copy of arg1
	*/
	public static inline function reserialize<T>(data:T):T {
        return haxe.Unserializer.run(haxe.Serializer.run(data));
	} 
}
