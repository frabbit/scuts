package hots.instances;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import hots.classes.Functor;
import scuts.core.types.Option;

import scuts.core.extensions.Function1Ext;
import scuts.core.extensions.Function2Ext;

private typedef B = OptionTBox;



class OptionTOfApplicativeImpl<M> extends ApplicativeAbstract<Of<M,Option<In>>> {
  
  var applicativeM:Applicative<M>;

  public function new (applicativeM:Applicative<M>) 
  {
    super(OptionTOfPointed.get(applicativeM));
    this.applicativeM = applicativeM;
  }

  /**
   * aka <*>
   */
  override public function apply<A,B>(f:OptionTOf<M,A->B>, val:OptionTOf<M,A>):OptionTOf<M,B> {
    var f1:Of<M, Option<A->B>> = B.unbox(f);
    var val1:Of<M, Option<A>> = B.unbox(val);
    
    var f2 = applicativeM.map(function (f:Option<A->B>) {
      return function (a:Option<A>) {
        return switch (f) {
          case Some(v):
            switch (a) {
              case Some(v2): Some(v(v2));
              case None: None;
            }
          case None: None;
        }
      }
    }, f1);
    return B.box(applicativeM.apply(f2, val1));
  }

}

typedef OptionTOfApplicative = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(OptionTOfApplicativeImpl)]>;