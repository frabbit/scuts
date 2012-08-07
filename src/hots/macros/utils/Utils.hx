package hots.macros.utils;
#if (macro || display)
import haxe.macro.Context;
import scuts.core.extensions.Options;
import scuts.core.extensions.Tup2s;

import haxe.macro.Type;
import scuts.core.extensions.Arrays;
import scuts.core.extensions.Dynamics;
import scuts.core.extensions.Ints;
import scuts.core.extensions.Strings;
import scuts.core.macros.Lazy;
import scuts.core.types.Option;
import scuts.core.types.Tup2;
import scuts.mcore.MContext;
import scuts.mcore.extensions.ClassTypes;
import scuts.mcore.extensions.EnumTypes;
import scuts.mcore.extensions.Types;
import scuts.mcore.Parse;
import scuts.mcore.Print;
import scuts.Scuts;
import scuts.core.types.Either;
using scuts.core.extensions.Eithers;
using scuts.core.extensions.Options;
using scuts.mcore.extensions.Types;
using scuts.core.extensions.Arrays;
using scuts.mcore.extensions.Exprs;
using scuts.mcore.extensions.Strings;
using scuts.core.extensions.Dynamics;
using scuts.mcore.extensions.ComplexTypes;
using scuts.mcore.extensions.FieldTypes;
using scuts.core.extensions.Functions;

