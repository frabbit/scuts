package scuts.core;

import scuts.ht.core.In;
import scuts.ht.core.Of;

import scuts.core.Tuples;
import scuts.core.Tuples.*;

abstract Writer<W, R>(W->Tup2<W,R>) 
{
	@:allow(scuts.core.Writers)
	function new (f:W->Tup2<W,R>) this = f;

	public function run ():W->Tup2<W,R> {
		return this;
	}

	@:from static function fromOf <T>(x:Of<Writer<W,In>, R>):Writer<W,R> return cast x;

	@:to function toOf ():Of<Writer<W,In>, R> return new Of(this);
}

class Writers 
{
	public static function writer <W,R>(f:W->Tup2<W,R>):Writer<W,R> 
	{
		return new Writer(f);
	}

	public static function pure <W,R>(r:R):Writer<W,R> 
	{
		return writer(function (w) return tup2(w,r));
	}

	public static function map <W, A,B>(w:Writer<W, A>, f:A->B):Writer<W,B> 
	{
		return writer(function (ctx) {
			var r = w.run()(ctx);
			return tup2(r._1, f(r._2));
		});
	}

/*
	public static function flatten <W, A>(r:Writer<W, Writer<W, A>>):Writer<W,A> 
	{
		return reader(function (ctx) {
			return r.run()(ctx).run()(ctx);
		});
	} 

	public static function flatMap <W, A,B>(r:Writer<W, A>, f:A->Writer<W,B>):Writer<W,B> 
	{
		return flatten(map(r,f));
	}

*/
}