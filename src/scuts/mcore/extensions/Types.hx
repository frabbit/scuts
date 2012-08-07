package scuts.mcore.extensions;
import haxe.macro.Type;
import haxe.macro.Expr;
import scuts.core.extensions.Arrays;
import scuts.core.types.Tup2;
import scuts.core.types.Option;
import scuts.mcore.MType;
import scuts.mcore.types.InstType;
import scuts.Scuts;

using scuts.core.extensions.Arrays;
using scuts.mcore.extensions.ClassTypes;
using scuts.mcore.extensions.EnumTypes;
using scuts.mcore.extensions.DefTypes;
using scuts.mcore.extensions.AnonTypes;

using scuts.core.extensions.Dynamics;
using scuts.mcore.extensions.Types;

using scuts.core.extensions.Strings;
using scuts.core.extensions.Bools;

using scuts.core.extensions.Functions;

private typedef TFunArg = {t:Type, name:String, opt:Bool};

class Types 
{

  public static inline function isTInst (t:Type):Bool return switch t
  {
    case TInst(_,_): true;
    default:         false;
  }
  
  public static inline function getInstType (t:Type):Option<InstType> return switch t
  {
    case TInst(c,_): Some(MType.getInstType(c.get()));
    default:         None;
  }

  
  public static function toComplexType (t:Type, wildcards:Array<Type>):ComplexType 
  {
    return if (isTInst(t) && wildcards.any(Types.eq.partial2(t))) switch t
    {
      // wildcards must be TInst
      case TInst(t, _): TPath({ pack: [], name: t.get().name, params: [] });
      default:          Scuts.unexpected();
    }
    else switch t 
    {
      case TEnum(t, params): BaseTypes.toComplexType(t.get(), params, wildcards);
      case TInst(t, params): BaseTypes.toComplexType(t.get(), params, wildcards);
      case TType(t, params): BaseTypes.toComplexType(t.get(), params, wildcards);
      case TLazy(t):         toComplexType(t(), wildcards);
      case TFun(args, ret):  function argToComplex (a) return toComplexType(a.t, wildcards);
                             ComplexType.TFunction(args.map(argToComplex), toComplexType(ret, wildcards));
      case TAnonymous(a):    Scuts.notImplemented();
      case TMono(t):         Scuts.notImplemented();
      case TDynamic(t):      Scuts.notImplemented();
    }
  }
  
  public static function asFunction(t:Type) return switch t 
  {
    case TFun(args, ret): Some(Tup2.create(args, ret));
    default:              None;
  }
  
  public static function eq(type1:Type, type2:Type):Bool 
  {
    var eqParams = Arrays.eq.partial3(Types.eq);
    
    function funEq (args1, args2, ret1:Type, ret2:Type) 
    {
      function funArgEq(a1:TFunArg, a2:TFunArg) 
      {
        return a1.name.eq(a2.name) 
            && a1.opt.eq(a2.opt) 
            && a1.t.eq(a2.t);
      }
      return Arrays.eq(args1, args2, funArgEq) && ret1.eq(ret2);
    }
    
    
    return switch type1 
    {
      case TAnonymous(a1): switch type2
      { 
        case TAnonymous(a2): a1.get().eq(a2.get()); 
        default :            false; 
      }
      case TInst(t1, params1): switch (type2) 
      { 
        case TInst(t2, params2): t1.get().eq(t2.get()) && eqParams(params1, params2); 
        default :                false; 
      }
      case TEnum(t1, params1): switch type2 
      { 
        case TEnum(t2, params2): t1.get().eq(t2.get()) && eqParams(params1, params2); 
        default :                false; 
      }
      case TType(t1, params1): switch type2 
      { 
        case TType(t2, params2): t1.get().eq(t2.get()) && eqParams(params1, params2); 
        default :                false; 
      }
      case TDynamic(t1): switch type2 
      { 
        case TDynamic(t2): t1.nullEq(t2, eq);
        default :          false; 
      }
      case TFun(args1, ret1): switch type2
      {
        case TFun(args2, ret2): funEq(args1, args2, ret1, ret2);
        default:                false;
      }
      case TMono(t1): switch type2 
      { 
        case TMono(t2): t1.get().nullEq(t2.get(), eq);
        default :       false; 
      }
      case TLazy(f1): switch type2 
      { 
        case TLazy(f2): f1().eq(f2());
        default :       false; 
      }
    }
  }
  
  public static function asClassType (t:Type):Option<Tup2<Ref<ClassType>, Array<Type>>> return switch t 
  {
    case TInst(t, params): Some(Tup2.create(t, params));
    default:               None;
  }
  
}