using scuts.core.extensions.Validations;
import scuts.core.types.Validation;
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
  static var hotsOfClassType = D.lazy(Context.getType("hots.Of").asClassType().extract()._1);
  static var hotsInClassType = D.lazy(hotsInType().asClassType().extract()._1);
  
  public static var hotsInType = D.lazy(Context.getType("hots.In"));
  
  static function typeIsHotsInType (t:Type) 
  {
    return Types.eq(hotsInType(), t);
  }
  
  public static function normalizeOfTypes (type:Type):Type 
  {
    return switch (MContext.followAliases(type)) {
      case TInst(ctRef, params):
        var ct = ctRef.get();
        
        function normalizeOfType (t:Tup2<Type, Type>) 
        {
          var containerType = t._1;
          var elemType = t._2;
          
          return if (!typeIsHotsInType(elemType)) 
          {
            var newT1 = normalizeOfTypes(containerType);
            
            switch (newT1) {
              case TFun(args, ret):
                if (typeIsHotsInType(ret)) 
                {
                  var newArgs = args.map(function (a) return { opt : a.opt, name : null, t: a.t } );
                  TFun(newArgs, elemType);
                } 
                else 
                {
                  var index = args.findLastIndex(function (a) return typeIsHotsInType(a.t));
                  
                  function replaceInTypeAt (pos:Int) {
                    return args.mapWithIndex(function (a,i) return { opt : a.opt, name : null, t: pos == i ? elemType : a.t } );
                  }
                  
                  var newArgs = index.map(replaceInTypeAt).getOrElseConst(args);
                  
                  TFun(newArgs, ret);
                }
              default:
                replaceFirstInType(newT1, elemType)
                .getOrElseConst(type);
            }
          } else {
            normalizeOfTypes(makeOfType(normalizeOfTypes(containerType), normalizeOfTypes(elemType)));
          }
        }
        
        getOfParts(type).map(normalizeOfType).getOrElseConst(type);
      case TEnum(eRef, params):
        TEnum(eRef, params.map(normalizeOfTypes));
      case TFun(args, ret):
        function normalizeArg (a) return { name:a.name, opt:a.opt, t:normalizeOfTypes(a.t)}
        TFun(args.map(normalizeArg), normalizeOfTypes(ret));
      default: Scuts.notImplemented();
    }
  }
  
  public static function getConstructorArgumentTypes (fields:Array<Field>):Option<Array<ComplexType>> 
  {
    function mapArgs (x:Function) 
      return x.args.map(function (x) return x.type);

    return 
      getFieldAsFunction(fields, "new")
      .map(mapArgs);
  }
  
  public static function getFieldAsFunction (fields:Array<Field>, field:String):Option<Function> 
  {
    return fields.some(function (x) return x.name == field)
      .flatMap(function (x) return x.kind.asFunction());
  }
  
  public static function reverseMapping (m:Array<Tup2<Type, Type>>):Array<Tup2<Type, Type>> {
    return m.map(Tup2s.swap);
  }
  
  public static function containsType (type:Type, search:Type):Bool
  {
    
    return Types.eq(type, search) || switch (type) {
      case TInst(t, params):
        params.any( containsType.partial2(search));
      case TEnum(t, params):
        params.any( containsType.partial2(search));
      case TFun(args, ret):
        args.any( function (x) return containsType(x.t, search )) 
        || containsType(ret, search);
      case TAnonymous(a):
        a.get().fields.any(function (x) return containsType(x.type, search));
      case TType(t, params):
        params.any( containsType.partial2(search));
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
  
  /**
   * Searches recursively in type for all types included in search. All found types are 
   * returned in an Array. Its not important how often the type is included, one occurrence is 
   * enough.
   * 
   * Example:
   * typeA : Array<Int>->String
   * typeInt : Int
   * typeString : String
   * typeFloat : String
   * getContainingTypes(typeA, [typeInt]) // [typeInt]
   * getContainingTypes(typeA, [typeInt, typeString]) // [typeInt, typeString]
   * getContainingTypes(typeA, [typeInt, typeFloat]) // [typeInt]
   * getContainingTypes(typeA, [typeFloat]) // []
   * 
   */
  public static function getContainingTypes (type:Type, search:Array<Type>):Array<Type>
  {
    function loop (type:Type, search:Array<Type>, found:Array<Type>):Tup2<Array<Type>, Array<Type>>
    {
      var foldParams = function (acc:Tup2<Array<Type>, Array<Type>>, cur) return loop(cur, acc._1, acc._2);
      var foldArgs   = function (acc:Tup2<Array<Type>, Array<Type>>, arg) return loop(arg.t, acc._1, acc._2);
      var foldFields = function (acc:Tup2<Array<Type>, Array<Type>>, f)   return loop(f.type, acc._1, acc._2);
      
      function findInParams (params:Array<Type>) return params.foldLeft(foldParams, Tup2.create(search, found));
      
      function findInner () 
      {
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

      // remove the founded type from search and add it to the result
      function typeFound( x:Tup2<Type, Int> ) 
        return Tup2.create(search.removeElemAt(x._2), found.appendElem(x._1));
      
      return 
        search
        .someWithIndex( Types.eq.partial2(type))
        .map( typeFound )
        .getOrElse(findInner);
    }
    return loop(type, search, [])._2;
  }
  
  public static function getParamsAsTypes (classType:ClassType):Array<Type> 
  {
    var m = classType.module;
    var s = (m != "" ? (m + ".") : "") + classType.name;
    var res = MContext.getType(s);
    
    function extractParams (x) return switch (x) 
    {
      case TInst(_, p), TType(_, p), TEnum(_, p): Some(p);
      default: None;
    }
    
    return 
      res.flatMap(extractParams)
      .getOrElse(D.lazy([]));
  }

  public static function remap (type:Type, mapping:Array<Tup2<Type, Type>>):Type 
  {
    var canMap     = mapping.some(function (x) return Types.eq(x._1, type));
    var remapParam = remap.partial2(mapping);
    var remapArg   = function (a) return { name: a.name, opt:a.opt, t : remap(a.t, mapping)};
    
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
            // TODO Needs compiler support
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
    
    function loop(from:ClassType, to:ClassType, path:Path):Option<Path> 
    {
     
      
      function findInSuperOrInterface () 
      {
        function findInSuper () 
        {
          var sc = from.superClass;
          return if (sc != null) loop(sc.t.get(), to, path.concat([SuperClass])) else None;
        }
        
        function findInInterfaces () 
        {
          function findInInterface (cur, index) return loop(cur.t.get(), to, path.concat([InterfaceAt(index)]));
          function findFirst (acc:Option<Path>, cur, index) return acc.orElse(findInInterface.partial1_2(cur, index));
          
          return from.interfaces.foldLeftWithIndex(findFirst, None);
        }
        return findInSuper().orElse(findInInterfaces);
      }
      
      return if (ClassTypes.eq(from, to)) Some(path) else findInSuperOrInterface();
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
  
  static function typeIsCompatibleTo1 ( t:Type, to:Type, wildcards:Array<Type>, mapping:Mapping, ignoreFunArgNames:Bool = true ):Option<Mapping> 
  {
    // expand both types first

    var comp = typeIsCompatibleTo1;
    // checks if the parameter arrays are compatible
    
    function compParams(paramsT:Array<Type>, paramsTo:Array<Type>) 
    {
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
    
    var to = MContext.followAliases(to);
    
    var t = MContext.followAliases(t);
    
    // wildcards in target type
    var targetIsWildcard = wildcards.some(to.eq);
    
    function addMappingIfPossible (v) 
    {
      function isWildCardInMapping (x:Tup2<Type,Type>) return x._1.eq(v); // wildcards must be unique in mapping
      function currentTypeIsAlsoInMapping (tup) return t.eq(tup._2);
      
      var targetInMapping = mapping.some(isWildCardInMapping);
      var currentTypeInMapping = targetInMapping.filter(currentTypeIsAlsoInMapping).isSome();
      
      return
        if (targetInMapping.isSome())
          if (currentTypeInMapping) Some(mapping) 
          else None
        else Some(mapping.appendElem(Tup2.create(to, t)));
      
    }
    
    function checkNormalTarget () return switch (to) 
    {
      case TLazy(f2): switch (t) 
      {
        case TLazy(f1): comp(f1(), f2(), wildcards, mapping);
        case TMono(_):  Some(mapping);
        default:        None;
      }
      case TAnonymous(a2): switch (t) 
      {
        case TAnonymous(a1): Scuts.notImplemented();
        case TMono(_):       Some(mapping);
        default:             None;
      }
      case TDynamic(t2): switch (t) 
      {
        case TDynamic(t1):
          if (t1 == null && t2 == null) Some(mapping)
          else if (t1 != null && t2 != null) comp(t1,t2, wildcards, mapping)
          else None;
        case TMono(_): Some(mapping);
        default: None;
      }
      case TInst(t2,params2): switch (t) 
      {
        case TInst(t1,params1): if (ClassTypes.eq(t1.get(),t2.get())) compParams(params1, params2) else None;
        case TMono(_):          Some(mapping);
        default:                None;
      }
      case TMono(t2Ref): Some(mapping);
      case TType(t2, params2): switch (t) 
      {
        case TType(t1, params1): None;
        case TMono(_): Some(mapping);
          //comp(t1,t2, openType) && compParams(params1, params2);
        default: None;
      }
      case TEnum(t2, params2): switch (t) 
      {
        case TEnum(t1, params1): if (EnumTypes.eq(t1.get(),t2.get())) compParams(params1, params2) else None;
        case TMono(_):           Some(mapping);
        default:                 None;
      }
      case TFun(args2, ret2): switch (t) 
      {
        case TFun(args1, ret1):
          
          if (args1.length == args2.length) 
          {
            function foldArgs (m:Option<Mapping>, a1,a2) 
            {
              return if ((ignoreFunArgNames || (a1.name == a2.name)) && a1.opt == a2.opt) 
                comp(a1.t, a2.t, wildcards, mapping)
              else None;
            }
            
            args1.zipFoldLeftWhile(
              args2,
              foldArgs,
              Options.isSome,
              Some(mapping)
            )
            .flatMap(comp.partial1_2_3_(ret1, ret2, wildcards));
          }
          else None;
        case TMono(_): Some(mapping);
        default:None;
      }
    }
    
    
    return if (targetIsWildcard.isSome()) targetIsWildcard.flatMap(addMappingIfPossible)
    else checkNormalTarget();
      
  }

  
  
  public static function makeOfType(container:Type, elem:Type) 
  {
    return TInst(hotsOfClassType(), [container, elem]);
  }

  public static function convertToOfType (containerType:Type) 
  {
    var errGeneral = function (type) 
      return Scuts.macroError("Cannot create Of Type, because " + Print.type(containerType) + " is not a " + type + " type");
    
    var err    = errGeneral.partial1("container");
    var errFun = errGeneral.partial1("supported function");
    
    function replaceLastWithInType (params:Array<Type>) {
      return params.take(params.length - 1).appendElem(hotsInType());
    }
    
    return switch (containerType) 
    {
      case TInst(t, params): 
        
        var len = params.length;
        if (len > 0) makeOfType(TInst(t, replaceLastWithInType(params)), params[len - 1]) else err();
        
      case TEnum(t, params): 
        
        var len = params.length;
        if (len > 0) makeOfType(TEnum(t, replaceLastWithInType(params)), params[len - 1]) else err();
        
      case TType(t, params): 
        
        var len = params.length;
        if (len > 0) makeOfType(TType(t, replaceLastWithInType(params)), params[len - 1]) else err();
        
      case TFun(args, ret): 
        
        if (args.length > 1) errFun();
        switch (ret) {
          case TInst(t,_): 
            var tget= t.get();
            
            function isVoid(ct:ClassType) return ct.pack.length == 0 && ct.name == "Void";
            
            if (isVoid(tget)) {
              errFun();
            } else if (Types.eq(ret, hotsInType())) {
              
              var newArgs = args.map(function (x) return { name: x.name, opt:x.opt, t:hotsInType() } );
              var r = makeOfType(TFun(newArgs, ret), args[0].t);
              r;
            } else {
              makeOfType(TFun(args, hotsInType()), ret);
            }
          default: 
            makeOfType(TFun(args, hotsInType()), ret);
        }
      default: err();
    }
  }
  
  public static function isOfType (type:Type):Bool return getOfParts(type).isSome()
  
  public static function getOfLevel (type:Type):Int {
    
    function getLevel (x) {
      return 1 + getOfLevel(x._1);
    }
    
    return 
      getOfParts(type)
      .map(getLevel)
      .getOrElseConst(0);
  }
  
  
  public static function isFunctionType(type:Type):Bool {
    return switch (type) 
    {
      case TFun(_, _):true;
      default: false;
    }
  }
  public static function isContainerType(type:Type):Bool 
  {
    return switch (type) 
    {
      case TInst(_, p), TEnum(_, p), TType(_, p): p.length > 0;
      default: false;
    }
  }
  
  
  public static function getContainerElemType(container:Type):Option<Type> 
  {
    return switch (container) 
    {
      case TInst(_, p), TEnum(_,p), TType(_, p): 
        if (p.length == 1) Some(p[0]) else None;
      default: None;
    }
  }
  
  
  public static function getContainerElemTypes(container:Type):Option<Array<Type>> 
  {
    return switch (container) 
    {
      case TInst(_, p), TEnum(_,p), TType(_, p): Some(p);
      default: None;
    }
  }
  
  public static function replaceContainerElemType(container:Type, newElemType:Type):Option<Type> 
  {
    return switch (container) 
    {
      case TInst(t, p): if (p.length == 1) Some(TInst(t, [newElemType])) else None;
      case TEnum(t, p): if (p.length == 1) Some(TEnum(t, [newElemType])) else None;
      case TType(t, p): if (p.length == 1) Some(TType(t, [newElemType])) else None;
      default: None;
    }
  }
  
  public static function replaceContainerElemTypeAt(container:Type, newElemType:Type, index:Int):Option<Type> 
  {
    return switch (container) 
    {
      case TInst(t, p): if (p.length > index) Some(TInst(t, p.replaceElemAt(newElemType, index))) else None;
      case TEnum(t, p): if (p.length > index) Some(TEnum(t, p.replaceElemAt(newElemType, index))) else None;
      case TType(t, p): if (p.length > index) Some(TType(t, p.replaceElemAt(newElemType, index))) else None;
      default: None;
    }
  }
  
  public static function replaceContainerElemTypes(container:Type, newElemTypes:Array<Type>):Option<Type> 
  {
    return switch (container) 
    {
      case TInst(t, p): if (p.length == newElemTypes.length) Some(TInst(t, newElemTypes)) else None;
      case TEnum(t, p): if (p.length == newElemTypes.length) Some(TEnum(t, newElemTypes)) else None;
      case TType(t, p): if (p.length == newElemTypes.length) Some(TType(t, newElemTypes)) else None;
      default: None;
    }
  }
  /**
   * right to left
   */
  public static function replaceFirstInType(type:Type, replacement:Type):Option<Type> 
  {
    var inType = hotsInType();
    
    function loop (t:Type) {
      return if (Types.eq(t, inType)) 
        Some(replacement)
      else {
        function replaceParamAt (params:Array<Type>, x:Tup2<Option<Type>, Int>) {
          return params.replaceElemAt(
            x._1.getOrError("Unexpected"),
            params.length - 1 - x._2
          );
        }
        
        switch (t) {
          case TInst(ct, params): 
            
            function replaceTypeParamAt (x) return TInst(ct, replaceParamAt(params, x));
            
            params
            .reverseCopy()
            .someMappedWithIndex(loop, Options.isSome)
            .map(replaceTypeParamAt);

          case TEnum(et, params): 
            
            function replaceTypeParamAt (x) return TEnum(et, replaceParamAt(params, x));
            
            params.reverseCopy()
            .someMappedWithIndex(loop, Options.isSome)
            .map( replaceTypeParamAt);
          
          case TType(tt, params): 
            
            function replaceTypeParamAt (x) return TType(tt, replaceParamAt(params, x));
            
            params.reverseCopy()
            .someMappedWithIndex(loop, Options.isSome)
            .map( replaceTypeParamAt);
          
          case TFun(args, ret):
            
            function replaceTypeParamInArgs() 
            {
              function replaceTypeParamAt (x:Tup2<Option<Type>, Int>) {
                var origIndex = args.length - 1 - x._2;
                
                var old = args[origIndex];
                var newArg = { name : old.name, opt: old.opt, t : x._1.getOrError("Unexpected")};
                return TFun(args.replaceElemAt(newArg, origIndex), ret);
              }
              return 
                args.reverseCopy()
                .someMappedWithIndex(function (a) return loop(a.t), Options.isSome)
                .map( replaceTypeParamAt );
            }
            
            loop(ret)
            .map(callback(TFun, args, _))
            .orElse(replaceTypeParamInArgs);
            
          default:Scuts.notImplemented();
        }
      }
    }
    return loop(type);
    
    
  }
  /*
   * 
   * left to right
   * 
   * 
  public static function replaceFirstInType(type:Type, replacement:Type):Option<Type> 
  {
    var inType = hotsInType();
    
    function loop (t:Type) {
      return if (Types.eq(t, inType)) Some(replacement)
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
          // generell von rechts nach links
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
  */
  public static function flattenOfType (ofType:Type):Type 
  {
    function flattenOuterParts (x) 
    {
      var containerType = x._1;
      
      function flattenInnerParts(y:Tup2<Type, Type>) 
      {
        var innerContainerType = y._1;
        var elemType = y._2;
        
        return makeOfType(makeOfType(containerType, innerContainerType), elemType);
      }

      var innerType = x._2; // this is also an ofType
      
      return getOfParts(innerType).map(flattenInnerParts);
    }
    
    var error = Lazy.expr(Scuts.macroError("Cannot flatten the type " + Print.type(ofType)));
    
    return 
      getOfParts(ofType)
      .flatMap(flattenOuterParts)
      .getOrElse(error);
  }
  
  public static function getOfContainerType (t:Type):Option<Type> 
  {
    return getOfParts(t).map(Tup2s.first);
  }
  
  public static function getOfElemType (t:Type):Option<Type> 
  {
    return getOfParts(t).map(Tup2s.second);
  }
  
  public static function replaceOfElemType(ofType:Type, newElemType:Type):Option<Type> 
  {
    return switch (MContext.followAliases(ofType)) 
    {
      case TInst(t, params):
        var tget = t.get();
        var pack = tget.pack;
        
        if (pack.length == 1 && pack[0] == "hots" && tget.name == "Of") {
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
      return Types.eq(t, inType()) || switch (t) 
      {
        case TInst(_, params), TEnum(_, params), TType(_, params):
          params.any(loop);
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
