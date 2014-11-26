package screens;
import core.Actor;
import core.Dialog;
import core.Entity;
import core.Level;
import core.Screen;
import entities.Hero;
import geom.Vec2;
import openfl.Assets;
import openfl.display.BitmapData;

/**
 * ...
 * @author Thomas B
 */
class GameScreen extends Screen
{
	
	var mActorToKeep : Map<String, Actor>;
	var mCurrentLevel : Level;
	var mDialog : Dialog;
	var mCurrentLevelName : String;
	var mNbCurrentTryNumber : Int;

	public function new() 
	{
		super();
		mNbCurrentTryNumber = 0;
		mActorToKeep = new Map<String, Actor>();
		//mActorToKeep.set("Hero", new Hero());
		//
		loadLevel("level1");
		//loadLevel("level4");
		//loadLevel("AntiGrav-sample");
	}
	
	public function loadLevel(name : String) {
		if (mDialog != null) {
			mDialog.destroy();
			mDialog = null;
		}
		if (mCurrentLevel != null)
			mCurrentLevel.destroy();
		mCurrentLevel = new Level(this, name, mActorToKeep);
		if (name == mCurrentLevelName)
			mNbCurrentTryNumber++;
		else{
			mNbCurrentTryNumber = 0;
			mCurrentLevelName = name;
		}
		mCurrentLevel.load();
		add(mCurrentLevel);
	}
	
	override function update(delta:Float) 
	{
		if (mDialog != null)
			mDialog.update(delta);
		super.update(delta);
	}
	
	override function _draw(buffer : BitmapData, dest : Vec2) { 
		super._draw(buffer, dest);
		if (mDialog != null)
			mDialog.draw(buffer, dest);
	}
	
	public function showDialog(level : Int) {
		var text = Assets.getText("dialogs/level" + level + "_" + mNbCurrentTryNumber + ".txt");
		if(text != null){
			text = StringTools.replace(text, "\n", "");
			mDialog = new Dialog(text);
		}
	}
	
}