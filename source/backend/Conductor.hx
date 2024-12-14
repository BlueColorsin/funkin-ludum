package backend;

typedef BPMchange = {
	timeStamp:Float,

	bpm:Float,
	timeSignature:Array<Int> // Numerator, Denominator
}

// my cancerous take on a conductor class
class Conductor {
	public static var songPosition:Float = 0;
	
	public static var bpm:Float = 60;
	
	public static var timeSignature:Array<Int> = [4 / 4];

	public static var crochet:Float = ((60 / bpm) * 1000); // beats in milliseconds
	public static var stepCrochet:Float = crochet / timeSignature[0]; // steps in milliseconds
	public static var offset:Float = 0;

	public static var safeFrames:Int = 10;
	public static var safeZoneOffset:Float = (safeFrames / 60) * 1000; // is calculated in create(), is safeFrames in milliseconds

	public static var BPM_CHANGE:BPMchange = {
		timeStamp: 0.0,

		bpm: 60,
		timeSignature: [4, 4]
	};

	public static var bpmChanges:Array<BPMchange>;

	public static var currentBPMchange:BPMchange = BPM_CHANGE;

	public static function updateBPM(?bpmChange:BPMchange) {
		currentBPMchange = bpmChange == null ? bpmChanges[0] : bpmChange;

		bpm = currentBPMchange.bpm;

		timeSignature = currentBPMchange.timeSignature;

		crochet = (60 / bpm) * 1000;
		stepCrochet = crochet / timeSignature[0];
	}

	public static function sortBPMchanges(?position:Float = null) {
		position ?? songPosition;

		bpmChanges.sort((struct1, struct2) -> {
			if (struct1.timeStamp < position) return 1;
			return Std.int(struct1.timeStamp - struct2.timeStamp);
		});

		if(currentBPM != bpmChanges[0]) changeBPM(position);
	}

	// gets the current step based off of argument one accounting for bpm changes
	public static function getCurrentStep(?position:Float = null):Int {
		position ?? songPosition;

		return Math.floor(position / ((60 / bpm) * 250));
	}
}
