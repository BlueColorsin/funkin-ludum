package objects;

import flixel.FlxSprite;

class StrumNote extends FlxSprite {
	public var downscroll:Bool = true;

	var resetAnim:Float = 0;

	override public function new(?x:Float = 0, ?y:Float = 0) {
		super(x, y);		
		antialiasing = true;
	}
	

	override function update(elapsed:Float) {
		super.update(elapsed);

		if(resetAnim < 0) return;

		resetAnim -= elapsed;
		if(resetAnim <= 0) {
			playAnim('static');
			resetAnim = 0;
		}
	}

	public function playAnim(anim:String, ?forced:Bool = false, ?resetAnim:Float = 0) {
		animation.play(anim, forced);
		this.resetAnim = resetAnim;

		if(animation.curAnim != null) {
			centerOffsets();
			centerOrigin();
		}
	}
}