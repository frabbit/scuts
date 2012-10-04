package hots.of;

import hots.In;
import hots.Of;
import scuts.core.types.Option;


abstract OptionOf<T> => Option<T>, <= Option<T>, => Of<Option<In>, T>, <= Of<Option<In>, T> {}