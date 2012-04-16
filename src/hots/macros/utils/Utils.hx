package hots.macros.utils;
#if (macro || display)
import haxe.macro.Context;
import haxe.macro.Type;
import scuts.core.extensions.Arrays;
import scuts.core.extensions.Dynamics;
import scuts.core.extensions.Ints;
import scuts.core.extensions.Strings;
import scuts.core.macros.Lazy;
import scuts.core.types.Option;
import scuts.core.types.Tup2;
import scuts.mcore.MContext;
import scuts.mcore.extensions.ClassTypeExt;
import scuts.mcore.extensions.EnumTypeExt;
import scuts.mcore.extensions.TypeExt;
import scuts.mcore.Parse;
import scuts.mcore.Print;
import scuts.Scuts;
import scuts.core.types.Either;
using scuts.core.extensions.Eithers;
using scuts.core.extensions.Options;
using scuts.mcore.extensions.TypeExt;
using scuts.core.extensions.Arrays;
using scuts.mcore.extensions.ExprExt;
using scuts.mcore.extensions.Strings;
using scuts.core.extensions.Dynamics;
using scuts.mcore.extensions.ComplexTypeExt;
using scuts.mcore.extensions.FieldTypeExt;

using scuts.core.Log;
private typedef D = Dynamics;

//
//
//
/*
 * 
 * Boxing:
 * 1x: 
 * Option<Int> => Of<Option<In>, Int> => M is Option<In>
 * 
 * 2x: 
 * Option<Option<Int>> 
 * => Of<Option<In>, Option<Int>> // Boxing of OptionBox
 * => Of<Of<Option<In>, Option<In>>, Int>
 * => Of<Of<Option<In>, Option<In>>, Int> // Boxing of OptionTBox
 * => M is Option<In>
 * 
 * 3x:
 * Option<Option<Option<Int>>> 
 * => Of<Option<In>, Option<Option<Int>>>                   // Boxing of OptionBox
 * => Of<Of<Option<In>, Option<In>>, Option<Int>>           // Boxing of OptionTBox
 * => Of<Of<Option<In>, Of<Option<In>, Option<In>>>, Int>   // Boxing of OptionTBox
 * => M is Option<In>
 * 
 * How to find a Monad based on the type of M:
 * Array<Int> => Array<In> => Monad
 * Of<Option<In>, Option<In>> => Of<M, Option<In>> => Monad
 * 
 * 
 * 
 * 
 * lookup:
   * Monad<Array<In>> => ArrayMonad
   * Monad<Option<In>> => OptionMonad
   * Monad<Of<M, Option<In>> => OptionTMonad
   * 
   */

import haxe.macro.Expr;

typedef Path = Array<PathNode>;

enum PathNode 
{
  SuperClass;
  InterfaceAt(index:Int);
}

class PathNodeExt 
{
  public static function eq (a:PathNode, b:PathNode) 
  {
    return switch (a) 
    {
      case SuperClass:      switch (b) { case SuperClass:true; default:false;};
      case InterfaceAt(i1): switch (b) { case InterfaceAt(i2): Ints.eq(i1, i2); default:false;};
    }
  }
}


typedef Mapping = Array<Tup2<Type, Type>>;


class Utils 
{
  public static function normalizeOfTypes (type:Type):Type {
    
    return switch (MContext.followAliases(type)) {
      case TInst(ctRef, params):
        var ct = ctRef.get();
        
        getOfParts(type).map(function (t) {
          return if (TypeExt.eq(hotsInType(), t._2)) 
          {
            
            getContainerElemType(t._1)
            .map(function (x) return if (TypeExt.eq(x, hotsInType())) t._1 else type)
            .getOrElseConst(type);
          } else
            makeOfType(normalizeOfTypes(t._1), normalizeOfTypes(t._2));
        }).getOrElseConst(type);
      case TEnum(eRef, params):
        TEnum(eRef, params.map(normalizeOfTypes));
      case TFun(args, ret):
        TFun(args.map(function (a) return { name:a.name, opt:a.opt, t:normalizeOfTypes(a.t)}), normalizeOfTypes(ret));
      default: Scuts.notImplemented();
    }
  }
  
  public static function getConstructorArgumentTypes (fields:Array<Field>):Option<Array<ComplexType>> 
  {
    return 
      getFieldAsFunction(fields, "new")
      .map(function (x) return x.args.map(function (x) return x.type));
  }
  
  public static function getFieldAsFunction (fields:Array<Field>, field:String):Option<Function> 
  {
    return fields.some(function (x) return x.name == field)
      .flatMap(function (x) return x.kind.asFunction());
  }
  
