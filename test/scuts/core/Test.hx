package scuts.core;

import scuts.core.Validation;

//using Promises;

class Test 
{

  public function new () {}
  
  public function testPromises() 
  {
    var p = Promises.mk();
    
    
    
    
    p.then(function () return loadImage("bild.jpg"));
    
    
    
    p.complete(Success(2));
    
    
    p.onComplete(function (x) {
      switch (x) {
        case Success(y): trace(y);
        case Failure(x): 
      }
    });
    
  }
  
  public function loadImage (url:String):Promise<String> {
    return Promises.pure(url);
  }
  
}