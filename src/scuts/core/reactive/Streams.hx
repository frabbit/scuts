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

import scuts.core.extensions.Ints;
import scuts.core.reactive.Reactive;
import scuts.core.extensions.Arrays;
import scuts.core.reactive.Stream;
import scuts.core.types.Tup2;
import scuts.core.types.Tup3;
import scuts.core.types.Tup4;
import scuts.core.types.Tup5;
import scuts.Scuts;


using scuts.core.extensions.Iterables;
using scuts.core.extensions.Arrays;
using scuts.core.reactive.Behaviours;
using scuts.core.reactive.Streams;

private typedef Beh<T> = Behaviour<T>;

class Streams 
{
  private function new() { }
  
  /**
   * Creates a new stream with the specified updater and optional sources.
   *
   * @param updater   The updater.
   * @param sources   (Optional) The sources.
   *
   */
  @:noUsing public static function create<I, O>(updater: Pulse<I> -> Propagation<O>, sources: Iterable<Stream<I>> = null): Stream<O> 
  {
    var sourceEvents = if (sources == null) null else (sources.toArray());
    return createRaw(cast updater, sourceEvents);
  }
  
  @:noUsing public static function createRaw<O>(updater: Pulse<Dynamic> -> Propagation<O>, sourceEvents: Array<Stream<Dynamic>>): Stream<O> 
  {
    return Stream._new(updater, sourceEvents);
  }
  
  /**
   * Creates a new stream that merely propagates all pulses it receives.
   *
   * @param sources
   */
  @:noUsing public static function identity<T>(sources: Iterable<Stream<T>> = null): Stream<T> 
  {
    var sourceArray = if (sources == null) null else (Arrays.fromIterable(sources));
    return createRaw(function(pulse) return Propagate(pulse), sourceArray);
  }
  
  
  
  /**
   * Creates an event stream that will never have any events. Calling 
   * sendEvent() on such a stream will throw an exception.
   */
  @:noUsing public static function zero<T>(): Stream<T> 
  {
    return Streams.create(function(pulse: Pulse<Dynamic>): Propagation<T> { 
      
      return Scuts.error('zero : received a value; zeroE should not receive a value; the value was ' + pulse.value);
    });            
  }
  
  /**
   * Creates an event stream that will send a single value.
   */
  @:noUsing public static function one<T>(val: T): Stream<T> 
  {
    var sent = false;
    
    var stream = Streams.create(
      function(pulse) {
        return if (sent) {
          Scuts.error('Streams.one: received an extra value');
        } else {
          sent = false;
          Propagate(pulse);
        }
      }
    );
    
    stream.sendLater(val);
    
    return stream;
  }
  
  /**
   * Merges the specified streams, or returns a zero stream if there are no 
   * streams.
   */
  public static function mergeIterable<T>(streams: Iterable<Stream<T>>): Stream<T> 
  {
    return if (streams.size() == 0) zero();
    else identity(streams);
  }
  
  /**
   * Retrieves a constant stream. If sources are specified, events from the
   * sources will be mapped to the constant.
   *
   * @param value     The constant.
   * @param sources   (Optional) Source streams.
   */
  @:noUsing public static function constantValue<I, O>(value: O, sources: Iterable<Stream<I>> = null): Stream<O> 
  {
    return Streams.create(
      function(pulse) return Propagate(pulse.withValue(value)),
      sources
    );
  }
  
  /**
   * Creates a "receiver" stream whose sole purpose is to be used in 
   * combination with sendEvent().
   */
  public static function receiver <T>():Stream<T> 
  {
    return Streams.identity();
  }
  
  /**
   * Switches off of an Stream of Bools, returning
   * the specified Stream<T> when true
   * 
   *
   * @param conditions    An Iterable of Tuple2s, composed of a
   *                      true/false Stream and an 'if true' 
   *                      Stream that will be returned if 
   *                      Tuple._1 == 'true.'
   *
   * @return              If 'conditions' contains aTuple2._1 
   *                      == 'true', Stream<T> else a
   *                      zero Stream.
   */
  @:noUsing public static function cond<T>(conditions: Iterable<Tup2<Stream<Bool>, Stream<T>>>): Stream<T> 
  {
    return switch (conditions.headOption()) {
        case None:    Streams.zero();
        case Some(h): StreamsBool.ifTrue(h._1, h._2, cond(conditions.tail()));
    }
  }
  
  /**
   * Creates a stream of time events, spaced out by the specified number of
   * milliseconds.
   *
   * @param time The number of milliseconds.
   */
  public static function timer(time: Int): Stream<Int> 
  {
    return timerB(Behaviours.constant(time));
  }
  
