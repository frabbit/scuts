package hots.macros.utils;
import haxe.macro.Context;
import haxe.macro.Type;
import scuts.core.extensions.DynamicExt;
import scuts.core.macros.Lazy;
import scuts.core.types.Option;
import scuts.core.types.Tup2;
import scuts.mcore.extensions.ClassTypeExt;
import scuts.mcore.extensions.EnumTypeExt;
import scuts.mcore.extensions.TypeExt;
import scuts.mcore.Parse;
import scuts.mcore.Print;
import scuts.Scuts;

using scuts.core.extensions.OptionExt;
using scuts.mcore.extensions.TypeExt;
using scuts.core.extensions.ArrayExt;
using scuts.mcore.extensions.ExprExt;
using scuts.mcore.extensions.StringExt;
using scuts.core.extensions.DynamicExt;
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


typedef Mapping = Array<Tup2<Type, Type>>;


class Utils 
{

  
  public static function typeIsCompatibleTo ( t:Type, to:Type, openTypes:Array<Type> ) {
    return typeIsCompatibleTo1(t, to, openTypes, []);
  }
  
  public static function typeIsCompatibleTo1 ( t:Type, to:Type, openTypes:Array<Type>, mapping:Mapping ):Option<Mapping> {
    
    // expand both types first
    var t = Context.follow(t);
    var to = Context.follow(to);
    
    var comp = typeIsCompatibleTo1;
    
    function compParams(paramsT:Array<Type>, paramsTo:Array<Type>) {
      return if (paramsT.length == paramsTo.length)
        {
          var res = Some(mapping);
          for (i in 0...paramsT.length) {
            var t1 = paramsT[i];
            var t2 = paramsTo[i];
            res = comp(t1, t2, openTypes, mapping);
            switch (res) {
              case Some(m): mapping = m;
              default:
                res = None;
                break;
            }
          }
          res;
        } else None;
    }
    var some = openTypes.some(function (x) return to.eq(x));
    return if (some.isSome()) {
      var v = some.extract();
      var res = mapping.some(function (x) return x._1.eq(v));
      switch (res) {
        case Some(tup): // mapping exists, check compatibility
          if (t.eq(tup._2)) {
            Some(mapping);
          } else None;
        default: // mapping does not exist
          var cp = mapping.copy();
          cp.push(Tup2.create(to, t));
          Some(cp);
      }
    }
    else 
      switch (to) {
        case TLazy(f2):
          switch (t) {
            case TLazy(f1): comp(f1(), f2(), openTypes,mapping);
            default: None;
          }
        case TAnonymous(a2):
          switch (t) {
            case TAnonymous(a1):
              None;
            default: None;
          }
        case TDynamic(t2):
          switch (t) {
            case TDynamic(t1):
              if (t1 == null && t2 == null) Some(mapping)
              else if (t1 != null && t2 != null) comp(t1,t2, openTypes, mapping)
              else None;
            default: None;
          }
        case TInst(t2,params2):
          switch (t) {
            case TInst(t1,params1):
              if (ClassTypeExt.eq(t1.get(),t2.get())) compParams(params1, params2) 
              else None;
            default: None;
          }
        case TMono(t2Ref):
          switch (t) {
            case TMono(t1Ref):
              var t1 = t1Ref.get();
              var t2 = t2Ref.get();
               if (t1 == null && t2 == null) Some(mapping)
               else if (t1 != null && t2 != null) comp(t1,t2, openTypes, mapping)
               else None;
            default: None;
          }
        case TType(t2, params2):
          switch (t) {
            case TType(t1, params1):
              None;
              //comp(t1,t2, openType) && compParams(params1, params2);
            default: None;
          }
        case TEnum(t2, params2):
          switch (t) {
            case TEnum(t1, params1):
              if (EnumTypeExt.eq(t1.get(),t2.get())) compParams(params1, params2) else None;
            default: None;
          }
        case TFun(args2, ret2):
          switch (t) {
            case TFun(args1, ret1):
              var compArgs = Lazy.expr({
                var res = Some(mapping);
                for (i in 0...args1.length) {
                  var a1 = args1[i];
                  var a2 = args2[i];
                  
                  if (a1.name == a2.name
                    && a1.opt == a2.opt) {
                    res = comp(a1.t, a2.t, openTypes, mapping);
                    switch (res) {
                      case Some(m):
                        mapping = m;
                        break;
                      default: None;
                    }
                  } else {
                    res = None;
                    break;
                  }
                }
                res;
              });
              
              if (args1.length == args2.length) {
                switch (compArgs()) {
                  case Some(m): comp(ret1, ret2, openTypes,m);
                  default: None;
                }
              } else None;
              
              
              
            default:None;
          }
      }
  }
  
  public static function createOfType (containerType:Type, elemType:Type) {
    var s = "{ var x: hots.Of<" + Print.type(containerType) + ", " + Print.type(elemType) + "> = null; x;}";
    var e = Context.parse(s, Context.makePosition({min:0, max:0, file: "in_macro"}));
    return Context.typeof(e);
  }
  
