
package scuts.ht.macros.implicits;

#if macro

import haxe.macro.Expr;

class Caches {

	public static var _doCache : Cache<haxe.macro.Expr>;

	public static var doCache(get, null):Cache<Expr>;

	public static function get_doCache () {
		if (_doCache == null) {
			//trace("create Do cache");
	    	_doCache = new Cache();
		}
		return _doCache;
	}

}

#end