  /**
   * Creates a stream of time events, spaced out by the specified number of
   * milliseconds.
   *
   * @param time The number of milliseconds.
   */
  public static function timerB(time: Beh<Int>): Stream<Int> 
  {
    var stream: Stream<Int> = Streams.identity();
    
    var pulser: Void -> Void = null;
    var timer = null;
    
    var createTimer = function() {
      return External.setTimeout(pulser, time.valueNow());
    }
    
    pulser = function() {
      stream.sendEventDynamic(External.now());
      
      if (timer != null) External.cancelTimeout(timer);
      
      if (!stream.weaklyHeld()) {
          timer = createTimer();
      }
    }
    
    timer = createTimer();
    
    return stream;
  }
  
  /**
   * Zips together the specified streams.
   */
  @:noUsing public static function zipIterable<T>(streams: Iterable<Stream<T>>): Stream<Iterable<T>> 
  {
    var stamps = streams.map(function(s) { return -1;   }).toArray();
    var values = streams.map(function(s) { return null; }).toArray();
    
    var output: Stream<T> = Streams.identity();
    
    for (index in 0...streams.size()) {
      var stream = streams.elemAt(index);
      
      output = output.merge(Streams.create(
        function(pulse: Pulse<T>): Propagation<T> {
          stamps[index] = pulse.stamp;
          values[index] = pulse.value;
          
          return Propagate(pulse);
        },
        [stream]
      ));
    }
    
    return Streams.create(
      function (pulse: Pulse<T>): Propagation<Iterable<T>> 
      {
        var stampsEqual = stamps.nub(Ints.eq).size() == 1;
        
        return if (stampsEqual) {
          var iter: Iterable<T> = values.copy();
          
          Propagate(pulse.withValue(iter));
        }
        else NotPropagate;
      },
      [output]
    ).uniqueSteps();
  }
  
  /**
   * Creates a stream of random number events, separated by the specified 
   * number of milliseconds.
   */
  public static function randomB(time: Beh<Int>): Stream<Float> 
  {
    return timerB(time).map(function(e) { return Math.random(); });
  }
  
  /**
   * Creates a stream of random number events, separated by the specified 
   * number of milliseconds.
   */
  public static function random(time: Int): Stream<Float> 
  {
    return randomB(Behaviours.constant(time));
  }
  
  /**
   * Converts an Stream of Streams into
   * a single Stream, whose events represent 
   * those of the last Stream to have an Event.
   *
   * @param   streams     The Stream of 
   *                      Streams to be
   *                      flattened.
   */
  public static function flatten<T>(stream: Stream<Stream<T>>): Stream<T> 
  {
    return stream.flatMap(
      function(stream: Stream<T>): Stream<T> {
          return stream;
      }
    );
  }
  
  /**
   * Converts a collection to a stream, whose events are separated by the 
   * specified amount of time.
   *
   * @param collection    The collection.
   * @param time          The time, in milliseconds.
   *
   */
  @:noUsing public static function fromIterable<T>(collection: Iterable<T>, time: Int): Stream<T> 
  {
    return fromIterableB(collection, Behaviours.constant(time));
  }
  
  /**
   * Converts a collection to a stream, whose events are separated by the 
   * specified amount of time.
   *
   * @param collection    The collection.
   * @param time          The time, as a signal, in milliseconds.
   *
   */
  @:noUsing public static function fromIterableB<T>(collection: Iterable<T>, time: Beh<Int>): Stream<T> 
  {
    var startTime: Float = -1.0;
    var accum = 0;
    
    var iterator = collection.iterator();
    
    if (!iterator.hasNext()) return Streams.zero();
    
    var stream: Stream<T> = Streams.identity();
    
    var pulser: Void -> Void = null;
    var timer = null;

    var createTimer = function() {
      var nowTime = External.now();
      
      if (startTime < 0.0) startTime = nowTime;
      
      var delta = time.valueNow();
      
      var endTime = startTime + accum + delta; 
      
      var timeToWait = endTime - nowTime;
      
      accum += delta;
      
      return if (timeToWait < 0) {
        pulser();
        null;
      }
      else {
        var t = External.setTimeout(pulser, Std.int(timeToWait));
        t;
      }
    }
    
    pulser = function() 
    {
      var next = iterator.next();
      
      stream.sendEventDynamic(next);

      if (timer != null) External.cancelTimeout(timer);

      if (iterator.hasNext()) {
          timer = createTimer();
      }
    }

    timer = createTimer();
    
    return stream;
  }
  
