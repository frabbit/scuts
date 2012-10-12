/*
 HaXe library written by John A. De Goes <john@socialmedia.com>

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the
 distribution.

 THIS SOFTWARE IS PROVIDED BY SOCIAL MEDIA NETWORKS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOCIAL MEDIA NETWORKS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package scuts.core.reactive;

import scuts.core.reactive.BehavioursBool;
import scuts.core.reactive.Streams;
import scuts.core.types.Tup3;
import scuts.core.types.Tup4;
import scuts.core.types.Tup5;

import scuts.core.reactive.Reactive;

//import haxe.data.collections.Collection;
import scuts.core.reactive.Behaviour;
import scuts.core.reactive.Stream;
import scuts.core.types.Tup2;

using scuts.core.extensions.Iterables;
using scuts.core.reactive.Streams;
using scuts.core.reactive.Behaviours;
//using haxe.data.collections.IterableExtensions;

private typedef Beh<T> = Behaviour<T>;



class Behaviours 
{
  private function new() { }
  
  
  /**
   * Applies a function to a signal's value that 
   * accepts an Stream value and returns the 
   * result as an Stream value.
   *
   * @param   f   The function to apply.
   *
   * @result      A Signal that is the result
   *              of the supplied function. 
   */
  public static function mapC<T>(b:Beh<T>, f: Stream<T> -> Stream<T>): Beh<T> 
  {
    return f(b.changes()).startsWith(b.get());
  }
  
  /**
   * Sends an event to the underlying Stream that will be immediately 
   * propagated with a new timestamp.
   *
   * @param   value   the value to send Into the Stream.
   */
  public static function sendSignalDynamic<T>(b:Beh<T>, value: Dynamic): Void 
  {
    b.changes().sendEventDynamic(value);
  }

  /**
   * Sends an event to the underlying Stream that will be immediately 
   * propagated with a new timestamp.
   *
   * @param   value   the value to send Into the Stream.
   */
  public static function sendSignal<T>(b:Beh<T>,value: T): Void 
  {
    b.changes().sendEvent(value);
  }
  
  @:noUsing public static function constant<T>(value: T): Beh<T> 
  {
    return Streams.identity().startsWith(value);
  }
  
  @:noUsing public static inline function pure<T>(value: T): Beh<T> 
  {
    return constant(value);
  }
  
  
  
  /**
   * Calms the stream. No event will be get through unless it occurs T 
   * milliseconds or more before the following event.
   *
   * @param time  The number of milliseconds.
   */
  public static function calm<T>(b:Beh<T>, time: Int): Beh<T> 
  {
    return b.mapC(function(s) return s.calm(time));
  }
  
  /**
   * Calms the stream. No event will be get through unless it occurs T 
   * milliseconds or more before the following event.
   *
   * @param time  The number of milliseconds as a Signal.
   */
  public static function calmB<T>(b:Beh<T>, time: Beh<Int>): Beh<T> 
  {
    return b.mapC(function(s) return s.calmB(time));
  }
  
  /**
   * Blinds the event stream to events occurring the specified 
   * number of milliseconds together or less.
   *
   * @param time The time to blind the stream to.
   */
  public static function blind<T>(b:Beh<T>, time: Int): Beh<T> 
  {
    return b.mapC(function(s) return s.blind(time));
  }
  
  /**
   * Blinds the event stream to events occurring the specified 
   * number of milliseconds together or less.
   *
   * @param time The time to blind the stream to.
   */
  public static function blindB<T>(b:Beh<T>, time: Beh<Int>): Beh<T> 
  {
    return b.mapC(function(s) return s.blindB(time));
  }
  
  /**
   * Delays this stream by the specified number of milliseconds.
   * 
   * @param   time    Time in milliseconds as an Int
   */
  public static function delay<T>(b:Beh<T>, time: Int): Beh<T> 
  {
    return b.mapC(function(s) return s.delay(time));
  }
  
  /**
   * Delays this stream by the specified number of milliseconds.
   * 
   * @param   time    Time in milliseconds as a Signal
   */
  public static function delayB<T>(b:Beh<T>, time: Beh<Int>): Beh<T> 
  {
    return b.mapC(function(s) return s.delayB(time));
  }
  
  
  /**
   * Applies a function to a value and returns the 
   * result as a Signal.
   *
   * @param   f   A Signal that accepts a T and 
   *              returns a Z.
   *
   * @result      A Signal that is the result
   *              of the supplied function. 
   */
  
  /*
  public static function liftB<T,Z>(b:Beh<T>, f: Beh<T -> Z>): Beh<Z> 
  {
    // uniqueSteps()???
    return b.changes()
    .map(function(a) return f.get()(a))
    .startsWith(f.get()(b.get()));
  }
  */
    
  
	
  /**
   * Zips elements of supplied Signals together and returns a
   * Signal of Tuple2 containing the zipped elements.
   *
   * [1, 2, 3].zip[1, 2, 3] == [Tuple2[1, 1], Tuple2[2, 2], Tuple2[3, 3]]
   *
   * @param b2  The Signal with which to zip 'this' Signal.
   *
   * @return     A Signal Tuple slice containing an element from each 
   *             supplied Signal
   */
  public static function zip<T,B>(b1:Beh<T>, b2: Beh<B>): Beh < Tup2 < T, B >> {
    return b1.zipWith(b2, Tup2.create);
  }
  
  /**
   * Zips elements of supplied Signals together and returns a
   * Signal of Tuple3 containing the zipped elements.
   *
   * @param b2  A Signal to be zipped.
   * @param b3  A Signal to be zipped.
   *
   * @return     A Signal Tuple slice containing an element from each 
   *             Signal
   */
  public static function zip3<T, B, C>(b1:Beh<T>, b2: Beh<B>, b3: Beh<C>): Beh<Tup3<T, B, C>> 
  {
    var createTuple = function() return Tup3.create(b1.get(), b2.get(), b3.get());
    
    return Streams.create(
      function(pulse) return Propagate(pulse.withValue(createTuple())),
      [b1, b2, b3].map(changes)
    ).startsWith(createTuple());
  }
  
  /**
   * Zips elements of supplied Signals together and returns a
   * Signal of Tuple4 containing the zipped elements.
   *
   * @param b2  A Signal to be zipped.
    * @param b3  A Signal to be zipped.
    * @param b4  A Signal to be zipped.
    *
    * @return     A Signal Tuple slice containing an element from each 
    *             Signal
     */
  public static function zip4<T, B, C, D>(b1:Beh<T>, b2: Beh<B>, b3: Beh<C>, b4: Beh<D>): Beh<Tup4<T, B, C, D>> 
  {
    function create()  return Tup4.create(b1.get(), b2.get(), b3.get(), b4.get());
    
    return Streams.create(
      function(pulse) {
        return Propagate(pulse.withValue(create()));
      },
      [b1, b2, b3, b4].map(changes)
    ).startsWith(create());
  }
    
   /**
    * Zips elements of supplied Signals together and returns a
    * Signal of Tuple5 containing the zipped elements.
    *
    * @param b2  A Signal to be zipped.
    * @param b3  A Signal to be zipped.
    * @param b4  A Signal to be zipped.
    * @param b5  A Signal to be zipped.
    *
    * @return     A Signal Tuple slice containing an element from each 
    *             Signal
    */
  public static function zip5<T, B, C, D, E>(b1:Beh<T>,b2: Beh<B>, b3: Beh<C>, b4: Beh<D>, b5: Beh<E>): Beh<Tup5<T, B, C, D, E>> 
  {
    function create() return Tup5.create(b1.get(), b2.get(), b3.get(), b4.get(), b5.get());
    
    return Streams.create(
      function(pulse) return Propagate(pulse.withValue(create())),
      [b1, b2, b3, b4, b5].map(changes)
    ).startsWith(create());
  }
  
  /**
   * Zips together the specified Signals.
   *
   *@param    signals   An Iterable of the 
   *                      Signals to be zipped.
   */
  public static function zipN<T>(b:Beh<T>, behaviours: Iterable<Beh<T>>): Beh<Iterable<T>> 
  {
    return zipIterable(behaviours.cons(b));
  }
  
  /**
   * Zips elements of supplied streams together using a function and returns a
   * Signal of the resulting elements.
   *
   * [1, 2, 3].zipWith([1, 2, 3], Tuple2.create) == [Tuple2[1, 1], Tuple2[2, 2], Tuple2[3, 3]]
   *
   * @param as  The signal with which to zipWith 'this'.
   * @param f  The function that will be used to get the result from the inputs signals ('this' and as).
   *
   * @return     The Signal of the result of the application of the function on using both stream elements as input.
	 * 
   */
  public static function zipWith<T,A, R>(b1:Beh<T>, b2: Beh<A>, f : T -> A -> R): Beh<R> 
  { 
    function create() return f(b1.get(), b2.get());
    
    return Streams.create(
      function(pulse) return Propagate(pulse.withValue(create())),
      [b1, b2].map(changes)
    ).startsWith(create());
  }
  
  public static function zipWith3<T, B, C, X>(b1:Beh<T>, b2: Beh<B>, b3: Beh<C>, f:T->B->C->X): Beh<X> {
    
    function create() return f(b1.get(), b2.get(), b3.get());
    
    return Streams.create(
      function(pulse) return Propagate(pulse.withValue(create())),
      [b1, b2, b3].map(changes)
    ).startsWith(create());
  }
  
  public static function zipWith4<T, B, C, D, X>(b1:Beh<T>, b2: Beh<B>, b3: Beh<C>, b4:Beh<D>, f:T->B->C->D->X): Beh<X> 
  {
    function create() return f(b1.get(), b2.get(), b3.get(), b4.get());
    
    return Streams.create(
      function(pulse) return Propagate(pulse.withValue(create())),
      [b1, b2, b3, b4].map(changes)
    ).startsWith(create());
  }
    
    
  /**
   * Applies a function to a value and returns the 
   * result as a Signal.
   *
   * @param   f   The function to apply.
   *
   * @result      A Signal that is the result
   *              of the supplied function. 
   */
  public static function map<T, Z>(b:Beh<T>, f: T -> Z): Beh<Z> 
  {
    return b.changes().map(f).startsWith(f(b.valueNow()));
  }
  
  public static function apply<A,B>(f:Beh<A->B>, v:Beh<A>):Beh<B> 
  {
    return v.changes()
    .map(function(a) return f.get()(a))
    .startsWith(f.get()(v.get()));
    
    // functor bind apply
    //function z (g:A->B) return map(v, function (x) return g(x));
    //return flatMap( f, z);
  }

  /**
   * Applies a function to a value and returns the 
   * result as a Signal.
   *
   * @param   f   A Signal that accepts a T and 
   *              returns a Z.
   *
   * @result      A Signal that is the result
   *              of the supplied function. 
   */
  public static function mapB<T,Z>(b:Beh<T>, f: Beh<T -> Z>): Beh<Z> 
  {
    return apply(f, b);
  }

  
  /**
   * Returns the Stream underlying the Signal.
   *
   * @result      The underlying Stream.
   */
  public static function changes<T>(b:Beh<T>): Stream<T> 
  {
    return b._underlying;
  }
    
  /**
   * Returns the present value of 'this' Signal. 
   *
   */
  public static function valueNow<T>(b:Beh<T>): T 
  {
    return b._last;
  }
  
  /**
   * Returns the present value of 'this' Signal. 
   *
   */
  public static inline function get<T>(b:Beh<T>): T 
  {
    return valueNow(b);
  }
  
  /**
   * Returns the present value of 'this' Signal. 
   *
   */
  public static function set<T>(b:Beh<T>, x:T):Beh<T> 
  {
    b.sendSignal(x);
    return b;
  }
    
  public static function flatMap<T,Z> (b:Beh<T>, f : T->Beh<Z>):Beh<Z>
  {
    return flatten(b.changes().map(f).startsWith(f(b.valueNow())));
  }
    
  /**
   * Converts an Signal of Signals into
   * a single Signal, whose values represent 
   * those of the last Signal to have an Event.
   *
   * @param   streams     The Signal of 
   *                      Signals to be
   *                      flattened.
   */
  public static function flatten<T>(beh: Beh<Beh<T>>): Beh<T> 
  {
    var init: Beh<T> = beh.get();

    var prevSourceE: Stream<T> = null;

    var receiverE: Stream<T> = Streams.identity();

    //XXX could result in out-of-order propagation! Fix!
    var makerE = Streams.create(
      function(p: Pulse<Beh<T>>): Propagation<Void> 
      {
        if (prevSourceE != null) {
          prevSourceE.removeListener(receiverE);
        }

        prevSourceE = p.value.changes();
        
        prevSourceE.attachListener(receiverE);

        receiverE.sendEventDynamic(p.value.get());
        
        return NotPropagate;
      },
      [beh.changes()]
    );

    makerE.sendEventDynamic(init);

    return receiverE.startsWith(init.get());
  }
    
    /**
     * Switches off a supplied Bool Signal, returning
     * an 'ifTrue' Signal if true or a 'ifFalse' 
     * Signal if false.
     * 
     *
     * @param conditions    An Iterable of Tuple2s, composed of a
     *                      true/false Signals and an 'if true' 
     *                      Signal that will be returned if 
     *                      Tuple._1 == 'true.'
     *
     * @param elseS         The Signal to return if Tuple._1
     *                      == false.
     *
     * @return              An 'ifTrue' Signal if Tuple._1
     *                      == true, else an 'ifFalse' Signal.
     */
    @:noUsing public static function cond<T>(conditions: Iterable<Tup2<Beh<Bool>, Beh<T>>>, elseB: Beh<T>): Beh<T> 
    {
      return switch (conditions.headOption()) 
      {
        case None:    elseB;
        case Some(h): BehavioursBool.ifTrue(h._1, h._2, cond(conditions.tail(), elseB));
      }
    }
    
    /**
     * Zips together the specified Signals.
     *
     *@param    signals   An Iterable of the 
     *                      Signals to be zipped.
     */
    @:noUsing public static function zipIterable<T>(behaviours: Iterable<Beh<T>>): Beh<Iterable<T>> 
    {
      function zipValueNow(): Iterable<T> {
        return behaviours.map(get);
      }
      
      return Streams.create(
        function(pulse) return Propagate(pulse.withValue(zipValueNow())),
        behaviours.map(changes)
      ).startsWith(zipValueNow());
    }
    
    /**
     * Returns the time at a specified time step interval.
     *
     * @param time      The interval at which to sample time.
     */
    @:noUsing public static function sample(time: Int): Beh<Int> 
    {
      return Streams.timer(time).startsWith(Std.int(External.now()));
    }
    
    /**
     * Returns the time step at a specified intverval.
     *
     * @param time      The interval at which to sample time.
     */
    @:noUsing public static function sampleB(time: Beh<Int>): Beh<Int> 
    {
      return Streams.timerB(time).startsWith(Std.int(External.now()));
    }
    
  @:noUsing public static function fromStream<T>(s:Stream<T>, init: T): Beh<T> 
  {
    return Beh._new(
      s,
      init,
      function(pulse: Pulse<Dynamic>): Propagation<T> {
        return Propagate(cast pulse);
      }
    );
  }
}