  public static function convertToOfType (containerType:Type) {
    var inType = Context.getType("hots.In");
    
    return switch (containerType) {
      case TInst(t, params): 
        if (params.length == 1) {
          var s = "{ var x: hots.Of<" + Print.type(TInst(t, [inType])) + ", " + Print.type(params[0]) + "> = null; x;}";
          
          var e = Context.parse(s, Context.makePosition({min:0, max:0, file: "in_macro"}));
          Context.typeof(e);
          /*
          var ofType = Context.follow(Context.getType("hots.Of"));
          switch (ofType) {
            case TAnonymous(a):
              var f = a.get().fields[0];
              
              
              var aGet = a.get();
              aGet.fields = [];
              trace(a.get().fields);
              if (f.name == Constants.HOTS_OF_FIELD_ID) {
                switch (f.type) {
                  case TAnonymous(a2):
                    var fields = a2.get().fields;
                    var mField = fields[0];
                    var tField = fields[1];
                    mField.type = TInst(t, [inType]);
                    tField.type = params[0];
                    
                    TAnonymous(new MyRef(aGet));
                  default: Scuts.macroError("Invalid Of Type");
                }
              } else {
                Scuts.macroError("Invalid Of Type");
              }
              
            default: Scuts.macroError("Invalid Of Type");
          }
          */
          
        } else  Scuts.macroError("Cannot create Of Type, because " + Print.type(containerType) + " is not a container type");
      default: Scuts.macroError("Cannot create Of Type, because " + Print.type(containerType) + " is not a container type");
    }
  }
  
  public static function isOfType (type:Type):Bool {
    return getOfParts(type).isSome();
  }
  
  public static function isContainerType(type:Type):Bool {
    return switch (type) {
      case TInst(_, params): params.length == 1;
      default: false;
    }
  }
  
  public static function getContainerElemType(container:Type):Option<Type> {
    return switch (container) {
      case TInst(_, params): if (params.length == 1) Some(params[0]) else None;
      default: None;
    }
  }
  
  public static function replaceContainerElemType(container:Type, newElemType:Type):Option<Type> {
    return switch (container) {
      case TInst(t, params): if (params.length == 1) Some(TInst(t, [newElemType])) else None;
      default: None;
    }
  }

  public static function flattenOfType (ofType:Type):Type 
  {
    var parts = getOfParts(ofType);
    var t = parts.flatMap(function (x) {
      var containerType = x._1;
      var innerType = x._2; // this is also an ofType
      var innerParts = getOfParts(innerType);
      return innerParts.map(function (y) {
        var innerContainerType = y._1;
        var elemType = y._2;
        
        return createOfType(createOfType(containerType, innerContainerType), elemType);
      });
      
    });
    return t.getOrElseThunk(Lazy.expr(Scuts.macroError("Cannot flatten the type " + Print.type(ofType))));
  }
  
  public static function getOfContainerType (t:Type):Option<Type> {
    return getOfParts(t).map(function (x) return x._1);
  }
  
  public static function getOfElemType (t:Type):Option<Type> {
    return getOfParts(t).map(function (x) return x._2);
  }
  
  
   public static function replaceOfElemType(ofType:Type, newElemType:Type):Option<Type> {
    return switch (Context.follow(ofType)) 
    {
      case TAnonymous(a):
        
        var fields = a.get().fields;
        var inner = Lazy.expr(switch (fields[0].type) 
        {
          case TAnonymous(a2):
            
            
            var fields2 = a2.get().fields;
            if (fields2.length == 2 
               && fields2[0].name == "m") {
               "hots.Of<$0, $1>".parseToType([fields2[0].type, newElemType]);
            }
            else None;
          default: None;
        });
        if (fields.length == 1 && fields[0].name == Constants.HOTS_OF_FIELD_ID) // It's an Of Type
          inner() // check if type is Type Constructor in Of Type
        else 
          None;
      default: None;
    }
  }
  
  public static function hasInnerInType (type:Type):Bool
  {
    return getContainerElemType(type)
      .filter(function (x) return TypeExt.eq(x, Context.getType("hots.In")))
      .isSome();
  }
  
  public static function getOfParts (type:Type):Option<Tup2<Type, Type>>
  {
    
    return switch (Context.follow(type)) 
    {
      
      case TAnonymous(a):
        
        var fields = a.get().fields;
        var inner = Lazy.expr(switch (fields[0].type) 
        {
          case TAnonymous(a2):
            
            var fields2 = a2.get().fields;
            if (fields2.length == 2 
               && fields2[0].name == "m") 
              Some(Tup2.create(fields2[0].type, fields2[1].type)) 
            else None;
          default: None;
        });
        if (fields.length == 1 && fields[0].name == Constants.HOTS_OF_FIELD_ID) // It's an Of Type
          inner() // check if type is Type Constructor in Of Type
        else 
          None;
      default: None;
    }
  }
  /*
  public static function getTypeClassOf(ct:ClassType) 
  {
    // ct must have an abstract superclass
    // this abstract superclass must implement exactly one interface (the type class)
    
    var typeClass = 
      ct.superClass.nullToOption()
      .filter(function (s) return s.t.get().meta.has(Constants.ABSTRACT_TYPE_CLASS_MARKER))
      .map(function (s) return s.t.get().interfaces.length != 1 ? None : s.t.get().interfaces[0])
      .filter(function (i) return i.
  }
  */
  /*
  public static function getTypeClassInstanceConstraints () {
    
  }
  */
  // returns a mapping of type parameters from a tc-instance to it's tc-class 
  public static function resolveTCInstanceParamsIn () {
    
  }
  
}
