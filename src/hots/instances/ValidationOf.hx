package hots.instances;
import hots.In;

import hots.Of;
import scuts.core.types.Either;
import scuts.core.types.Validation;

typedef ValidationOf<F, S> = Of<Validation<F, In>, S>

typedef FailProjectionOf<F, S> = Of<FailProjection<S, In>, F>


