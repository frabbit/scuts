package scuts.core.types;



import scuts.Assert;


import scuts.core.types.Option;



// based on stax version of future https://github.com/jdegoes/stax

class Future<T> 
{

  
  //#if (!macro && scuts_multithreaded)
  //var mutex:Mutex;
  //#end
  var _listeners:Array<T->Void>;
  var _cancelers:Array<Void->Void>;
  
  
  
  var _result:T;
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
    return _isSet ? Some(_result) : None;
  }
  
  public function value (#if (!macro && scuts_multithreaded) ?block:Bool = false #end):T {
    #if (!macro && scuts_multithreaded)
    //var l = new Lock();
    //mutex.acquire();
    if (block) {
      while (!isDone()) {
        Tasks.processNext();
      }
    }
    //l.release();
    #end
    return _isSet ? _result : throw "error result is not available";
  }
  
  public function new () 
  {
    //#if (!macro && scuts_multithreaded)
    //mutex = new Mutex();
    //#end
    _isSet = false;
    _canceled = false;
    _result = null;
    _listeners = [];
    _cancelers = [];
  }
  

 
  
  public function deliver (t:T) 
  {
    //#if (!macro && scuts_multithreaded) var l = new Lock(); #end
    //#if (!macro && scuts_multithreaded) mutex.acquire(); #end
    if (_isSet) {
      throw "Cannot set the result of this future more than once";
    }
    
    if (!_canceled) {
      
      //#if (!macro && scuts_multithreaded) mutex.acquire(); if (!_canceled) { #end
      _result = t;
      _isSet = true;
      
      
      var v = _result;
      
      for (r in _listeners) {
        r(v);
      }
      _listeners = [];
      _cancelers = [];
      //#if (!macro && scuts_multithreaded) } mutex.release(); #end
    } // else ignore value
    //#if (!macro && scuts_multithreaded) mutex.release(); #end
    //#if (!macro && scuts_multithreaded) l.release(); #end
    return this;
  }
  
  public function cancel ():Bool {
    //#if (!macro && scuts_multithreaded) var l = new Lock(); #end
    return if (!_isSet) {
      
      // double check if multithreaded
      //#if (!macro && scuts_multithreaded) mutex.acquire(); if (!_canceled) { #end
      _canceled = true;
      
      for (c in _cancelers) {
        c();
      }
      _listeners = [];
      _cancelers = [];
      //#if (!macro && scuts_multithreaded) } mutex.release(); #end
      
      true;
    } else {
      false;
    }
    //#if (!macro && scuts_multithreaded) l.release(); #end
  }
  
  public function deliverTo (f:T->Void) {
    //#if (!macro && scuts_multithreaded) var l = new Lock(); #end
    //#if (!macro && scuts_multithreaded) mutex.acquire(); #end
    if (_isSet) {
      f(value());
    } else if (!_canceled) {
      //#if (!macro && scuts_multithreaded) mutex.acquire(); if (!_canceled) { #end
      _listeners.push(f);
      //#if (!macro && scuts_multithreaded) } mutex.release(); #end
    } 
    //#if (!macro && scuts_multithreaded) mutex.release(); #end
    //#if (!macro && scuts_multithreaded) l.release(); #end
    // ignore listener if cancelled
    
    return this;
  }
  
  public function ifCanceled (f:Void->Void) {
    //#if (!macro && scuts_multithreaded) var l = new Lock(); #end
    //#if (!macro && scuts_multithreaded) mutex.acquire(); #end
    if (!_isSet) {
      if (_canceled) f();
      else {
        //#if (!macro && scuts_multithreaded) mutex.acquire(); if (!_canceled) {  #end
        _cancelers.push(f);
        //#if (!macro && scuts_multithreaded) } mutex.release(); #end
      }
    }
    //#if (!macro && scuts_multithreaded) mutex.release(); #end
    //#if (!macro && scuts_multithreaded) l.release(); #end
    // ignore listener if complete
    return this;
  }

}
