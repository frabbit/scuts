
package ;

class MyMacro {

	static var _cache = null;

	macro public static function getCached ():haxe.macro.Expr {
		if (_cache == null) {
			trace("create cache");
			_cache = macro null;
		}
		return _cache;
	}

}