  public static function attachListener<T>(s:Stream<T>, dependent: Stream<Dynamic>): Void 
  {
    s._sendsTo.push(dependent);

    // Rewrite the propagation graph:
    if (s._rank > dependent._rank) {
      var lowest = Rank.lastRank() + 1;
      var q: Array<Stream<Dynamic>> = [dependent];

      while (q.length > 0) {
          var cur = q.splice(0,1)[0];
          
          cur._rank = Rank.nextRank();
          
          q = q.concat(cur._sendsTo);
      }
    }
  }

  public static function removeListener<T>(s:Stream<T>, dependent: Stream<Dynamic>, isWeakReference: Bool = false): Bool 
  {
    var foundSending = false;
    
    for (i in 0...s._sendsTo.length) {
      if (s._sendsTo[i] == dependent) {
          s._sendsTo.splice(i, 1);
          
          foundSending = true;
          
          break;
      }
    }

    if (isWeakReference && s._sendsTo.length == 0) {
      s.setWeaklyHeld(true);
    }

    return foundSending;
  }

  /**
   * Invokes the specified function when this stream is "finished", defined 
   * as being unable to produce any more events.
   */
  public static function whenFinishedDo<T>(s:Stream<T>, f: Void -> Void): Void 
  {
    if (s.weaklyHeld()) {
      f();
    }
    else {
      s._cleanups.push(f);
    }
  }

  /**
   * Calls the specified function for each event.
   */
  public static function each<T>(s:Stream<T>, f: T -> Void): Stream<T> 
  {
    Streams.create(
      function(pulse: Pulse<T>): Propagation<T> {
          f(pulse.value);
          
          return NotPropagate;
      },
      [s]
    );
    
    return s;
  }



  /**
   * Converts the stream to an array. Note: This array will grow 
   * continuously without bound unless clients remove elements from it.
   */
  public static function toArray<T>(s:Stream<T> ): Array<T> 
  {
    var array: Array<T> = [];
    
    s.each(function(e) { array.push(e); });
    
    return array;
  }

  /**
   * Maps this stream to a stream of constant values.
   *
   * @param value The constant that every value will be mapped to.
   *
   */
  public static function constant<Z, T>(s:Stream<T>, value: Z): Stream<Z> 
  {
    return s.map(function(v) return value );
  }

  /**
   * AKA bind. Binds each value to another stream, and returns a 
   * flattened stream.
   *
   * @param k The flatMap function.
   */
  public static function flatMap<Z,T>(s:Stream<T>, k: T -> Stream<Z>): Stream<Z> 
  {
    var m: Stream<T> = s;
    var prevE: Stream<Z> = null;

    var outE: Stream<Z> = Streams.identity();

    var inE: Stream<Dynamic> = Streams.create(
      function (pulse: Pulse<Dynamic>): Propagation<Dynamic> 
      {
        if (prevE != null) {
          prevE.removeListener(outE, true); // XXX This is sloppy
        }
        
        prevE = k(pulse.value);
        
        prevE.attachListener(outE);

        return NotPropagate;
      },
      [m]
    );

    return outE;
  }

  /**
   * Sends an event now. This function should not be used except to create
   * "pure" streams.
   *
   * @param value The value to send.
   */
  public static function sendEventDynamic<T>(s:Stream<T>, value: Dynamic): Stream<T> 
  {
    s.propagatePulse(new Pulse(Stamp.nextStamp(), value));
    return s;
  }

  /**
   * A typed version of sendEvent.
  * Sends an event now. This function should not be used except to create
   * "pure" streams.
   *
   * @param value The value to send.
   */
  public static function sendEvent<T>(s:Stream<T>, value: T): Stream<T> 
  {
    s.propagatePulse(new Pulse(Stamp.nextStamp(), value));
    return s;
  }
  
  public static function send<T>(s:Stream<T>, value: T): Stream<T> 
  {
    return sendEvent(s, value);
  }
  
  public static function apply<A,B>(f:Stream<A->B>, v:Stream<A>):Stream<B> 
  {
    return v.zipWith(f, function (v1,f1) return f1(v1));
  }

  /**
   * Sends an event later. This function should not be used except to create
   * "pure" streams.
   *
   * @param value     The value to send.
   *
   * @param millis    The number of milliseconds to send it in. If this is 0, 
   *                  the event will be scheduled for "as soon as possible".
   *
   */
  public static function sendLaterIn<T>(s:Stream<T>, value: Dynamic, millis: Int): Stream<T> 
  {
    External.setTimeout(
      function() s.sendEventDynamic(value),
      millis
    );
    
    return s;
  }

  /**
   * Sends an event later, "as soon as possible".
   *
   * @param value The value to send.
   */
  public static function sendLater<T>(s:Stream<T>, value: Dynamic): Stream<T> 
  {
    return s.sendLaterIn(value, 0);
  }

