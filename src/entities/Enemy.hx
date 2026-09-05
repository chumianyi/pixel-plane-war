import flash.display.Bitmap;
import flash.display.Sprite;

class Enemy extends Sprite {
	public var px:Float;
	public var py:Float;
	public var vx:Float;
	public var vy:Float;
	public var hp:Int;
	public var maxHp:Int;
	public var alive:Bool;
	public var bmp:Bitmap;
	public var bmpW:Int;
	public var bmpH:Int;
	public var type:String;
	public var shootCooldown:Int;
	public var moveTimer:Int;
	public var scoreValue:Int;
	public var entered:Bool;
	public var targetY:Float;

	public function new(type:String, ppx:Float, ppy:Float) {
		super();
		this.type = type;
		this.px = ppx;
		this.py = ppy;
		this.alive = true;
		this.entered = false;
		this.moveTimer = 0;
		this.shootCooldown = 60;

		var scale = 2;
		var rows:Array<String>;
		if (type == "normal") {
			rows = PixelArt.enemyNormal();
			this.hp = 2;
			this.vy = 2;
			this.scoreValue = 100;
			scale = 2;
		} else if (type == "elite") {
			rows = PixelArt.enemyElite();
			this.hp = 5;
			this.vy = 1.5;
			this.scoreValue = 300;
			scale = 2;
		} else {
			rows = PixelArt.enemyBoss();
			this.hp = 50;
			this.vy = 1;
			this.scoreValue = 2000;
			scale = 1;
		}
		this.maxHp = hp;
		var data = PixelArt.fromString(rows, scale);
		this.bmpW = data.width;
		this.bmpH = data.height;
		bmp = new Bitmap(data);
		bmp.smoothing = false;
		addChild(bmp);
		this.targetY = type == "boss" ? 100 : 100 + Math.random() * 150;
		updatePos();
	}

	public function update(stageW:Int, stageH:Int):Void {
		if (!alive) return;
		moveTimer++;

		if (!entered) {
			py += vy;
			if (py >= targetY) {
				entered = true;
			}
		} else {
			if (type == "normal") {
				px += Math.sin(moveTimer * 0.03) * 1.5;
				py += 0.5;
			} else if (type == "elite") {
				px += Math.sin(moveTimer * 0.02) * 2;
				py += Math.sin(moveTimer * 0.01) * 0.5;
			} else {
				px += Math.sin(moveTimer * 0.015) * 1.5;
				py = targetY + Math.sin(moveTimer * 0.01) * 20;
			}
		}

		if (px < bmpW/2) px = bmpW/2;
		if (px > stageW - bmpW/2) px = stageW - bmpW/2;

		if (shootCooldown > 0) shootCooldown--;
		updatePos();

		if (py > stageH + 50) {
			alive = false;
		}
	}

	public function canShoot():Bool {
		return shootCooldown <= 0 && alive && entered;
	}

	public function shoot(playerX:Float, playerY:Float):Array<Bullet> {
		var bullets:Array<Bullet> = [];
		if (type == "normal") {
			shootCooldown = 90;
			bullets.push(new Bullet(false, px, py + bmpH/2));
		} else if (type == "elite") {
			shootCooldown = 70;
			var b1 = new Bullet(false, px - 10, py + bmpH/2);
			var b2 = new Bullet(false, px + 10, py + bmpH/2);
			bullets.push(b1);
			bullets.push(b2);
		} else {
			shootCooldown = 40;
			var angles = [-0.2, 0, 0.2];
			for (a in angles) {
				var b = new Bullet(false, px, py + bmpH/2);
				b.vx = Math.sin(a) * 4;
				b.vy = Math.cos(a) * 5;
				bullets.push(b);
			}
			if (moveTimer % 200 < 40) {
				for (i in 0...5) {
					var angle = -0.4 + i * 0.2;
					var b = new Bullet(false, px, py + bmpH/2);
					b.vx = Math.sin(angle) * 3;
					b.vy = Math.cos(angle) * 4;
					bullets.push(b);
				}
			}
		}
		return bullets;
	}

	public function takeDamage(dmg:Int):Bool {
		hp -= dmg;
		if (hp <= 0) {
			hp = 0;
			alive = false;
			return true;
		}
		return false;
	}

	private function updatePos():Void {
		bmp.x = px - bmpW / 2;
		bmp.y = py - bmpH / 2;
	}
}
