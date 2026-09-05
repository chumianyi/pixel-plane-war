import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

class Bullet extends Sprite {
	public var px:Float;
	public var py:Float;
	public var vx:Float;
	public var vy:Float;
	public var damage:Int;
	public var isPlayer:Bool;
	public var alive:Bool;
	public var bmp:Bitmap;
	public var bmpW:Int;
	public var bmpH:Int;

	public function new(isPlayer:Bool, ppx:Float, ppy:Float) {
		super();
		this.isPlayer = isPlayer;
		this.px = ppx;
		this.py = ppy;
		this.alive = true;
		this.damage = isPlayer ? 1 : 1;
		if (isPlayer) {
			this.vy = -12;
			this.vx = 0;
			var data = PixelArt.fromString(PixelArt.bulletPlayer(), 2);
			this.bmpW = data.width;
			this.bmpH = data.height;
			bmp = new Bitmap(data);
		} else {
			this.vy = 6;
			this.vx = 0;
			var data = PixelArt.fromString(PixelArt.bulletEnemy(), 2);
			this.bmpW = data.width;
			this.bmpH = data.height;
			bmp = new Bitmap(data);
		}
		bmp.smoothing = false;
		addChild(bmp);
		updatePos();
	}

	public function update():Void {
		px += vx;
		py += vy;
		updatePos();
		if (py < -20 || py > 820 || px < -20 || px > 500) {
			alive = false;
		}
	}

	private function updatePos():Void {
		bmp.x = px - bmpW / 2;
		bmp.y = py - bmpH / 2;
	}

	public function hitTest(ox:Float, oy:Float, ow:Float, oh:Float):Bool {
		return px > ox - ow/2 && px < ox + ow/2 && py > oy - oh/2 && py < oy + oh/2;
	}
}
