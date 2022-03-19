% Copyright

class dice : dice
    open core

constructors
    new : (shipClass::roll Lock).
    new : (shipClass::roll Lock, shipClass::roll Crit).

predicates
    getCount : (shipClass::count) -> integer.
    getPD : (integer) -> integer.

predicates
    getBest : (shipClass::roll, shipClass::roll) -> shipClass::roll.

end class dice
