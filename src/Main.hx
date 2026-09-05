import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;

class Main {
	public static function main():Void {
		var game = new Game();
		Lib.current.addChild(game);
	}
}

class Game extends Sprite {
	private var currentScene:Sprite;
	private var sceneType:String;
	private var stageW:Int;
	private var stageH:Int;
	private var lastScore:Int;

	public function new() {
		super();
		stageW = 480;
		stageH = 800;
		lastScore = 0;

		stage.scaleMode = StageScaleMode.SHOW_ALL;
		stage.align = StageAlign.TOP;
		stage.frameRate = 60;

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		startIntro();
	}

	private function startIntro():Void {
		clearScene();
		sceneType = "intro";
		currentScene = new IntroScene(stageW, stageH);
		addChild(currentScene);
	}

	private function startBattle():Void {
		clearScene();
		sceneType = "battle";
		currentScene = new BattleScene(stageW, stageH);
		addChild(currentScene);
	}

	private function startVictory(score:Int):Void {
		clearScene();
		sceneType = "victory";
		currentScene = new VictoryScene(stageW, stageH, score);
		addChild(currentScene);
	}

	private function startGameOver(score:Int):Void {
		clearScene();
		sceneType = "gameover";
		currentScene = new GameOverScene(stageW, stageH, score);
		addChild(currentScene);
	}

	private function clearScene():Void {
		if (currentScene != null) {
			if (contains(currentScene)) {
				removeChild(currentScene);
			}
			try {
				Reflect.callMethod(currentScene, Reflect.field(currentScene, "destroy"), []);
			} catch (e:Dynamic) {}
			currentScene = null;
		}
	}

	private function onEnterFrame(e:Event):Void {
		if (currentScene == null) return;

		if (sceneType == "intro") {
			var intro = cast(currentScene, IntroScene);
			intro.update();
			if (intro.complete) {
				startBattle();
			}
		} else if (sceneType == "battle") {
			var battle = cast(currentScene, BattleScene);
			battle.update();
			if (battle.complete) {
				lastScore = battle.finalScore;
				if (battle.victory) {
					startVictory(lastScore);
				} else {
					startGameOver(lastScore);
				}
			}
		} else if (sceneType == "victory") {
			var vic = cast(currentScene, VictoryScene);
			vic.update();
			if (vic.restart) {
				startIntro();
			}
		} else if (sceneType == "gameover") {
			var go = cast(currentScene, GameOverScene);
			go.update();
			if (go.restart) {
				startIntro();
			}
		}
	}
}
