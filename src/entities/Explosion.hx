import flash.display.Bitmap;
import flash.display.Sprite;

class Explosion extends Sprite {
	public var px:Float;
	public var py:Float;
	public var frame:Int;
	public var frameTimer:Int;
	public var alive:Bool;
	public var bmp:Bitmap;
	public var scale:Int;

	public function new(ppx:Float, ppy:Float, scale:Int=3) {
		super();
		this.px = ppx;
		this.py = ppy;
		this.frame = 0;
		this.frameTimer = 0;
		this.alive = true;
		this.scale = scale;
		var data = PixelArt.fromString(PixelArt.explosion1(), scale);
		bmp = new Bitmap(data);
		bmp.smoothing = false;
		addChild(bmp);
		updatePos();
	}

	public function update():Void {
		frameTimer++;
		if (frameTimer >= 4) {
			frameTimer = 0;
			frame++;
			if (frame > 3) {
				alive = false;
				return;
			}
			removeChild(bmp);
			var rows:Array<String>;
			if (frame == 1) rows = PixelArt.explosion2();
			else if (frame == 2) rows = PixelArt.explosion3();
			else rows = PixelArt.explosion1();
			var data = PixelArt.fromString(rows, scale);
			bmp = new Bitmap(data);
			bmp.smoothing = false;
			addChild(bmp);
			updatePos();
		}
	}

	private function updatePos():Void {
		bmp.x = px - bmp.width / 2;
		bmp.y = py - bmp.height / 2;
	}
}
