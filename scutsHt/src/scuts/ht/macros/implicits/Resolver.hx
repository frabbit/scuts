package scuts.ht.macros.implicits;

#if macro

#if display

typedef Resolver = scuts.ht.macros.implicits.DisplayResolver;

#else

typedef Resolver = scuts.ht.macros.implicits.RealResolver;

#end

#end