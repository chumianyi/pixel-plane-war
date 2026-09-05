import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.text.AntiAliasType;
import flash.text.GridFitType;

class PixelFont {
	public static function createText(text:String, size:Int=14, color:Int=0xFFFFFF, bold:Bool=false):TextField {
		var tf = new TextField();
		tf.text = text;
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.selectable = false;
		tf.multiline = false;
		tf.wordWrap = false;
		try {
			tf.antiAliasType = AntiAliasType.NORMAL;
			tf.gridFitType = GridFitType.PIXEL;
		} catch (e:Dynamic) {}
		var fmt = new TextFormat();
		fmt.font = "SimSun";
		fmt.size = size;
		fmt.color = color;
		fmt.bold = bold;
		fmt.letterSpacing = 0;
		tf.setTextFormat(fmt);
		return tf;
	}

	public static function createTextArea(text:String, width:Int, size:Int=14, color:Int=0xFFFFFF):TextField {
		var tf = new TextField();
		tf.width = width;
		tf.height = 100;
		tf.text = text;
		tf.selectable = false;
		tf.multiline = true;
		tf.wordWrap = true;
		try {
			tf.antiAliasType = AntiAliasType.NORMAL;
			tf.gridFitType = GridFitType.PIXEL;
		} catch (e:Dynamic) {}
		var fmt = new TextFormat();
		fmt.font = "SimSun";
		fmt.size = size;
		fmt.color = color;
		fmt.leading = 4;
		tf.setTextFormat(fmt);
		return tf;
	}

	public static function setText(tf:TextField, text:String):Void {
		tf.text = text;
		var fmt = tf.getTextFormat();
		tf.setTextFormat(fmt);
	}
}
