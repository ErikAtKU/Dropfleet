% Copyright

class dice : dice
    open core

constructors
    new : (shipClass::roll Lock).
    new : (shipClass::roll Lock, shipClass::roll Crit).

predicates
    getCount : (shipClass::count) -> integer.
    getPD : (integer) -> integer.

end class dice
