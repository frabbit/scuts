package scuts.ht.macros.syntax;

#if macro

#if (display)

typedef DoTools = scuts.ht.macros.syntax.DisplayDoTools;

#else

typedef DoTools = scuts.ht.macros.syntax.RealDoTools;

#end

#end