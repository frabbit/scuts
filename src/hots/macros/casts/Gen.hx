package hots.macros.casts;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
import neko.FileSystem;
import neko.io.File;
import scuts.mcore.extensions.ComplexTypes;
import scuts.mcore.extensions.Types;
import scuts.mcore.Make;
import scuts.mcore.Print;
import scuts.Scuts;


class Gen 
{


  
  
  public static function check () {
    
    
  }
  
  public static function box (f:Expr, boxClass:Expr, castUpName:String, castDownName:String, boxName:String, unboxName:String):Type
  {
  
    
    
    Compiler.addClassPath("cache");
    
    var name = "X_hots_gen_casts_Casts_" + Context.signature([f,boxClass, castUpName, castDownName, boxName, unboxName]);
    
    var fqClass = name;
    
    return try {
      Context.getType(fqClass);
    } catch (e:Dynamic) {
      var named = null;
      
      var t1:ComplexType = null;
      var t2:ComplexType = null;
      var params:Array<TypeParamDecl> = [];
      
      switch (f.expr) {
        case EFunction(name, f1):
          t1 = f1.args[0].type;
          t2 = f1.ret;
          params = f1.params;
          f1.expr = macro return null;
          named = { expr : EFunction("f", f1), pos : f.pos };
        default: Scuts.unexpected();
      }
      
      //trace(Print.type(Context.typeof(macro { $named; f;} )));
       
      var boxField = Make.field(boxClass, boxName);
      var f1:Function = {
        args : [ { name : "x", opt : false, type : t1 } ],
        ret : t2,
        expr : macro return $boxField(x),
        params : params
      };
      var unboxField = Make.field(boxClass, unboxName);
      var f2:Function = {
        args : [ { name : "x", opt : false, type : t2 } ],
        ret : t1,
        expr : macro return $unboxField(x),
        params : params
      };
    
      
      
      
      
      var field1:Field = {
        name : "box",
        access : [AStatic, APublic],
        kind : FFun( f1 ),
        pos : Context.currentPos()
      }
      
      var field2:Field = {
        name : "unbox",
        access : [AStatic, APublic],
        kind : FFun( f2 ),
        pos : Context.currentPos()
      }
      
      var cl = 
        "class " + name + 
        "{" + 
        "public static inline " + Print.func(f1, castUpName) + 
        "\n" + 
        "public static inline " + Print.func(f2, castDownName) + 
        "}";
      
        
      if (!FileSystem.exists("cache")) {
        FileSystem.createDirectory("cache");
      }
      
      var output = File.write("cache" + "/" + name + ".hx");
      output.writeString(cl);
      output.close();
      
      /*
      var x = {
        
        pack : ["hots", "gen", "casts"],
        name : name,
        pos : Context.currentPos(),
        meta : [],
        params : [],
        isExtern : false,
        kind : TDClass(),
        fields : [field1, field2]
      
      }
      
      Context.defineType(x);
      */
      Context.getType(fqClass);
    }
  }
  
}

#end