  public static function reverseMapping (m:Array<Tup2<Type, Type>>) {
    return m.map(function (x) return Tup2.create(x._2, x._1));
  }
  
  public static function containsType (type:Type, search:Type):Bool
  {
    return TypeExt.eq(type, search) || switch (type) {
      case TInst(t, params):
        params.any( function (x) return containsType(x, search ));
      case TEnum(t, params):
        params.any( function (x) return containsType(x, search ));
      case TFun(args, ret):
        args.any( function (x) return containsType(x.t, search )) 
        || containsType(ret, search);
      case TAnonymous(a):
        a.get().fields.any(function (x) return containsType(x.type, search));
      case TType(t, params):
        params.any( function (x) return containsType(x, search ));
      case TDynamic(t):
        containsType(t, search);
      case TLazy(t):
        containsType(t(), search);
      case TMono(t):
        containsType(t.get(), search);
      default:
        false;
    }
  }
  
  public static function getContainingTypes (type:Type, search:Array<Type>):Array<Type>
  {
    
    
    function loop (type:Type, search:Array<Type>, found:Array<Type>):Tup2<Array<Type>, Array<Type>>
    {
      var foldParams = function (acc:Tup2<Array<Type>, Array<Type>>, cur) return loop(cur, acc._1, acc._2);
      var foldArgs = function (acc:Tup2<Array<Type>, Array<Type>>, arg) return loop(arg.t, acc._1, acc._2);
      var foldFields = function (acc:Tup2<Array<Type>, Array<Type>>, f) return loop(f.type, acc._1, acc._2);
      
      function findInParams (params:Array<Type>) return params.foldLeft(foldParams, Tup2.create(search, found));
      
      function findInner () {
        return switch (type) {
          case TInst(t, params):
            findInParams(params);
          case TEnum(t, params):
            findInParams(params);
          case TFun(args, ret):
            var cur = args.foldLeft(foldArgs, Tup2.create(search, found));
            loop(ret, cur._1, cur._2);
          case TAnonymous(a):
            a.get().fields.foldLeft(foldFields, Tup2.create(search, found));
          case TType(t, params):
            findInParams(params);
          case TDynamic(t):
            loop(t, search, found);
          case TLazy(t):
            loop(t(), search, found);
          case TMono(t):
            loop(t.get(), search, found);
        }
      }
      
      return 
        search
        .someWithIndex( function (x) return TypeExt.eq(x, type))
        .map( function ( x ) return Tup2.create(search.removeElemAt(x._2), found.concat([x._1])))
        .getOrElse(findInner);
    }
    return loop(type, search, [])._2;
  }
  
  public static function getParamsAsTypes (classType:ClassType):Array<Type> 
  {
    var m = classType.module;
    var s = (m != "" ? (m + ".") : "") + classType.name;
    var res = MContext.getType(s);
    return 
      res.flatMap(function (x) return switch (x) {
        case TInst(_, p), TType(_, p), TEnum(_, p): Some(p);
        default: None;
      })
      .getOrElse(D.lazy([]));
  }
  
  
  
  
  public static function remap (type:Type, mapping:Array<Tup2<Type, Type>>):Type 
  {
    var canMap = mapping.some(function (x) return TypeExt.eq(x._1, type));
    var remapParam = function (x) return remap(x, mapping);
    var remapArg = function (a) return { name: a.name, opt:a.opt, t : remap(a.t, mapping)};
    
    return switch (canMap) {
      case Some(v): v._2;
      case None:
        switch (type) {
          case TInst(t, params):
            TInst(t, params.map( remapParam));
          case TEnum(t, params):
            TEnum(t, params.map( remapParam ));
          case TFun(args, ret):
            TFun(args.map( remapArg ), remap(ret, mapping));
          case TAnonymous(a):
            Scuts.notImplemented();
          case TType(t, params):
            TType(t, params.map( remapParam ));
          case TDynamic(t):
            (t == null) ? type : TDynamic(remap(t, mapping));
          case TLazy(t):
            TLazy(D.lazy(remap(t(), mapping)));
          case TMono(t):
            type; // do nothing
        }
    }
  }
  
