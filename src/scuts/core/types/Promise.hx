package scuts.core.types;

import scuts.Assert;
import scuts.core.types.Option;
import scuts.Scuts;

#if scuts_multithreaded
typedef Mutex = #if cpp cpp.vm.Mutex #elseif neko neko.vm.Mutex #else #error "not implemented" #end
#end

private typedef Percent = Float;



// based on stax version of future https://github.com/jdegoes/stax

class Promise<T> 
{
  #if scuts_multithreaded
  var mutex:Mutex;
  #end
  
  var _completeListeners:Array<T->Dynamic>;
  var _cancelListeners:Array<Void->Dynamic>;
  
  var _progressListeners:Array<Percent->Dynamic>;
  
  var _value:Option<T>;
  var _complete:Bool;
  var _cancelled:Bool;

  public inline function isComplete () {
    return _complete;
  }
  public inline function isCancelled () {
    return _cancelled;
  }
  
  public inline function isDone () {
    return _complete || _cancelled;
  }
  
  public function valueOption():Option<T> {
    return _value;
  }
  
  public function value ():T {
    return switch (_value) {
      case Some(v): v;
      case None: Scuts.error("error result is not available");
    }
  }
  
  public function new () 
  {
    #if scuts_multithreaded
    mutex = new Mutex();
    #end
    _complete = false;
    _cancelled = false;
    _value = None;
    _completeListeners = [];
    _cancelListeners = [];
    _progressListeners = [];
  }
  

  public function onProgress (f:Percent->Dynamic) {
    if (isComplete()) {
      f(1.0);
    } else if (!isCancelled()) {
      _progressListeners.push(f);
    } 
    return this;
  }
  
  public function progress (percent:Percent) {
    Assert.assertTrue(percent >= 0.0 && percent <= 1.0);
    for (l in _progressListeners) {
      l(percent);
    }
    return this;
  }
  
  public function complete (val:T) 
  {
    
    if (isComplete()) {
      throw "Cannot set the result of this future more than once";
    }
    
    if (!isCancelled()) {
      
      #if scuts_multithreaded mutex.acquire(); if (!isDone()) { #end
      _value = Some(val);
      _complete = true;

      progress(1.0);
      
      for (r in _completeListeners) {
        r(val);
      }
      _completeListeners = [];
      _cancelListeners = [];
      _progressListeners = [];
      #if scuts_multithreaded } mutex.release(); #end
    } // else ignore value
    
    return this;
  }
  
  public function cancel ():Bool {
    
    return if (!_complete) {
      
      // double check if multithreaded
      #if scuts_multithreaded mutex.acquire(); if (!_canceled) { #end
      _cancelled = true;
      
      for (c in _cancelListeners) {
        c();
      }
      _completeListeners = [];
      _progressListeners = [];
      _cancelListeners = [];
      #if scuts_multithreaded } mutex.release(); #end
      
      true;
    } else {
      false;
    }
  }
  
  public function onComplete (f:T->Dynamic) {
    if (isComplete()) {
      f(value());
    } else if (!isCancelled()) {
      #if scuts_multithreaded mutex.acquire(); if (!_canceled) { #end
      _completeListeners.push(f);
      #if scuts_multithreaded } mutex.release(); #end
    } 
    // ignore listener if cancelled
    
    return this;
  }
  
  public function onCancelled (f:Void->Dynamic) {
    if (!isComplete()) {
      if (isCancelled()) f();
      else {
        #if scuts_multithreaded mutex.acquire(); #end
        _cancelListeners.push(f);
        #if scuts_multithreaded mutex.release(); #end
      }
    }
    // ignore listener if complete
    return this;
  }

}