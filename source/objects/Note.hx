package objects;

import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import states.PlayState;
import backend.Conductor;
import backend.Paths;
import backend.NoteTypeHandler;
import flixel.FlxSprite;

class Note extends FlxSprite {
	public static var swagWidth:Float = 160 * 0.7;

	public var strumTime:Float = 0.0;
	
	public var mustPress:Bool = false;
	public var canHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var hasBeenHit:Bool = false;

	public var multiAlpha:Float = 1.0;

	public var copyAlpha:Bool = true;
	public var copyX:Bool = true;

	public var isSustain:Bool = false;

	public var tail:Array<Note> = [];
	public var parentNote:Note;

	public var noteData:Int = 0;

	public function new(strumTime:Float, noteData:Int, ?noteType:String = "000000", ?parentNote:Note = null) {
		super();

		this.strumTime = strumTime;
		this.parentNote = parentNote;
		this.noteData = noteData;
	
		scrollFactor.set(0, 0);

		frames = Paths.getSparrowAtlas("NOTE_assets");

		animation.addByPrefix('purple_Scroll', 'purple0');
		animation.addByPrefix('blue_Scroll', 'blue0');
		animation.addByPrefix('green_Scroll', 'green0');
		animation.addByPrefix('red_Scroll', 'red0');

		animation.addByPrefix('purple_holdend', 'pruple end hold');
		animation.addByPrefix('green_holdend', 'green hold end');
		animation.addByPrefix('red_holdend', 'red hold end');
		animation.addByPrefix('blue_holdend', 'blue hold end');

		animation.addByPrefix('purple_hold', 'purple hold piece');
		animation.addByPrefix('green_hold', 'green hold piece');
		animation.addByPrefix('red_hold', 'red hold piece');
		animation.addByPrefix('blue_hold', 'blue hold piece');

		switch(noteData % 4) {
			case 0:
				animation.play("purple_Scroll");
			case 1:
				animation.play("blue_Scroll");
			case 2:
				animation.play("green_Scroll");
			case 3:
				animation.play("red_Scroll");
		}

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();

		antialiasing = true;
		
		x = noteData * (swagWidth + 20);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (mustPress) {
			this.canHit = (strumTime > Conductor.songPosition - Conductor.safeZoneOffset && strumTime < Conductor.songPosition + Conductor.safeZoneOffset);
	
			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit) {
				this.tooLate = true;
			}

			return;
		}

		canHit = false;

		if (!wasGoodHit && strumTime <= Conductor.songPosition) {
			if(!isSustain || (parentNote.wasGoodHit))
				wasGoodHit = true;
		}
	}

	public function followStrum(strum:StrumNote) {
		if(copyAlpha)
			alpha = strum.alpha * multiAlpha;
		
		if(copyX)
			x = strum.x;
		
		var distance = (0.45 * (Conductor.songPosition - strumTime) * PlayState.songSpeed);

		if (!strum.downscroll)
			distance *= -1;

		y = strum.y + distance;
		
		if(strum.downscroll && isSustain) {
			y -= (frameHeight * scale.y) - (Note.swagWidth / 2);
		}
	}
}