package scuts.ht.syntax;

import scuts.ht.core.Ht;
import scuts.ht.instances.std.ArrayTOf;
import scuts.ht.instances.std.LazyTOf;
import scuts.ht.instances.std.OptionTOf;
import scuts.ht.instances.std.PromiseTOf;
import scuts.ht.instances.std.ValidationTOf;
import scuts.core.Lazy;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Validations;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.ht.core.OfOf;


class ValidationTransformer 
{
	public inline static function runT<M,F,S>(x:ValidationTOf<M,F,S>):Of<M, Validation<F,S>> return x.runT();
	
	// hack for js, forcing inline
	//#if #end 
	public static inline function validationT <M,F,S>(x:Of<M, Validation<F,S>>):ValidationTOf<M,F,S> {
		//return ValidationTOf.intoT(x);
		return ValidationTOf.intoT(x);
	}

	
}

class PromiseTransformer 
{
	public inline static function  runT<M,A>(x:PromiseTOf<M, A>):Of<M, PromiseD<A>> return x.runT();

	
	public inline static function promiseT <M,A>(x:Of<M, PromiseD<A>>):PromiseTOf<M, A> 
	{
		return PromiseTOf.intoT(x);
	}
}


class ArrayTransformer 
{
	public inline static function  runT<M,A>(x:ArrayTOf<M, A>):Of<M, Array<A>> return x.runT();
	
	
	public inline static function arrayT <M,A>(x:Of<M, Array<A>>):ArrayTOf<M, A> 
	{
		return ArrayTOf.intoT(x);
		
	}
}

class OptionTransformer 
{
	
	public inline static function optionT <M,A>(x:Of<M, Option<A>>):OptionTOf<M, A> 
	{
		return OptionTOf.intoT(x);
	}
	public inline static function  runT<M,A>(x:OptionTOf<M, A>):Of<M, Option<A>> return Ht.preservedCast(x.runT());
}

class LazyTransformer 
{
	
	public inline static function lazyT <M,A>(x:Of<M, Void->A>):LazyTOf<M, A> 
	{
		return LazyTOf.intoT(x);
	}
	public inline static function runT<M,T>(x:LazyTOf<M, T>):Of<M, Void->T> return x.runT();
}