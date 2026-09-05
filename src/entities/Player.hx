import flash.display.Bitmap;
import flash.display.Sprite;

class Player extends Sprite {
	public var px:Float;
	public var py:Float;
	public var speed:Float;
	public var hp:Int;
	public var maxHp:Int;
	public var alive:Bool;
	public var bmp:Bitmap;
	public var bmpW:Int;
	public var bmpH:Int;
	public var shootCooldown:Int;
	public var invincible:Int;
	public var crashing:Bool;
	public var crashVy:Float;
	public var smokeTimer:Int;

	public function new(ppx:Float, ppy:Float) {
		super();
		this.px = ppx;
		this.py = ppy;
		this.speed = 6;
		this.hp = 5;
		this.maxHp = 5;
		this.alive = true;
		this.shootCooldown = 0;
		this.invincible = 0;
		this.crashing = false;
		this.crashVy = 1;
		this.smokeTimer = 0;
		var data = PixelArt.fromString(PixelArt.playerPlane(), 2);
		this.bmpW = data.width;
		this.bmpH = data.height;
		bmp = new Bitmap(data);
		bmp.smoothing = false;
		addChild(bmp);
		updatePos();
	}

	public function update(keys:Map<String,Bool>, touchX:Float, touchY:Float, touching:Bool, stageW:Int, stageH:Int):Void {
		if (crashing) {
			crashVy += 0.15;
			py += crashVy;
			px += Math.sin(py * 0.05) * 2;
			smokeTimer++;
			updatePos();
			if (py > stageH + 50) {
				alive = false;
			}
			return;
		}
		if (!alive) return;

		if (touching) {
			var dx = touchX - px;
			var dy = touchY - py - 40;
			var dist = Math.sqrt(dx*dx + dy*dy);
			if (dist > 2) {
				px += dx * 0.15;
				py += dy * 0.15;
			}
		} else {
			if (keys.get("left")) px -= speed;
			if (keys.get("right")) px += speed;
			if (keys.get("up")) py -= speed;
			if (keys.get("down")) py += speed;
		}

		if (px < bmpW/2) px = bmpW/2;
		if (px > stageW - bmpW/2) px = stageW - bmpW/2;
		if (py < bmpH/2) py = bmpH/2;
		if (py > stageH - bmpH/2) py = stageH - bmpH/2;

		if (shootCooldown > 0) shootCooldown--;
		if (invincible > 0) {
			invincible--;
			bmp.visible = (invincible % 4 < 2);
		} else {
			bmp.visible = true;
		}
		updatePos();
	}

	public function canShoot():Bool {
		return shootCooldown <= 0 && alive && !crashing;
	}

	public function shoot():Bullet {
		shootCooldown = 10;
		return new Bullet(true, px, py - bmpH/2);
	}

	public function takeDamage(dmg:Int):Bool {
		if (invincible > 0 || crashing) return false;
		hp -= dmg;
		invincible = 60;
		if (hp <= 0) {
			hp = 0;
			crashing = true;
			crashVy = 1;
		}
		return true;
	}

	private function updatePos():Void {
		bmp.x = px - bmpW / 2;
		bmp.y = py - bmpH / 2;
	}
}
