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
package scuts.reactive;


import scuts.core.Promises;
import scuts.reactive.BehavioursBool;
import scuts.core.Tuples;

import scuts.reactive.Reactive;
import scuts.reactive.StreamSubscriptions.StreamSubscription;

using scuts.core.Iterables;
using scuts.reactive.Streams;
using scuts.reactive.Behaviours;

using scuts.core.Functions;

private typedef Beh<T> = Behaviour<T>;


abstract BehaviourSource<T>(Beh<T>) to Beh<T> {
  @:allow(scuts.reactive.Behaviours) function new (b:Beh<T>) this = b;

  public var stream(get, never):Stream<T>;

  inline function get_stream () return this.stream;
}


@:allow(scuts.reactive)
class Behaviour<T>
{
  private var _underlyingRaw: Stream<Dynamic>;
  private var _underlying:    Stream<T>;
  private var _updater:       Pulse<Dynamic> -> Propagation<T>;

  private var _last: T;

  public var stream(get, null):Stream<T>;

  public function get_stream () return _underlying;

  function new(stream: Stream<Dynamic>, init: T, updater: Pulse<Dynamic> -> Propagation<T>)
  {
    this._last          = init;
    this._underlyingRaw = stream;
    this._updater       = updater;

    var self = this;

    this._underlying = Streams.create(
      function(pulse)
      {
        return switch (updater(pulse))
        {
          case Propagate(newPulse):
            self._last = newPulse.value;
            Propagate(newPulse);
          case NotPropagate:
            NotPropagate;
        }
      },
      // [stream]???
      [stream.uniqueSteps()]
    );
  }


}


class Behaviours
{
  @:noUsing public static function source <T>(init:T):BehaviourSource<T>
  {
    return new BehaviourSource(Streams.source().asBehaviour(init));
  }

