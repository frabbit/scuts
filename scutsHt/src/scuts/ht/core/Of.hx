package scuts.ht.core;


#if !macro
using scuts.core.Validations;

import scuts.core.Eithers.Either;
import scuts.core.Ios;
import scuts.ht.core.Hots;
import scuts.ht.instances.std.LazyOf;
import scuts.core.Conts;
import scuts.core.Lazy;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.States;
#end


/*
 * Represents a type constructor that needs one type to construct a real type.
 * 
 * f.e. Array<T> can be represented as Of<Array<In>, T>
 * 
 */



abstract OfI<M,A>(Dynamic) {
	public function new (x:Dynamic) this = x;
}

abstract Of<M,A>(OfI<M,A>) 
{
	public inline function new (o:Dynamic) this = o;

	#if !macro
	@:arrayAccess public static inline function arrayGet <A>(x:OfI<Array<In>, A>, index:Int):A return Hots.checkType(var _ : Array<A> = cast x)[index];

	// convinience methods for casting of often used types
	@:from public static inline function fromArray <A>(x:Array<A>):Of<Array<In>, A> return new Of(x);
	@:to public inline static function toArray <A>(x:OfI<Array<In>, A>):Array<A> return Hots.preservedCast(cast x);

	@:from public static inline function fromOption (x:Option<A>):Of<Option<In>, A> return new Of(x);
	@:to public static function toOption <A>(x:OfI<Option<In>, A>):Option<A> return Hots.preservedCast(cast x);

	@:from public static inline function fromIo (x:Io<A>):Of<Io<In>, A> return new Of(x);
	@:to public static function toIo <A>(x:OfI<Io<In>, A>):Io<A> return Hots.preservedCast(cast x);

	@:from public static inline function fromPromise (x:PromiseD<A>):Of<PromiseD<In>, A> return new Of(x);
	@:to public static function toPromise <A>(x:OfI<PromiseD<In>, A>):PromiseD<A> return Hots.preservedCast(cast x);

	@:from public static inline function fromList (x:List<A>):Of<List<In>, A> return new Of(x);
	@:to public static function toList <A>(x:OfI<List<In>, A>):List<A> return Hots.preservedCast(cast x);

	@:from public static inline function fromCont <A,R>(x:Cont<A,R>):Of<Cont<In,R>, A> return new Of(x);
	@:to public static function toCont <A,R>(x:OfI<Cont<In,R>, A>):Cont<A,R> return Hots.preservedCast(cast x);

	@:from public static inline function fromState <A,R>(x:State<A,R>):Of<State<In,R>, A> return new Of(x);
	@:to public static function toState <A,R>(x:OfI<State<In,R>, A>):State<A,R> return Hots.preservedCast(cast x);

	@:from public static inline function fromMapElem <K>(x:Map<K, A>):Of<Map<K, In>, A> return new Of(x);
	@:to public static function toMapElem <K,A>(x:OfI<Map<K, In>, A>):Map<K, A> return Hots.preservedCast(cast x);
	
	@:from public static inline function fromValidation <F,A>(x:Validation<F,A>):Of<Validation<F, In>, A> return Hots.preservedCheckType(var _ :  Of<Validation<F, In>, A> = new Of(x));
	@:to public static function toValidation <F,A>(x:OfI<Validation<F, In>, A>):Validation<F, A> return Hots.preservedCast(cast x);

	@:from public static inline function fromLazy (x:Lazy<A>):Of<Void->In, A> return new Of(x);
	@:to public static function toLazy <A>(x:OfI<Void->In, A>):Lazy<A> return Hots.preservedCast(cast x);

	@:from public static inline function fromEither <L,R>(x:Either<L,R>):Of<Either<L, In>, R> return Hots.preservedCheckType(var _ :  Of<Either<L, In>, R> = new Of(x));
	@:to public static function toEither <L,R>(x:OfI<Either<L, In>, R>):Either<L, R> return Hots.preservedCast(cast x);

	#end
}

