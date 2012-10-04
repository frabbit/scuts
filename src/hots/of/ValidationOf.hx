package hots.of;
import hots.In;

import hots.Of;
import scuts.core.types.Validation;


abstract ValidationOf<F,S> => Validation<F,S>, <= Validation<F,S>, => Of<Validation<F, In>, S>, <= Of<Validation<F, In>, S> {}

abstract FailProjectionOf<F,S> => FailProjection<F,S>, <= FailProjection<F,S>, => Of<FailProjection<S, In>, F>, <= Of<FailProjection<S, In>, F> {}




