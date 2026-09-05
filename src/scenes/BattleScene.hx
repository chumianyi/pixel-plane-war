import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.TextField;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TouchEvent;

class BattleScene extends Sprite {
	public var complete:Bool;
	public var victory:Bool;
	public var finalScore:Int;

	private var stageW:Int;
	private var stageH:Int;
	private var player:Player;
	private var enemies:Array<Enemy>;
	private var playerBullets:Array<Bullet>;
	private var enemyBullets:Array<Bullet>;
	private var explosions:Array<Explosion>;
	private var keys:Map<String,Bool>;
	private var touchX:Float;
	private var touchY:Float;
	private var touching:Bool;
	private var score:Int;
	private var wave:Int;
	private var waveTimer:Int;
	private var enemiesSpawned:Int;
	private var enemiesInWave:Int;
	private var bossSpawned:Bool;
	private var bossDefeated:Bool;
	private var scoreText:TextField;
	private var hpBar:Sprite;
	private var hpText:TextField;
	private var waveText:TextField;
	private var stars:Array<Bitmap>;
	private var clouds:Array<Bitmap>;
	private var autoShootTimer:Int;
	private var crashExplosionDone:Bool;
	private var gameOverTimer:Int;

	public function new(w:Int, h:Int) {
		super();
		this.stageW = w;
		this.stageH = h;
		this.complete = false;
		this.victory = false;
		this.finalScore = 0;
		this.score = 0;
		this.wave = 1;
		this.waveTimer = 0;
		this.enemiesSpawned = 0;
		this.enemiesInWave = 5;
		this.bossSpawned = false;
		this.bossDefeated = false;
		this.autoShootTimer = 0;
		this.crashExplosionDone = false;
		this.gameOverTimer = 0;

		enemies = [];
		playerBullets = [];
		enemyBullets = [];
		explosions = [];
		keys = new Map<String,Bool>();
		keys["left"] = false;
		keys["right"] = false;
		keys["up"] = false;
		keys["down"] = false;
		keys["shoot"] = false;

		drawBackground();

		player = new Player(w / 2, h - 150);
		addChild(player);

		// UI
		scoreText = PixelFont.createText("分数: 0", 16, 0xFFFFFF, true);
		scoreText.x = 10;
		scoreText.y = 10;
		addChild(scoreText);

		waveText = PixelFont.createText("第1波", 14, 0xFFEB3B);
		waveText.x = 10;
		scoreText.y = 10;
		waveText.y = 32;
		addChild(waveText);

		hpBar = new Sprite();
		drawHpBar();
		hpBar.x = w - 160;
		hpBar.y = 15;
		addChild(hpBar);

		hpText = PixelFont.createText("HP", 12, 0xFFFFFF);
		hpText.x = w - 160;
		hpText.y = 2;
		addChild(hpText);

		// 事件监听
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
	}

	private function drawBackground():Void {
		var g = graphics;
		g.beginFill(0x0A1628);
		g.drawRect(0, 0, stageW, stageH);
		g.endFill();

		stars = [];
		for (i in 0...50) {
			var sd = PixelArt.fromString(PixelArt.star(), 1);
			var s = new Bitmap(sd);
			s.x = Math.random() * stageW;
			s.y = Math.random() * stageH;
			addChild(s);
			stars.push(s);
		}

		clouds = [];
		for (i in 0...5) {
			var cd = PixelArt.fromString(PixelArt.cloud(), 2);
			var c = new Bitmap(cd);
			c.x = Math.random() * stageW;
			c.y = Math.random() * stageH;
			c.alpha = 0.3;
			addChild(c);
			clouds.push(c);
		}
	}

