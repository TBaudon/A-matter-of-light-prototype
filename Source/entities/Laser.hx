package entities ;
import core.Entity;
import core.Level;
import core.Utils;
import geom.Vec2;
import haxe.Log;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.filters.GlowFilter;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Thomas BAUDON
 */
class Laser extends Entity
{
	
	var mLevel : Level;
	var mAngle : Float;
	var mFiring : Bool;
	
	var mStartX : Int;
	var mStartY : Int;
	
	var mEndX : Int;
	var mEndY : Int;
	
	var mDir : Vec2;
	
	var mDrawLine : Shape;
	
	var mEndPos:Vec2;
	
	var mTile : Array<{x : Int, y : Int}>;
	
	var mColor : UInt;
	
	var mImpact : Bool;

	public function new(level : Level, color : UInt = 0xff0000) 
	{
		super();
		mLevel = level;
		mAngle = 0;
		mFiring = false;
		mDir = new Vec2();
		mDrawLine = new Shape();
		mColor = color;
	}
	
	public function setAngle(angle : Float) {
		mAngle = angle / Math.PI * 180;
	}
	
	public function setEndPos(vec : Vec2) {
		mEndPos = vec;
		mDir.set(mEndPos.x - pos.x, mEndPos.y - pos.y);
	}
	
	override function update(delta:Float) 
	{
		super.update(delta);
		if (mEndPos == null) return;
		
		mImpact = false;
		
		var end = mLevel.castRay(pos, mEndPos);
		if (end != null) {
			mEndPos = end;
			mDir.set(mEndPos.x - pos.x, mEndPos.y - pos.y);
			mImpact = true;
		} 
	}
	
	override function draw(buffer:BitmapData, dest:Vec2) 
	{
		super.draw(buffer, dest);
		
		mDrawLine.graphics.clear();
		mDrawLine.graphics.lineStyle(8, mColor, 0.8);
		mDrawLine.graphics.moveTo(dest.x,dest.y);
		mDrawLine.graphics.lineTo(dest.x + mDir.x, dest.y + mDir.y);
		mDrawLine.graphics.lineStyle(5, 0xffffff, 0.4);
		mDrawLine.graphics.moveTo(dest.x,dest.y);
		mDrawLine.graphics.lineTo(dest.x + mDir.x, dest.y + mDir.y);
		mDrawLine.graphics.lineStyle(2, 0xffffff, 0.8);
		mDrawLine.graphics.moveTo(dest.x,dest.y);
		mDrawLine.graphics.lineTo(dest.x + mDir.x, dest.y + mDir.y);
		mDrawLine.filters = [new GlowFilter(mColor)];
		
		if (mImpact) {
			var radius = Math.random() * 5 + 5;
			mDrawLine.graphics.lineStyle(0, 0, 0);
			mDrawLine.graphics.beginFill(0xffffff, 0.8);
			mDrawLine.graphics.drawCircle(dest.x + mDir.x, dest.y + mDir.y, radius);
		}
		
		buffer.draw(mDrawLine);
	}
	
	public function getDir() : Vec2 {
		return mDir;
	}
	
}