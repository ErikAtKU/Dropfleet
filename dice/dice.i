% Copyright

interface dice
    open core

predicates
    getRoll_dt : () -> integer determ.

predicates
    isCrit : (integer Roll) determ.

predicates
    setParticle : ().

predicates
    setBurnthroughCrit : ().

predicates
    setScald : ().

end interface dice