	private function drawHpBar():Void {
		var g = hpBar.graphics;
		g.clear();
		g.beginFill(0x333333);
		g.drawRect(0, 0, 140, 16);
		g.endFill();
		var pct = player != null ? player.hp / player.maxHp : 1;
		var color = pct > 0.5 ? 0x4CAF50 : (pct > 0.25 ? 0xFFC107 : 0xF44336);
		g.beginFill(color);
		g.drawRect(2, 2, (140 - 4) * pct, 12);
		g.endFill();
		g.lineStyle(1, 0xFFFFFF);
		g.drawRect(0, 0, 140, 16);
		g.lineStyle();
	}

	private function onKeyDown(e:KeyboardEvent):Void {
		var code = e.keyCode;
		if (code == 37 || code == 65) keys["left"] = true;
		if (code == 39 || code == 68) keys["right"] = true;
		if (code == 38 || code == 87) keys["up"] = true;
		if (code == 40 || code == 83) keys["down"] = true;
		if (code == 32) keys["shoot"] = true;
	}

	private function onKeyUp(e:KeyboardEvent):Void {
		var code = e.keyCode;
		if (code == 37 || code == 65) keys["left"] = false;
		if (code == 39 || code == 68) keys["right"] = false;
		if (code == 38 || code == 87) keys["up"] = false;
		if (code == 40 || code == 83) keys["down"] = false;
		if (code == 32) keys["shoot"] = false;
	}

	private function onMouseDown(e:MouseEvent):Void {
		touching = true;
		touchX = e.stageX;
		touchY = e.stageY;
	}

	private function onMouseUp(e:MouseEvent):Void {
		touching = false;
	}

	private function onMouseMove(e:MouseEvent):Void {
		if (touching) {
			touchX = e.stageX;
			touchY = e.stageY;
		}
	}

	private function onTouchBegin(e:TouchEvent):Void {
		touching = true;
		touchX = e.stageX;
		touchY = e.stageY;
	}

	private function onTouchEnd(e:TouchEvent):Void {
		touching = false;
	}

	private function onTouchMove(e:TouchEvent):Void {
		touchX = e.stageX;
		touchY = e.stageY;
	}