  /**
   * Creates a signal backed by this event stream, which starts with the 
   * specified value.
   *
   * @param init  The initial value.
   */
  public static function startsWith<T>(s:Stream<T>, init: T): Beh<T> 
  {
    return Behaviours.fromStream(s, init);
  }

  /**
   * Delays this stream by the specified number of milliseconds.
   *
   * @param   time    Time in milliseconds as an Int
   */
  public static function delay<T>(s:Stream<T>, time: Int): Stream<T> 
  {
    var resE = Streams.identity();

    Streams.create(
      function(pulse)
      { 
        resE.sendLaterIn(pulse.value, time);
        return NotPropagate;
      },
      [s]
    );

    return resE;
  }

  /**
   * Delays this stream by the specified number of milliseconds.
   * 
   * @param   time    Time in milliseconds as a Signal
   */
  public static function delayB<T>(s:Stream<T>, time: Beh<Int>): Stream<T> 
  {
    var receiverEE = Streams.identity();
    
    var link = {
      from:    s, 
      towards: s.delay(time.valueNow())
    };

    // XXX: event is not guaranteed to output
    var switcherE = Streams.create(
      function (pulse: Pulse<Int>): Propagation<Int> {
        link.from.removeListener(link.towards); 
        
        link = {
            from:    s, 
            towards: s.delay(pulse.value)
        };
        
        receiverEE.sendEventDynamic(link.towards);
        
        return NotPropagate;
      },
      [time.changes()]
    );
    
    
    var resE = Streams.flatten(receiverEE);
    
    switcherE.sendEventDynamic(time.valueNow());
    
    return resE;
  }

  /**
   * Calms the stream. No event will be fired unless it occurs T milliseconds
   * after the prior event.
   *
   * @param time  The number of milliseconds.
   */
  public static function calm<T>(s:Stream<T>, time: Int): Stream<T> 
  {
    return s.calmB(Behaviours.constant(time));
  }

  /**
   * Calms the stream. No event will be get through unless it occurs T 
   * milliseconds or more before the following event.
   *
   * @param time  The number of milliseconds.
   */
  public static function calmB<T>(s:Stream<T>, time: Beh<Int>): Stream<T> 
  {
    var out: Stream<T> = Streams.identity();
  
    var towards: Timeout = null;
  
    Streams.create(
      function (pulse: Pulse<T>): Propagation<T> 
      {
        if (towards != null) 
        {
          External.cancelTimeout(towards);
        }
        
        towards = External.setTimeout(
          function() 
          {
            towards = null;
            
            out.sendEventDynamic(pulse.value);
          },
          time.valueNow()
        );
        
        return NotPropagate;
      },
      [s]
    );
    
    return out;
  }

  /**
   * Blinds the event stream to events occurring less than the specified 
   * milliseconds together.
   *
   * @param time The time to blind the stream to.
   */
  public static function blind<T>(s:Stream<T>, time: Int): Stream<T> 
  {
    return s.blindB(Behaviours.constant(time));
  }

  /**
   * Blinds the event stream to events occurring the specified 
   * number of milliseconds together or less.
   *
   * @param time The time to blind the stream to.
   */
  public static function blindB<T>(s:Stream<T>, time: Beh<Int>): Stream<T> 
  {
    var lastSent = External.now() - time.valueNow() - 1;
    
    return Streams.create(            
      function (p: Pulse<T>): Propagation<T> 
      {
        var curTime = External.now();
        
        if (curTime - lastSent > time.valueNow()) { // XXX What happens if signal time decreases, then we "owe" a prior event???
          lastSent = curTime;
          
          return Propagate(p);
        }
        else { 
          return NotPropagate;
        }
      },
      [s]
    );
  }

  /**
   * Maps this stream into a stream of values determined by "snapshotting" 
   * the value of the signal.
   *
   * @param value The value.
   */
  public static function snapshot<Z,T>(s:Stream<T>, value: Beh<Z>): Stream<Z> 
  {
    return s.map(function(t) return value.valueNow());
  }

  /**
   * Filters adjacent repeats.
   *
   * @param optStart  An optional start value.
   */
  /*
  public function filterRepeats(?optStart: T, eq:T->T->Bool): Stream<T> {                     
    return filterRepeatsBy(optStart, function(v1, v2) return eq(v1, v2));
  }
  */

  /**
   * Filters adjacent repeats.
   *
   * @param optStart  An optional start value.
   * @param eq        An equality function.
   */
  public static function filterRepeatsBy<T>(s:Stream<T>, ?optStart: T, eq: T -> T -> Bool): Stream<T> 
  {
    var hadFirst = optStart == null ? false : true;
    var prev     = optStart;
    
    return s.filter(
      function(v) 
      {
        return if (!hadFirst || !eq(prev,v)) {
          hadFirst = true;
          prev     = v;
          
          true;
        }
        else false;
      }
    );
  }

