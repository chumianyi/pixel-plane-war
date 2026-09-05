import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.TextField;
import flash.events.MouseEvent;
import flash.events.TouchEvent;

class GameOverScene extends Sprite {
	public var restart:Bool;
	private var stageW:Int;
	private var stageH:Int;
	private var titleText:TextField;
	private var scoreText:TextField;
	private var restartText:TextField;
	private var stateTimer:Int;
	private var debris:Array<Bitmap>;

	public function new(w:Int, h:Int, score:Int) {
		super();
		this.stageW = w;
		this.stageH = h;
		this.restart = false;
		this.stateTimer = 0;

		drawBackground();

		// 残骸
		debris = [];
		for (i in 0...8) {
			var d = new Bitmap(PixelArt.fromString(PixelArt.explosion3(), 2));
			d.x = Math.random() * w;
			d.y = h - 100 + Math.random() * 60;
			d.alpha = 0.6;
			addChild(d);
			debris.push(d);
		}

		titleText = PixelFont.createText("游戏结束", 40, 0xF44336, true);
		titleText.x = (w - titleText.width) / 2;
		titleText.y = 200;
		addChild(titleText);

		scoreText = PixelFont.createText("分数: " + score, 20, 0xFFFFFF);
		scoreText.x = (w - scoreText.width) / 2;
		scoreText.y = 280;
		addChild(scoreText);

		var tipText = PixelFont.createText("战机已坠毁", 16, 0xAAAAAA);
		tipText.x = (w - tipText.width) / 2;
		tipText.y = 330;
		addChild(tipText);

		restartText = PixelFont.createText("点击重新开始", 18, 0x4FC3F7);
		restartText.x = (w - restartText.width) / 2;
		restartText.y = h - 100;
		addChild(restartText);

		addEventListener(MouseEvent.CLICK, onClick);
		addEventListener(TouchEvent.TOUCH_TAP, onClick);
	}

	private function drawBackground():Void {
		var g = graphics;
		g.beginFill(0x1A0A0A);
		g.drawRect(0, 0, stageW, stageH);
		g.endFill();
		g.beginFill(0x2D1414);
		g.drawRect(0, stageH * 0.5, stageW, stageH * 0.5);
		g.endFill();
		// 地面
		g.beginFill(0x3E1F1F);
		g.drawRect(0, stageH - 80, stageW, 80);
		g.endFill();
		// 弹坑
		g.beginFill(0x000000);
		g.drawEllipse(stageW / 2 - 60, stageH - 90, 120, 30);
		g.endFill();
	}

	private function onClick(e:Dynamic):Void {
		stateTimer++;
		if (stateTimer > 30) {
			restart = true;
		}
	}

	public function update():Void {
		stateTimer++;
		// 标题闪烁
		if (stateTimer % 40 < 20) {
			titleText.alpha = 1;
		} else {
			titleText.alpha = 0.6;
		}
		// 重新开始提示闪烁
		if (stateTimer % 60 < 30) {
			restartText.alpha = 1;
		} else {
			restartText.alpha = 0.4;
		}
	}

	public function destroy():Void {
		removeEventListener(MouseEvent.CLICK, onClick);
		removeEventListener(TouchEvent.TOUCH_TAP, onClick);
	}
}
