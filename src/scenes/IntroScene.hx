import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.TextField;
import flash.events.MouseEvent;
import flash.events.TouchEvent;

class IntroScene extends Sprite {
	public var complete:Bool;
	private var stageW:Int;
	private var stageH:Int;
	private var npc:Character;
	private var player:Character;
	private var playerPlane:Bitmap;
	private var dialogueBox:Sprite;
	private var dialogueText:TextField;
	private var nameText:TextField;
	private var state:Int; // 0=dialogue, 1=walk_to_plane, 2=board, 3=takeoff
	private var stateTimer:Int;
	private var fullText:String;
	private var textIndex:Int;
	private var textTimer:Int;
	private var stars:Array<Bitmap>;
	private var clouds:Array<Bitmap>;
	private var groundY:Float;

	public function new(w:Int, h:Int) {
		super();
		this.stageW = w;
		this.stageH = h;
		this.complete = false;
		this.state = 0;
		this.stateTimer = 0;
		this.textIndex = 0;
		this.textTimer = 0;
		this.groundY = h - 120;
		this.fullText = "我们的飞机即将要失守了。上面派了我们去围攻那些战机。我们走吧。";

		drawBackground();

		// 角色
		npc = new Character("npc", 120, groundY, 3);
		player = new Character("player", 220, groundY, 3);
		addChild(npc);
		addChild(player);

		// 飞机（停在地面）
		var planeData = PixelArt.fromString(PixelArt.playerPlane(), 2);
		playerPlane = new Bitmap(planeData);
		playerPlane.smoothing = false;
		playerPlane.x = 340 - planeData.width / 2;
		playerPlane.y = groundY - planeData.height + 20;
		addChild(playerPlane);

		// 对话框
		dialogueBox = new Sprite();
		drawDialogueBox();
		dialogueBox.x = 30;
		dialogueBox.y = h - 180;
		addChild(dialogueBox);

		nameText = PixelFont.createText("NPC队员", 14, 0xFFEB3B);
		nameText.x = 50;
		nameText.y = h - 175;
		addChild(nameText);

		dialogueText = PixelFont.createTextArea("", w - 100, 14, 0xFFFFFF);
		dialogueText.x = 50;
		dialogueText.y = h - 150;
		addChild(dialogueText);

		// 点击继续
		addEventListener(MouseEvent.CLICK, onClick);
		addEventListener(TouchEvent.TOUCH_TAP, onClick);
	}

	private function drawBackground():Void {
		var g = graphics;
		// 天空渐变
		g.beginFill(0x0D1B2A);
		g.drawRect(0, 0, stageW, stageH);
		g.endFill();
		// 星星
		stars = [];
		for (i in 0...30) {
			var sd = PixelArt.fromString(PixelArt.star(), 1);
			var s = new Bitmap(sd);
			s.x = Math.random() * stageW;
			s.y = Math.random() * (groundY - 50);
			addChild(s);
			stars.push(s);
		}
		// 地面
		g.beginFill(0x1B3A2F);
		g.drawRect(0, groundY, stageW, stageH - groundY);
		g.endFill();
		// 地面条纹
		g.beginFill(0x2D5A47);
		for (i in 0...20) {
			g.drawRect(i * 30, groundY, 15, 4);
		}
		g.endFill();
	}

	private function drawDialogueBox():Void {
		var g = dialogueBox.graphics;
		g.clear();
		g.beginFill(0x000000, 0.85);
		g.drawRect(0, 0, stageW - 60, 130);
		g.endFill();
		g.lineStyle(2, 0x4FC3F7, 1);
		g.drawRect(0, 0, stageW - 60, 130);
		g.lineStyle();
	}

	private function onClick(e:Dynamic):Void {
		if (state == 0) {
			if (textIndex < fullText.length) {
				// 快速显示全部
				textIndex = fullText.length;
				dialogueText.text = fullText;
			} else {
				// 进入下一阶段
				state = 1;
				stateTimer = 0;
				removeChild(dialogueBox);
				removeChild(nameText);
				removeChild(dialogueText);
			}
		}
	}

	public function update():Void {
		if (state == 0) {
			// 逐字显示
			textTimer++;
			if (textTimer >= 2 && textIndex < fullText.length) {
				textTimer = 0;
				textIndex++;
				dialogueText.text = fullText.substring(0, textIndex);
			}
			npc.update();
			player.update();
		} else if (state == 1) {
			// 跑向飞机
			stateTimer++;
			var npcDone = npc.walkTo(300, 3);
			var playerDone = player.walkTo(330, 3);
			if (npcDone && playerDone) {
				state = 2;
				stateTimer = 0;
			}
		} else if (state == 2) {
			// 登上飞机（角色消失）
			stateTimer++;
			if (stateTimer == 10) {
				if (contains(npc)) removeChild(npc);
				if (contains(player)) removeChild(player);
			}
			if (stateTimer > 30) {
				state = 3;
				stateTimer = 0;
			}
		} else if (state == 3) {
			// 飞机起飞
			stateTimer++;
			playerPlane.y -= 3 + stateTimer * 0.1;
			playerPlane.x += Math.sin(stateTimer * 0.1) * 1;
			if (playerPlane.y < -100 || stateTimer > 100) {
				complete = true;
			}
		}

		// 星星闪烁
		for (s in stars) {
			s.visible = (Math.random() > 0.1);
		}
	}

	public function destroy():Void {
		removeEventListener(MouseEvent.CLICK, onClick);
		removeEventListener(TouchEvent.TOUCH_TAP, onClick);
	}
}