  /**
   * Maps this stream to another stream by using the specified function.
   *
   * @param mapper    The mapping function.
   */
  public static function map<Z, T>(s:Stream<T>, mapper: T -> Z): Stream<Z> 
  { 
    return Streams.create(
      function(pulse: Pulse<T>): Propagation<Z> 
      {
        return Propagate(pulse.map(mapper));
      },
      [s]
    );
  }
  
  
  
  /**
   * A stream of values resulting from left folding.
   *
   * @param initial   The initial value.
   * @param folder    The folding function.
   */
  public static function scanl<Z, T>(s:Stream<T>, initial: Z, folder: Z -> T -> Z): Stream<Z> 
  {
    var acc = initial;
    
    return s.map(
      function (n: T): Z 
      {
        var next = folder(acc, n);
        
        acc = next;
        
        return next;
      }
    );
  }

  /**
   * Same as scanl, but without an initial value.
   */
  public static function scanlP<T>(s:Stream<T>, folder: T -> T -> T): Stream<T> 
  { 
    var acc = null;
    
    return s.map(
      function (n: T): T 
      {
        var next: T;
        
        if (acc != null) {
          next = folder(acc, n);
        }
        else {
          next = n;
        }
        
        acc = next;
        
        return next;
      }
    );
  }

  /**
   * Returns a finite stream consisting of the first n elements of this 
   * stream.
   *
   * @param n The number of values.
   */
  public static function take<T>(s:Stream<T>, n: Int): Stream<T> 
  {
    var count = n;

    return Streams.create(
      function(pulse: Pulse<Dynamic>): Propagation<T> 
      {
        return if (count > 0) { 
          --count; 
          Propagate(pulse); 
        }
        else {
          s.setWeaklyHeld(true);
          NotPropagate;
        }
      },
      [s]
    );
  }

  /**
   * Returns a finite stream consisting of the first subset of this stream
   * for which the filter returns true.
   *
   * @param n The number of values.
   */
  public static function takeWhile<T>(s:Stream<T>, filter: T -> Bool): Stream<T> 
  {
    var stillChecking = true;
    
    
    return Streams.create(
      function(pulse: Pulse<Dynamic>): Propagation<T> 
      {
        return if (stillChecking) 
        {
          if (filter(pulse.value)) 
            Propagate(pulse)
          else 
          {
            stillChecking = false;
            s.setWeaklyHeld(true);
            NotPropagate;
          }
        }
        else NotPropagate;
      },
      [s]
    );
  }

  /**
   * Shifts events forward in time by the specified number of events.
   * 
   * @param n The number of events to shift by.
   */
  public static function shift<T>(s:Stream<T>, n: Int): Stream<T> 
  {
    var queue: Array<T> = [];
    
    return Streams.create(
      function(pulse: Pulse<T>): Propagation<T> 
      {
        queue.push(pulse.value);
        
        return 
          if (queue.length <= n) NotPropagate;
          else Propagate(pulse.withValue(queue.shift()));
      },
      [s]
    );
  }

  /**
   * Shifts events forward in time until the specified predicate returns 
   * false for an event.
   *
   * @param pred  The predicate.
   */
  public static function shiftWhile<T>(s:Stream<T>, pred: T -> Bool): Stream<T> 
  {
    var queue: Array<T> = [];
    
    var checking = true;
    
    return Streams.create(
      function(pulse: Pulse<T>): Propagation<T> 
      {
        queue.push(pulse.value);
        
        return if (checking) 
        {
          if (pred(pulse.value)) NotPropagate;
          else 
          {
            checking = false;
            Propagate(pulse.withValue(queue.shift()));
          }
        }
        else Propagate(pulse.withValue(queue.shift()));
      },
      [s]
    );
  }

  /**
   * Shifts events forward in time by pulling from the specified iterable
   * until it's exhausted, then streaming the delayed events.
   *
   * @param elements  The elements to use in time shifting.
   */
  public static function shiftWith<T>(s:Stream<T>, elements: Iterable<T>): Stream<T> 
  {
    var queue: Array<T> = elements.toArray();
    
    var n = queue.length;
    
    return Streams.create(
      function(pulse: Pulse<T>): Propagation<T> 
      {
        queue.push(pulse.value);
        
        return 
          if (queue.length <= n) NotPropagate;
          else Propagate(pulse.withValue(queue.shift()));
      },
      [s]
    );
  }

