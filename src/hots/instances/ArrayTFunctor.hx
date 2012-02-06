package hots.instances;
import hots.classes.FunctorTAbstract;
import hots.In;
import scuts.core.extensions.ArrayExt;
import hots.classes.Functor;
import hots.classes.FunctorT;


import scuts.core.extensions.Function1Ext;
import scuts.core.extensions.Function2Ext;

#if macro
import hots.macros.TypeClasses;
import haxe.macro.Expr;
#end

class ArrayTFunctor 
{
  static var hash:Hash<Functor<Dynamic>> = new Hash();
  
  @:macro public static function get <A>(functorA:ExprRequire<Functor<A>>):Expr {
    return TypeClasses.forType([functorA], "Hash<Functor<Dynamic>>", "hots.instances.FunctorArrayTImpl", "hots.instances.ArrayTFunctor");
  }
}

private typedef BAT = ArrayTBox;
private typedef BA = ArrayBox;

class FunctorArrayTImpl<M> extends FunctorTAbstract<M,Array<In>> {
  
  var functorM:Functor<M>;
  
  public function new (functorM:Functor<M>) 
  {
    this.functorM = functorM;
  }

  /**
   * @inheritDoc
   */
  override public function map<A,B>(f:A->B, fa:ArrayTOf<M, A>):ArrayTOf<M, B> {
    
    return BAT.box(functorM.map(function (x:Array<A>) {
      
      return BA.unbox(ArrayFunctor.get().map(f, BA.box(x)));
    },BAT.unbox(fa)));
  }
}