package;

import flixel.addons.transition.FlxTransitionableState;

import flixel.util.FlxTimer;

class SigmaState extends FlxTransitionableState {
	var char:Character;

	var thingArray:Array<String> = [];
	var index:Int = 0;

	override function create() {
		char = new Character("boyfriend", 0, 0);
		add(char);

		thingArray = char.animation.getNameList();
		trace(thingArray);

		char.playAnim(thingArray[0], false, false, 0);

		char.animation.finishCallback = (name:String) -> {
			if ((index + 1) > thingArray.length) {
				index = 0;
			} else {
				index++;
			}

			char.playAnim(thingArray[index], false, false, 0);
		}
		
		super.create();
	}

	override function update(elapsed:Float) {
		
		super.update(elapsed);
	}
}