  /**
   * Drops the specified number of events from this stream. This method does
   * not change the timestamps of events.
   *
   * @param n The number to drop.
   */
  public static function drop<T>(s:Stream<T>, n: Int): Stream<T> 
  {
    var count = n;
    
    return Streams.create(
      function(pulse: Pulse<T>): Propagation<T> {
        return 
          if (count > 0) { --count; NotPropagate; }
          else Propagate(pulse);
      },
      [s]
    );
  }

  /**
   * Drops events for as long as the predicate returns true.
   *
   * @param pred  The predicate.
   */
  public static function dropWhile<T>(s:Stream<T>, pred: T -> Bool): Stream<T> 
  {
    var checking = true;
    
    return Streams.create(
      function(pulse: Pulse<T>): Propagation<T> {
        return if (checking) {
          if (pred(pulse.value)) NotPropagate;
          else {
            checking = false;
               
            Propagate(pulse);
          }
        }
        else Propagate(pulse);
      },
      [s]
    );
  }

  /**
   * Partitions the stream into two event streams, one for which the 
   * predicate is true, one for which the predicate is false.
   *
   * @param pred  The predicate.
   */
  public static function partition<T>(s:Stream<T>, pred: T -> Bool): Tup2<Stream<T>, Stream<T>> 
  { 
    var trueStream = Streams.create(
      function(pulse: Pulse<T>): Propagation<T> {
          return if (pred(pulse.value)) Propagate(pulse); else NotPropagate;
      },
      [s]
    );
    
    var falseStream = Streams.create(
      function(pulse: Pulse<T>): Propagation<T> {
          return if (!pred(pulse.value)) Propagate(pulse); else NotPropagate;
      },
      [s]
    );
    
    return Tup2.create(trueStream, falseStream);
  }

  /**
   * Returns a tuple of takeWhile/dropWhile for the specified predicate.
   *
   * @param pred  The predicate.
   */
  public static function partitionWhile<T>(s:Stream<T>, pred: T -> Bool): Tup2<Stream<T>, Stream<T>> 
  { 
    var trueStream  = s.takeWhile(pred);
    var falseStream = s.dropWhile(pred);
    
    return Tup2.create(trueStream, falseStream);
  }

  /**
   * Filters this stream by the specified predicate.
   *
    * @param pred The predicate.
    */
  public static function filter<T>(s:Stream<T>, pred: T -> Bool): Stream<T> 
  {
    return Streams.create(
      function(pulse: Pulse<Dynamic>): Propagation<T> 
      {
        return if (pred(pulse.value)) Propagate(pulse); else NotPropagate;
      },
      [s]
    );
  }

  /**
   * Accepts all elements until the predicate first returns false.
   *
   * @param pred  The predicate.
   */
  public static function filterWhile<T>(s:Stream<T>, pred: T -> Bool): Stream<T> 
  { 
    var checking = true;

    return Streams.create(
      function(pulse: Pulse<Dynamic>): Propagation<T> 
      {
        return if (checking) {
          if (pred(pulse.value)) {
            Propagate(pulse);
          }
          else {
            checking = false;
            
            s.setWeaklyHeld(true);
            
            NotPropagate;
          }
        }
        else NotPropagate;
      },
      [s]
    );
  }

  /**
   * Zips elements of supplied streams together using a function and returns a
   * Stream of the resulting elements.
   *
   * [1, 2, 3].zipWith([1, 2, 3], Tuple2.create) == [Tuple2[1, 1], Tuple2[2, 2], Tuple2[3, 3]]
   *
   * @param as  The stream with which to zipWith 'this'.
   * @param f  The function that will be used to get the result from the inputs streams ('this' and as).
   *
   * @return     The Stream of the result of the application of the function on using both stream elements as input.
  * 
   */
  public static function zipWith<A, R, T>(s:Stream<T>, as: Stream<A>, f : T -> A -> R): Stream<R> 
  { 
    var testStamp = -1;
    
    var value1: T = null;

    Streams.create(
      function(pulse: Pulse<T>): Propagation<T> { 
        testStamp = pulse.stamp; 
        
        value1 = pulse.value; 
        
        return NotPropagate; 
      },
      [s]
    );
     
    return Streams.create(
      function(pulse: Pulse<A>): Propagation<R> { 
        return if (testStamp == pulse.stamp) 
          Propagate(pulse.withValue(f(value1, pulse.value))) 
        else NotPropagate;
      },
      [as]
    );
  }

  /**
   * Zips elements of supplied streams together and returns an
   * Stream of Tuple2 containing the zipped elements.
   *
   * [1, 2, 3].zip[1, 2, 3] == [Tuple2[1, 1], Tuple2[2, 2], Tuple2[3, 3]]
   *
   * @param as  The stream with which to zip 'this'.
   *
   * @return     A Tuple slice containing an element from each 
   *             stream
   */
  public static function zip<A,T>(s:Stream<T>, as: Stream<A>): Stream < Tup2 < T, A >> 
  {
    return s.zipWith(as, Tup2.create);
  }

