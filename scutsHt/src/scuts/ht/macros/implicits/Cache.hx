
package scuts.ht.macros.implicits;


import haxe.ds.StringMap;

class Cache<T> {

	var enabled = true;

	var cache:StringMap<T>;

	public function new (enabled : Bool = true) {
		//enabled = false;
		this.enabled = enabled;

		if (enabled) {
			cache = new StringMap();
		}
	}

	public function set (key:String, val:T):T {
		if (enabled && key != null) {
			cache.set(key, val);
		}
		return val;
	}

	public function get (key:String):T {
		return if (enabled) {
			cache.get(key);
		} else {
			throw "cannot get value from disabled cache";
		}
	}

	public function exists (key:String) {
		return enabled && cache.exists(key);
	}

}