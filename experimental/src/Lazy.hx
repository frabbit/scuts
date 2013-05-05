
package ;


abstract Lazy<T>(Void->T) 
{
	inline function new (x) this = x;

	public var val(get, never):T;

	public function get_val ():T {
		var f : Void->T = this;
		return f();
	}

	@:from public static function fromThunk (t:Void->T)
	{
		var v:Null<T> = null;
		return new Lazy(function ():T 
		{
			if (v == null) v = t();
			return v;
		});
	}

	@:to public function toConst ():T
	{
		return get_val(this);
	}

	@:from public static function fromConst (t:T):Lazy<T>
	{
		return new Lazy(function () return t);
	}
}

class LazyTest {
	public static function withLazy2 (l:Lazy<String>) {
		var s : String = l;
		trace(s);
	}

	public static function withLazy (l:Lazy<Int>) {
		trace(l.val);
	}

	public static function withInt (i:Int) {
		trace(i);
	}

	public static function main () {


		var lazy:Lazy<Int> = function () {trace("hey"); return 1+1+1;};
		trace(lazy.val);
		trace(lazy.val);
		withInt(lazy);
		withLazy(lazy);
		withLazy(17);
		withLazy2("17");
		withLazy2(function () return "17 str");
	}

}