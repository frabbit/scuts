package hots.macros;

#if (macro || display)
import haxe.macro.Expr;
import haxe.macro.Type;
import hots.macros.generators.GenEqAnon;
import hots.macros.generators.GenEqEnum;
import neko.FileSystem;
import neko.io.File;
import scuts.core.types.Tup2;
import scuts.mcore.Context;
import scuts.mcore.extensions.ExprExt;
import scuts.mcore.extensions.TypeExt;
import scuts.mcore.Make;
import scuts.mcore.MContext;
import scuts.mcore.MType;
import scuts.mcore.Print;
import scuts.Scuts;

import scuts.core.types.Option;
import scuts.core.types.Either;
import hots.macros.generators.GenError;

using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.IteratorExt;
using scuts.core.extensions.OptionExt;
using scuts.core.extensions.EitherExt;
using scuts.mcore.extensions.ExprExt;
using scuts.core.extensions.HashExt;

using scuts.core.Log;



#end
class GenEq 
{

  @:macro public static function forType (type:Expr):Type 
  {
    return forType1(type);
  }
  
  #if (macro || display)
  public static function forType1 (type:Expr):Type 
  {
    function handleTType (t:DefType, params) 
    {
      return 
        if (t.name.indexOf("#") == 0) 
          Context.getType2(t.pack, t.module, t.name.substr(1))
          .toRightConst(GEInvalidType)
          .flatMapRight(function (x) {
            
            return switch (x) 
            {
              case TEnum(et, params):  GenEqEnum.build(x, et.get(), params);
              case TAnonymous(fields): GenEqAnon.build(x, fields.get(), params);
              default:                 
                trace(x);
                Left(GEInvalidType);
            }
          })
        else
          Left(GEInvalidType);
    }
    trace(type);
    return 
      MContext.typeof(type).traced()
      .toRight(function () return GEInvalidType)
      .flatMapRight(function (t) {
        trace(t);
        return switch (t) 
        {
          case TType(t, params): trace(t);  handleTType(t.get(), params);
          default:               trace(t); Left(GEInvalidType);
        }
      })
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
  
  
  
  
  
  
  
  
  #end
  
}