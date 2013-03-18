package scuts.ht.macros.generators;

#if false

#if macro

import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.ht.macros.generators.GenEqAnon;
import scuts.ht.macros.generators.GenEqEnum;
import neko.FileSystem;
import neko.io.File;
import scuts.core.Tup2;
import scuts.mcore.Context;
import scuts.mcore.ast.Exprs;
import scuts.mcore.ast.Types;
import scuts.mcore.Make;
import scuts.mcore.MContext;
import scuts.mcore.MType;
import scuts.mcore.Print;
import scuts.Scuts;

import scuts.core.Option;
import scuts.core.Either;
import scuts.ht.macros.generators.GenError;

using scuts.core.Arrays;
using scuts.core.Iterators;
using scuts.core.Options;
using scuts.core.Eithers;
using scuts.mcore.ast.Exprs;
using scuts.core.Hashs;

using scuts.core.Log;






class GenEq
{

  public static function forType (type:Expr):Type 
  {
    function handleTType (t:DefType, params) 
    {
      function buildEq(x:Type) 
      {
        return switch (x) 
        {
          case TEnum(et, params):  GenEqEnum.build(x, et.get(), params);
          case TAnonymous(fields): GenEqAnon.build(x, fields.get(), params);
          default:                 
            trace(x);
            Left(GEInvalidType);
        }
      }
      return 
        if (t.name.indexOf("#") == 0) 
          Context.getType2(t.pack, t.module, t.name.substr(1))
          .toRightConst(GEInvalidType)
          .flatMapRight(buildEq)
        else
          Left(GEInvalidType);
    }
    
    function handleType (t) 
    {
      return switch (t) 
      {
        case TType(t, params): handleTType(t.get(), params);
        default:               Left(GEInvalidType);
      }
    }
    
    return 
      MContext.typeof(type)
      .toRight(function () return GEInvalidType)
      .flatMapRight(handleType)
      .getOrElse(handleError);
  }
  
  static function handleError (err:GenError) 
  {
    var msg = switch (err) {
      case GEInvalidType: "No Valid Type";
      case ClassGenerationError: "Cannot retrieve generated class";
    }
    return Scuts.macroError(msg);
  }

}

#end

#end