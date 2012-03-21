package hots.instances;
import hots.classes.Monad;
import hots.In;

import hots.Of;
import hots.OfOf;


typedef KleisliOf<M,A,B> = OfOf<In->Of<M, In>, A, B>; //  A -> Monad<B>