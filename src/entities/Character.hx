import flash.display.Bitmap;
import flash.display.Sprite;

class Character extends Sprite {
	public var px:Float;
	public var py:Float;
	public var bmp:Bitmap;
	public var bmpW:Int;
	public var bmpH:Int;
	public var charType:String;
	public var walkFrame:Int;
	public var walkTimer:Int;
	public var facing:Int;

	public function new(charType:String, ppx:Float, ppy:Float, scale:Int=3) {
		super();
		this.charType = charType;
		this.px = ppx;
		this.py = ppy;
		this.walkFrame = 0;
		this.walkTimer = 0;
		this.facing = 1;
		var rows:Array<String>;
		if (charType == "player") rows = PixelArt.playerCharacter();
		else if (charType == "npc") rows = PixelArt.npcCharacter();
		else rows = PixelArt.chiefCharacter();
		var data = PixelArt.fromString(rows, scale);
		this.bmpW = data.width;
		this.bmpH = data.height;
		bmp = new Bitmap(data);
		bmp.smoothing = false;
		addChild(bmp);
		updatePos();
	}

	public function update():Void {
		walkTimer++;
		if (walkTimer > 30) {
			walkTimer = 0;
		}
		var bob = Math.sin(walkTimer * 0.2) * 1;
		bmp.y = py - bmpH / 2 + bob;
	}

	public function walkTo(targetX:Float, speed:Float):Bool {
		var dx = targetX - px;
		if (Math.abs(dx) < speed) {
			px = targetX;
			updatePos();
			return true;
		}
		px += (dx > 0 ? speed : -speed);
		facing = dx > 0 ? 1 : -1;
		walkTimer++;
		var bob = Math.sin(walkTimer * 0.5) * 2;
		bmp.y = py - bmpH / 2 + bob;
		bmp.x = px - bmpW / 2;
		return false;
	}

	private function updatePos():Void {
		bmp.x = px - bmpW / 2;
		bmp.y = py - bmpH / 2;
	}
}
