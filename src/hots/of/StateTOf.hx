package hots.of;

import hots.In;
import hots.Of;
import scuts.core.types.State;

abstract StateTOf<M,ST,A> => Of<M, State<ST,A>>, => OfOf<M, State<ST, In>, A>, <= OfOf<M, State<ST,In>, A> {}