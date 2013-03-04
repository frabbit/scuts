package scuts1.core;

using scuts.core.Validations;

import scuts1.core.Hots;
import scuts1.instances.std.LazyOf;
import scuts.core.Cont;
import scuts.core.Lazy;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.States;


/*
 * Represents a type constructor that needs one type to construct a real type.
 * 
 * f.e. Array<T> can be represented as Of<Array<In>, T>
 * 
 */



abstract OfI<M,A>(Dynamic) {
	public function new (x:Dynamic) this = x;
}

abstract Of<M,A>(OfI<M,A>) {


	public inline function new (o:Dynamic) this = o;


	@:arrayAccess public static inline function arrayGet <A>(x:OfI<Array<In>, A>, index:Int):A return Hots.safeCast(cast x, var _ : Array<A>)[index];

	// convinience methods for casting of often used types
	@:from public inline static function fromArray <A>(x:Array<A>):Of<Array<In>, A> return new Of(x);
	@:to public inline static function toArray <A>(x:OfI<Array<In>, A>):Array<A> return Hots.safeCast(cast x, var _ : Array<A>);

	@:from public static inline function fromOption (x:Option<A>):Of<Option<In>, A> return new Of(x);
	@:to public static function toOption <A>(x:OfI<Option<In>, A>):Option<A> return Hots.safeCast(cast x, var _ : Option<A>);

	@:from public static function fromPromise (x:Promise<A>):Of<Promise<In>, A> return new Of(x);
	@:to public static function toPromise <A>(x:OfI<Promise<In>, A>):Promise<A> return Hots.safeCast(cast x, var _ : Promise<A>);

	@:from public static inline function fromList (x:List<A>):Of<List<In>, A> return new Of(x);
	@:to public static function toList <A>(x:OfI<List<In>, A>):List<A> return Hots.safeCast(cast x, var _ : List<A>);

	@:from public static inline function fromCont <A,R>(x:Cont<A,R>):Of<Cont<In,R>, A> return new Of(x);
	@:to public static function toCont <A,R>(x:OfI<Cont<In,R>, A>):Cont<A,R> return Hots.safeCast(cast x, var _ : Cont<A,R>);

	@:from public static inline function fromState <A,R>(x:State<A,R>):Of<State<In,R>, A> return new Of(x);
	@:to public static function toState <A,R>(x:OfI<State<In,R>, A>):State<A,R> return Hots.safeCast(cast x, var _ : State<A,R>);
	
	@:from public static inline function fromMapElem <K>(x:Map<K, A>):Of<Map<K, In>, A> return new Of(x);
	@:to public static function toMapElem <K,A>(x:OfI<Map<K, In>, A>):Map<K, A> return Hots.safeCast(cast x, var _ : Map<K,A>);
	
	@:from public static inline function fromValidation <F>(x:Validation<F,A>):Of<Validation<F, In>, A> return new Of(x);
	@:to public static function toValidation <F,A>(x:OfI<Validation<F, In>, A>):Validation<F, A> return Hots.safeCast(cast x, var _ : Validation<F,A>);

	@:from public static function fromLazy (x:Lazy<A>):Of<Void->In, A> return new Of(x);
	@:to public static function toLazy <A>(x:OfI<Void->In, A>):Lazy<A> return Hots.safeCast(cast x, var _ : Lazy<A>);

}
