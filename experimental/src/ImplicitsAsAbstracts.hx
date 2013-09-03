
package ;


using ImplicitsAsAbstracts.ArrayToOfConversions;


class In {} // represents a wildcard:  Array<In> <=> Array<_>

// represents a type constructor: Of<M,A> <=> M<A> 
// represents a type constructor: Of<Array<In>,A> <=> Array<A> 

abstract Of<M,A> (Dynamic) {

	public inline function new (m:Dynamic) this = m;

	public inline function val ():Dynamic return this;

	/*@:from*/ public macro static function from (expr:haxe.macro.Expr, ?required:haxe.macro.Expr.ComplexType):Null<haxe.macro.Expr> 
	{
		// toOf must br provided through using
		// could also check if toOf is really available
		return macro $expr.toOf();

	}

	/*@:to*/ public macro static function to (expr:haxe.macro.Expr):Null<haxe.macro.Expr> 
	{
		// fromOf must br provided through using
		// could also check if fromOf is really available
		return macro $expr.fromOf();
	}
}

class ArrayToOfConversions 
{
	public static function toOf <T>(a:Array<T>):Of<Array<In>, T> 
	{
		return new Of(a);
	}
	
	public static function fromOf <T>(a:Of<Array<In>, T>):Array<T> 
	{
		return a.val();
	}
}



interface Functor<F> {
	public function map <A,B>(a:Of<F,A>, f:A->B):Of<F,B>;
}

class ArrayFunctor implements Functor<Array<In>> {

	public function new () {}

	public static var instance:Functor<Array<In>> = new ArrayFunctor();

	public function map <A,B>(a:Of<Array<In>,A>, f:A->B):Of<Array<In>,B>
	{
		// calls fromOf and toOf internally (using ArrayToOfConversions)

		// return (a:Array<A>).map(f);

		return Of.from(Of.to(a).map(f));
	}
}

abstract Implicit<T> (T) {

	private inline function new (m:T) this = m;

	/*@:from */ public macro static function from(e:haxe.macro.Expr, ?requiredType:haxe.macro.Expr.ComplexType):haxe.macro.Expr 
	{
		// resolve implicits searches the current call context for type classes (locals, statics, members with correct type )
		// this function is already implemented by scuts
		
		function resolveImplicit (type:haxe.macro.Expr.ComplexType) 
		{	
			// simplified resolution
			return macro ArrayFunctor.instance;
		}

		// real call
		var implicitExpr = resolveImplicit(requiredType);

		return macro new Implicit($implicitExpr);
	}


	@:to public function to ():T return this;



}







class ImplicitsAsAbstracts {

	public static function map<M,A,B>(x:Of<M,A>, f:A->B, functor:Implicit<Functor<M>>):Of<M,B> {
		return (functor:Functor<M>).map(x,f);
	}  

	
	static public function main()
	{
		// usage of type classes

		//flatMap([1,2,3], function (x) return x+1, _); // expr _ is passed to the macro 'Implicit.from' with the required type Implicit<Functor<M>> and is 
	
		// translated call

		var r = map(Of.from([1,2,3]), function (x) return x+1, Implicit.from(_ /*, Implicit<Functor<Array<In>>> */ ));
		trace(r);
	}


}