  /**
   * Returns an Array of type parameter mappings from subType to superType,
   * if subType is really a subType of superType. If there is no inheritance None is returned.
   * 
   * Example 1:
   *  class B<T1, T2>
   *  class A<X, Y> extends B<Y, X>
   *  ->  Mapping A->B : [(A.Y, B.T1), (A.X, B.T2)]
   * Example 2:
   *  interface C<A,B>
   *  class B<T1, T2> implements C<T2,T1>
   *  class A<X, Y> extends B<Y, X>: 
   *  ->  Mapping A->C: [(A.X, C.A), (A.Y, C.B)]
   *  ->  Mapping A->B: [(A.Y, B.T1), (A.X, B.T2)]
   *  ->  Mapping B->C: [(B.T2, C.A), (B.T1, C.B)]
   * 
   * 
   * @param	subType
   * @param	superType
   * @return Some, if a type parameter mapping from subType to superType exist or None
   */
  public static function getTypeParamMappings (subType:ClassType, superType:ClassType):Option<Mapping>
  {
    function loop (sub:ClassType, sup:ClassType, path:Path, index):Mapping 
    {
      return if (path.length == 0)  // special case subType and superType are the same
      {
        var params = getParamsAsTypes(subType);
        params.map(function (x) return Tup2.create(x, x));
      }
      else if (index == path.length-1) // last
      {
        var superParams = getParamsAsTypes(sup);
        var subParams = switch (path[index]) {
          case SuperClass: sub.superClass.params;
          case InterfaceAt(index): sub.interfaces[index].params;
        }
        subParams.zipWith(superParams, function (t1, t2) return Tup2.create(t1, t2));
      }
      else 
      {
        var newSubTypeBase = switch (path[index]) {
          case SuperClass: sub.superClass;
          case InterfaceAt(i): sub.interfaces[i];
        }
        var params = newSubTypeBase.params;
        var newSubTypeParams = getParamsAsTypes(newSubTypeBase.t.get());
        var mapping = newSubTypeParams.zip(params);
        var maps = loop(newSubTypeBase.t.get(), sup, path, index+1);

        params.zipWith(maps, function (t1, tup) return Tup2.create(remap(tup._1, mapping), tup._2));
      }
    }
    
    var path = getFirstPath(subType, superType);
    return path.map(function (x) return loop(subType, superType, x, 0));
    
  }
  
  
  
  public static function getFirstPath (from:ClassType, to:ClassType):Option<Path> 
  {
    function loop(from:ClassType, to:ClassType, path:Path) 
    {
      return if (ClassTypeExt.eq(from, to)) {
        Some(path);
      } else {
        var fromSuper = function () return 
          if (from.superClass != null)
            loop(from.superClass.t.get(), to, path.concat([SuperClass]))
          else None;
        
        var fromInterf = function () 
        {
          return from.interfaces.foldLeftWithIndex(
            function (acc:Option<Path>, cur, index) 
            {
              return acc.orElse(
                function () return loop(cur.t.get(), to, path.concat([InterfaceAt(index)]))
              );
            }, None);
        }
        fromSuper().orElse(fromInterf);
      }
    }
    return loop(from, to, []);
  }
  
  /**
   * Checks if type t is compatible to type given the free type parameters in wildcards.
   * It returns a type mapping from types in t to wildcards if compatible, otherwise None.
   * 
   * 
   * Examples:
   * t = Array<Int>, to = Array<T>, wildcards = [T] => Some([(T, Int)])
   * t = Array<Int>, to = Array<Int>, wildcards = [] => Some([])
   * t = Array<String>, to = Array<Int>, wildcards = [] => None
   * t = Array<Int, Option<String>>, to = Array<T, S>, wildcards = [T, S] => Some([(T, Int), (S, Option<String>)])
   * 
   */
  public static function typeIsCompatibleTo ( t:Type, to:Type, wildcards:Array<Type>):Option<Mapping> {
    return typeIsCompatibleTo1(t, to, wildcards, []);
  }
  
