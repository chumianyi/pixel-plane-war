import flash.display.BitmapData;
import flash.geom.Rectangle;

class PixelArt {
	public static var COLORS:Map<String,Int> = [
		"." => 0x00000000,
		"K" => 0xFF000000,
		"W" => 0xFFFFFFFF,
		"R" => 0xFFE53935,
		"G" => 0xFF43A047,
		"B" => 0xFF1E88E5,
		"Y" => 0xFFFDD835,
		"O" => 0xFFFB8C00,
		"P" => 0xFFEC407A,
		"U" => 0xFF8E24AA,
		"S" => 0xFFBDBDBD,
		"D" => 0xFF424242,
		"L" => 0xFF90CAF9,
		"H" => 0xFFFFCCBC,
		"N" => 0xFF6D4C41,
		"C" => 0xFF00ACC1,
		"M" => 0xFF5D4037,
		"E" => 0xFFEEEEEE,
		"F" => 0xFF795548,
		"T" => 0xFF00E5FF,
		"V" => 0xFF7C4DFF,
		"Q" => 0xFFFF6F00,
		"Z" => 0xFF263238
	];

	public static function fromString(rows:Array<String>, scale:Int=1):BitmapData {
		var h = rows.length;
		var w = rows[0].length;
		var bmp = new BitmapData(w * scale, h * scale, true, 0x00000000);
		for (y in 0...h) {
			var row = rows[y];
			for (x in 0...w) {
				var ch = row.charAt(x);
				var color = COLORS.exists(ch) ? COLORS[ch] : 0x00000000;
				if (color != 0x00000000) {
					var rect = new Rectangle(x * scale, y * scale, scale, scale);
					bmp.fillRect(rect, color);
				}
			}
		}
		return bmp;
	}

	// 玩家角色 - 绿色头盔可爱小人 16x16
	public static function playerCharacter():Array<String> {
		return [
			"....GGGGGGGG....",
			"...GHHHHHHHHG...",
			"..GHWKHHHHKWGH..",
			"..GHHHHHHHHHHG..",
			"..GHHKHHHHKHHG..",
			"..GHWWHWWHWWHG..",
			"...GHHHHHHHHG...",
			"....GGGGGGGG....",
			"...RRRRRRRRRR...",
			"..RRWWRRRRWWRR..",
			"..RRWWRRRRWWRR..",
			"...RRRRRRRRRR...",
			"....DD....DD....",
			"....DD....DD....",
			"...DDD....DDD...",
			"...KKK....KKK..."
		];
	}

	// NPC角色 - 蓝色头盔可爱小人 16x16
	public static function npcCharacter():Array<String> {
		return [
			"....BBBBBBBB....",
			"...BHHHHHHHHB...",
			"..BHWKHHHHKWBH..",
			"..BHHHHHHHHHHB..",
			"..BHHKHHHHKHHB..",
			"..BHWWHWWHWWHB..",
			"...BHHHHHHHHB...",
			"....BBBBBBBB....",
			"...OOOOOOOOOO...",
			"..OOWWOOOOWWOO..",
			"..OOWWOOOOWWOO..",
			"...OOOOOOOOOO...",
			"....DD....DD....",
			"....DD....DD....",
			"...DDD....DDD...",
			"...KKK....KKK..."
		];
	}

	// 局长角色 - 黄色帽子+胡子 16x16
	public static function chiefCharacter():Array<String> {
		return [
			"....YYYYYYYY....",
			"...YYYYYYYYYY...",
			"..YYKKKKKKKKYY..",
			"...HHHHHHHHHH...",
			"..HWKHHHHHHKWH..",
			"..HHHHHHHHHHHH..",
			"..HHHKHHHHKHHH..",
			"..HHWWHWWHWWHH..",
			"...HHHHHHHHHH...",
			"....NNNNNNNN....",
			"...NNNNNNNNNN...",
			"..NNWNNNNNNWNN..",
			"....DD....DD....",
			"....DD....DD....",
			"...DDD....DDD...",
			"...KKK....KKK..."
		];
	}

