package backend;

using StringTools;

typedef NoteType = {
	texture:String,
	name:String,
	callbacks:Dynamic
}

class NoteTypeHandler {
	public static var NOTETYPE_DATA:NoteType = {
		name: "null",
		texture: "NOTE_ASSETS",
		callbacks: {} // create, update(elapsed:Float), onHit(miss:Bool)
	};

	public static var noteTypes:Map<String, Dynamic> = [
		"000000" => {
			name: "default",
			texture: "NOTE_ASSETS",
			callbacks: {
				create: () -> {},
				update: (elapsed:Float) -> {},
				onHit: (miss:Bool) -> {}
			}
		}
	];

	private static var noteTypeCache:Map<String, NoteType> = new Map<String, NoteType>();

	public static function get(tag:String):NoteType {
		if(noteTypeCache.exists(tag))
			return noteTypeCache.get(tag);

		noteTypeCache.set(tag, Util.castStructure(NOTETYPE_DATA, noteTypes.get(tag)));
		return noteTypeCache.get(tag);
	}

	public static function clear() {
		noteTypeCache.clear();
	}
}