  public static function typeIsCompatibleTo1 ( t:Type, to:Type, wildcards:Array<Type>, mapping:Mapping ):Option<Mapping> 
  {
    // expand both types first
    var t = MContext.followAliases(t);
    var to = MContext.followAliases(to);
    
    var comp = typeIsCompatibleTo1;
    // checks if the parameter arrays are compatible
    function compParams(paramsT:Array<Type>, paramsTo:Array<Type>) {
      return 
        if (paramsT.length == paramsTo.length)
        {
          paramsT.zipFoldLeftWhile(
            paramsTo,
            function (m:Option<Mapping>, t1:Type,t2:Type) return comp(t1, t2, wildcards, m.extract()),
            function (c:Option<Mapping>) return c.isSome(),
            Some(mapping)
          );
        }
        else None;
    }
    var some = wildcards.some(function (x) return to.eq(x));
    
    return some.flatMap(function (v)
      return  
        mapping.some(function (x) return x._1.eq(v))
        .map(function (tup) return if (t.eq(tup._2)) Some(mapping) else None)
        .getOrElse(function () return Some(mapping.append(Tup2.create(to, t))))
    )
    .orElse(function () {
      return switch (to) {
        case TLazy(f2): switch (t) 
        {
          case TLazy(f1): comp(f1(), f2(), wildcards, mapping);
          default: None;
        }
        case TAnonymous(a2): switch (t) 
        {
          case TAnonymous(a1): Scuts.notImplemented();
          default: None;
        }
        case TDynamic(t2): switch (t) 
        {
          case TDynamic(t1):
            if (t1 == null && t2 == null) Some(mapping)
            else if (t1 != null && t2 != null) comp(t1,t2, wildcards, mapping)
            else None;
          default: None;
        }
        case TInst(t2,params2): switch (t) 
        {
          case TInst(t1,params1):
            if (ClassTypeExt.eq(t1.get(),t2.get())) compParams(params1, params2) else None;
          default: None;
        }
        case TMono(t2Ref): switch (t) 
        {
          case TMono(t1Ref):
            var t1 = t1Ref.get();
            var t2 = t2Ref.get();
            if (t1 == null && t2 == null) Some(mapping)
            else if (t1 != null && t2 != null) comp(t1,t2, wildcards, mapping)
            else None;
          default: None;
        }
        case TType(t2, params2): switch (t) 
        {
          case TType(t1, params1): None;
            //comp(t1,t2, openType) && compParams(params1, params2);
          default: None;
        }
        case TEnum(t2, params2): switch (t) 
        {
          case TEnum(t1, params1):
            if (EnumTypeExt.eq(t1.get(),t2.get())) compParams(params1, params2) else None;
          default: None;
        }
        case TFun(args2, ret2): switch (t) 
        {
          case TFun(args1, ret1):
            if (args1.length == args2.length) 
            {
              function foldArgs (m:Option<Mapping>, a1,a2) 
              {
                return if (a1.name == a2.name && a1.opt == a2.opt) 
                  comp(a1.t, a2.t, wildcards, mapping)
                else None;
              }
              args1.zipFoldLeftWhile(
                args2,
                foldArgs,
                function (c:Option<Mapping>) return c.isSome(),
                Some(mapping)
              )
              .flatMap(function (m) return comp(ret1, ret2, wildcards,m));
            }
            else None;
          default:None;
        }
      }
    });
  }

  static var hotsOfClassType = Dynamics.lazy(Context.getType("hots.Of").asClassType().extract()._1);
  
  static var hotsInType = Dynamics.lazy(Context.getType("hots.In"));
  static var hotsInClassType = Dynamics.lazy(hotsInType().asClassType().extract()._1);
  
  public static function makeOfType(container:Type, elem:Type) 
  {
    return TInst(hotsOfClassType(), [container, elem]);
  }
  
  public static function convertToOfType (containerType:Type) 
  {
    var err = function () return Scuts.macroError("Cannot create Of Type, because " + Print.type(containerType) + " is not a container type");
    
    return switch (containerType) 
    {
      case TInst(t, params): if (params.length == 1) makeOfType(TInst(t, [hotsInType()]), params[0]) else err();
      case TEnum(t, params): if (params.length == 1) makeOfType(TEnum(t, [hotsInType()]), params[0]) else err();
      case TType(t, params): if (params.length == 1) makeOfType(TType(t, [hotsInType()]), params[0]) else err();
      default: err();
    }
  }
  
  public static function isOfType (type:Type):Bool return getOfParts(type).isSome()
  
  public static function isContainerType(type:Type):Bool 
  {
    return switch (type) 
    {
      case TInst(_, params), TEnum(_, params), TType(_, params): params.length == 1;
      default: false;
    }
  }
  
  public static function getContainerElemType(container:Type):Option<Type> 
  {
    return switch (container) 
    {
      case TInst(_, params), TEnum(_,params), TType(_, params): if (params.length == 1) Some(params[0]) else None;
      default: None;
    }
  }
  
  public static function getContainerElemTypes(container:Type):Option<Array<Type>> 
  {
    return switch (container) 
    {
      case TInst(_, params), TEnum(_,params), TType(_, params): Some(params);
      default: None;
    }
  }
  
  public static function replaceContainerElemType(container:Type, newElemType:Type):Option<Type> 
  {
    return switch (container) 
    {
      case TInst(t, params): if (params.length == 1) Some(TInst(t, [newElemType])) else None;
      case TEnum(t, params): if (params.length == 1) Some(TEnum(t, [newElemType])) else None;
      case TType(t, params): if (params.length == 1) Some(TType(t, [newElemType])) else None;
      default: None;
    }
  }
  
