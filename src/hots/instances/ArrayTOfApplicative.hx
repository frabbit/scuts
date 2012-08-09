package hots.instances;
import hots.classes.Applicative;
import hots.classes.ApplicativeAbstract;
import hots.classes.FunctorAbstract;
import hots.instances.ArrayTOfFunctor;
import hots.In;
import hots.Of;
import scuts.core.extensions.Arrays;
import hots.classes.Functor;



using hots.box.ArrayBox;



class ArrayTOfApplicative<M> extends ApplicativeAbstract<OfT<M,Array<In>>> {
  
  var appM:Applicative<M>;

  public function new (appM, pointed) 
  {
    super(pointed);
    this.appM = appM;
  }

  /**
   * aka <*>
   */
  override public function apply<A,B>(f:ArrayTOf<M,A->B>, of:ArrayTOf<M,A>):ArrayTOf<M,B> 
  {
    
    function mapInner (x:Array<A->B>) 
    {
      return function (a:Array<A>) 
      {
        var res = [];
        for (a1 in a) 
          for (f1 in x) 
            res.push(f1(a1));

        return res;
      }
    }
    
    var newF = appM.map(f.unboxT(), mapInner);
    
    return appM.apply(newF, of.unboxT()).boxT();
  }

}
