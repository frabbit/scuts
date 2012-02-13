package hots.instances;
import hots.classes.Monad;
import hots.In;

import hots.Of;
import hots.COf;


typedef KleisliOf<M,A,B> = COf<In->Of<M, In>, A, B>; //  A -> Monad<B>