  public static function replaceFirstInType(type:Type, replacement:Type):Option<Type> 
  {
    var inType = hotsInType();
    
    function loop (t:Type) {
      return if (TypeExt.eq(t, inType)) Some(replacement)
      else switch (t) {
        case TInst(ct, params): 
          // Special care for Of types, check always the right side first (reverse parameters).
          // Of<Array<hots.In>, hots.In> should be replaced by Of<Array<hots.In>, X> and not by Of<Array<X>, hots.In>
          // for the replacement type X.
          
          var isOf = isOfType(t);
          
          var p = if (isOf) params.reverseCopy() else params;

          p.someMappedWithIndex(function (p) return loop(p), function (x:Option<Type>) return x.isSome())
          .map( function (x) {
            var replaced = p.replaceElemAt(x._1.getOrError("Unexpected"),x._2);
            var maybeReversed = if (isOf) replaced.reverseCopy() else replaced;
            return TInst(ct, maybeReversed);
          });

        case TEnum(et, params): 
          var found = params.someMappedWithIndex(function (p) return loop(p), function (x:Option<Type>) return x.isSome());
          found.map( function (x) {
            return TEnum(et, params.replaceElemAt(x._1.getOrError("Unexpected"), x._2));
          });
        case TType(tt, params): 
          var found = params.someMappedWithIndex(function (p) return loop(p), function (x:Option<Type>) return x.isSome());
          found.map( function (x) {
            return TType(tt, params.replaceElemAt(x._1.getOrError("Unexpected"), x._2));
          });
        
        case TFun(args, ret):
          args.someMappedWithIndex(function (a) return loop(a.t), function (x:Option<Type>) return x.isSome())
          .map( function (x) {
            var oldArg = args[x._2];
            var newArg = { name : oldArg.name, opt: oldArg.opt, t : x._1.getOrError("Unexpected")};
            return TFun(args.replaceElemAt(newArg, x._2), ret);
          })
          .orElse(function () 
            return loop(ret)
              .map(function (x) return TFun(args, x))
          );
          
        default:Scuts.notImplemented();
      }
      
      
      
    }
    return loop(type);
    
    
  }

  public static function flattenOfType (ofType:Type):Type 
  {
    var parts = getOfParts(ofType);
    var t = parts.flatMap(function (x) 
    {
      var containerType = x._1;
      var innerType = x._2; // this is also an ofType
      var innerParts = getOfParts(innerType);
      return innerParts.map(function (y) 
      {
        var innerContainerType = y._1;
        var elemType = y._2;
        
        return makeOfType(makeOfType(containerType, innerContainerType), elemType);
      });
      
    });
    return t.getOrElse(Lazy.expr(Scuts.macroError("Cannot flatten the type " + Print.type(ofType))));
  }
  
  public static function getOfContainerType (t:Type):Option<Type> 
  {
    return getOfParts(t).map(function (x) return x._1);
  }
  
  public static function getOfElemType (t:Type):Option<Type> 
  {
    return getOfParts(t).map(function (x) return x._2);
  }
  
  public static function replaceOfElemType(ofType:Type, newElemType:Type):Option<Type> 
  {
    return switch (MContext.followAliases(ofType)) 
    {
      case TInst(t, params):
        var tget = t.get();
        if (tget.pack.length == 1 && tget.pack[0] == "hots" && tget.name == "Of") {
          Some(TInst(t, [params[0], newElemType]));
        } else {
          None;
        }
      default: None;
    }
  }
  
  
  
  public static function hasInnerInType (type:Type):Bool
  {
    var inType = hotsInType;
    
    function loop(t:Type) 
    {
      return TypeExt.eq(t, inType()) || switch (t) 
      {
        case TInst(_, params), TEnum(_, params), TType(_, params):
          params.any(function (p) return loop(p));
        case TFun(args, ret):
          args.any(function (a) return loop(a.t)) || loop(ret);
        
        default: 
          
          trace(type);
          trace(t);
          Scuts.notImplemented();
      }
    }
    return loop(type);
  }
  
  public static function getOfParts (type:Type):Option<Tup2<Type, Type>>
  {
    return switch (MContext.followAliases(type)) 
    {
      case TInst(t, params):
        var tget = t.get();
        if (tget.pack.length == 1 && tget.pack[0] == "hots" && tget.name == "Of") {
          Some(Tup2.create(params[0], params[1]));
        } else {
          None;
        }
      default: None;
    }
  }
}
#end
