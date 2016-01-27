package starlingone.utils {
	
	public class Rgb {
		public var red:int;
		public var green:int;
		public var blue:int;
		private static const redB:int=0x10000;
		private static const greenB:int=0x100;
		private static const blueB:int=0x1;
		public function Rgb(r:int, g:int, b:int) {
			// constructor code
			red = r;
			green = g;
			blue = b;
		}
		public function percentage(per:Number):int{
			red *= per;
			green *= per;
			blue *= per;
			return toHex();
		}
		public function toHex():int{
			return rgbToHex(red, green, blue);
		}
		public static function hexPercentage(hex:int, per:Number):int{
			return hexToRgb(hex).percentage(per)
		}
		public static function rgbToHex(red:int, green:int, blue:int):int{
			return red*redB + green*greenB + blue*blueB;
		}
		public static function hexToRgb(hex:int):Rgb{
			var red:int = hex/redB;
			var redPure:int = red*redB;
			var green:int = (hex-redPure)/greenB;
			var greenPure:int = green*greenB;
			var blue:int = hex-redPure-greenPure;
			if(red<0){
				red = 0;
			}
			if(green<0){
				green = 0;
			}
			if(blue<0){
				blue = 0;
			}
			return new Rgb(red, green, blue);
		}
	}
	
}
