package objects;

import backend.Paths;
import backend.NoteTypeHandler;
import flixel.FlxSprite;

class Note extends FlxSprite {
	public var strumTime:Float = 0.0;

	public var mustPress:Bool = false;
	public var canHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var hasBeenHit:Bool = false;

	public var parentNote:Note;

	public var noteData:Int = 0;

	public static var swagWidth:Float = 160 * 0.7;

	public function new(strumTime:Float, noteData:Int, parentNote:Note) {
		super();

		this.strumTime = strumTime;
		this.parentNote = parentNote;
		this.noteData = noteData;
	
		scrollFactor.set(0, 0);

		frames = Paths.getSparrowAtlas("NOTE_assets");

		animation.addByPrefix('greenScroll', 'green0');
		animation.addByPrefix('redScroll', 'red0');
		animation.addByPrefix('blueScroll', 'blue0');
		animation.addByPrefix('purpleScroll', 'purple0');

		animation.addByPrefix('purpleholdend', 'pruple end hold');
		animation.addByPrefix('greenholdend', 'green hold end');
		animation.addByPrefix('redholdend', 'red hold end');
		animation.addByPrefix('blueholdend', 'blue hold end');

		animation.addByPrefix('purplehold', 'purple hold piece');
		animation.addByPrefix('greenhold', 'green hold piece');
		animation.addByPrefix('redhold', 'red hold piece');
		animation.addByPrefix('bluehold', 'blue hold piece');

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();

		antialiasing = true;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}
}