	public function update():Void {
		if (complete) return;

		// 背景滚动
		for (s in stars) {
			s.y += 2;
			if (s.y > stageH) {
				s.y = -5;
				s.x = Math.random() * stageW;
			}
		}
		for (c in clouds) {
			c.y += 0.5;
			if (c.y > stageH + 20) {
				c.y = -30;
				c.x = Math.random() * stageW;
			}
		}

		// 玩家坠毁处理
		if (player.crashing) {
			player.update(keys, touchX, touchY, touching, stageW, stageH);
			// 冒烟
			if (player.smokeTimer % 5 == 0) {
				var smokeBmp = new Bitmap(PixelArt.fromString(PixelArt.smoke(), 2));
				smokeBmp.x = player.px + Math.random() * 20 - 10;
				smokeBmp.y = player.py;
				smokeBmp.alpha = 0.7;
				addChild(smokeBmp);
				// 简单烟雾上升
				// 由于没有Tween，用一个简单数组管理
			}
			// 坠毁爆炸
			if (player.py > stageH - 80 && !crashExplosionDone) {
				crashExplosionDone = true;
				var exp = new Explosion(player.px, stageH - 60, 5);
				addChild(exp);
				explosions.push(exp);
				player.visible = false;
			}
			gameOverTimer++;
			if (gameOverTimer > 120) {
				finalScore = score;
				victory = false;
				complete = true;
			}
			updateExplosions();
			return;
		}

		player.update(keys, touchX, touchY, touching, stageW, stageH);

		// 射击（电脑：空格；手机：自动射击）
		autoShootTimer++;
		var shouldShoot = keys.get("shoot") == true || touching || autoShootTimer > 8;
		if (shouldShoot && player.canShoot()) {
			var b = player.shoot();
			addChild(b);
			playerBullets.push(b);
			autoShootTimer = 0;
		}

		// 敌人生成
		waveTimer++;
		if (!bossSpawned) {
			if (enemiesSpawned < enemiesInWave && waveTimer > 60) {
				waveTimer = 0;
				spawnEnemy();
				enemiesSpawned++;
			}
			// 检查波次完成
			var aliveEnemies = 0;
			for (en in enemies) if (en.alive) aliveEnemies++;
			if (enemiesSpawned >= enemiesInWave && aliveEnemies == 0) {
				wave++;
				if (wave > 3) {
					// 生成Boss
					bossSpawned = true;
					spawnBoss();
					waveText.text = "BOSS战!";
				} else {
					enemiesSpawned = 0;
					enemiesInWave = 5 + wave * 2;
					waveText.text = "第" + wave + "波";
					waveTimer = -90; // 波次间隔
				}
			}
		}

		// 更新敌人
		for (en in enemies) {
			en.update(stageW, stageH);
			if (en.canShoot()) {
				var bs = en.shoot(player.px, player.py);
				for (b in bs) {
					addChild(b);
					enemyBullets.push(b);
				}
			}
		}

		// 更新子弹
		for (b in playerBullets) b.update();
		for (b in enemyBullets) b.update();

		// 碰撞检测：玩家子弹 vs 敌人
		for (b in playerBullets) {
			if (!b.alive) continue;
			for (en in enemies) {
				if (!en.alive) continue;
				if (b.hitTest(en.px, en.py, en.bmpW, en.bmpH)) {
					b.alive = false;
					removeChild(b);
					var destroyed = en.takeDamage(b.damage);
					if (destroyed) {
						score += en.scoreValue;
						var exp = new Explosion(en.px, en.py, en.type == "boss" ? 5 : 3);
						addChild(exp);
						explosions.push(exp);
						removeChild(en);
						if (en.type == "boss") {
							bossDefeated = true;
						}
					}
					break;
				}
			}
		}

		// 碰撞检测：敌人子弹 vs 玩家
		for (b in enemyBullets) {
			if (!b.alive) continue;
			if (b.hitTest(player.px, player.py, player.bmpW * 0.6, player.bmpH * 0.6)) {
				b.alive = false;
				removeChild(b);
				player.takeDamage(1);
			}
		}

		// 碰撞检测：敌人 vs 玩家
		for (en in enemies) {
			if (!en.alive) continue;
			if (Math.abs(en.px - player.px) < (en.bmpW + player.bmpW) * 0.3 &&
				Math.abs(en.py - player.py) < (en.bmpH + player.bmpH) * 0.3) {
				player.takeDamage(2);
				en.takeDamage(5);
				if (!en.alive) {
					score += en.scoreValue;
					var exp = new Explosion(en.px, en.py, 3);
					addChild(exp);
					explosions.push(exp);
					removeChild(en);
				}
			}
		}

		// 清理死亡实体
		playerBullets = playerBullets.filter(function(b) return b.alive);
		enemyBullets = enemyBullets.filter(function(b) return b.alive);
		enemies = enemies.filter(function(en) {
			if (!en.alive && contains(en)) {
				// 已经在碰撞中removeChild了
			}
			return en.alive;
		});

		updateExplosions();

		// 更新UI
		scoreText.text = "分数: " + score;
		drawHpBar();

		// 胜利检测
		if (bossDefeated) {
			finalScore = score;
			victory = true;
			complete = true;
		}
	}

	private function updateExplosions():Void {
		for (exp in explosions) {
			exp.update();
			if (!exp.alive && contains(exp)) {
				removeChild(exp);
			}
		}
		explosions = explosions.filter(function(e) return e.alive);
	}

	private function spawnEnemy():Void {
		var type = "normal";
		if (wave >= 2 && Math.random() < 0.3) type = "elite";
		var x = 40 + Math.random() * (stageW - 80);
		var en = new Enemy(type, x, -40);
		addChild(en);
		enemies.push(en);
	}

	private function spawnBoss():Void {
		var boss = new Enemy("boss", stageW / 2, -80);
		addChild(boss);
		enemies.push(boss);
	}

	public function destroy():Void {
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		stage.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
	}
}