  /**
   * Zips elements of supplied streams together and returns an
   * Stream of Tuple3 containing the zipped elements.
   *
   * [1, 2, 3].zip([1, 2, 3], [1, 2, 3]) == [Tuple3[1, 1, 1], Tuple3[2, 2, 2], Tuple3[3, 3, 3]]
   *
   * @param as  The a stream with which to zip 'this'.
   * @param bs  The b stream with which to zip 'this' and as.
   *
   * @return     A Tuple slice containing an element from each 
   *             stream
   */
  public static function zip3<A, B, T>(s:Stream<T>, as: Stream<A>, bs: Stream<B>): Stream<Tup3<T, A, B>> 
  { 
    var streams: Array<Dynamic> = [];
    
    streams.push(s);
    streams.push(as);
    streams.push(bs);
    
    return Streams.zipIterable(streams).map(function(i: Iterable<Dynamic>): Tup3<T, A, B> { return Tup3.create(i.elemAt(0), i.elemAt(1), i.elemAt(2)); });
  }

  public static function zipWith3<A, B,X,T>(s:Stream<T>, as: Stream<A>, bs: Stream<B>, f:T->A->B->X): Stream<X> 
  { 
    var streams: Array<Dynamic> = [];
    
    streams.push(s);
    streams.push(as);
    streams.push(bs);
    
    return Streams.zipIterable(streams).map(function(i: Iterable<Dynamic>): X { return f(i.elemAt(0), i.elemAt(1), i.elemAt(2)); });
  }

  public static function zipWith4<A, B,C, X,T>(s:Stream<T>, as: Stream<A>, bs: Stream<B>, cs:Stream<C>, f:T->A->B->C->X): Stream<X> 
  { 
    var streams: Array<Dynamic> = [];
    
    streams.push(s);
    streams.push(as);
    streams.push(bs);
    streams.push(cs);
    
    return Streams.zipIterable(streams).map(function(i: Iterable<Dynamic>): X { 
      return f(i.elemAt(0), i.elemAt(1), i.elemAt(2), i.elemAt(3)); 
    });
  }

  /**
   * Zips elements of supplied streams together and returns an
   * Stream of Tuple4 containing the zipped elements.
   *
   * For example see above
   *
   * @param as  The a stream with which to zip 'this'.
   * @param bs  The b stream with which to zip 'this' and as.
   * @param cs  The c stream with which to zip 'this,' as, and bs.
   *
   * @return     A Tuple slice containing one element from each 
   *             stream
   */
  public static function zip4<A, B, C, T>(s:Stream<T>, as: Stream<A>, bs: Stream<B>, cs: Stream<C>): Stream<Tup4<T, A, B, C>> 
  { 
    var streams: Array<Dynamic> = [];
    
    streams.push(s);
    streams.push(as);
    streams.push(bs);
    streams.push(cs);
    
    return Streams.zipIterable(streams).map(function(i: Iterable<Dynamic>): Tup4<T, A, B, C> { 
      return Tup4.create(i.elemAt(0), i.elemAt(1), i.elemAt(2), i.elemAt(3)); 
    });
  }

  /**
   * Zips elements of supplied streams together and returns an
   * Stream of Tuple5 containing the zipped elements.
   *
   * For example see above
   *
   * @param as  The a stream with which to zip 'this'.
   * @param bs  The b stream with which to zip 'this' and as.
   * @param cs  The c stream with which to zip 'this,' as, and bs.
   * @param ds  The d stream with which to zip 'this,' as, bs, and cs.
   *
   * @return     A Tuple slice containing one element from each 
   *             stream
   */
  public static function zip5<A, B, C, D, T>(s:Stream<T>, as : Stream<A>, bs: Stream<B>, cs: Stream<C>, ds: Stream<D>): Stream<Tup5<T, A, B, C, D>> 
  { 
    var streams: Array<Dynamic> = [];
    
    streams.push(s);
    streams.push(as);
    streams.push(bs);
    streams.push(cs);
    streams.push(ds);
    
    return Streams.zipIterable(streams).map(function(i: Iterable<Dynamic>) { 
      return Tup5.create(i.elemAt(0), i.elemAt(1), i.elemAt(2), i.elemAt(3), i.elemAt(4)); 
    });
  }

  /**
   * Groups Stream elements which are sent
   * sequentially and are == to each other into
   * iterables and returns these in a new stream
   *
   * @return     An Stream of grouped elements
   */
  public static function group<T>(s:Stream<T>): Stream<Iterable<T>> 
  {
    return groupBy(s,function(e1, e2) { return e1 == e2; });
  }

