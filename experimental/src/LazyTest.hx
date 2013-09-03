
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
		return val;
	}

	@:from public static function fromConst (t:T):Lazy<T>
	{
		return new Lazy(function () return t);
	}
}

class Lazys {
	public static function map <A,B>(l:Lazy<A>, f:A->B):Lazy<B> 
	{
		return function () return f(l.val);
	}

	public static function flatMap <A,B>(l:Lazy<A>, f:A->Lazy<B>):Lazy<B> 
	{
		return function () return f(l.val).val;
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

		var l2 = Lazys.map(lazy, function (x) return x+1);
		var l3 = Lazys.flatMap(lazy, function (x) return function () {trace("hey2"); return 1+1+1;});
		trace("before");
		l2.val;
		

		// trace(lazy.val);
		// trace(lazy.val);
		// withInt(lazy);
		// withLazy(lazy);
		// withLazy(17);
		// withLazy2("17");
		// withLazy2(function () return "17 str");


	}

}