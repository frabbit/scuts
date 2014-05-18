package scuts.mcore.ast;

#if macro

import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
import scuts.core.Arrays;
import scuts.mcore.Parse;
import scuts.Scuts;
using scuts.core.Arrays;

class ComplexTypes 
{
  @:noUsing public static function fromString(s:String):ComplexType {
    var x = "{ var x : " + s + " = null; x;}";
    return switch (Context.parse(x, Context.currentPos()).expr) {
      case EBlock(b):
        switch (b[0].expr) {
          case EVars(v): v[0].type;
          default: Scuts.unexpected();
        }
      default: Scuts.unexpected();
    }
  }
  
  public static function eq (c1:ComplexType, c2:ComplexType):Bool return switch [c1,c2]
  {
    case [TAnonymous(fields1),TAnonymous(fields2)]: Arrays.eq(fields1, fields2, Fields.eq);
    case [TExtend(p1, fields1),TExtend(p2, fields2)]: Arrays.eq(p1,p2, TypePaths.eq) && Arrays.eq(fields1, fields2, Fields.eq);
    case [TFunction(args1, ret1),TFunction(args2, ret2)]: Arrays.eq(args1, args2, ComplexTypes.eq) && ComplexTypes.eq(ret1, ret2);
    case [TOptional(t1),TOptional(t2)]: eq(t1,t2); 
    case [TParent(t1), TParent(t2)]: eq(t1,t2);
    case [TPath(p1),TPath(p2)]: TypePaths.eq(p1,p2);
    case _ : false;
  }
  
  public static function isInstanceOf (subType:ComplexType, superType:ComplexType):Bool 
  {
    var test = '{
      var subType:$0 = null;
      var superType:$1 = subType;
      superType;
    }';
    
    var e = Parse.parse(test, [subType, superType]);

    // get type of expression, should work when subType is a SubType of superType
    // and throws an exception if not
    return try {
      Context.typeof(e);
      true;
    } catch (e:Dynamic) {
      false;
    }
  }
  
  public static function isSubtypeOf (subType:ComplexType, superType:ComplexType):Bool 
  {
    return isInstanceOf(subType, superType) && !isInstanceOf(superType, subType);
  }
  
  public static function isSupertypeOf (superType:ComplexType, subType:ComplexType):Bool
  {
    return isSubtypeOf(subType, superType);
  }
  
  
}

#end