  /**
   * Groups Stream elements which are sent
   * sequentially and which return true from the
   * supplied comparison function into iterables
   * and returns these in a new stream
   *
   * @param   eq      The comparison function that
   *                  will be used fo evaluate the 
   *                  equality of the stream
   *                  elements.
   *
   * @return     An Stream of grouped elements
   */
  public static function groupBy<T>(s:Stream<T>, eq: T -> T -> Bool): Stream<Iterable<T>> 
  { 
    var prev = null;
    
    var cur: Array<T> = [];
    
    return Streams.create(
      function(pulse: Pulse<T>): Propagation<Iterable<T>> 
      {
        var ret: Propagation<Iterable<T>> = NotPropagate;
        
        if (prev != null) 
        {
          if (!eq(prev, pulse.value)) 
          {
            var iter: Iterable<T> = cur;
            
            ret = Propagate(pulse.withValue(iter));
            
            cur = [];
            
            cur.push(pulse.value);
            
            prev = null;
          }
          else cur.push(pulse.value);
        }
        else cur.push(pulse.value);
        
        prev = pulse.value;
        
        return ret;
      },
      [s]
    );
  }

  /**
   * Merges this stream and the specified stream.
   *
   * @param that  The Stream with which to 
   *              merge 'this' stream
   */
  public static function merge<T>(s:Stream<T>, that: Stream<T>): Stream<T> 
  {
    return Streams.create(function(p) return Propagate(p), [s, that]);
  }
  
  /**
   * Creates a new Stream in which only events on 
   * different time steps will appear
   *
   */
  public static function uniqueSteps<T>(s:Stream<T>): Stream<T> 
  {
    var lastStamp = -1;
    
    return Streams.create(
      function(pulse: Pulse<T>): Propagation<T> 
      {
        return if (pulse.stamp != lastStamp) 
        {
          lastStamp = pulse.stamp;
          Propagate(pulse);
        }
        else NotPropagate;
      },
      [s]
    );
  }

  /**
   * Creates a new Stream in which only new events
   * will appear (including those on the same time step)
   *
   * @param eq  The Function used to check event equality
   */
  public static function uniqueEvents<T>(s:Stream<T>, ?eq: T -> T -> Bool): Stream<T> 
  {
    if (eq == null) eq = function(e1, e2) { return e1 == e2; }
    
    var lastEvent: T = null;
    
    return Streams.create(
      function(pulse: Pulse<T>): Propagation<T> 
      {
        return if (lastEvent==null || !eq(pulse.value, lastEvent)) 
        {
          lastEvent = pulse.value;
          Propagate(pulse);
        }
        else NotPropagate;
      },
      [s]
    );
  }
  /**
   * Creates a new Stream in which only unique events
   * taking place at unique timesteps will appear
   *
   * @param eq  The Function used to check event equality
   */
  public static function unique<T>(s:Stream<T>, ?eq: T -> T -> Bool): Stream<T> 
  {
    return s.uniqueSteps().uniqueEvents(eq);
  }

  private static function propagatePulse<T>(s:Stream<T>, pulse: Pulse<Dynamic>) 
  {
    // XXX Change so that we won't propagate more than one value per time step???
    var queue = new PriorityQueue<{stream: Stream<Dynamic>, pulse: Pulse<Dynamic>}>();
    

    queue.insert({k: s._rank, v: {stream: s, pulse: pulse}});
    
    while (queue.length() > 0) 
    {
      var qv = queue.pop();
      
      var stream = qv.v.stream;
      var pulse  = qv.v.pulse;
      
      var propagation = stream._updater(pulse);
      
      switch (propagation) 
      {
        case Propagate(nextPulse): 
          
          var weaklyHeld = true;
          
          for (recipient in stream._sendsTo) 
          {
            weaklyHeld = weaklyHeld && recipient.weaklyHeld();
        
            queue.insert(
              {
                k: recipient._rank,
                v: { stream: recipient, pulse:  nextPulse }
              }
            );
          }
          if (stream._sendsTo.length > 0 && weaklyHeld) {
              stream.setWeaklyHeld(true);
          }
        case NotPropagate:
      }
    }
  }
  
  public static function setWeaklyHeld<T>(s:Stream<T>, held: Bool): Bool 
  {
    if (s._weak != held) 
    {
      s._weak = held;
  
      if (!held) 
      {
        for (cleanup in s._cleanups) cleanup();
        s._cleanups = [];
      }
    }
    
    return s._weak;
  }

  public static function weaklyHeld<T>(s:Stream<T>): Bool 
  {
    return s._weak;
  }
}