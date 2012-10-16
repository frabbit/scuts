package hots.of;

import hots.In;
import hots.Of;
import scuts.core.Tup2;
import scuts.core.State;


abstract StateOf<S,T> => State<S,T>, <= State<S,T>, => Of<State<S,In>, T>, <= Of<State<S,In>, T> {}