package hots.instances;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.In;
import hots.Of;
import hots.classes.Functor;
import scuts.core.types.Option;




using hots.box.OptionBox;



class OptionTOfApplicative<M> extends ApplicativeAbstract<Of<M,Option<In>>> {
  
  var applicativeM:Applicative<M>;

  public function new (applicativeM:Applicative<M>, pointed) 
  {
    super(pointed);
    this.applicativeM = applicativeM;
  }

  /**
   * aka <*>
   */
  override public function apply<A,B>(f:OptionTOf<M,A->B>, val:OptionTOf<M,A>):OptionTOf<M,B> 
  {
    function mapInner (f:Option<A->B>)
    {
      return function (a:Option<A>) return switch (f) 
      {
        case Some(v):
          switch (a) {
            case Some(v2): Some(v(v2));
            case None: None;
          }
        case None: None;
      }
    }
    
    var newF = applicativeM.map(f.unboxT(), mapInner);
    
    return applicativeM.apply(newF, val.unboxT()).boxT();
  }

}
