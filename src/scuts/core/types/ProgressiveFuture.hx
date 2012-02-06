package scuts.core.types;

import scuts.Assert;
import scuts.core.types.Option;

#if scuts_multithreaded
typedef Mutex = #if cpp cpp.vm.Mutex #elseif neko neko.vm.Mutex #else #error "not implemented" #end
#end

private typedef Percent = Float;



// based on stax version of future https://github.com/jdegoes/stax

class ProgressiveFuture<T> 
{
  #if scuts_multithreaded
  var mutex:Mutex;
  #end
  var _listeners:Array<T->Void>;
  var _cancelers:Array<Void->Void>;
  
  var _progressListeners:Array<Percent->Void>;
  
  
  var _result:Option<T>;
  var _isSet:Bool;
  var _canceled:Bool;

  
  public function isDelivered () {
    return _isSet;
  }
  public function isCanceled () {
    return _canceled;
  }
  
  public function isDone () {
    return _isSet || _canceled;
  }
  
  public function valueOption():Option<T> {
    return _result;
  }
  
  public function value ():T {
    return switch (_result) {
      case Some(v): v;
      case None: throw "error result is not available";
    }
  }
  
  public function new () 
  {
    #if scuts_multithreaded
    mutex = new Mutex();
    #end
    _isSet = false;
    _canceled = false;
    _result = None;
    _listeners = [];
    _cancelers = [];
    _progressListeners = [];
  }
  

  public function onProgress (f:Percent->Void) {
    if (isDelivered()) {
      f(1.0);
    } else if (!isCanceled()) {
      _progressListeners.push(f);
    } 
    return this;
  }
  
  public function setProgress (percent:Percent) {
    Assert.assertTrue(percent >= 0.0 && percent <= 1.0);
    for (l in _progressListeners) {
      l(percent);
    }
    return this;
  }
  
  public function deliver (t:T) 
  {
    
    if (_isSet) {
      throw "Cannot set the result of this future more than once";
    }
    
    if (!_canceled) {
      
      #if scuts_multithreaded mutex.acquire(); if (!isDone()) { #end
      _result = Some(t);
      _isSet = true;
      
      
      var v = value();
      for (p in _progressListeners) {
        p(1.0);
      }
      for (r in _listeners) {
        r(v);
      }
      _listeners = [];
      _cancelers = [];
      _progressListeners = [];
      #if scuts_multithreaded } mutex.release(); #end
    } // else ignore value
    
    return this;
  }
  
  public function cancel ():Bool {
    
    return if (!_isSet) {
      
      // double check if multithreaded
      #if scuts_multithreaded mutex.acquire(); if (!_canceled) { #end
      _canceled = true;
      
      for (c in _cancelers) {
        c();
      }
      _listeners = [];
      _progressListeners = [];
      _cancelers = [];
      #if scuts_multithreaded } mutex.release(); #end
      
      true;
    } else {
      false;
    }
  }
  
  public function deliverTo (f:T->Void) {
    if (_isSet) {
      f(value());
    } else if (!_canceled) {
      #if scuts_multithreaded mutex.acquire(); if (!_canceled) { #end
      _listeners.push(f);
      #if scuts_multithreaded } mutex.release(); #end
    } 
    // ignore listener if cancelled
    
    return this;
  }
  
  public function ifCanceled (f:Void->Void) {
    if (!_isSet) {
      if (_canceled) f();
      else {
        #if scuts_multithreaded mutex.acquire(); #end
        _cancelers.push(f);
        #if scuts_multithreaded mutex.release(); #end
      }
    }
    // ignore listener if complete
    return this;
  }

}