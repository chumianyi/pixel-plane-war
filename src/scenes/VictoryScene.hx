import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.TextField;
import flash.events.MouseEvent;
import flash.events.TouchEvent;

class VictoryScene extends Sprite {
	public var restart:Bool;
	private var stageW:Int;
	private var stageH:Int;
	private var chief:Character;
	private var player:Character;
	private var dialogueBox:Sprite;
	private var dialogueText:TextField;
	private var nameText:TextField;
	private var fullText:String;
	private var textIndex:Int;
	private var textTimer:Int;
	private var state:Int; // 0=dialogue, 1=score show
	private var stateTimer:Int;
	private var scoreText:TextField;
	private var titleText:TextField;
	private var restartText:TextField;
	private var stars:Array<Bitmap>;

	public function new(w:Int, h:Int, score:Int) {
		super();
		this.stageW = w;
		this.stageH = h;
		this.restart = false;
		this.state = 0;
		this.stateTimer = 0;
		this.textIndex = 0;
		this.textTimer = 0;
		this.fullText = "感谢你的付出。";

		drawBackground();

		// 局长和玩家角色
		chief = new Character("chief", 150, h - 200, 3);
		player = new Character("player", 330, h - 200, 3);
		addChild(chief);
		addChild(player);

		// 标题
		titleText = PixelFont.createText("胜 利", 36, 0xFFEB3B, true);
		titleText.x = (w - titleText.width) / 2;
		titleText.y = 80;
		addChild(titleText);

		// 分数
		scoreText = PixelFont.createText("最终分数: " + score, 20, 0x4FC3F7, true);
		scoreText.x = (w - scoreText.width) / 2;
		scoreText.y = 140;
		scoreText.visible = false;
		addChild(scoreText);

		// 对话框
		dialogueBox = new Sprite();
		var g = dialogueBox.graphics;
		g.beginFill(0x000000, 0.85);
		g.drawRect(0, 0, w - 60, 100);
		g.endFill();
		g.lineStyle(2, 0xFFEB3B, 1);
		g.drawRect(0, 0, w - 60, 100);
		g.lineStyle();
		dialogueBox.x = 30;
		dialogueBox.y = h - 160;
		addChild(dialogueBox);

		nameText = PixelFont.createText("局长", 14, 0xFFEB3B);
		nameText.x = 50;
		nameText.y = h - 155;
		addChild(nameText);

		dialogueText = PixelFont.createTextArea("", w - 100, 16, 0xFFFFFF);
		dialogueText.x = 50;
		dialogueText.y = h - 130;
		addChild(dialogueText);

		restartText = PixelFont.createText("点击重新开始", 16, 0xAAAAAA);
		restartText.x = (w - restartText.width) / 2;
		restartText.y = h - 40;
		restartText.visible = false;
		addChild(restartText);

		addEventListener(MouseEvent.CLICK, onClick);
		addEventListener(TouchEvent.TOUCH_TAP, onClick);
	}

	private function drawBackground():Void {
		var g = graphics;
		g.beginFill(0x1A237E);
		g.drawRect(0, 0, stageW, stageH);
		g.endFill();
		// 渐变效果用多层矩形模拟
		g.beginFill(0x283593);
		g.drawRect(0, stageH * 0.3, stageW, stageH * 0.7);
		g.endFill();
		g.beginFill(0x3949AB);
		g.drawRect(0, stageH * 0.6, stageW, stageH * 0.4);
		g.endFill();

		stars = [];
		for (i in 0...40) {
			var sd = PixelArt.fromString(PixelArt.star(), 1);
			var s = new Bitmap(sd);
			s.x = Math.random() * stageW;
			s.y = Math.random() * stageH * 0.6;
			addChild(s);
			stars.push(s);
		}
	}

	private function onClick(e:Dynamic):Void {
		if (state == 0) {
			if (textIndex < fullText.length) {
				textIndex = fullText.length;
				dialogueText.text = fullText;
			} else {
				state = 1;
				stateTimer = 0;
				scoreText.visible = true;
				restartText.visible = true;
			}
		} else if (state == 1) {
			restart = true;
		}
	}

	public function update():Void {
		if (state == 0) {
			textTimer++;
			if (textTimer >= 3 && textIndex < fullText.length) {
				textTimer = 0;
				textIndex++;
				dialogueText.text = fullText.substring(0, textIndex);
			}
			chief.update();
			player.update();
		}
		stateTimer++;
		// 星星闪烁
		for (s in stars) {
			s.visible = (Math.random() > 0.15);
		}
		// 标题闪烁
		if (stateTimer % 60 < 30) {
			titleText.alpha = 1;
		} else {
			titleText.alpha = 0.7;
		}
	}

	public function destroy():Void {
		removeEventListener(MouseEvent.CLICK, onClick);
		removeEventListener(TouchEvent.TOUCH_TAP, onClick);
	}
}
