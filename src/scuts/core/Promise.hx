package scuts.core;

import scuts.core.debug.Assert;
import scuts.core.Options;
import scuts.core.Option;
import scuts.Scuts;

using scuts.core.Options;

#if scuts_multithreaded
typedef Mutex = 
  #if 
  cpp cpp.vm.Mutex 
  #elseif neko 
  neko.vm.Mutex 
  #else 
  #error "not implemented" 
  #end

#end

private typedef Percent = Float;

class Promise<T> 
{
  
  #if scuts_multithreaded
  var mutex:Mutex;
  #end
  
  inline function lock () 
  {
    #if scuts_multithreaded
    mutex.acquire(); 
    #end
  }
  
  inline function unlock () 
  {
    #if scuts_multithreaded 
    mutex.release(); 
    #end
  }
  
  inline function initMutex () 
  {
    #if scuts_multithreaded
    mutex = new Mutex();
    #end
    
  }
  
  inline function isCompleteDoubleCheck() 
  {
    #if scuts_multithreaded
    return isCompleteDoubleCheck();
    #else
    return false;
    #end
  }
  
  inline function isDoneDoubleCheck() 
  {
    #if scuts_multithreaded
    return isDone();
    #else
    return false;
    #end
  }
  
  inline function isCancelledDoubleCheck() 
  {
    #if scuts_multithreaded
    return isCancelled();
    #else
    return false;
    #end
  }
  
  
  var _completeListeners:Array<T->Dynamic>;
  var _cancelListeners:Array<Void->Dynamic>;
  
  var _progressListeners:Array<Percent->Dynamic>;
  
  var _value:Option<T>;
  var _complete:Bool;
  var _cancelled:Bool;

  public inline function isComplete () return _complete
  
  public inline function isCancelled () return _cancelled
  
  public inline function isDone () return _complete || _cancelled
  
  public function valueOption():Option<T> return _value
  
  public function extract ():T 
  {
    return _value.getOrError("error result is not available");
  }
  
  public function new () 
  {
    initMutex();
    
    _complete = false;
    _cancelled = false;
    _value = None;
    
    clearListeners();
  }
  
  /*
  public function await ():T {
    
  }
  */

  public function onProgress (f:Percent->Dynamic):Promise<T> 
  {
    if (isComplete()) f(1.0)
    else if (!isCancelled()) 
    {
      lock();
      if (!isDoneDoubleCheck()) _progressListeners.push(f)
      else onProgress(f);
      unlock();
    } 
    return this;
  }
  
  public function progress (percent:Percent):Promise<T>
  {
    Assert.isTrue(percent >= 0.0 && percent <= 1.0, null);
    for (l in _progressListeners) l(percent);
    return this;
  }

  public function complete (val:T):Promise<T> 
  {
    return if (isDone()) this
    else 
    {
      lock();
      if (!isDoneDoubleCheck()) 
      {
        _value = Some(val);
        _complete = true;
        
        progress(1.0);
        
        for (c in _completeListeners) c(val);
        
        clearListeners();
      }
      unlock();
      this;
    }
  }
  
  function clearListeners () 
  {
    _completeListeners = [];
    _cancelListeners = [];
    _progressListeners = [];
  }
  
  public function cancel ():Bool 
  {
    return if (!isComplete() && !isCancelled()) 
    {
      lock(); 
      if (!isDoneDoubleCheck()) 
      {
        _cancelled = true;
        
        for (c in _cancelListeners) c();

        clearListeners();
      }
      unlock();
      isCancelled();
    } 
    else false;
  }
  
  public function onComplete (f:T->Dynamic) 
  {
    if (isComplete()) 
    {
      f(extract());
    } 
    else if (!isCancelled()) 
    {
      lock();
      if (!isDoneDoubleCheck()) _completeListeners.push(f);
      else onComplete(f);
      unlock();
    } 
    
    return this;
  }
  
  public function onCancelled (f:Void->Dynamic) 
  {
    if (!isComplete()) 
    {
      if (isCancelled()) f();
      else 
      {
        lock();
        if (!isDoneDoubleCheck()) _cancelListeners.push(f);
        else onCancelled(f);
        unlock();
      }
    }
    return this;
  }

}