package backend;

import sys.FileSystem;
import sys.io.File;

import openfl.system.System;
import openfl.utils.Assets;
import openfl.media.Sound;
import openfl.display.BitmapData;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;

class Paths {
	public static inline var GLOBAL_PREFIX:String = "assets/";

	public static function get(path:String, ?subfolder:Null<String> = ""):String {
		return '$GLOBAL_PREFIX$subfolder$path';
	}

	/*CACHE SYSTEM*/

	public static var sounds:Map<String, Sound> = [];
	public static var images:Map<String, FlxGraphic> = [];

	public static var trackedAssets:Array<String> = [];

	public static var dumpExclusions:Array<String> = [];

	public static function clearMemory(?all:Bool = false) {
		if(all)
			trackedAssets = [];

		for (key in images.keys()) {
			if (trackedAssets.contains(key) || dumpExclusions.contains(key)) continue;

			images.get(key).destroy();
			images.remove(key);
		}

		for (key in sounds.keys()) {
			if (trackedAssets.contains(key) || dumpExclusions.contains(key)) continue;

			Assets.cache.clear(key);
			sounds.remove(key);
		}

		if(all)
			System.gc();
	}

	/*ASSET GETTERS*/

	public static function audio(path, ?subfolder = "audio/"):Sound {
		var key = get('$path.ogg', subfolder);

		if (sounds.exists(key)) return sounds.get(key);

		if(!FileSystem.exists(key)) return null;
		
		sounds.set(key, Sound.fromFile(key));
		trackedAssets.push(key);
		return sounds.get(key);
	}

	public static function image(path, ?subfolder = "images/"):FlxGraphic {
		var key:String = get('$path.png', subfolder);

		if (images.exists(key)) {
			return images.get(key);
			trackedAssets.push(key);
		}

		if(!FileSystem.exists(key)) return null;

		return cacheBitmap(key, BitmapData.fromFile(key));
	}

	public static function cacheBitmap(key:String, bitmap:BitmapData):FlxGraphic {
		var graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, key);
		graphic.persist = true;
		graphic.destroyOnNoUse = false;

		images.set(key, graphic);
		trackedAssets.push(key);
		return graphic;
	}

	public static function file(path, ?subfolder = "") {
		final key = get(path, subfolder);

		if(FileSystem.exists(key))
			return File.getContent(key);
		
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

	/*ANIMATION*/

	public static function getSparrowAtlas(path, ?subfolder = "images/"):FlxAtlasFrames {
		var xml:String = file('$path.xml', subfolder);

		if (xml == null)
			throw "NO FUCKING XML YOU STUPID CUNT";

		//trace(xml);

		return FlxAtlasFrames.fromSparrow(image(path, subfolder), xml);
	}
}