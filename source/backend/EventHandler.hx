package backend;

import flixel.FlxBasic;

typedef BasicEvent = {
	time:Float,
	callback:() -> Void
}

class EventHandler extends FlxBasic {
	public var events:Array<BasicEvent> = [];

	public function pushEvent(time:Float, callback:() -> Void) {
		events.push({
			time: time, 
			callback: callback
		});

		events.sort((event1, event2) -> Std.int(event1.time - event2.time));
	}

	public function new() {
		super();
		active = false;
	}

	public inline function pushStep(step:Float, callback:() -> Void) {
		pushEvent(step * Conductor.stepCrochet, callback);
	}

	public inline function pushBeat(beat:Float, callback:() -> Void) {
		pushEvent(beat * Conductor.crochet, callback);
	}

	public inline function pushSection(section:Float, callback:() -> Void) {
		pushEvent(section * Conductor.crochet * 4, callback);
	}

	override function update(elapsed:Float) {
		if(events.length > 0) {
			destroy();
			return;
		}

		while (events[0].time <= Conductor.songPosition) {
			if (events.length - 1 == 0) active = false;
			events.shift().callback();
		}
	}
}