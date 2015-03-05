package scuts.core;

import scuts.ht.core._;
import scuts.ht.core.Of;

abstract Reader<Ctx, R>(Ctx->R)
{
	@:allow(scuts.core.Readers)
	function new (f:Ctx->R) this = f;

	public function run ():Ctx->R {
		return this;
	}

	@:from static function fromOf <T>(x:Of<Reader<Ctx,_>, R>):Reader<Ctx,R> return cast x;

	@:to function toOf ():Of<Reader<Ctx,_>, R> return new Of(this);
}

class Readers
{
	public static function reader <Ctx,R>(f:Ctx->R):Reader<Ctx,R>
	{
		return new Reader(f);
	}

	public static function pure <Ctx,R>(r:R):Reader<Ctx,R>
	{
		return reader(function (ctx) return r);
	}

	public static function map <Ctx, A,B>(r:Reader<Ctx, A>, f:A->B):Reader<Ctx,B>
	{
		return reader(function (ctx) {
			return f(r.run()(ctx));
		});
	}

	public static function flatten <Ctx, A>(r:Reader<Ctx, Reader<Ctx, A>>):Reader<Ctx,A>
	{
		return reader(function (ctx) {
			return r.run()(ctx).run()(ctx);
		});
	}

	public static function flatMap <Ctx, A,B>(r:Reader<Ctx, A>, f:A->Reader<Ctx,B>):Reader<Ctx,B>
	{
		return flatten(map(r,f));
	}


}