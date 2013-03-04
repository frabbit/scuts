package scuts1.macros.generators;

#if false

#if macro
import scuts1.macros.generators.GenError;
import haxe.macro.Expr;
import haxe.macro.Type;
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

using scuts.core.Arrays;
using scuts.core.Iterators;
using scuts.core.Options;
using scuts.core.Eithers;
using scuts.mcore.ast.Exprs;
using scuts.core.Hashs;

#end

private typedef ClassData = {
  type : Type,
  anonType : AnonType,
  dependencies : Array<Type>,
  fieldsData: Array<FieldData>
}



private enum FieldData {
  Simple(name:String, type:Type);
  Complex(name:String, data:Array<FieldData>);
}


class GenEqAnon 
{

  public static function build(t:Type, at:AnonType, params:Array<Type>):Either<GenError, Type>
  {
    
    
    
    var data = getClassData(t, at, params);
    
    return Left(GEInvalidType);
    /*
    var classData = buildEqEnumClass(data);
    
    var folder = MContext.getCacheFolder();
    
    var output = File.write(folder + "/" + classData._1 + ".hx", false);
    output.writeString(classData._2);
    output.close();
    
    
    
    return MContext.getType(classData._1)
    .toRightConst(ClassGenerationError);
    */
  }
  
  static function getClassData (t:Type, at:AnonType, params:Array<Type>):ClassData
  {
    
    function loop (fields:Array<ClassField>) {
      return fields.map(function (f) {
        var t = f.type;
        return switch(t) {
          case TAnonymous(a): Complex(f.name, loop(a.get().fields));
            
          default: Simple(f.name, f.type);
      }
    });
    }
    var fieldsData = loop(at.fields);

    return {
      type : t,
      anonType : at,
      dependencies : params,
      fieldsData : fieldsData
    };
  }
  
}

#end