  public static function set <T> (b:BehaviourSource<T>, val:T) {
      return Streams.send(b.stream, val);
  }

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
    return f(b.stream).asBehaviour(b.get());
  }



  @:noUsing public static function constant<T>(value: T): Beh<T>
  {
    return Streams.constantValue(value).asBehaviour(value);
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
   * @param time  The number of milliseconds as a Behaviour.
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
   * @param   time    Time in milliseconds as a Behaviour
   */
  public static function delayB<T>(b:Beh<T>, time: Beh<Int>): Beh<T>
  {
    return b.mapC(function(s) return s.delayB(time));
  }

  public static function uniqueEvents<T>(s:Behaviour<T>, ?eq: T -> T -> Bool): Behaviour<T>
  {
    return s.stream.uniqueEvents(eq).toBehaviour(s.get());
  }

  public static function applyTo <T>(s:Behaviour<T>, f:T->Void):StreamSubscription
  {


    f(s.get());
    return s.stream.listen(f);
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
    return b.stream
    .map(function(a) return f.get()(a))
    .asBehaviour(f.get()(b.get()));
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
      [cast b1.stream, cast b2.stream, cast b3.stream]
    ).asBehaviour(createTuple());
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
      [cast b1.stream, cast b2.stream, cast b3.stream, cast b4.stream]
    ).asBehaviour(create());
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
      [cast b1.stream, cast b2.stream, cast b3.stream, cast b4.stream, cast b5.stream]
    ).asBehaviour(create());
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
      [cast b1.stream, cast b2.stream]
    ).asBehaviour(create());

  }

  public static function zipWith3<T, B, C, X>(b1:Beh<T>, b2: Beh<B>, b3: Beh<C>, f:T->B->C->X): Beh<X> {

    function create() return f(b1.get(), b2.get(), b3.get());

    return Streams.create(
      function(pulse) return Propagate(pulse.withValue(create())),
      [cast b1.stream, cast b2.stream, cast b3.stream]
    ).asBehaviour(create());
  }

  public static function zipWith4<T, B, C, D, X>(b1:Beh<T>, b2: Beh<B>, b3: Beh<C>, b4:Beh<D>, f:T->B->C->D->X): Beh<X>
  {
    function create() return f(b1.get(), b2.get(), b3.get(), b4.get());

    return Streams.create(
      function(pulse) return Propagate(pulse.withValue(create())),
      [cast b1.stream, cast b2.stream, cast b3.stream, cast b4.stream]
    ).asBehaviour(create());
  }

  public static function zipWith5<T, B, C, D,E, X>(b1:Beh<T>, b2: Beh<B>, b3: Beh<C>, b4:Beh<D>, b5:Beh<E>, f:T->B->C->D->E->X): Beh<X>
  {
    function create() return f(b1.get(), b2.get(), b3.get(), b4.get(), b5.get());

    return Streams.create(
      function(pulse) return Propagate(pulse.withValue(create())),
      [cast b1.stream, cast b2.stream, cast b3.stream, cast b4.stream, cast b5.stream]
    ).asBehaviour(create());
  }

  public static function zipWith6<T, B, C, D,E, F, X>(b1:Beh<T>, b2: Beh<B>, b3: Beh<C>, b4:Beh<D>, b5:Beh<E>,b6:Beh<F>, f:T->B->C->D->E->F->X): Beh<X>
  {
    function create() return f(b1.get(), b2.get(), b3.get(), b4.get(), b5.get(), b6.get());

    return Streams.create(
      function(pulse) return Propagate(pulse.withValue(create())),
      [cast b1.stream, cast b2.stream, cast b3.stream, cast b4.stream, cast b5.stream, cast b6.stream]
    ).asBehaviour(create());
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
    return b.stream.map(f).asBehaviour(f(b.get()));
  }

  public static function map2<T1,T2, Z>(b:Beh<Tup2<T1,T2>>, f: T1->T2 -> Z): Beh<Z>
  {
    return map(b, f.tupled());
  }

  public static function map3<T1,T2,T3, Z>(b:Beh<Tup3<T1,T2,T3>>, f: T1->T2->T3 -> Z): Beh<Z>
  {
    return map(b, f.tupled());
  }

  public static function apply<A,B>(f:Beh<A->B>, v:Beh<A>):Beh<B>
  {
    return v.stream
    .map(function(a) return f.get()(a))
    .asBehaviour(f.get()(v.get()));

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


  /**
   * Returns the present value of 'this' Signal.
   *
   */
  public static inline function get<T>(b:Beh<T>): T
  {
    return b._last;
  }

  public static function flatMap<T,Z> (beh:Beh<T>, f : T->Beh<Z>):Beh<Z>
  {
    var init: T = beh.get();

    var currentSource: Stream<Z> = null;

    var receiverE: Stream<Z> = Streams.identity();

    //XXX could result in out-of-order propagation! Fix!
    var makerE:Stream<T> = Streams.create(
      function(p: Pulse<T>): Propagation<T>
      {
        if (currentSource != null) {
          currentSource.removeListener(receiverE);
        }
        var b = f(p.value);
        currentSource = b.stream;

        currentSource.attachListener(receiverE);
        receiverE.send(b.get());

        return NotPropagate;
      },
      [beh.stream]
    );

    makerE.send(init);

    var initZ = f(init).get();
    return receiverE.asBehaviour(initZ);
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
      function(p: Pulse<Beh<T>>): Propagation<Beh<T>>
      {
        if (prevSourceE != null) {
          prevSourceE.removeListener(receiverE);
        }

        prevSourceE = p.value.stream;

        prevSourceE.attachListener(receiverE);
        var newVal = p.value.get();

        receiverE.send(newVal);

        return NotPropagate;
      },
      [beh.stream]
    );

    makerE.send(init);

    return receiverE.asBehaviour(init.get());
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
      ).asBehaviour(zipValueNow());
    }

    /**
     * Returns the time at a specified time step interval.
     *
     * @param time      The interval at which to sample time.
     */
    @:noUsing public static function sample(time: Int): Beh<Int>
    {
      return Streams.timer(time).asBehaviour(Std.int(External.now()));
    }

    /**
     * Returns the time step at a specified intverval.
     *
     * @param time      The interval at which to sample time.
     */
    @:noUsing public static function sampleB(time: Beh<Int>): Beh<Int>
    {
      return Streams.timerB(time).asBehaviour(Std.int(External.now()));
    }

  @:noUsing public static function fromStream<T>(s:Stream<T>, init: T): Beh<T>
  {
    return new Beh(
      s,
      init,
      function(pulse: Pulse<Dynamic>): Propagation<T> {
        return Propagate(cast pulse);
      }
    );
  }
}
