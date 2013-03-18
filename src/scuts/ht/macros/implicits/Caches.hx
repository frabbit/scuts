
package scuts.ht.macros.implicits;

#if macro

import haxe.macro.Expr;

class Caches {

	

	public static var doCache(get, null):Cache<Expr>;

	public static function get_doCache () {
		if (RealCache._doCache == null) {
			//trace("create Do cache");
	    	RealCache._doCache = new Cache();
		}
		return RealCache._doCache;
	}

}

#end