	// 玩家战机 - 朝上 32x32
	public static function playerPlane():Array<String> {
		return [
			".......TTTT.......",
			"......TCCCC T......",
			"......TCCCC T......",
			".....TCCWWCCT.....",
			".....TCCWWCCT.....",
			"....TCCWWWWCCT....",
			"....TCCWWWWCCT....",
			"...SSSCCCCCCSSS...",
			"..SSSSSCCCCSSSSS..",
			".SSSSSSSCCSSSSSSS.",
			"SSSSSSSSSSSSSSSSSS",
			"SSSKKSSSSSSSSKKSSS",
			"SSKKKSSSSSSSSKKKSS",
			"SKKKSSSSSSSSSSKKKS",
			"SKKSSSSSSSSSSSSKKS",
			"SKSSSSSSSSSSSSSSKS",
			"SSSSSSSSSSSSSSSSSS",
			".SSSSSSSSSSSSSSSS.",
			"..SSSSSSSSSSSSSS..",
			"...SSSSSSSSSSSS...",
			"....SSSSSSSSSS....",
			".....SSSSSSSS.....",
			"......SSSSSS......",
			".......OOOO.......",
			".......OYYO.......",
			"........OO........",
			"........QQ........",
			".......QRRQ.......",
			"......QRRRRQ......",
			".......QRRQ......."
		];
	}

	// 普通敌机 - 朝下 24x24
	public static function enemyNormal():Array<String> {
		return [
			"......DDDDDD......",
			".....DDDDDDDD.....",
			"....DDDRRRRDDD....",
			"....DDRRRRRRDD....",
			"...DDRRWWWWRRDD...",
			"...DDRRWWWWRRDD...",
			"..DDDDRRRRRRDDDD..",
			".DDDDDDDDDDDDDDDD.",
			"DDDDKKDDDDDDKKDDDD",
			"DDDKKKDDDDDDKKKDDD",
			"DDKKKDDDDDDDDKKKDD",
			"DDKKDDDDDDDDDDKKDD",
			"DDKDDDDDDDDDDDDKDD",
			"DDDDDDDDDDDDDDDDDD",
			".DDDDDDDDDDDDDDDD.",
			"..DDDDDDDDDDDDDD..",
			"...DDDDDDDDDDDD...",
			"....DDDDDDDDDD....",
			".....DDDDDDDD.....",
			"......DDDDDD......",
			".......OOOO.......",
			".......OYYO.......",
			"........OO........"
		];
	}

	// 精英敌机 - 朝下 28x28
	public static function enemyElite():Array<String> {
		return [
			"........UUUUUU........",
			".......UUUUUUUU.......",
			"......UUVVVVVVUU......",
			".....UUVVVVVVVVUU.....",
			"....UUVVWWWWWWVVUU....",
			"....UUVVWWWWWWVVUU....",
			"...UUVVVWWWWWWVVVUU...",
			"..UUUUVVVVVVVVVVUUUU..",
			".UUUUUUVVVVVVVVUUUUUU.",
			"UUUUUUUUVVVVVVUUUUUUUU",
			"UUUKKUUUUVVVVUUUU KKUUU",
			"UUKKKUUUUVVVVUUUU KKKUU",
			"UKKKUUUUUVVVVUUUU UKKKU",
			"UKKUUUUUUUVVVUUUUUUKKU",
			"UKUUUUUUUUUVVUUUUUUUKU",
			"UUUUUUUUUUUVVUUUUUUUUU",
			".UUUUUUUUUUVVUUUUUUUU.",
			"..UUUUUUUUUVVUUUUUUU..",
			"...UUUUUUUUUVUUUUUU...",
			"....UUUUUUUUUUUUUU....",
			".....UUUUUUUUUUUU.....",
			"......UUUUUUUUUU......",
			".......OOOOOOOO.......",
			".......OYYYYYYO.......",
			"........OYYYYO........",
			".........OOOO.........",
			".........QRRQ.........",
			"........QRRRRQ........"
		];
	}

