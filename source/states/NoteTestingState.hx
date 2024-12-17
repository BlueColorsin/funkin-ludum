package states;

import flixel.FlxG;
import flixel.util.FlxColor;
import objects.Character;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import backend.Paths;
import backend.ChartParser;
import flixel.FlxState;

import objects.UiGroup;

class NoteTestingState extends FlxState {
	var sprite:FlxSprite;
	var ui:UiGroup;

	override function create() {
		sprite = new FlxSprite().loadGraphic(Paths.image("car"));
		sprite.scale.set(1, 1);

		ui = new UiGroup(120, 200);
		ui.add(sprite);

		add(ui);
	}

	var speed:Float = 10;
	override function update(elapsed:Float) {
		if (FlxG.keys.pressed.LEFT)
			sprite.x -= speed;

		else if (FlxG.keys.pressed.UP)
			sprite.y -= speed;

		else if (FlxG.keys.pressed.DOWN)
			sprite.y += speed;

		else if (FlxG.keys.pressed.RIGHT)
			sprite.x += speed;
		
		super.update(elapsed);
	}
}