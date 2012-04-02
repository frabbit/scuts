package scuts.core.lifting;
import scuts.core.types.Future;

import scuts.core.types.Option;
using scuts.core.extensions.OptionExt;

class LiftWithFuture0
{

  public static function liftWithFuture <A> (f:Void->A):Void->Future<A> 
  {
    return function () {
      var fut = new Future();
      fut.deliver(f());
      return fut;
    }
  }
}

class LiftWithFuture1 
{

  public static function liftWithFuture <A, B> (f:A->B):Future<A>->Future<B> 
  {
    return function (a:Future<A>) {
      var fut = new Future();
      a.deliverTo( function (r) fut.deliver(f(r)) );
      a.ifCanceled(function () fut.cancel());
      
      return fut;
    }
  }
}
class LiftWithFuture2 
{

  public static function liftWithFuture <A, B, C> (f:A->B->C):Future<A>->Future<B>->Future<C> 
  {
    return function (a:Future<A>, b:Future<B>) {
      var fut = new Future();
      
      var valA = None;
      var valB = None;
      
      function check () {
        if (valA.isSome() && valB.isSome()) {
          fut.deliver(f(valA.value(), valB.value()));
        }
      }
      
      a.deliverTo(function (r) {
        valA = Some(r);
        check();
      });
      
      b.deliverTo(function (r) {
        valB = Some(r);
        check();
      });
      
      var cancel = function () fut.cancel;
      
      a.ifCanceled(cancel);
      b.ifCanceled(cancel);

      return fut;
      
    }
  }

}
class LiftWithFuture3
{
  public static function liftWithFuture <A, B, C, D> (f:A->B->C->D):Future<A>->Future<B>->Future<C>->Future<D>
  {
    return function (a:Future<A>, b:Future<B>, c:Future<C>) {
      var fut = new Future();
      
      var valA = None;
      var valB = None;
      var valC = None;
      
      function check () {
        if (valA.isSome() && valB.isSome() && valC.isSome()) {
          fut.deliver(f(valA.value(), valB.value(), valC.value()));
        }
      }
      
      a.deliverTo(function (r) {
        valA = Some(r);
        check();
      });
      b.deliverTo(function (r) {
        valB = Some(r);
        check();
      });
      c.deliverTo(function (r) {
        valC = Some(r);
        check();
      });
      
      
      
      var cancel = function () fut.cancel;
      
      a.ifCanceled(cancel);
      b.ifCanceled(cancel);
      c.ifCanceled(cancel);
      
      return fut;
    }
  }
}

class LiftWithFuture4 
{  
  public static function liftWithFuture <A, B, C, D, E> (f:A->B->C->D->E):Future<A>->Future<B>->Future<C>->Future<D>->Future<E>
  {
    return function (a:Future<A>, b:Future<B>, c:Future<C>, d:Future<D>) {
      var fut = new Future();
      
      var valA = None;
      var valB = None;
      var valC = None;
      var valD = None;
      
      function check () {
        if (valA.isSome() && valB.isSome() && valC.isSome() && valD.isSome()) {
          fut.deliver(f(valA.value(), valB.value(), valC.value(), valD.value()));
        }
      }
      
      a.deliverTo(function (r) {
        valA = Some(r);
        check();
      });
      b.deliverTo(function (r) {
        valB = Some(r);
        check();
      });
      c.deliverTo(function (r) {
        valC = Some(r);
        check();
      });
      d.deliverTo(function (r) {
        valD = Some(r);
        check();
      });
      
      var cancel = function () fut.cancel;
      
      a.ifCanceled(cancel);
      b.ifCanceled(cancel);
      c.ifCanceled(cancel);
      d.ifCanceled(cancel);
      
      return fut;
    }
  }
  
}

class LiftWithFuture5 
{  
  public static function liftWithFuture <A, B, C, D, E, F> (f:A->B->C->D->E->F):Future<A>->Future<B>->Future<C>->Future<D>->Future<E>->Future<F>
  {
    return function (a:Future<A>, b:Future<B>, c:Future<C>, d:Future<D>, e:Future<E>) {
      var fut = new Future();
      
      var valA = None;
      var valB = None;
      var valC = None;
      var valD = None;
      var valE = None;
      
      function check () {
        if (valA.isSome() && valB.isSome() && valC.isSome() && valD.isSome() && valE.isSome()) {
          fut.deliver(f(valA.value(), valB.value(), valC.value(), valD.value(), valE.value()));
        }
      }
      
      a.deliverTo(function (r) {
        valA = Some(r);
        check();
      });
      b.deliverTo(function (r) {
        valB = Some(r);
        check();
      });
      c.deliverTo(function (r) {
        valC = Some(r);
        check();
      });
      d.deliverTo(function (r) {
        valD = Some(r);
        check();
      });
      e.deliverTo(function (r) {
        valE = Some(r);
        check();
      });
      
      var cancel = function () fut.cancel;
      
      a.ifCanceled(cancel);
      b.ifCanceled(cancel);
      c.ifCanceled(cancel);
      d.ifCanceled(cancel);
      e.ifCanceled(cancel);
      
      return fut;
    }
  }
  
}