	// Boss战机 - 朝下 64x48
	public static function enemyBoss():Array<String> {
		var rows:Array<String> = [];
		// 简化的Boss，用大块像素
		for (y in 0...48) {
			var row = "";
			for (x in 0...64) {
				if (y < 4) {
					// 顶部
					if (x >= 24 && x < 40) row += "V";
					else if (x >= 20 && x < 44 && y >= 2) row += "U";
					else row += ".";
				} else if (y < 12) {
					// 上部主体
					if (x >= 16 && x < 48) {
						if (x >= 28 && x < 36 && y >= 6) row += "R";
						else if (x >= 30 && x < 34 && y >= 8) row += "Y";
						else row += "U";
					} else if (x >= 12 && x < 52) row += "V";
					else row += ".";
				} else if (y < 24) {
					// 中部宽体
					if (x >= 4 && x < 60) {
						if ((x < 12 || x >= 52) && y >= 16) row += "K";
						else if (x >= 20 && x < 44 && y >= 14 && y < 20) row += "V";
						else if (x >= 24 && x < 40 && y >= 16 && y < 18) row += "R";
						else row += "U";
					} else row += ".";
				} else if (y < 36) {
					// 下部
					if (x >= 8 && x < 56) {
						if (x >= 16 && x < 24 || x >= 40 && x < 48) {
							if (y >= 28) row += "K";
							else row += "D";
						} else row += "U";
					} else row += ".";
				} else {
					// 底部引擎
					if (x >= 20 && x < 44) {
						if (y >= 40) {
							if (x >= 26 && x < 38) row += "Q";
							else row += "O";
						} else row += "D";
					} else if (x >= 24 && x < 40 && y >= 38) row += "Y";
					else row += ".";
				}
			}
			rows.push(row);
		}
		return rows;
	}

	// 玩家子弹 4x8
	public static function bulletPlayer():Array<String> {
		return [
			".YY.",
			"YWWY",
			"YWWY",
			"YCCY",
			"YCCY",
			"YTTY",
			"YTTY",
			".TT."
		];
	}

	// 敌人子弹 4x8
	public static function bulletEnemy():Array<String> {
		return [
			".RR.",
			"RQQR",
			"RQQR",
			"ROOR",
			"ROOR",
			"RYYR",
			"RYYR",
			".YY."
		];
	}

	// 爆炸帧1
	public static function explosion1():Array<String> {
		return [
			"...OOO...",
			"..OYYYO..",
			".OYWWWYO.",
			"OYWWWWWWO",
			"OYWWWWWYO",
			".OYWWWYO.",
			"..OYYYO..",
			"...OOO..."
		];
	}

	// 爆炸帧2
	public static function explosion2():Array<String> {
		return [
			"..O...O..",
			".OYY.YYO.",
			"OYWWWWWYO",
			"OYWWWWWYO",
			"..WWWWW..",
			"OYWWWWWYO",
			".OYY.YYO.",
			"..O...O.."
		];
	}

	// 爆炸帧3
	public static function explosion3():Array<String> {
		return [
			".O.....O.",
			"OQ.....QO",
			"..Q...Q..",
			"...QQQ...",
			"...QQQ...",
			"..Q...Q..",
			"OQ.....QO",
			".O.....O."
		];
	}

	// 烟雾
	public static function smoke():Array<String> {
		return [
			"..DDD..",
			".DSSSD.",
			"DSEESS D",
			"DSEESS D",
			".DSSSD.",
			"..DDD.."
		];
	}

	// 星星背景
	public static function star():Array<String> {
		return [
			".W.",
			"WWW",
			".W."
		];
	}

	// 云朵
	public static function cloud():Array<String> {
		return [
			"..EEEE..",
			".EEEEEE.",
			"EEEEEEEE",
			"EEEEEEEE",
			".EEEEEE."
		];
	}
}
