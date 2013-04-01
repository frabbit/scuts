package scuts.reactive;

import scuts.reactive.Reactive;
import scuts.core.Tuples;
// import scuts.core.Tup3;
// import scuts.core.Tup4;
// import scuts.core.Tup5;

using scuts.core.Iterables;

using scuts.reactive.Behaviours;
using scuts.reactive.Streams;

private typedef Beh<T> = Behaviour<T>;

@:allow(scuts.reactive.Streams)
class Stream<T> 
{
  private var _rank: Int;
  private var _sendsTo: Array<Stream<Dynamic>>;
  private var _updater: Pulse<Dynamic> -> Propagation<T>;
  
  private var _weak: Bool;
  
  private var _cleanups: Array<Void -> Void>;
  
  private static function _new<T>(updater: Pulse<Dynamic> -> Propagation<T>, sources: Array<Stream<Dynamic>> = null):Stream<T> 
  {
    return new Stream(updater, sources);
  }
  
  function new(updater: Pulse<Dynamic> -> Propagation<T>, sources: Array<Stream<Dynamic>> = null) 
  {
    this._updater  = updater;

    this._sendsTo  = [];
    this._weak     = false;
    this._rank     = Rank.nextRank();
    this._cleanups = [];
    
    if (sources != null) 
    {
      for (source in sources) 
      {
        source.attachListener(this);
      }
    }
  }
    
  
    
    
}
