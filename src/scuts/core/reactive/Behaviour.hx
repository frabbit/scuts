package scuts.core.reactive;

import scuts.core.reactive.Reactive;
import scuts.core.reactive.Streams;
import scuts.core.Tup3;
import scuts.core.Tup4;
import scuts.core.Tup5;

using scuts.core.reactive.Behaviours;
using scuts.core.reactive.Streams;

private typedef Beh<T> = Behaviour<T>;

@:allow(scuts.core.reactive.Behaviours)
class Behaviour<T> 
{
  private var _underlyingRaw: Stream<Dynamic>;
  private var _underlying:    Stream<T>;
  private var _updater:       Pulse<Dynamic> -> Propagation<T>;
  
  private var _last: T;
  
  private static function _new <T>(stream: Stream<Dynamic>, init: T, updater: Pulse<Dynamic> -> Propagation<T>):Behaviour<T> 
  {
    return new Behaviour(stream, init, updater);
  }
  
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