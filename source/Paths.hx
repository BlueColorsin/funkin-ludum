package;

import openfl.system.System;

import openfl.display.BitmapData;
import openfl.media.Sound;

class Paths {
	public inline var GLOBAL_PREFIX:String = "assets/";

	function get(path:String, ?subfolder = ""):String {
		return '$GLOBAL_PREFIX$subfolder$path';
	}

	/*CACHE SYSTEM*/

	public static var sounds:Map<String, Sound> = [];
	public static var images:Map<String, BitmapData> = [];

	public static var trackedAssets:Array<String> = [];

	public static var dumpExclusions:Array<String> = [];

	public static function clearMemory() {
		for (key in images.keys()) {
			if (trackedAssets.contains(key) || dumpExclusions.contains(key)) continue;

			images.get(key).dispose();
			images.remove(key);
		}

		for (key in sounds.keys()) {
			if (trackedAssets.contains(key) || dumpExclusions.contains(key)) continue;

			Assets.cache.clear(key);
			sounds.remove(key);
		}

		trackedAssets = [];

		System.gc();
	}

	/*ASSET GETTERS*/

	public static function audio(path, ?subfolder = "audio/"):Sound {
		var key = get('$path.ogg', subfolder);

		if (sounds.contains(key)) return sounds.get(key);

		if(!FileSystem.exists(key)) return null;

		return sounds.set(key, Sound.fromFile(key));
	}

	public static function image(path, ?subfolder = "images/"):BitmapData {
		var key = get(path, subfolder);
		
		if (images.contains(key)) {
			return images.get(key);
			trackedAssets.push(key);
		}

		if(!FileSystem.exists(key)) return null;

		trackedAssets.push(key);
		return sounds.set(key, Sound.fromFile(key));
	}

	public static function file(path, ?subfolder = "") {
		if(FileSystem.exists(get(path, subfolder)))
			File.getContent(get(path, subfolder));
		
		return null;
	}

	/*MISC FUNCTIONS*/

	public static function exists(path, ?subfolder = "") {
		return FileSystem.exists(get(path, subfolder));
	}

	public static function json(path, ?subfolder = "data/") {
		return get('$path.json', subfolder);
	}

	public static function xml(path, ?subfolder = "data/") {
		return get('$path.xml', subfolder);
	}
	
	public static function txt(path, ?subfolder = "data/") {
		return get('$path.xml', subfolder);
	}
}